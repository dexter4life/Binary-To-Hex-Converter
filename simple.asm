
;nasm -o numberToHexStr.obj -f win32 stringToHexString.asm
;link /subsystem:console /defaultlib:msvcrtd.lib /entry:main numberToHexStr.obj

;==========================================================
;	data section contains all initialized datas
;==========================================================
section 			.data
	hash_table	db 	"0123456789ABCDEF"
	msg			db	"The hex number is: %s", 13, 10, 0
	msg2		db	"Enter decimal number: ", 0;
	in_m		db	"%d"

;==========================================================
;	Code section contains all intel executable instructions
;==========================================================
section				.bss
	hex_buf		resb	64						;save 64 byte to store hex chars
	mydata		resb	4						;reserve 4 byte for storage of input
;==========================================================
;	Code section contains all intel executable instructions
;==========================================================
section 			.text 				 
	global 		main
	extern		_printf
	extern		_scanf
	extern		__getch
	extern		_toupper

main:											;entry point
	push 	ebp									;save current value of ebp
	mov 	ebp, 	esp							;save current value in ebp for later
	sub		esp,	192							;reserve for command line argument
	push	dword 	mydata
	call	_getinput
	add		esp,	4
	push	dword 	hex_buf						;push address of hash_table to stack
	push	dword 	mydata
	call 	numberToHexStr						;call our numberToHexStr function
	add 	esp,	8
	pop 	ebx									;remove data from the stack
	xor 	ebx, 	ebx							;clear ebx register
	push	dword 	hex_buf						; eax contains return value
	push  	msg									;push value of _printf ==> printf(msg, eax)
	call 	_printf								;call printf method to display string
	add 	esp,  	8							;move esp to above msg by 4 byte
	call 	__getch
	push 	dword 	eax
	call	_toupper
	cmp		eax,	dword 'Y'
	je		near main
	add 	esp,  	ebp							;move the esp register to the ebp entry in the stack	
	pop 	ebp									;restore value of ebp
	mov 	eax, 	0							;return value for operating system
	ret											;return to operating system
	
numberToHexStr:									;string to hex conversion method
	push 	ebp									;save current state of ebp
	mov 	ebp,	esp 						;setup a stack frame for numberToHexStr
	xor 	edi, 	edi							;set edi to zero
	push	dword [ebp + 12]	
	push	dword [ebp + 8]	
	call	get_byte	
	add		esp, 	8							;remove mydata from stack
	pop 	ebp									;restore base pointer
	ret
get_byte:										;extract each nibbles from existing numbers and shift nibble to the left
	push	ebp									;save ebp register
	mov 	ebp, 	esp							;setup stack frame for getByte
	xor		ebx,	ebx
	mov 	ebx,	dword[ebp + 8]				;store value mydata in edi for conversion
	push 	dword[ebp + 8]						;push mydata in the stack frame for hex_length function
	call	hex_length							;get the nibble count in data
	add		esp, 	4
	mov	 	ecx, 	eax							;hex_length return nibble count in eax, ecx = eax
	mov 	edi,	dword [ebp + 12]			;hex_buf address store it in edi for printf
	mov 	esi,	[ebx]						;ebx value copy to esi
	mov 	edx,	esi							;dublicate value of esi in edx ( esi == edx)
loop_label1:
	dec		ecx									;decrement nibble count
	and		esi, 	0fh 						;mask esi with eax value
	mov 	al, 	byte[ hash_table + esi]		;copy equivalent byte from hash_table to al
	mov 	[edi + ecx],  byte al				;store value in memory ( hex_buf)
	shr		edx, 	4							;shift edx right by one nibble
	mov 	esi,	edx							;save edx in esi for next masking esi = edx >> 4
	mov 	eax, 	esi							;save esi in eax for cmp test
	cmp		eax,	0							;compare eax to 0 
	jnz		loop_label1							;jmp if not equal to loop_label1
	pop		ebp									;remove stack frame 
	ret
hex_length:										;get numbers of nibbles in a number	
	push	ebp									;save previous ebp register
	mov 	ebp, 	esp							;set up a stack frame for hex_length routine
	xor 	ecx,	ecx
	mov		ebx, 	dword [ebp + 8]				;copy address of mydata to eax
	mov 	edi,	[ebx]						;copy value of mydata to edi
_increment_label2:			
	shr 	edi, 	4							;shift right 4 bits
	inc		ecx									;increment count register
	mov 	eax,	edi
	cmp 	eax, 	0							;compare edi to zero
	jnz		_increment_label2					;jmp not zero to _increment_label2
	mov 	eax,	ecx							;move count value in ecx to eax ( eax = ecx )
	pop 	ebp									;remove stack from
	ret
_getinput:
	push	ebp
	mov 	ebp, 	esp
	sub		esp,	4
	push	msg2			
	call	_printf								;prompt for input
	add		esp, 	4
	push	dword[ebp + 8]
	push	in_m
	call	_scanf								;get data from dos
	add		esp,	8
	add 	esp, 	4
	pop		ebp
	ret