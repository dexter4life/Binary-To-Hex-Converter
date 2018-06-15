
[BITS 16]

org 		0100h		;origin of the program

[SECTION .text]
start:
	mov 	dx, [textpos]
	call	SetCursorPos
	
	mov 	dx, 	mymsg
	call 	WriteText
	
	call 	Exit
	
	ret
WriteText:
	mov 	ah, 	09h			; text print routine from dos
	int 	21h				; call the IVT
	ret
	
SetCursorPos:
	mov 	ah, 02h
	mov 	bh, 0
	int 	10h
	ret 
Exit:	
	mov ax, 04c00h
	int 	21h
	
[SECTION .data]
	textpos 	dw 	1017
	mymsg 		db 	'This is the text i want to display','$'
	CRLF		db 	0Dh, 0Ah, '$'

	
