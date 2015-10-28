CON
  _clkmode        = xtal1 + pll16x
  _xinfreq        = 5_000_000

PIN_SCL = 0
PIN_SDA = 1
PIN_NOSE = 2
PIN_MOUTH = 3

{{

I used the following 8x8 NeoPixel grid from AdaFruit:
https://www.adafruit.com/products/1487

Propeller Demo Board

             7404 
     P0  ────────────────── NeoPixel DIN
  +5 In  ──────────┐
    GND  ───────┐  │
                 │  │
                 │  │
2A Wall Wart     │  │
                 │  │
     +5  ────────┼──┻─────────┳─ NeoPixel +5
                 │     1000µF  
    GND  ────────┻────────────┻─ NeoPixel GND   

In my case the NeoPixels are powered by 5V. They require the
Data in (DIN) signal to be close to 5V. The propeller GPIO
output is only 3.3V. I used a 7404 Hex Inverter chip to boost
the output up to 5V. I used two of the inverters on the the
chip back to back to re-invert the signal to match the propeller
output value. If you only want to use one of the inverters then
you can invert the propeller output in the code.

}}

OBJ    
    NOSE      : "NeoPixel"
    LEFT_EYE  : "HT16K33_Bicolor_8x8"
    RIGHT_EYE : "HT16K33_Bicolor_8x8"

VAR
    long   command    ' Command trigger -- write non-zero value
    long   buffer     ' Pointer to the pixel data buffer
    long   numPixels  ' Number of pixels to write
    long   pin        ' The pin number to send data over

    ' Pixel buffer
    long   pixels[64]

    long   mouth[64*3]

PUB Main | i

  dira[PIN_NOSE] := 1
  outa[PIN_NOSE] := 0

  dira[PIN_MOUTH] := 1
  outa[PIN_MOUTH] := 0

  LEFT_EYE.init($71,PIN_SCL)  ' 0=SCL, 1=SDA
  RIGHT_EYE.init($72,PIN_SCL) ' 0=SCL, 1=SDA
  
  LEFT_EYE.clearRaster
  RIGHT_EYE.clearRaster
  
  LEFT_EYE.setPixel(3,1,1)
  RIGHT_EYE.setPixel(6,3,2)

  LEFT_EYE.drawRaster
  RIGHT_EYE.drawRaster 

  pin := PIN_NOSE
   
  NOSE.start(@command)

  PauseMSec(1000)

  ' $00_GG_RR_BB

  ' Fill the grid with a green
  repeat i from 0 to 63
    pixels[i] := $00_10_00_00

  ' Add some diagonals
  repeat i from 0 to 7
    pixels[i*8 + i]   := $00_00_20_00  ' Red diagonal upper-left to bottom-right
    pixels[i*8 +7 -i] := $00_00_00_20  ' Blue diagonal upper-right to bottom-left
  
  pin        := PIN_NOSE
  numPixels  := 64
  buffer     := @pixels
  command    := 1

  PauseMSec(1000)      

  repeat i from 0 to (64*3-1)
    mouth[i] := $00_10_10_00

  mouth[64*3-1] := $00_10_10
  mouth[0] := $00_10_10
  mouth[64*1-1] := $00_10_10
  mouth[64*1] := $00_10_10
  mouth[64*2-1] := $00_10_10
  mouth[64*2 ] := $00_10_10

  pin        := PIN_MOUTH
  numPixels  := 64*3
  buffer     := @mouth
  command    := 1

  repeat 

PRI PauseMSec(Duration)
  waitcnt(((clkfreq / 1_000 * Duration - 3932) #> 381) + cnt)

CON
{{   
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│                                TERMS OF USE: MIT License                                │                                                            
├─────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this     │
│software and associated documentation files (the "Software"), to deal in the Software    │
│without restriction, including without limitation the rights to use, copy, modify, merge,│
│publish, distribute, sublicense, and/or sell copies of the Software, and to permit       │
│persons to whom the Software is furnished to do so, subject to the following conditions: │
│                                                                                         │
│The above copyright notice and this permission notice shall be included in all copies or │
│substantial portions of the Software.                                                    │
│                                                                                         │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESSED OR IMPLIED,    │
│INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR │
│PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE│
│FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR     │
│OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER   │
│DEALINGS IN THE SOFTWARE.                                                                │
└─────────────────────────────────────────────────────────────────────────────────────────┘
}}           