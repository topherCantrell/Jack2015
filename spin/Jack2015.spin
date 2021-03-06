CON
  _clkmode        = xtal1 + pll16x
  _xinfreq        = 5_000_000

PIN_SCL = 0
PIN_SDA = 1
PIN_NOSE = 2
PIN_MOUTH = 3

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

    long cpuStack1[64]
    long cpuStack2[64]

DAT
orangeEye byte $3C, $3C, $7E, $7E, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $7E, $7E, $3C, $3C
greenEye  byte $3C, $00, $7E, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $7E, $00, $3C, $00
redEye    byte $00, $3C, $00, $7E, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $7E, $00, $3C
eyebuf    byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 

DAT    long
sparkleScript 
 byte $F1, $01 ,$00, $05 ' RNDGOSUB 5
 byte $FE ' ABORT
 byte $00 ' Padding
 byte $03, $0b ' NOSECOLORS 11
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00 ' Padding
 byte $00 ' Padding
 byte $09, $0b ' MOUTHCOLORS 11
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $00,$00,$00, $00
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F1, $01 ,$00, $95 ' RNDGOSUB 149
 byte $F2 ' RETURN
 byte $07, $0a ' RNDPALETTENOSE 10
 byte $0A, $0a ' RNDPALETTEMOUTH 10
 byte $08 ' RNDEYES
 byte $05 ' DRAWNOSE .ABCDEFGHIJ
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $03, $00, $00, $00, $00 ' ...C....
 byte $00, $00, $08, $02, $05, $00, $00, $00 ' ..HBE...
 byte $00, $00, $07, $08, $03, $00, $00, $00 ' ..GHC...
 byte $00, $09, $02, $04, $02, $04, $00, $00 ' .IBDBD..
 byte $05, $03, $0a, $01, $08, $05, $0a, $00 ' ECJAHEJ.
 byte $04 ' DRAWMOUTH .ABCDEFGHIJ
 byte $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $07 ' E......................G
 byte $00, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $05, $00 ' .A....................E.
 byte $00, $04, $07, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0a, $07, $06, $00 ' .DGA................JGF.
 byte $00, $00, $06, $09, $07, $08, $03, $06, $09, $0a, $00, $00, $00, $00, $07, $09, $08, $08, $0a, $03, $0a, $07, $00, $00 ' ..FIGHCFIJ....GIHHJCJG..
 byte $00, $00, $00, $0a, $0a, $05, $04, $09, $09, $02, $04, $02, $04, $01, $04, $0a, $07, $03, $09, $02, $01, $00, $00, $00 ' ...JJEDIIBDBDADJGCIBA...
 byte $00, $00, $00, $05, $03, $0a, $01, $08, $05, $08, $0a, $0a, $06, $06, $05, $08, $08, $02, $03, $07, $0a, $00, $00, $00 ' ...ECJAHEHJJFFEHHBCGJ...
 byte $00, $00, $00, $00, $09, $07, $09, $06, $03, $02, $01, $0a, $02, $07, $08, $06, $09, $03, $05, $09, $00, $00, $00, $00 ' ....IGIFCBAJBGHFICEI....
 byte $00, $00, $00, $00, $00, $00, $00, $04, $0a, $08, $02, $05, $08, $04, $0a, $04, $09, $00, $00, $00, $00, $00, $00, $00 ' .......DJHBEHDJDI.......
 byte $F0, $01, $f4 ' PAUSE 500
 byte $F2 ' RETURN
 ' 416 bytes

