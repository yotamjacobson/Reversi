DrawBorder proc
				push bp
				mov bp, sp
				push ax bx cx dx si
				
				mov bh, 0
				mov ah, 0ch
				mov al, ss:[bp + 8]
				
				mov dx, ss:[bp + 4]
				mov cx, ss:[bp + 6]
				int 10h
				
				mov bl, 31
@@yUp:			inc dx
				int 10h
				dec bl
				jnz @@yUp
				
				mov bl, 31
@@xUp:			inc cx
				int 10h
				dec bl
				jnz @@xUp
				
				mov bl, 31
@@yDown:		dec dx
				int 10h
				dec bl
				jnz @@yDown
				
				mov bl, 30
@@xDown:		dec cx
				int 10h
				dec bl
				jnz @@xDown
	
				mov bl, 30
@@yyUp:			inc dx
				int 10h
				dec bl
				jnz @@yyUp
				
				mov bl, 29
@@xxUp:			inc cx
				int 10h
				dec bl
				jnz @@xxUp
				
				mov bl, 29
@@yyDown:		dec dx
				int 10h
				dec bl
				jnz @@yyDown
				
				mov bl, 28
@@xxDown:		dec cx
				int 10h
				dec bl
				jnz @@xxDown
								
				pop si dx cx bx ax bp
				ret 6
DrawBorder endp	