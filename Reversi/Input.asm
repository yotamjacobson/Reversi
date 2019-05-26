	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;				W INPUT
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wPressed proc
				push dx
				cmp pointerY, DRAW_Y	
				jne uSkip
				jmp endU
				
uSkip:			push 7
				push pointerX
				push pointerY
				call DrawBorder
				
				mov dx, boardSize
				sub nBPos, dx
				dec nBPos
				push offset numboard
				push nBPos
				call IsOption
				cmp canMove, 0
				je uuSkip
				
				push pointerColor
				jmp uuuSkip
uuSkip:			push pointerColorX
uuuSkip:		sub pointerY, 32
				push pointerX
				push pointerY
				call DrawBorder
				
endU:			pop dx
				ret
wPressed endp
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;				A INPUT
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
aPressed proc
				cmp pointerX, DRAW_X
				jne lSkip
				jmp @@endL
				
lSkip:			push 7
				push pointerX
				push pointerY
				call DrawBorder
				
				dec nBPos
				push offset numboard
				push nBPos
				call IsOption
				cmp canMove, 0
				je llSkip
				
				push pointerColor
				jmp lllSkip
llSkip:			push pointerColorX
lllSkip:		sub pointerX, 32
				push pointerX
				push pointerY
				call DrawBorder
				
@@endL:			ret
aPressed endp
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;				S INPUT
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sPressed proc
				push ax bx cx dx
				mov bx, DRAW_Y	;
				mov ax, boardSize	;
				mov cx, 32			;
				mul cx				; getting ax to the coordinate of the lowest tile
				add ax, bx			;
				sub ax, 32			; 
				
				cmp pointerY, ax	; 
				jne dSkip			; checking if there's a space below
				jmp endD			;
				
dSkip:			push 7
				push pointerX
				push pointerY
				call DrawBorder
				
				mov dx, boardSize
				add nBPos, dx
				inc nBPos
				push offset numboard
				push nBPos
				call IsOption
				cmp canMove, 0
				je ddSkip
				
				push pointerColor
				jmp dddSkip
ddSkip:			push pointerColorX
dddSkip:		add pointerY, 32
				push pointerX
				push pointerY
				call DrawBorder
				
endD:			pop dx cx bx ax
				ret
sPressed endp
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;				D INPUT
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dPressed proc
				push ax bx cx dx
				mov bx, DRAW_X		;
				mov ax, boardSize	;
				mov cx, 32			;
				mul cx				; getting ax to the coordinate of the right-most tile
				add ax, bx			;
				sub ax, 32			; 
				
				cmp pointerX, ax	; 
				jne rSkip			;	checking if there's space to the right
				jmp @@endR			; 
				
rSkip:			push 7
				push pointerX
				push pointerY
				call DrawBorder
				
				inc nBPos
				push offset numboard
				push nBPos
				call IsOption
				cmp canMove, 0
				je rrSkip

				push pointerColor
				jmp rrrSkip
rrSkip:			push pointerColorX
rrrSkip:		add pointerX, 32
				push pointerX
				push pointerY
				call DrawBorder

@@endR:			pop dx cx bx ax	
				ret
dPressed endp
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;			SPACEBAR INPUT
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
spacePressed proc
				push dx si
				mov si, nBPos			;	
				cmp numboard[si], 2		; not making a turn if the tile is taken
				jne endTurn				;
				
				call TurnPieces			; turning the pieces that need to be turned
				
				cmp turn, 1				; drawing a blue piece if its his turn
				je placeBlue			;

				push offset yellowPiece	;		
				push pointerX			;
				push pointerY			;
				call DrawTile			; placing a yellow piece where the player chose
				jmp finishTurn			;

placeBlue:		push offset bluePiece	;	
				push pointerX			;
				push pointerY			; placing a blue piece where the player chose
				call DrawTile			; 
				
finishTurn:		push pointerColor		;
				push pointerX			;
				push pointerY			; repainting the border that was drawn over
				call DrawBorder			;
				
				push dx					;
				mov dx, turn			;
				mov numboard[si], dl	; updating the numboard on the placed piece
				pop dx					;
				
				xor turn, 1				; switching turn
								
endTurn:		pop si dx
				ret
spacePressed endp