DAT  long
eyeScript
 byte $F1, $05 ,$00, $fa ,$00, $d2 ,$00, $bf ,$00, $9d ,$00, $1b ' RNDGOSUB 250, 210, 191, 157, 27
 byte $F1, $05 ,$00, $fa ,$00, $d2 ,$00, $bf ,$00, $9d ,$00, $1b ' RNDGOSUB 250, 210, 191, 157, 27
 byte $FF, $00, $00 ' GOTO 0
 byte $01, $22, $22 ' DRAWEYES 2,2
 byte $F0, $05, $dc ' PAUSE 1500
 byte $01, $33, $33 ' DRAWEYES 3,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $44, $44 ' DRAWEYES 4,4
 byte $F0, $00, $40 ' PAUSE 64
 byte $F1, $01 ,$00, $3c ' RNDGOSUB 60
 byte $F1, $01 ,$00, $3c ' RNDGOSUB 60
 byte $01, $33, $33 ' DRAWEYES 3,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $F2 ' RETURN
 byte $01, $34, $34 ' DRAWEYES 3,4
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $24, $24 ' DRAWEYES 2,4
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $14, $14 ' DRAWEYES 1,4
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $04, $04 ' DRAWEYES 0,4
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $03, $03 ' DRAWEYES 0,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $02, $02 ' DRAWEYES 0,2
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $01, $01 ' DRAWEYES 0,1
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $00, $00 ' DRAWEYES 0,0
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $10, $10 ' DRAWEYES 1,0
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $20, $20 ' DRAWEYES 2,0
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $30, $30 ' DRAWEYES 3,0
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $40, $40 ' DRAWEYES 4,0
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $41, $41 ' DRAWEYES 4,1
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $42, $42 ' DRAWEYES 4,2
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $43, $43 ' DRAWEYES 4,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $44, $44 ' DRAWEYES 4,4
 byte $F0, $00, $40 ' PAUSE 64
 byte $F2 ' RETURN
 byte $01, $22, $22 ' DRAWEYES 2,2
 byte $F0, $05, $dc ' PAUSE 1500
 byte $01, $31, $33 ' DRAWEYES 3,1, 3,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $40, $44 ' DRAWEYES 4,0, 4,4
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F0, $05, $dc ' PAUSE 1500
 byte $01, $31, $33 ' DRAWEYES 3,1, 3,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $F0, $00, $40 ' PAUSE 64
 byte $F2 ' RETURN
 byte $01, $13, $13 ' DRAWEYES 1,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $03, $03 ' DRAWEYES 0,3
 byte $F0, $05, $dc ' PAUSE 1500
 byte $01, $13, $13 ' DRAWEYES 1,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $F2 ' RETURN
 byte $01, $22, $22 ' DRAWEYES 2,2
 byte $F0, $05, $dc ' PAUSE 1500
 byte $01, $11, $11 ' DRAWEYES 1,1
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $10, $10 ' DRAWEYES 1,0
 byte $F0, $05, $dc ' PAUSE 1500
 byte $01, $20, $20 ' DRAWEYES 2,0
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $30, $30 ' DRAWEYES 3,0
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F0, $05, $dc ' PAUSE 1500
 byte $01, $21, $21 ' DRAWEYES 2,1
 byte $F0, $00, $40 ' PAUSE 64
 byte $F2 ' RETURN
 byte $01, $22, $22 ' DRAWEYES 2,2, 2,2
 byte $F0, $05, $dc ' PAUSE 1500
 byte $02, $11, $22, $22 ' BLINK 1,1,2,2,2,2
 byte $F0, $05, $dc ' PAUSE 1500
 byte $01, $33, $33 ' DRAWEYES 3,3, 3,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $01, $44, $44 ' DRAWEYES 4,4, 4,4
 byte $F0, $05, $dc ' PAUSE 1500
 byte $02, $11, $44, $44 ' BLINK 1,1,4,4,4,4
 byte $F0, $05, $dc ' PAUSE 1500
 byte $01, $33, $33 ' DRAWEYES 3,3, 3,3
 byte $F0, $00, $40 ' PAUSE 64
 byte $F2 ' RETURN
 ' 289 bytes        

