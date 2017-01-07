.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    	bl		InstallInteruptTable

	
	bl		EnableJTAG	// enables jtag

	bl		InitFrameBuffer // branch to function 'InitFrameBuffer'

mainMenu:
	bl 		homescreenstart

story:
	mov		r0, #0
	mov		r1, #0
	mov		r2, #1024
	mov		r3, #768
	ldr		r4, =storyScreen
	bl		DrawPicture

	bl		disableIrq

readStory:
	bl	ReadSnes	// read the buttons, returns register of buttons pressed 1= not pressed, 0 
				// = pressed
	
	ldr	r1, =0xffff		// load value into r1	
	eors	r0, r1			// flip the bits with an exclusive or
	beq	readStory


	bl		initValPack

restart:

	mov		r0, #3			// set the lives to 3
	ldr		r1, =gameState		// get adress of the gameState
	str		r0, [r1, #12]		// store the value of lives into memory
	
	mov		r0, #0			// mov 0 into the r0 register
	str		r0, [r1, #16]		// store the door flag back to 0
	str		r0, [r1, #20]		// reset 

	mov		r0, #0
	str		r0, [r1, #8]		// store the number of ribbons (score) to 0 in memory

gameScreen:
	
	mov		r8, #400	
	mov		r9, #0
	mov		r0, #0 		// r0 = 0 (x-coord)
	mov		r1, #0		// r1 = 0 (y-coord)

	bl	clearScreen	


	ldr	r0, =gameState  // get the adress of gameState
	mov	r1, #3		// move 3 into r1
	str	r1, [r0, #12]	// sotre 3 into memery at offset 12 (lives)


	bl 		Border

//**************************DRAW THE LIVES AND SCORE********************//
	bl 		DrawChar

	mov 	r0, #64 	// x coord
	mov 	r1, #736	// y coord
	mov	r2, #32		// width of image
	mov 	r3, #32		// height of image
	ldr 	r4, =heart	// load image into reg
	bl 	DrawPicture	// call draw picture

	mov 	r0, #96 	// x coord
	mov 	r1, #736	// y coord
	mov	r2, #32		// width of image
	mov 	r3, #32		// height of image
	ldr 	r4, =heart	// load image into reg
	bl 	DrawPicture	// call draw picture

	mov 	r0, #128 	// x coord
	mov 	r1, #736	// y coord
	mov	r2, #32		// width of image
	mov 	r3, #32		// height of image
	ldr 	r4, =heart	// load image into reg
	bl 	DrawPicture	// call draw picture
	
//**********************************************************************//
	
	bl		map
	bl	DrawScore2		// UPDATE SCORE
	ldr	r10, =70000


//***************INIT SNAKE ARRAY*******************************//
initSnake:
	mov	r1, #4
	ldr	r0, =gameState
	str	r1, [r0, #4]		//set length of snake as 4
	mov	r1, #0			// set direction to up (0)
	str	r1, [r0]

	mov	r8 , #256
	mov	r9, #352
	mov	r4, #0

InsertLoop:
	
	mov	r0, r4
	mov	r1, r8
	mov	r2, r9
	
	bl	InsertPosition

	add	r4, #1
	add	r9, #32
	cmp	r4, #4
	blt	InsertLoop



	mov	r8, #1
	mov	r5, #0
update:



	//get new head location
	mov	r0, #0
	bl	LoadPosition		// x cord is loaded into r0
					// y cord is loaded into r1
	
	mov	r2, r0			// move x cord to r2
	mov	r3, r1			// move y cord to r3

	push	{r2, r3}		// preserve r2 and r3 since ReadSnes whipes the value
	bl	ReadSnes		// call readSnes and return button register into r0
	pop	{r2, r3}		// restore r2 and r3

	//CHECK IF THE GAME SHOULD RESET OR QUIT
	ldr	r4, =gameState
	ldr	r4, [r4, #20]
	cmp	r4, #1			// check if we need to restart the game
	beq	restart

	cmp	r4, #2			// check if we need to quit game to main menu
	beq	mainMenu		// quit to main menu

	
	ldr	r1, =gameState		// load the the gamestate register
	bl	GetDirection		// get direction uses r0 has the button register and r1
					// as the gameState adress
					// r0 has new x cord from GetDirection
					// r1 has new y cord from GetDirection

	mov	r2, #32			// set the width as 32
	mov	r3, #32			// set the hegith as 32


//**************************CHECK FOR BOW COLLISON******************************//
	push	{r0-r3}			// preserve r0-r3 to be used by other subroutines
	bl	DetectBow		// see if desired position of head detects a bow

	cmp	r0, #1			// 1 means a bow was detected
	moveq 	r9, #1			// user r9 to update snake later use this to set r5 = r9

	ldr	r1, =gameState		// load the gameState into r1 if equal flag is set
	ldreq	r2, [r1, #8]		// load current score value if equal flag is set
	addeq	r2, #1			// increment score by 1 if equal flag is set
	streq	r2, [r1, #8]		// store the new score into the gameState score location

	push	{r2}
	bleq	DrawScore2		// UPDATE SCORE
	pop	{r2}

	cmp	r2, #20			// check if the score is 20

	moveq	r3, #1			// set flag in 1 to indicate a door should be availeble
	ldr	r1, =gameState
	streq	r3, [r1, #16]		// store the flag value into the adress


	pop	{r0-r3}			// restore r0-r3 for next subroutine call

//**************************CHECK FOR FEMALE PEPE*******************************//

	push	{r0-r3}			// preserve r0-r3 to be used by other subroutines
	bl	DetectFemalePepe	// see if desired position of head detects a bow

	cmp	r0, #1			// 1 means a female pepe was detected
	pop	{r0-r3}			// restore r0-r3 for next subroutine call	
	bleq	WinScreen		// go to win screen

	push	{r0-r3}
	sub	r1, #32
	
	bl	DetectFemalePepe	// see if desired position of head detects a bow
		
	cmp	r0, #1			// 1 means a bow was detected
	pop	{r0-r3}			// restore r0-r3 for next subroutine call	
	bleq	WinScreen

//**************************CHECK FOR VALUE PACK**********************************//

	push	{r0-r3}
	bl	DetectValuePack
					//TODO, RESPONSE TO VALUE PACK!!!
	cmp	r0, #1
	bleq	door			// Opens an extra door
	pop	{r0-r3}	
	beq	next


//**************************COLLISION DETECT************************************//
	push	{r0-r3}	
	cmp	r9, #1			// see if r9 has 4 in it, indicating that a ribbon was detected
	beq	next			// ingore collision detection if this is true
	blne	DetectCollision		// continue with collision detection if no ribbon was detected
	cmp	r0, #0			// check result with 0, indication a collison occured
	pop	{r0-r3}			// restoren r0-r3 for next subroutine
	beq	reset			// branch to the end of the end of program if true

next:
//****************************************************************************//
	cmp	r9, #1
	moveq	r5, r9
	push	{r0-r3}
	cmp	r5, #0
	blgt	InsertBody
	subgt	r5, #1
	pop	{r0-r3}

			
	push	{r0-r3}			// preserve r0 to r3 for anothe subroutine call
	bl	UpdateSnake		// update the snake posistion array
	pop	{r0-r3}			// restore r0-r3 since they are manipulated by updateSnake

	bl	DrawSnake		// Draws snkae new position on the screen
	
	


////////////////////////PRINT //BITCH/////////////////////////////////////////////////////////////////////
	ldr	r7, =gameState
	ldr	r6, [r7, #16]		// the door flag
	cmp	r6, #1			// check if door is 1
	bleq	door
	


	cmp	r6, #1
	moveq	r6, #2
	streq	r6, [r7, #16]
g:
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	cmp	r8, #1			// for initially random
	moveq	r8, #0			// set random flag to 0
	bleq	random			// create the intial random flag

	cmp	r9, #1			// compare r9 with 1
	moveq	r9, #0			// reset r9
	bleq	random			// print out the bow at the end!!!

	ldr	r0, =70000		// clock timer
	bl	Wait
	b	update


.global haltLoop$
haltLoop$:
	b		haltLoop$

/////////////////////////REE SET//////////////////////////////////////////////////////
reset:
	mov		r8, #400	
	mov		r9, #0
	mov		r0, #0 		// r0 = 0 (x-coord)
	mov		r1, #0		// r1 = 0 (y-coord)

	mov		r4, r0		// copy r0 into r4 (temp thing for the loop)
	// clear entire screen first
	mov		r2,	#0	// r2 = 0 (holds the colour)
resetLoop:

	bl		DrawPixel 	// branch to function 'DrawPixel'


	add		r4, #1		// r4 = r4 + 1
	ldr		r5, =752928	// r5 is...
	cmp		r4, r5		// compare r4 to r5
	mov		r0, r4		// copy r4 into r0

	add		r2,	#0	// add 0 into r2	

	blt		resetLoop	// if r4 < r5, then branch to loop

	bl 		Border		// Draw border of game
	bl		map		// draw map

	bl		removeLives	// decrement lives

	bl		DrawScore2	// draw the current score

	ldr		r5, =gameState		// get the remaining live memory	
	ldr		r4, [r5, #12]		// load the value of the reaming lives


	cmp		r4, #0		// see if any lives remain
	beq		LoseScreen	// if so end the fucking game BITCH HOE (sry relly tired forgive me senpai 						// <3	)


	ldr		r4, [r5, #16]
	cmp		r4, #2
	bleq		door
		

	b		initSnake

//****************************************************************************************************************

pauseScreen:
	mov 	r0, #416
	mov	r1, #256
	mov	r2, #160
	mov	r3, #96
	ldr 	r4, =pauseMenu

	bl 	DrawPicture


	
LoseScreen:
	bl	disableIrq


	mov	r0, #0			// start x coord is r0
	mov	r1, #0			// start y coord is r1
	ldr 	r2,=1024		// x dimension 
	ldr 	r3,=768			// y dimension
	ldr	r4,=losescreen		// addr of pic

	bl	DrawPicture

	ldr	r0, =100000
	bl	Wait
	b read
	
	

WinScreen:

	bl	disableIrq

	mov	r0, #0			// start x coord is r0
	mov	r1, #0			// start y coord is r1
	ldr 	r2,=1024		// x dimension 
	ldr 	r3,=768			// y dimension
	ldr	r4,=winscreen		// addr of pic

	bl	DrawPicture
	
	ldr	r0, =100000
	bl	Wait
	b 	read


read:
	bl	ReadSnes	// read the buttons, returns register of buttons pressed 1= not pressed, 0 
				// = pressed
	
	ldr	r1, =0xffff		// load value into r1	
	eors	r0, r1			// flip the bits with an exclusive or
	beq	read

	b	mainMenu

.global clearScreen
clearScreen:
	push	{lr}
	push	{r0-r10}
	mov	r4, #0
	mov	r2, #0
	

	mov		r0, #0 		// r0 = 0 (x-coord)
	mov		r1, #0		// r1 = 0 (y-coord)

	mov		r4, r0		// copy r0 into r4 (temp thing for the loop)

	mov		r2,	#0	// r2 = 0 (holds the colour)
	ldr		r2,	=0 // GREEN COLOUR =0b11111111100000

clearLoop:
	bl		DrawPixel 	// branch to function 'DrawPixel'


	add		r4, #1		// r4 = r4 + 1
	ldr		r5, =786432	// r5 is...
	cmp		r4, r5		// compare r4 to r5
	mov		r0, r4		// copy r4 into r0

	add		r2, #0

	blt		clearLoop	// if r4 < r5, then branch to loop
	

	pop	{r0-r10}
	pop	{lr}
	bx	lr

.section .data

	.align 4
font: 	.incbin "font.bin"

	.align 1

.global gameState
gameState:
	.int	0	// keep track of previous button initially up, 1 = down, 2 = left, 3 = right
	.int	4	// length of the snake, inititally is
	.int	0	// score (ribbons caught)
	.int	3	// lives
	.int	0	// has door
	.int	0	// restart flag, 1 indicates restart game, 2 indcates go back to start menu!
	.int	0	// 1 indicates we are on the some pause screen
	
.global snake
snake:
	.rept 256	// snake array used to keep track of its body positions
	.word  0	// initilize a word with value 0
	.endr		// end after setting 256 words.
	


