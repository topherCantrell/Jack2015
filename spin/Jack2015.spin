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
    NOSE      : "NeoPixelPlate"
    NOSE_API  : "NeoPixelPlateAPI"
    
    MOUTH     : "NeoPixelPlate"    
    MOUTH_API : "NeoPixelPlateAPI"
    
    LEFT_EYE  : "HT16K33_Bicolor_8x8"
    
    RIGHT_EYE : "HT16K33_Bicolor_8x8"

VAR

' Eye routines            
    long   blankRightEyePtr
    long   colorRightEye
    long   blankLeftEyePtr
    long   colorLeftEye

DAT
orangeEye
    byte $3C, $3C, $7E, $7E, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $7E, $7E, $3C, $3C
greenEye
    byte $3C, $00, $7E, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $7E, $00, $3C, $00
redEye
    byte $00, $3C, $00, $7E, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $7E, $00, $3C

script

 byte $03, $02 ' COLORS
 byte $00,$00,$00,$00
 byte $00,$10,$10,$10
 byte $05 ' DRAWNOSE .#
 byte $01, $01, $01, $01, $01, $01, $01, $01 ' ########
 byte $01, $00, $00, $00, $00, $00, $00, $01 ' #......#
 byte $01, $00, $00, $00, $00, $00, $00, $01 ' #......#
 byte $01, $00, $00, $00, $00, $00, $00, $01 ' #......#
 byte $01, $00, $00, $00, $00, $00, $00, $01 ' #......#
 byte $01, $00, $00, $00, $00, $00, $00, $01 ' #......#
 byte $01, $00, $00, $00, $00, $00, $00, $01 ' #......#
 byte $01, $01, $01, $01, $01, $01, $01, $01 ' ########
 byte $04 ' DRAWMOUTH .#
 byte $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' #.......................
 byte $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' .#......................
 byte $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01 ' ..#....................#
 byte $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00 ' ...########...........#.
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00 ' ...........#.........#..
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00 ' ............#.......#...
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00, $00, $01, $00, $00, $00, $00 ' .............#.....#....
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00 ' ..............#####.....
 byte $01, $22, $22 ' DRAWEYES 2,2, 2,2
 byte $F0, $03, $e8 ' PAUSE 1000
 byte $02, $11, $22, $22 ' BLINK 1,1, 2,2, 2,2
 byte $F0, $01, $f4 ' PAUSE 500
 byte $02, $11, $22, $22 ' BLINK 1,1, 2,2, 2,2
 byte $F0, $00, $64 ' PAUSE 100
 byte $01, $11, $11 ' DRAWEYES 1,1, 1,1
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $21, $21 ' DRAWEYES 2,1, 2,1
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $31, $31 ' DRAWEYES 3,1, 3,1
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $32, $32 ' DRAWEYES 3,2, 3,2
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $33, $33 ' DRAWEYES 3,3, 3,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $23, $23 ' DRAWEYES 2,3, 2,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $13, $13 ' DRAWEYES 1,3, 1,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $12, $12 ' DRAWEYES 1,2, 1,2
 byte $F0, $00, $40 ' PAUSE 64
 byte $FF, $00, $00 ' GOTO 0









PUB Main | i

  dira[PIN_NOSE] := 1
  outa[PIN_NOSE] := 0

  dira[PIN_MOUTH] := 1
  outa[PIN_MOUTH] := 0

  NOSE.init (PIN_NOSE,  8, 8,   0,0,             0,0,0,0,0,0)
  NOSE_API.init(NOSE.getAPIptr)
  
  MOUTH.init(PIN_MOUTH, 8,8,    0,0,   1,0,1,0,  0,0)
  MOUTH_API.init(MOUTH.getAPIptr)

  blankRightEyePtr := @orangeEye
  blankLeftEyePtr := @orangeEye 
  colorRightEye := 0
  colorLeftEye :=0

  LEFT_EYE.init($71,PIN_SCL)  ' 0=SCL, 1=SDA
  RIGHT_EYE.init($72,PIN_SCL) ' 0=SCL, 1=SDA

  runScript(@script)  
  ' Should never return. But just in case.  
  repeat 



PUB colors(ptr)
  ' Set nose and mouth palette

PUB drawNose(ptr)
  ' Draw nose

PUB drawMouth(ptr)
  ' Draw mouth

