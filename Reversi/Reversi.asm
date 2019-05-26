locals
sseg segment stack
		dw 200h dup(?)
sseg ends

cseg segment
assume cs:cseg, ds:dseg, ss:sseg

include Dseg.asm
include IsOption.asm
include Board.asm
include Border.asm
include Input.asm
include Turn.asm
include Tile.asm
include Win.asm
include BigTile.asm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				ACTUAL CODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:			mov ax, dseg
				mov ds, ax
			
				mov cx, 32			;
				mov ah, 2			;
				mov dl, 10			;
clear:			int 21h				;
				loop clear			; clearing console
				mov ah, 2			;
				mov bh, 0			;
				mov dx, 09b7h		;
				int 10h				;
				
				lea dx, chooseText	;
				mov ah, 9			; asking for board size
				int 21h				;

sizeIn:			mov ah, 8			;
				int 21h				;
				mov ah, 0			; getting board size
				
				cmp ax, 27			;
				jne noQuit			; checking if escape was pressed
				jmp quit			;
noQuit:			sub ax, 48			;
				
				cmp ax, 12			;
				ja sizeIn			;
				cmp ax, 4			; regulate size input
				jl sizeIn			;
				
				mov boardSize, ax	; set board size
				
				jmp setup
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				WHEN RESETTING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
resetup:		mov di, 5			;
				mov si, 0ffffh		;
				mov ah, 0ch			;
				mov al, 0			;
				mov bh, 0			;
				mov dx, 0			;
				mov cx, 0			;
drawBlack:		int 10h				; painting the screen black
				inc cx				;
				dec si				;
				cmp si, 0			;
				jne drawBlack		;
				mov si, 0ffffh		;
				mov cx, 0			;
				add dx, 100			;
				dec di				;
				cmp di, 0			;
				jne drawBlack		;

				jmp start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;				EVERY ITERATION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setup:			mov si, DRAW_X		;
				mov pointerX, si	;
				mov si, DRAW_Y		;	
				mov pointerY, si	; resetting variables
				mov blues, 0		;
				mov yellows, 0		;
				mov nBPos, 0		;

				mov ah, 0			;
				mov al, 12h			; setting video mode
				int 10h				;
								
				mov ax, boardSize	;
				inc ax				;
				mov cx, boardSize	;
				mul cl				; di = last index of the board
				mov di, ax			;
				dec di				;
				
				mov si, 0						;
nextRow:		mov cx, boardSize				;
setRow:			mov numboard[si], 2				;
				inc si							;
				loop setRow						;
				cmp si, di						; creating the numboard with 0feh at 
				je boardDone					; the end of each row and 0ffh at the
				mov numboard[si], byte ptr 254	; end of the board
				inc si							;
				jmp nextRow						;
boardDone:		mov numboard[si], byte ptr 255	;

				mov ax, boardSize	;
				mov cl, 2			;
				div cl				;
				mov ah, 0			; cx & dx = boardsize / 2 - 1,
				mov cx, ax			; in order to find the middle of
				dec cx				; the board
				mov dx, cx			;
				
				mov ax, boardSize	;
				inc ax				;
				mov si, 0			;
toMid:			add si, ax			; si = index of the middle of the board
				loop toMid			;
				add si, dx			;
				
				mov numboard[si], 1	;
				inc si				;
				mov numboard[si], 0	;
				add si, boardSize	; placing the first pieces according to si
				mov numboard[si], 0	;
				inc si				;
				mov numboard[si], 1	;
				
				mov turn, 1			; resetting the turn
				
				lea ax, numboard	;
				push ax				;
				push DRAW_X			; drawing initial board
				push DRAW_Y			;
				call DrawBoard		;
				
				push pointerColorX	;
				push pointerX		; drawing the first border
				push pointerY		;
				call DrawBorder		;
				
				mov si, 0			;
				mov ax, boardsize	;
				mov cl, 2			;
				div cl				;
				cmp ah, 1 			;
				jne ajmp			;
				mov si, 16			;
