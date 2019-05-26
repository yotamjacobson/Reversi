TurnPieces proc
				push si ax bx cx dx
				
				mov si, 0 ; indexer of turnedPieces starts at 0
				mov bx, 0 ; making sure bh is set to 0

@@loop:			cmp turnedPieces[si], 0ffh	;
				je @@end					; checking if all the pieces were turned
				
				mov bl, turnedPieces[si]	;
				xor numboard[bx], 1			; updating the numboard on the turned piece				
				
				mov cx, 0	; 
				mov dx, 0	; making sure dh and ch are 0
				mov ax, boardSize
				inc ax
				push bx
				xchg ax, bx
				div bl
				pop bx
				mov cl, ah			; cx = x pos
				mov dl, al			; dx = y pos
				
				mov al, 32			;
				mul cl				;
				mov cx, ax			; cx = x pos in pixels
				add cx, draw_X		;
				
				mov al, 32			;
				mul dl				;
				mov dx, ax			; dx = y pos in pizels
				add dx, draw_Y		;
				
				cmp numboard[bx], 0
				je drawBlue
				push offset bluePiece
				jmp @@draw
drawBlue:		push offset yellowPiece
@@draw:			push cx
				push dx
				call DrawTile

				mov turnedPieces[si], 0ffh
				inc si						
				jmp @@loop
				
@@end:			pop dx cx bx ax si
				ret		
TurnPieces endp