IsOption proc
				push bp
				mov bp, sp
				push ax bx cx dx si
				mov di, ss:[bp + 6]	; di = offset of numboard
				mov si, ss:[bp + 4]	; si = index in numboard
				
				mov bx, 0					;
@@clearTurn:	cmp turnedPieces[bx], 0ffh	; 
				je prestart					; clearing previous moves
				mov turnedPieces[bx], 0ffh	; 
				inc bx						;
				jmp @@clearTurn				;
				
prestart:		mov canMove, word ptr 0				
				mov turnPointer, word ptr 0
								
				mov bx, si						;
				cmp ds:[di + bx], byte ptr 2	;
				je @@start						; skipping the check if the tile is already taken
				jmp @@end						;

@@start:				
				; TOP LEFT
				mov ax, boardSize	; 
				add ax, 2			; ax = row length + 1
				
				mov bx, si
				sub bx, ax
				cmp bx, di
				jl notl
				mov dx, turn
				xor dx, 1
				cmp ds:[di + bx], dl
				jne notl
				
tlloop:			sub bx, ax
				cmp ds:[di + bx], byte ptr 254
				je notl
				cmp bx, di
				jl notl
				cmp ds:[di + bx], byte ptr 2
				je notl
				mov dx, turn
				cmp ds:[di + bx], dl
				jne tlloop
				
				mov canMove, word ptr 1
				push si
				mov dx, turn
				xor dx, 1
turntl:			mov si, turnPointer
				add bx, ax
				cmp ds:[di + bx], dl
				jne endtl
				mov turnedPieces[si], bl
				inc turnPointer
				jmp turntl
				
endtl:			pop si

notl:			
				; TOP RIGHT
topRight:		mov ax, boardSize
				
				mov bx, si
				sub bx, ax
				cmp bx, di
				jl notr
				mov dx, turn
				xor dx, 1
				cmp ds:[di + bx], dl
				jne notr

trloop:			sub bx, ax
				cmp ds:[di + bx], byte ptr 254
				je notr
				cmp bx, di
				jl notr
				cmp ds:[di + bx], byte ptr 2
				je notr
				mov dx, turn
				cmp ds:[di + bx], dl
				jne trloop
				
				mov canMove, word ptr 1								
				push si
				mov dx, turn
				xor dx, 1
turntr:			mov si, turnPointer
				add bx, ax
				cmp ds:[di + bx], dl
				jne endtr
				mov turnedPieces[si], bl
				inc turnPointer
				jmp turntr
				
endtr:			pop si	

notr:
				; BOTTOM RIGHT
bottomRight:	mov cx, boardSize
				mov ax, boardSize
				inc ax
				mul cx
				dec ax
				mov cx, ax			; cx = the last field of the numboard

				mov ax, boardSize	;
				add ax, 2			; ax = row length + 1
				
				mov bx, si
				add bx, ax
				cmp bx, cx
				ja nobr
				mov dx, turn
				xor dx, 1
				cmp ds:[di + bx], dl
				jne nobr

brloop:			add bx, ax			
				cmp ds:[di + bx], byte ptr 254
				je nobr
				cmp ds:[di + bx], byte ptr 255
				je nobr
				cmp bx, cx
				ja nobr
				cmp ds:[di + bx], byte ptr 2
				je nobr
				mov dx, turn
				cmp ds:[di + bx], dl
				jne brloop
				
				mov canMove, word ptr 1
				push si				
				mov dx, turn
				xor dx, 1
turnbr:			mov si, turnPointer
				sub bx, ax
				cmp ds:[di + bx], dl
				jne endbr
				mov turnedPieces[si], bl
				inc turnPointer
				jmp turnbr
				
endbr:			pop si	

nobr:		
				; BOTTOM LEFT
bottomLeft:		mov cx, boardSize
				mov ax, boardSize
				inc ax
				mul cx
				dec ax
				mov cx, ax			; cx = the last field of the numboard

				mov ax, boardSize
				
				mov bx, si
				add bx, ax
				cmp bx, cx
				ja nobl
				mov dx, turn
				xor dx, 1
				cmp ds:[di + bx], dl
				jne nobl