DAT  long
noseScript
 byte $00 ' Padding
 byte $00 ' Padding
 byte $03, $03 ' NOSECOLORS 3
 byte $00,$00,$00, $00
 byte $00,$20,$08, $00
 byte $15,$15,$15, $00
 byte $F1, $01 ,$00, $75 ' RNDGOSUB 117
 byte $F0, $07, $d0 ' PAUSE 2000
 byte $F1, $01 ,$00, $b7 ' RNDGOSUB 183
 byte $F0, $03, $e8 ' PAUSE 1000
 byte $F1, $01 ,$00, $75 ' RNDGOSUB 117
 byte $F0, $03, $e8 ' PAUSE 1000
 byte $F1, $01 ,$00, $b7 ' RNDGOSUB 183
 byte $F0, $01, $f4 ' PAUSE 500
 byte $F1, $01 ,$00, $75 ' RNDGOSUB 117
 byte $F0, $01, $f4 ' PAUSE 500
 byte $F1, $01 ,$00, $f9 ' RNDGOSUB 249
 byte $F0, $03, $e8 ' PAUSE 1000
 byte $F1, $01 ,$00, $75 ' RNDGOSUB 117
 byte $F0, $07, $d0 ' PAUSE 2000
 byte $F1, $01 ,$00, $b7 ' RNDGOSUB 183
 byte $F0, $01, $f4 ' PAUSE 500
 byte $F1, $01 ,$00, $b7 ' RNDGOSUB 183
 byte $F0, $07, $d0 ' PAUSE 2000
 byte $F1, $01 ,$00, $f9 ' RNDGOSUB 249
 byte $F0, $03, $e8 ' PAUSE 1000
 byte $F1, $01 ,$00, $b7 ' RNDGOSUB 183
 byte $F0, $01, $f4 ' PAUSE 500
 byte $F1, $01 ,$00, $f9 ' RNDGOSUB 249
 byte $F0, $07, $d0 ' PAUSE 2000
 byte $F1, $01 ,$00, $75 ' RNDGOSUB 117
 byte $F0, $03, $e8 ' PAUSE 1000
 byte $F1, $01 ,$00, $b7 ' RNDGOSUB 183
 byte $F0, $03, $e8 ' PAUSE 1000
 byte $FF, $00, $00 ' GOTO 0
 byte $05 ' DRAWNOSE .#
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $01, $01, $00, $00, $00 ' ...##...
 byte $00, $00, $00, $01, $01, $00, $00, $00 ' ...##...
 byte $00, $00, $01, $01, $01, $01, $00, $00 ' ..####..
 byte $00, $01, $01, $01, $01, $01, $01, $00 ' .######.
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $F2 ' RETURN
 byte $05 ' DRAWNOSE .#
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $01, $01, $00, $00, $00 ' ...##...
 byte $00, $00, $01, $01, $01, $00, $00, $00 ' ..###...
 byte $00, $01, $01, $01, $01, $00, $00, $00 ' .####...
 byte $01, $01, $01, $01, $01, $00, $00, $00 ' #####...
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $F2 ' RETURN
 byte $05 ' DRAWNOSE .#
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $00, $00, $00, $01, $01, $00, $00, $00 ' ...##...
 byte $00, $00, $00, $01, $01, $01, $00, $00 ' ...###..
 byte $00, $00, $00, $01, $01, $01, $01, $00 ' ...####.
 byte $00, $00, $00, $01, $01, $01, $01, $01 ' ...#####
 byte $00, $00, $00, $00, $00, $00, $00, $00 ' ........
 byte $F2 ' RETURN
 ' 315 bytes  

