; RE projekat broj 28
; jul 2017
; Projekat radili:
; Katarina Radinovic Kapralovic 2014 / 0007
; Nikola Neskovic 2014/0217

INCLUDE Irvine32.inc
INCLUDE macros.inc

;.386
;.model flat, stdcall
;.stack 4096
ExitProcess proto, dwExitCode:dword

.const
L = 279
duzina = 280
L2 = 139
BUFFER_SIZE = 2

.data
barray	SWORD - 2, 2, 12, 31, 60, 99, 141, 177, 197, 192
		SWORD 158, 100, 30, -37, -83, -97, -77, -34, 18, 58
		SWORD 73, 58, 21, -23, -55, -62, -43, -5, 33, 57
		SWORD 54, 27, -12, -46, -59, -45, -10, 30, 56, 57
		SWORD 31, -11, -48, -64, -50, -12, 33, 64, 65, 35
		SWORD -12, -56, -74, -58, -14, 39, 76, 77, 42, -15
		SWORD -67, -89, -70, -16, 48, 92, 94, 50, -19, -83
		SWORD -109, -85, -18, 60, 114, 115, 61, -25, -103, -135
		SWORD -104, -21, 76, 142, 142, 74, -34, -131, -170, -129
		SWORD -23, 99, 180, 179, 91, -46, -169, -217, -163, -26
		SWORD 132, 236, 231, 114, -67, -227, -288, -213, -28, 184
		SWORD 323, 313, 150, -101, -324, -407, -297, -29, 279, 481
		SWORD 466, 216, -171, -522, -657, -479, -30, 507, 880, 869
		SWORD 402, -389, -1184, -1581, -1240, -31, 1890, 4102, 6037, 7164


buffer SWORD ?
filenameIN BYTE "input.pcm",0
filenameOUT BYTE "input_out.pcm"
fileHandleIN HANDLE ?
fileHandleOUT HANDLE ?
x SWORD duzina DUP(0)
K WORD 0
y SDWORD 0
time1 dword 0
time2 dword 0


.code
main proc
	
	call GetMseconds		; vreme starta
	mov time1, eax

;Otvaranje izlaznog fajla
	mov	edx, OFFSET filenameOUT
	call	CreateOutputFile
	mov	fileHandleOUT, eax
	
; Otvaranje ulaznog fajla
	mov	edx,OFFSET filenameIN
	call	OpenInputFile
	mov	fileHandleIN,eax

	
; Provera da li je doslo do greske
	cmp	eax,INVALID_HANDLE_VALUE		
	jne	file_ok							
	mWrite <"Cannot open file",0dh,0ah>
	jmp	quit						
	
file_ok:
; Read the file into a buffer.
	mov	edx,OFFSET buffer
	mov	ecx,BUFFER_SIZE
	call	ReadFromFile
	jnc	buf_ok			
	mWrite "Error reading file. "	
	call	WriteWindowsMsg
	jmp	close_file
	
	
buf_ok:
	xor eax, eax
	xor edx, edx
	xor ecx, ecx
	xor ebx, ebx

	movsx ebx, K					;broj bajtova koji je do sada upisan u x
	.IF(ebx < L + L)				; max K = 2 * (280 - 1)
		add K, 2
	.ENDIF
	.IF(ebx > 0)					; preskace se samo pri upisu prvog podatka
		mov esi, ebx
		sub ebx,2
		mov eax,esi
		shr eax,1
		mov ecx, eax
	pomeranje:						;siftovanje ulaznog niza-bafera
		movsx eax, x[ebx]
		mov x[esi], ax
		mov esi, ebx
		sub ebx, 2
		dec ecx
		jnz pomeranje
	.ENDIF
		
	mov ax, buffer
	mov x, ax
	mov ecx, L
		
	.while (ecx > 139)				; racunanje y(n)
		mov eax, ecx
		shl eax, 1
		mov ebx, eax
		movsx edx, x[ebx]
		mov eax, L
		sub eax, ecx
		shl eax, 1
		mov ebx, eax
		movsx eax, x[ebx]
		add edx, eax
		mov eax, L
		sub eax, ecx
		shl eax, 1
		mov ebx, eax
		movsx eax, barray[ebx]
		imul eax, edx
		add y, eax
		dec ecx
	.endw

; Upis u fajl
	mov eax, fileHandleOUT
	mov	edx,OFFSET y +2				;upis visa dva bajta
	mov	ecx,BUFFER_SIZE
	call	WriteToFile
	cmp	eax, BUFFER_SIZE
	jz	dalje						; greska?
	mWrite "Error writing to file. "		
	call	WriteWindowsMsg
	jmp	close_file
		
dalje:
	mov y, 0						;priprema za sledecu petlju
	mov eax, fileHandleIN
	mov	edx,OFFSET buffer
	mov	ecx,BUFFER_SIZE
	call	ReadFromFile
	cmp	eax, BUFFER_SIZE
	jz buf_ok						;povratak na pocetak

	
close_file:
	mov	eax,fileHandleIN
	call	CloseFile
	mov	eax, fileHandleOUT
	call	CloseFile

	call GetMseconds				; vreme zavrsetka programa
	mov time2, eax
	sub eax,time1
	call WriteDec
	mWrite " ms passed "
	call Crlf
	call WaitMsg

quit:
	exit

main endp
end main