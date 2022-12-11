;===========================================================================
; reZet80 - Z80-based retrocomputing and retrogaming
; (c) copyright 2016-2021 Adrian H. Hilgarth (all rights reserved)
; reZet80 SCOUT deMon (_demon.asm) [last modified: 2021-12-16]
; indentation setting: tab size = 8
;===========================================================================
; deMon (debug Monitor) execution loop
_loop:		ld a, 0ffh
		ld i, a			; i holds last key code
;---------------------------------------------------------------------------
; update both display digits
;  a : temp storage
;  a': temp storage
;  b : display digit / counter
;  c : output port number
;  d : temp storage
; de : ptr to 7-segment table
; hl : ptr to display buffer
_loop0:		ld hl, _pos
		ld l, (hl)		; current display position
		dec l			; adjust display position
		jr nz, _loop1		; leftmost digit ?
		inc l
_loop1:		dec l			; adjust display position again
		jr nz, _loop2		; leftmost digit ?
		inc l
_loop2:		ld a, 01h		; 00000001b + rrca -> 10000000b
		ld bc, 0201h		; display 2 digits, I/O port 01h
_out:		push bc			; save counter
		rrca			; set A15 for 1st (leftmost) digit
		ld b, a			; set A14 for 2nd digit
		ex af, af'		; save MSB of I/O port
		ld a, (hl)		; load hex digit
		inc hl
		ld de, _7segdat
		add a, e
		ld e, a
		ld a, (de)		; load 7-segment code to display
		ld d, 08h		; output 8 times
_out0:		out (c), a		; 16-bit I/O
		dec d
		jr nz, _out0		; for the right brightness
		ex af, af'		; restore MSB of I/O port
		pop bc			; restore counter
		djnz _out
;---------------------------------------------------------------------------
; read keypad
;  a : temp storage
;  a': temp storage
;  b : keypad row / counter
;  c : input port number
;  d : key code
;  e : temp storage
; hl : ptr to key buffer
		ld a, 01h		; 00000001b + rrca -> 10000000b
		ld bc, 0300h		; read 3 key rows, I/O port 00h
		ld d, c			; d = pressed key code
_in:		ld e, b			; save counter
		rrca			; set A15/A14/A13 for
		ld b, a			; 1st/2nd/3rd keypad row
		ex af, af'		; save MSB of I/O port
		in a, (c)		; 16-bit I/O
		ld b, 08h		; 8 keys per row
_in0:		rrca			; any key pressed ?
		jr c, _in1
		inc d
		djnz _in0
		ex af, af'		; restore MSB of I/O port
		ld b, e			; restore counter
		djnz _in
_in1:		ld a, d
		cp 18h			; d = 18h if no key pressed
		jr z, _in2
		ld i, a			; remember key pressed
		jr _loop0
_in2:		ld a, i
		cp 0ffh			; key pressed before ?
		jr z, _loop0		; no key to save/evaluate
;---------------------------------------------------------------------------
		ld hl, _pos
		ld e, l			; save position
		ld l, (hl)		; current key buffer position
		ld (hl), a		; save key
		inc hl			; advance to next key buffer position
		ld a, l
		ld l, e			; restore position
		ld (hl), a		; save new key buffer position
		jr _loop
		; TODO add code from reZet80 PIONEER deMon
		; TODO adapt for 2-digit display
;===========================================================================