blloop:			add bx, ax
				cmp ds:[di + bx], byte ptr 254
				je nobl
				cmp ds:[di + bx], byte ptr 255
				je nobl
				cmp bx, cx
				ja nobl
				cmp ds:[di + bx], byte ptr 2
				je nobl
				mov dx, turn
				cmp ds:[di + bx], dl
				jne blloop
				
				mov canMove, word ptr 1
				push si
				mov dx, turn
				xor dx, 1
turnbl:			mov si, turnPointer
				sub bx, ax
				cmp ds:[di + bx], dl
				jne endbl
				mov turnedPieces[si], bl
				inc turnPointer
				jmp turnbl
				
endbl:			pop si
				
nobl:			
				; TOP
top:			mov ax, boardSize
				inc ax
				
				mov bx, si
				sub bx, ax
				cmp bx, di
				jl @@not
				mov dx, turn
				xor dx, 1
				cmp ds:[di + bx], dl
				jne @@not
				
tloop:			sub bx, ax
				cmp bx, di
				jl @@not
				cmp ds:[di + bx], byte ptr 2
				je @@not
				mov dx, turn
				cmp ds:[di + bx], dl
				jne tloop
				
				mov canMove, word ptr 1
				push si
				mov dx, turn
				xor dx, 1
turnt:			mov si, turnPointer
				add bx, ax
				cmp ds:[di + bx], dl
				jne endt
				mov turnedPieces[si], bl
				inc turnPointer
				jmp turnt
				
endt:			pop si
				
@@not:			
				; LEFT
@@left:			mov bx, si
				dec bx
				cmp bx, di
				jl nol
				mov dx, turn
				xor dx, 1
				cmp ds:[di + bx], dl
				jne nol
				
lloop:			dec bx
				cmp bx, di
				jl nol
				cmp ds:[di + bx], byte ptr 2
				je nol
				cmp ds:[di + bx], byte ptr 254
				je nol
				mov dx, turn
				cmp ds:[di + bx], dl
				jne lloop
				
				mov canMove, word ptr 1
				push si
				mov dx, turn
				xor dx, 1
turnl:			mov si, turnPointer
				inc bx
				cmp ds:[di + bx], dl
				jne endl
				mov turnedPieces[si], bl
				inc turnPointer
				jmp turnl
				
endl:			pop si

nol:				
				; BOTTOM
bottom:			mov cx, boardSize
				mov ax, boardSize
				inc ax
				mul cx
				dec ax
				mov cx, ax			; cx = the last field of the numboard

				mov ax, boardSize
				inc ax
				
				mov bx, si
				add bx, ax
				cmp bx, cx
				ja nob
				mov dx, turn
				xor dx, 1
				cmp ds:[di + bx], dl
				jne nob
				
bloop:			add bx, ax
				cmp bx, cx
				ja nob
				cmp ds:[di + bx], byte ptr 2
				je nob
				mov dx, turn
				cmp ds:[di + bx], dl
				jne bloop
				
				mov canMove, word ptr 1
				push si
				mov dx, turn
				xor dx, 1
turnb:			mov si, turnPointer
				sub bx, ax
				cmp ds:[di + bx], dl
				jne endb
				mov turnedPieces[si], bl
				inc turnPointer
				jmp turnb
				
endb:			pop si

nob:				
				; RIGHT
@@right:		mov bx, si
				inc bx
				mov dx, turn
				xor dx, 1
				cmp ds:[di + bx], dl
				jne nor
				
rloop:			inc bx
				cmp ds:[di + bx], byte ptr 2
				je nor
				cmp ds:[di + bx], byte ptr 254
				je nor
				cmp ds:[di + bx], byte ptr 255
				je nor
				mov dx, turn
				cmp ds:[di + bx], dl
				jne rloop
				
				mov canMove, word ptr 1
				push si
				mov dx, turn
				xor dx, 1
turnr:			mov si, turnPointer
				dec bx
				cmp ds:[di + bx], dl
				jne endr
				mov turnedPieces[si], bl
				inc turnPointer
				jmp turnr
				
endr:			pop si

nor:
@@end:			mov turnPointer, 0
				pop si dx cx bx ax bp
				ret 4
IsOption endp