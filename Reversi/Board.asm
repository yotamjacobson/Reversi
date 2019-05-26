DrawBoard proc
				push bp 
				mov bp, sp
				push ax bx cx dx si
				
				mov si, ss:[bp + 8] ; si = numBoard's offset
				mov dx, ss:[bp + 4] ; dx = y pos
@@newRow:		mov cx, ss:[bp + 6] ; cx = x pos	
@@xUp:			mov al, ds:[si]		; al = the value on the numboard
				inc si
				cmp al, 2
				je @@empty
				cmp al, 0
				je @@yellow
				cmp al, 1
				je @@blue
				cmp al, 7
				je @@black
				cmp al, 8
				je @@wall
				cmp al, 9
				je @@surprise
				cmp al, 0feh
				je @@yUp
				cmp al, 0ffh
				je @@close	
				
@@empty:		lea bx, emptyTile 
				push bx				; tile's offset
				push cx				; x pos
				push dx				; y pos
				call DrawTile
				jmp @@nextCol
				
@@yellow:		lea bx, yellowPiece 
				push bx				; tile's offset
				push cx				; x pos
				push dx				; y pos
				call DrawTile
				jmp @@nextCol
				
@@blue:			lea bx, bluePiece 
				push bx				; tile's offset
				push cx				; x pos
				push dx				; y pos
				call DrawTile
				jmp @@nextCol
				
@@black:		lea bx, blackTile 
				push bx				; tile's offset
				push cx				; x pos
				push dx				; y pos
				call DrawTile
				jmp @@nextCol
	
@@wall:			lea bx, brickWall 
				push bx				; tile's offset
				push cx				; x pos
				push dx				; y pos
				call DrawTile
				jmp @@nextCol
	
@@surprise:		lea bx, sausage 
				push bx				; tile's offset
				push cx				; x pos
				push dx				; y pos
				call DrawTile
				jmp @@nextCol
	
@@nextCol:		add cx, 32 			; moving to the next column
				jmp @@xUp	
@@yUp:			add dx, 32			; moving to the next row
				jmp @@newRow
	
@@close:		pop si dx cx bx ax bp
				ret 6
DrawBoard endp