;===========================================================================
; reZet80 - Z80-based retrocomputing and retrogaming
; (c) copyright 2016-2021 Adrian H. Hilgarth (all rights reserved)
; 7-segment LED driver data (_7segdat.asm) [last modified: 2021-11-06]
; indentation setting: tab size = 8
;===========================================================================
; --A--
; |   |
; F   B
; |   |
; --G--
; |   |
; E   C
; |   |
; --D--  P
;---------------------------------------------------------------------------
; bit 0: A
; bit 1: B
; bit 2: C
; bit 3: D
; bit 4: E
; bit 5: F
; bit 6: G
; bit 7: P
;---------------------------------------------------------------------------
; data for common cathode displays
; make sure table doesn't cross 256-byte boundary
_7segdat:
db 3fh	; 00h: '0': 00111111b [  F E D C B A]
db 06h	; 01h: '1': 00000110b [        C B  ]
db 5bh	; 02h: '2': 01011011b [G   E D   B A]
db 4fh	; 03h: '3': 01001111b [G     D C B A]
db 66h	; 04h: '4': 01100110b [G F     C B  ]
db 6dh	; 05h: '5': 01101101b [G F   D C   A]
db 7dh	; 06h: '6': 01111101b [G F E D C   A]
db 07h	; 07h: '7': 00000111b [        C B A]
db 7fh	; 08h: '8': 01111111b [G F E D C B A]
db 6fh	; 09h: '9': 01101111b [G F   D C B A]
db 77h	; 0ah: 'A': 01110111b [G F E   C B A]
db 7ch	; 0bh: 'b': 01111100b [G F E D C    ]
db 39h	; 0ch: 'C': 00111001b [  F E D     A]
db 5eh	; 0dh: 'd': 01011110b [G   E D C B  ]
db 79h	; 0eh: 'E': 01111001b [G F E D     A]
db 71h	; 0fh: 'F': 01110001b [G F E       A]
;===========================================================================
