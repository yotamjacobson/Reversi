IsWin proc
				push bp
				mov bp, sp
				push bx di ax
				
				mov ax, 0 			; ax tells if both players were checked for possible moves
				mov won, word ptr 2 ; default = not one won
				
checkAgain:		mov di, ss:[bp + 4]	; di = numboard's offset
				mov bx, 0			; bx -> indexer of numboard, starts at 0
				
@@loop:			push di				;
				push bx				; checking if placing on the bx'th tile is possible 
				call IsOption		;
					
				cmp canMove, 1		;
				je @@end			; if the player can move exit the function

				inc bx							;
				cmp ds:[di + bx], byte ptr 254	;
				jne @@skip						; going to the next tile and looping back	
				inc bx							; if there are still tiles to check
				jmp @@loop						;
@@skip:			cmp ds:[di + bx], byte ptr 255	;
				jne @@loop						;
				
				cmp ax, 1		;
				je winFound		; checking if the second player has moves 
				xor turn, 1		; and if he does, changing the turn to him
				mov ax, 1		; 
				jmp checkAgain	;
				
winFound:		mov won, 1
	
@@end:			pop ax di bx bp
				ret 2
IsWin endp