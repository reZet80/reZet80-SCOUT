;===========================================================================
; reZet80 - Z80-based retrocomputing and retrogaming
; (c) copyright 2016-2021 Adrian H. Hilgarth (all rights reserved)
; reZet80 SCOUT (_scout.asm) [last modified: 2021-11-27]
; indentation setting: tab size = 8
;===========================================================================
; memory:
_ROM_2K:	equ 1			; 2 KiB ROM (0000-07FF)
_ROM_4K:	equ 0			; 4 KiB ROM (0000-0FFF)
					; 1 KiB RAM (8000-83FF)
_pos:		equ 8000h		; current position (8000)
_buffer:	equ 8001h		; display/key buffer (8001-800X)
					; stack (8XXX-83FF)
;---------------------------------------------------------------------------
; I/O ports:
; input port:	00h
; output port:	01h
;---------------------------------------------------------------------------
; start of Z80 execution, rst 00
		di			; needed for soft reset
		im 1			; simple interrupt mode 1
		ld hl, 8400h		; above RAM
		jr _init 
;---------------------------------------------------------------------------
		ds 08h, 0ffh		; rst 08
		ds 08h, 0ffh		; rst 10
		ds 08h, 0ffh		; rst 18
		ds 08h, 0ffh		; rst 20
		ds 08h, 0ffh		; rst 28
		ds 08h, 0ffh		; rst 30
;---------------------------------------------------------------------------
_isr:		reti			; ISR starts at 0038, rst 38
		ds 2ch, 0ffh		; fill up
;---------------------------------------------------------------------------
_nmi:		retn			; NMISR starts at 0066
;---------------------------------------------------------------------------
; split hexadecimal number into 2 digits and write to display buffer
;  a: hexadecimal number (input)
;  c: temp storage
; hl: ptr to display buffer
_hex2d:		ld c, a
		rrca
		rrca
		rrca
		rrca			; bits 4-7
		and 0fh
		ld (hl), a
		inc hl
		ld a, c
		and 0fh			; bits 0-3
		ld (hl), a
		ret
;---------------------------------------------------------------------------
_init:		ld sp, hl		; stack at top of RAM
		ld d, h			; save for later use
_init0:		dec hl			; start from 83FF
		ld a, 55h		; 55h = 01010101b
		ld (hl), a
		cp (hl)
		jr nz, _init1		; no RAM
		cpl			; 10101010b = aah
		ld (hl), a
		cp (hl)
		jr z, _init0
_init1:		inc hl			; no more RAM found
		ld a, 01h
		ld (hl), a		; set up buffer position
		inc hl
		ld a, d
		sub h
		rrca
		rrca			; determine amount of RAM in KiB
		and 0fh
		call _hex2d		; display amount of RAM
;---------------------------------------------------------------------------
include "_demon.asm"			; no jump/call so include first
;---------------------------------------------------------------------------
if _ROM_2K
		ds 07F0h-$, 0ffh	; fill up (2 KiB)
endif
if _ROM_4K
		ds 0FF0h-$, 0ffh	; fill up (4 KiB)
endif
;---------------------------------------------------------------------------
include "_7segdat.asm"			; 7-segment data
;===========================================================================