ajmp:			dec al				; ax = pos at which to draw the idicator
				mov cl, 32			;
				mul cl				;
				add ax, DRAW_X		;
				sub ax, 16			;
				add ax, si			;
				mov indicX, ax	

				
				push offset TurnText	;
				push indicX				;
				push 40					;
				call DrawTile			;
				push offset blueNoBack	;
				mov ax, indicX			; drawing initial turn indicator
				add ax, 64				;
				push ax					;
				push 40					;
				call DrawTile			;
				
	; inputs
input:			mov ah, 7
				int 21h
				
				cmp al, 27 ; escape pressed
				jne w
				jmp quit

w:				cmp al, 119	; "w" pressed 
				jne a
				call wPressed
				jmp input

a:				cmp al, 97	; "a" pressed 
				jne s
				call aPressed
				jmp input

s:				cmp al, 115	; "s" pressed 
				jne d
				call sPressed
				jmp input

d:				cmp al, 100	; "d" pressed
				jne r
				call dPressed
				jmp input

r:				cmp al, 114	; "r" pressed
				jne space
				jmp resetup

space:			cmp al, 32
				jne noIn

				push offset numboard	;
				push nBPos				;
				call IsOption			; only procceeding if move is possible				
				cmp canMove, 1			;
				jne noIn				;
				
				call spacePressed		; calling space actions
				
				push offset numboard	;
				call IsWin				;
				cmp won, 1				; checking if game is over
				je winScreen			;
				
				cmp turn, 1					;
				jne yellowTurn				;
				push offset blueNoBack		;	checking who's turn it is
				jmp showTurn				;
yellowTurn:		push offset yellowNoBack	;
	
showTurn:		mov si, indicX				;
				add si, 64					;
				push si						; drawing turn indicator
				push 40						;
				call DrawTile				;
				jmp input

noIn:			jmp input 	; go back to loop if input was not recognized

;;;;;;;;;;;;;;;;;;;;;;
;		FINITO
;;;;;;;;;;;;;;;;;;;;;;
winScreen:
				
				mov di, offset numboard
				mov bx, 0
				
countLoop:		cmp ds:[di + bx], byte ptr 0	;
				jne askip						;
				inc yellows						;
askip:			cmp ds:[di + bx], byte ptr 1	; add to the piece counters
				jne bskip						;
				inc blues						;
								
bskip:			inc bx							;
				cmp ds:[di + bx], byte ptr 254	;
				jne cskip						; going to the next tile and looping back	
				inc bx							; if there are still tiles to check
				jmp countLoop					;
cskip:			cmp ds:[di + bx], byte ptr 255	;
				jne countLoop			
				
				mov ax, blues
				mov bx, yellows
				cmp ax, bx
				ja blue
				cmp ax,bx
				jb yellow								
				push offset noOneWins
				jmp drawWin

blue:			push offset blueWins
				jmp drawWin
yellow:			push offset yellowWins

drawWin:		mov si, indicX
				sub si, 16
				push si
				push 8	
				call DrawBigTile
				
winInput:		mov ah, 7
				int 21h
				cmp al, 27	; escape
				je quit
				cmp al, 13	; enter key
				je replay
				cmp al, 114	; 'r' button
				jne noRes
replay:			jmp resetup
noRes:			jmp winInput
	
quit:
	int 3
cseg 	ends
end 	start





; DrawTileFull	proc 
				; push bp 
				; mov bp, sp
				; push ax bx cx dx si
				; mov ah, 0ch			; ah = value needed for pixel drawing
				; mov si, ss:[bp + 8]	; si = offset of tile
				; mov dx, ss:[bp + 4] ; dx = y pos
	; @@nextRow:	mov cx, ss:[bp + 6]	; cx = x pos
	; @@xUp:		mov al, ds:[si]		; al = color of the pixel
				; inc si
				; cmp al, 0feh
				; je @@yUp
				; cmp al, 0ffh
				; je @@close
				; int 10h
				; inc cx
				; jmp @@xUp
	; @@yUp:		inc dx
				; jmp @@nextRow
		
	; @@close:	pop si dx cx bx ax bp
				; ret 6
; DrawTileFull	endp 

