DrawBigTile proc
				push bp
				mov bp, sp
				push ax bx cx dx si
				
				mov ah, 0ch
				mov bh, 0
				
				mov si, ss:[bp + 8]	; si = offset of tile
				mov dx, ss:[bp + 4]	; dx = y pos
@@nextRow:		mov cx, ss:[bp + 6]	; cx = x pos
@@nextPix:		mov al, ds:[si + 1] ; al = color
				mov bl, ds:[si] 	; bl = counter				
				cmp bl, 255
				je @@close
				cmp bl, 254
				je @@yUp
				add si, 2
	
@@draw:			int 10h	;
				inc dx	;
				int 10h	;
				inc dx	;
				int 10h	;
				inc dx	;
				int 10h	;
				inc cx	;
				int 10h	; drawing sixteen pixels
				dec dx	;
				int 10h	;
				dec dx	;
				int 10h	;
				dec dx	;
				int 10h	;
				inc cx	;
				int 10h	;
				int 10h	;
				inc dx	;
				int 10h	;
				inc dx	;
				int 10h	;
				inc dx	;
				int 10h	;
				inc cx	;
				int 10h	;
				dec dx	;
				int 10h	;
				dec dx	;
				int 10h	;
				dec dx	;
				int 10h	;
				inc cx	;
				dec bl	
				jnz @@draw
				
				jmp @@nextPix	
@@yUp:			inc si
				add dx, 4
				jmp @@nextRow	
				
@@close:		pop si dx cx bx ax bp	
				ret 6
DrawBigTile endp