PUB drawEyes(x1,y1, x2,y2)
  eyePattern(x1,y1,x2,y2)
  LEFT_EYE.drawRaster
  RIGHT_EYE.drawRaster

PRI eyePattern(x1,y1,x2,y2) 
  LEFT_EYE.copyRaster(blankLeftEyePtr)
  LEFT_EYE.setPixel(x1+1,y1+1,colorLeftEye)
  LEFT_EYE.setPixel(x1+2,y1+1,colorLeftEye)
  LEFT_EYE.setPixel(x1+1,y1+2,colorLeftEye)
  LEFT_EYE.setPixel(x1+2,y1+2,colorLeftEye)
  RIGHT_EYE.copyRaster(blankRightEyePtr)
  RIGHT_EYE.setPixel(x2+1,y2+1,colorRightEye)
  RIGHT_EYE.setPixel(x2+2,y2+1,colorRightEye)
  RIGHT_EYE.setPixel(x2+1,y2+2,colorRightEye)
  RIGHT_EYE.setPixel(x2+2,y2+2,colorRightEye)

PUB blinkEyes(left,right, x1,y1, x2,y2) | i, j
      
  repeat i from 0 to 3
    eyePattern(x1,y1,x2,y2)
    repeat j from 0 to i          
      if left
        LEFT_EYE.drawLine(0,j,7,j,0)
        LEFT_EYE.drawLine(0,7-j,7,7-j,0)
      if right
        RIGHT_EYE.drawLine(0,j,7,j,0)
        RIGHT_EYE.drawLine(0,7-j,7,7-j,0)
    LEFT_EYE.drawRaster
    RIGHT_EYE.drawRaster
    PauseMSec(10)

  repeat i from 2 to 1
    eyePattern(x1,y1,x2,y2)
    repeat j from 0 to i    
      if left
        LEFT_EYE.drawLine(0,j,7,j,0)
        LEFT_EYE.drawLine(0,7-j,7,7-j,0)
      if right
        RIGHT_EYE.drawLine(0,j,7,j,0)
        RIGHT_EYE.drawLine(0,7-j,7,7-j,0)
    LEFT_EYE.drawRaster
    RIGHT_EYE.drawRaster
    PauseMSec(10)

  eyePattern(x1,y1,x2,y2)
  LEFT_EYE.drawRaster
  RIGHT_EYE.drawRaster 

PRI PauseMSec(Duration)
  waitcnt(((clkfreq / 1_000 * Duration - 3932) #> 381) + cnt)











PRI scriptCommands(c, p) | a, b, d, t1, t2, t3, t4

  if c==$01
    ' DRAWEYES xy,  xy
    a := byte[p]
    p := p + 1
    b := byte[p]
    drawEyes( (a>>4), (a&15), (b>>4), (b&15) )
    return 2

  if c==$02
    ' BLINK LR, xy,  xy
    d := byte[p]
    p := p + 1
    a := byte[p]
    p := p + 1
    b := byte[p]
    blinkEyes( (d>>4), (d&15), (a>>4), (a&15), (b>>4), (b&15) )
    return 3

  if c==$03
    ' COLORS size, abcd, abcd, ...
    a := byte[p]
    p := p + 1

    NOSE_API.setPalette(p)
    MOUTH_API.setPalette(p)

    return a*4+1

  if c==$04
    ' DRAWMOUTH 192_bytes_of_data
    MOUTH_API.renderRaster(2, p, 24, 8, 0, 0)

    return 192

  if c==$05
    ' DRAWNOSE 64_bytes_of_data
    NOSE_API.renderRaster(2, p, 8, 8, 0, 0)
    
    return 64



    

PRI readScriptWord(p) | a,b
  a := byte[p]
  p := p + 1
  b := byte[p]
  return (a<<8) | b

PUB runScript(ptr) | p, c, a, b

  p := ptr
  
  repeat
    c := byte[p]
    p := p + 1

    if c==0
      ' NOP ... do nothing     

    elseif c<$80
      p := p + scriptCommands(c,p)
    
    elseif c==$F0
      a := readScriptWord(p)
      p := p + 2
      PauseMSec(a)

    elseif c==$FF
      a := readScriptWord(p)
      p := p + 2
      p := ptr + a

    else
      ' Error ... unknown command