DAT long
mouthScript
 byte $00 ' Padding
 byte $00 ' Padding
 byte $09, $04 ' MOUTHCOLORS 4
 byte $00,$00,$00, $00
 byte $00,$20,$08, $00
 byte $20,$00,$20, $00
 byte $00,$20,$20, $00
 byte $F1, $05 ,$00, $77 ,$00, $9d ,$00, $c3 ,$08, $9b ,$08, $9b ' RNDGOSUB 119,157,195,2203,2203
 byte $F1, $05 ,$00, $77 ,$00, $9d ,$00, $c3 ,$08, $9b ,$08, $9b ' RNDGOSUB 119,157,195,2203,2203
 byte $F1, $05 ,$00, $77 ,$00, $9d ,$00, $c3 ,$08, $9b ,$08, $9b ' RNDGOSUB 119,157,195,2203,2203
 byte $F1, $05 ,$00, $77 ,$00, $9d ,$00, $c3 ,$08, $9b ,$08, $9b ' RNDGOSUB 119,157,195,2203,2203
 byte $F1, $05 ,$00, $77 ,$00, $9d ,$00, $c3 ,$08, $9b ,$08, $9b ' RNDGOSUB 119,157,195,2203,2203
 byte $F1, $05 ,$00, $77 ,$00, $9d ,$00, $c3 ,$08, $9b ,$08, $9b ' RNDGOSUB 119,157,195,2203,2203
 byte $F1, $05 ,$00, $77 ,$00, $9d ,$00, $c3 ,$08, $9b ,$08, $9b ' RNDGOSUB 119,157,195,2203,2203
 byte $F1, $05 ,$00, $77 ,$00, $9d ,$00, $c3 ,$08, $9b ,$08, $9b ' RNDGOSUB 119,157,195,2203,2203
 byte $FF, $00, $00 ' GOTO 0
 byte $F1, $01 ,$00, $e9 ' RNDGOSUB 233
 byte $F1, $01 ,$03, $fd ' RNDGOSUB 1021
 byte $F1, $01 ,$04, $c2 ' RNDGOSUB 1218
 byte $F1, $01 ,$05, $87 ' RNDGOSUB 1415
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F1, $01 ,$04, $c2 ' RNDGOSUB 1218
 byte $F1, $01 ,$03, $fd ' RNDGOSUB 1021
 byte $F1, $01 ,$00, $e9 ' RNDGOSUB 233
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F2 ' RETURN
 byte $F1, $01 ,$00, $e9 ' RNDGOSUB 233
 byte $F1, $01 ,$01, $ae ' RNDGOSUB 430
 byte $F1, $01 ,$02, $73 ' RNDGOSUB 627
 byte $F1, $01 ,$03, $38 ' RNDGOSUB 824
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F1, $01 ,$02, $73 ' RNDGOSUB 627
 byte $F1, $01 ,$01, $ae ' RNDGOSUB 430
 byte $F1, $01 ,$00, $e9 ' RNDGOSUB 233
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F2 ' RETURN
 byte $F1, $01 ,$00, $e9 ' RNDGOSUB 233
 byte $F1, $01 ,$06, $4c ' RNDGOSUB 1612
 byte $F1, $01 ,$07, $11 ' RNDGOSUB 1809
 byte $F1, $01 ,$07, $d6 ' RNDGOSUB 2006
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F1, $01 ,$07, $11 ' RNDGOSUB 1809
 byte $F1, $01 ,$06, $4c ' RNDGOSUB 1612
 byte $F1, $01 ,$00, $e9 ' RNDGOSUB 233
 byte $F0, $05, $dc ' PAUSE 1500
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' ########################
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' ########################
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01 ' .......................#
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' ########################
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00 ' #######################.
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01 ' .......................#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01 ' ....................####
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00 ' #######################.
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00 ' ####################....
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01 ' .......................#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01 ' ....................####
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $00 ' .................######.
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00 ' ####################....
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00 ' #################.......
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01 ' #......................#
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' ########################
 byte $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00 ' .######################.
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01 ' #......................#
 byte $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01 ' ####................####
 byte $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00 ' .######################.
 byte $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00 ' ....################....
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01 ' #......................#
 byte $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01 ' ####................####
 byte $00, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $00 ' .######..........######.
 byte $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00 ' ....################....
 byte $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00 ' .......##########.......
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' #.......................
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' ########################
 byte $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' .#######################
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' #.......................
 byte $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ####....................
 byte $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' .#######################
 byte $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' ....####################
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#
 byte $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' #.......................
 byte $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ####....................
 byte $00, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' .######.................
 byte $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' ....####################
 byte $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' .......#################
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $00, $64 ' PAUSE 100
 byte $F2 ' RETURN
 byte $F1, $01 ,$0b, $1b ' RNDGOSUB 2843
 byte $F1, $01 ,$0a, $56 ' RNDGOSUB 2646
 byte $F1, $01 ,$09, $91 ' RNDGOSUB 2449
 byte $F1, $01 ,$08, $cc ' RNDGOSUB 2252
 byte $F1, $01 ,$09, $91 ' RNDGOSUB 2449
 byte $F1, $01 ,$0a, $56 ' RNDGOSUB 2646
 byte $F1, $01 ,$0b, $1b ' RNDGOSUB 2843
 byte $F1, $01 ,$0a, $56 ' RNDGOSUB 2646
 byte $F1, $01 ,$09, $91 ' RNDGOSUB 2449
 byte $F1, $01 ,$08, $cc ' RNDGOSUB 2252
 byte $F1, $01 ,$09, $91 ' RNDGOSUB 2449
 byte $F1, $01 ,$0a, $56 ' RNDGOSUB 2646
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#*@
 byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00 ' ........########........
 byte $00, $00, $00, $00, $01, $01, $01, $01, $03, $03, $00, $00, $00, $03, $03, $00, $01, $01, $01, $01, $00, $00, $00, $00 ' ....####@@...@@.####....
 byte $00, $01, $01, $01, $00, $00, $00, $00, $03, $03, $00, $00, $00, $03, $03, $00, $00, $03, $03, $00, $01, $01, $01, $00 ' .###....@@...@@..@@.###.
 byte $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01 ' #......................#
 byte $01, $00, $00, $00, $00, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $00, $01 ' #....**.............**.#
 byte $00, $01, $01, $01, $00, $02, $02, $00, $00, $00, $02, $02, $00, $00, $00, $02, $02, $00, $00, $00, $01, $01, $01, $00 ' .###.**...**...**...###.
 byte $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $02, $02, $00, $00, $00, $02, $01, $01, $01, $01, $00, $00, $00, $00 ' ....####..**...*####....
 byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00 ' ........########........
 byte $F0, $01, $f4 ' PAUSE 500
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#*@
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00 ' ........########........
 byte $00, $00, $00, $00, $01, $01, $01, $01, $03, $03, $00, $00, $00, $03, $03, $00, $01, $01, $01, $01, $00, $00, $00, $00 ' ....####@@...@@.####....
 byte $01, $01, $01, $01, $00, $00, $00, $00, $03, $03, $00, $00, $00, $03, $03, $00, $00, $03, $03, $00, $01, $01, $01, $01 ' ####....@@...@@..@@.####
 byte $01, $01, $01, $01, $00, $02, $02, $00, $00, $00, $02, $02, $00, $00, $00, $02, $02, $00, $00, $00, $01, $01, $01, $01 ' ####.**...**...**...####
 byte $00, $00, $00, $00, $01, $01, $01, $01, $00, $00, $02, $02, $00, $00, $00, $02, $01, $01, $01, $01, $00, $00, $00, $00 ' ....####..**...*####....
 byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00 ' ........########........
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $01, $f4 ' PAUSE 500
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#*@
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00 ' ........########........
 byte $01, $01, $01, $01, $01, $01, $01, $01, $03, $03, $02, $02, $00, $03, $03, $02, $01, $01, $01, $01, $01, $01, $01, $01 ' ########@@**.@@*########
 byte $01, $01, $01, $01, $01, $01, $01, $01, $03, $03, $02, $02, $00, $03, $03, $02, $01, $01, $01, $01, $01, $01, $01, $01 ' ########@@**.@@*########
 byte $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00 ' ........########........
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $01, $f4 ' PAUSE 500
 byte $F2 ' RETURN
 byte $04 ' DRAWMOUTH .#*@
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' ########################
 byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ' ########################
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 ' ........................
 byte $F0, $01, $f4 ' PAUSE 500
 byte $F2 ' RETURN
 ' 3040 bytes  


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

  runScript(@sparkleScript,@stackspc1)

  cognew(runScript(@eyeScript,@stackspc1),@cpuStack1)
  cognew(runScript(@mouthScript,@stackspc2),@cpuStack2)
  runScript(@noseScript,@stackspc3)
   
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
        LEFT_EYE.drawLine(j,0,     j,7,    0)
        LEFT_EYE.drawLine(7-j,0,   7-j,7,  0)
      if right
        RIGHT_EYE.drawLine(j,0,    j,7,    0)
        RIGHT_EYE.drawLine(7-j,0,  7-j,7,  0)
    LEFT_EYE.drawRaster
    RIGHT_EYE.drawRaster
    PauseMSec(10)

  repeat i from 2 to 1
    eyePattern(x1,y1,x2,y2)
    repeat j from 0 to i          
      if left
        LEFT_EYE.drawLine(j,0,     j,7,    0)
        LEFT_EYE.drawLine(7-j,0,   7-j,7,  0)
      if right
        RIGHT_EYE.drawLine(j,0,    j,7,    0)
        RIGHT_EYE.drawLine(7-j,0,  7-j,7,  0)
    LEFT_EYE.drawRaster
    RIGHT_EYE.drawRaster
    PauseMSec(10)

  eyePattern(x1,y1,x2,y2)
  LEFT_EYE.drawRaster
  RIGHT_EYE.drawRaster 



 
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
    ' NOSECOLORS size, abcd, abcd, ...
    a := byte[p]
    p := p + 1
    NOSE_API.setPalette(p)
    'NOSE_API.setPalette(@noseTest)

    return a*4+1

  if c==$09
    ' MOUTHCOLORS size, abcd, abcd, ...
    a := byte[p]
    p := p + 1
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

  if c==$06
    ' EYEPATTERN 32_bytes_of_data
    LEFT_EYE.copyRaster(p)
    RIGHT_EYE.copyRaster(p+16)
    LEFT_EYE.drawRaster
    RIGHT_EYE.drawRaster
    return 32

  if c==$07
    ' RNDPALETTE cnt
    a := byte[p]
    p := p + 1
    d := NOSE_API.getPalette + 4
    repeat c from 1 to a
      repeat t1 from 0 to 3
        t2 := (random?)&255
        byte[d] := t2//$20
        d := d + 1

    return 1

  if c==$0A
    ' RNDPALETTE cnt
    a := byte[p]
    p := p + 1
    d := MOUTH_API.getPalette + 4
    repeat c from 1 to a
      repeat t1 from 0 to 3
        t2 := (random?)&255
        byte[d] := t2//$20
        d := d + 1

    return 1

  if c==$08
    ' RNDEYES

    a := @eyebuf
    b := @orangeEye
    repeat d from 0 to 16
      t1 := (random?)&255
      byte[a] := byte[b] & t1
      a := a+1
      b := b+1
    LEFT_EYE.copyRaster(@eyebuf)
    
    a := @eyebuf
    b := @orangeEye
    repeat d from 0 to 16
      t1 := (random?)&255
      byte[a] := byte[b]  & t1
      a := a+1
      b := b+1
    RIGHT_EYE.copyRaster(@eyebuf)
    LEFT_EYE.drawRaster
    RIGHT_EYE.drawRaster

    return 0



    
VAR
  long stackspc1[8]
  long stackspc2[8]
  long stackspc3[8] 
  long random
  
PRI PauseMSec(Duration)
  waitcnt(((clkfreq / 1_000 * Duration - 3932) #> 381) + cnt)
  
PRI readScriptWord(p) | a,b
  a := byte[p]
  p := p + 1
  b := byte[p]
  return (a<<8) | b

PRI getRandom(mod) | r
  r := random?
  r := r & 255
  return r // mod

PUB runScript(ptr,stk) | p, c, a, b, sp

  sp := 0
  p := ptr
  random := cnt
  
  repeat
    c := byte[p]
    p := p + 1

    if c==0
      ' NOP ... do nothing     

    elseif c<$80
      p := p + scriptCommands(c,p)
    
    elseif c==$F0
      ' PAUSE nn
      a := readScriptWord(p)
      p := p + 2
      PauseMSec(a)

    elseif c==$F1
      ' RNDGOSUB cnt aa bb cc dd ee ...      
      a := byte[p]
      p := p + 1
      b := p + a*2 ' Next command
      a := getRandom(a)
      a := a*2 
      p :=  ptr + readScriptWord(p+a) ' Subroutine
      long[stk+sp] := b
      sp:= sp+4

    elseif c==$F2
      ' RETURN
      sp := sp - 4
      p := long[stk+sp]

    elseif c==$FF
      ' GOTO nn
      a := readScriptWord(p)
      p := p + 2
      p := ptr + a

    else
      ' ABORT (FE)
      return