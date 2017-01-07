.global GetMenuDirection
// r0 is the button register
// this returns 1 if down is pressed
// returns 0 if up is pressed
// returns 2 if A is pressed
// returns 3 if neither are pressed
GetMenuDirection:

	push	{r4-r10}
	ldr	r4, =0xffff
	eor	r4, r0

	// UP PRESSED
	mov	r5, #1			// Checking if the up button was pressed!
	lsl	r5, #4			// shift bit by 4 
	ands	r5, r4			// and while setting flags 
	
	movne	r0, #0			// if not equal, indicates button is set
	bne	menuDirEnd		// branch to end subroutine

	// DOWN PRESSED
	mov	r5, #1			// Checking if the down button was pressed!
	lsl	r5, #5			// shift bit by 5 to get the down button
	ands	r5, r4			// and while setting a condition code
	
	movne	r0, #1			// if not equal to zero put 1 (for up) into r0
	bne	menuDirEnd		// end the subroutine

	// A BUTTON PRESSED
	mov	r5, #1			// Checking if the down button was pressed!
	lsl	r5, #8			// shift 8 times to check the A button
	ands	r5, r4			// and while seting a condition code
	
	movne	r0, #2			// set 2 indicating A was pressed if not equal
	bne	menuDirEnd		// end the subroutine if not equal

	// START BUTTON PRESSED
	mov	r5, #1			// Checking if the down button was pressed!
	lsl	r5, #3			// shift 8 times to check the A button
	ands	r5, r4			// and while seting a condition code
	
	movne	r0, #4			// set 2 indicating start was pressed if not equal
	bne	menuDirEnd		// end the subroutine if not equal



	// OTHER BUTTONS PRESSED
	mov	r0, #3			// move 3 into r0 if none of the desired buttons are pressed

menuDirEnd:

	pop	{r4-r10}
	bx	lr


.global IsOppositeDir

// r0 is the postion proposed
// then we load the current position from memory, if it is the opposite direction ie: left vs right or up vs down
// return 0 if it is not the opposite direction
// return 1 if it is, returned in r0

IsOppositeDir:

	push	{r4-r10}
	ldr	r4, =gameState	// load previous button pressed from memory
	ldr	r4, [r4]	// load value into r4

	cmp	r0, #0		// check if the button pressed is up
	beq	checkUp		// if so branch to checkUp

	cmp	r0, #1		// check if the button pressed is down
	beq	checkDown	// if so branch to checkDown

	cmp	r0, #2		// check if the button pressed is left
	beq	checkLeft	// if so branch to checkLEft

	cmp	r0, #3		// check if the button pressed is right
	beq	checkRight	// if so branch to checkRight

	mov	r0, #0
	b	endIsOpposite

checkUp:
	cmp	r4, #1		// compare r4 with 1
	movne	r0, #0		// 
	bne	endIsOpposite
	mov	r0, #1
	b	endIsOpposite

checkDown:
	cmp	r4, #0
	movne	r0, #0
	bne	endIsOpposite
	mov	r0, #1
	b	endIsOpposite

checkLeft:
	cmp	r4, #3
	movne	r0, #0
	bne	endIsOpposite
	mov	r0, #1
	b	endIsOpposite	

checkRight:
	cmp	r4, #2
	movne	r0, #0
	bne	endIsOpposite
	mov	r0, #1
		
endIsOpposite:

	pop	{r4-r10}
	bx	lr


.global GetDirection
// r0 is the button register, returns 0...3 for valid directions
// r1 is the adress of the struct
// r2 is x -cord of head
// r3 is y -cord of head
// returns x in r0
// returns y in r1
// 0 = up
// 1 = down
// 2 = left
// 3 = right
GetDirection:
	push	{lr}
	push	{r4-r10}

	ldr	r4, =0xffff		// bit mask of all one's
	eor	r4, r0			// flip the bits


	mov	r5, #1			// move 1 into r5
	lsl	r5, #4			// shitf by 4 bits for up
	ands	r5, r4			// and while setting flags
	beq	next			// if result is 0 this button was not pressed
	movne	r0, #0			// check if the direction is opposite of previous
	blne	IsOppositeDir		// calling is opposite sub routine
	cmp	r0, #0			// compare result with 0, if eq then then they are not opposite
	moveq	r0, #0			// move 0 into r0
	streq	r0, [r1]		// store result into position			 
	beq	endDirection		// go to end of subroutine

next:
	mov	r5, #1			// move 1 into r5
	lsl	r5, #5			// shitf by 5 bits for down
	ands	r5, r4			// and while setting flags
	beq	next1			// if result is 0 this button was not pressed
	movne	r0, #1			// check if the proposed direction (down = 1) is opposite of previous
	blne	IsOppositeDir		// calling is opposite sub routine
	cmp	r0, #0			// compare result with 0, if eq then then they are not opposite
	moveq	r0, #1			// move 1 into r0
	streq	r0, [r1]		// store result into position			 
	beq	endDirection		// go to end of subroutine 

next1:
	mov	r5, #1			// move 1 into r5
	lsl	r5, #6			// shift by 6 bits for left
	ands	r5, r4			// and while setting flags
	beq	next2			// if result is 0 this button was not pressed
	movne	r0, #2			// check if the proposed direction (left = 2) is opposite of previous
	blne	IsOppositeDir		// calling is opposite sub routine
	cmp	r0, #0			// compare result with 0, if eq then then they are not opposite
	moveq	r0, #2			// move 2 into r0
	streq	r0, [r1]		// store result into position			 
	beq	endDirection		// go to end of subroutine
	
next2:
	mov	r5, #1			// move 1 into r5
	lsl	r5, #7			// shitf by 7 bits for right
	ands	r5, r4			// and while setting flags
	beq	next3			// if result is 0 this button was not pressed
	movne	r0, #3			// check if the proposed direction (right = 3) is opposite of previous
	blne	IsOppositeDir		// calling is opposite sub routine
	cmp	r0, #0			// compare result with 0, if eq then then they are not opposite
	moveq	r0, #3			// move 3 into r0
	streq	r0, [r1]		// store result into position			 
	beq	endDirection		// go to end of subroutine


next3:
	mov	r5, #1			// move 1 into r5
	lsl	r5, #3			// shitf by 3 bits for right
	ands	r5, r4			// and while setting flags
	beq	endDirection		// if result is 0 this button was not pressed
	blne	startMenu		// check if the proposed direction (right = 3) is opposite of previous
					// OPEN START MENU
	

//*****************************************************************
	
endDirection:	
	//modify x and y values based on what was stored


	ldr	r4, [r1]		// load the value from memory previous position or the new position
	cmp	r4, #0			// check if its up
	subeq	r3, #32			//update y value for up

	cmp	r4, #1			// check if its down
	addeq	r3, #32			//update y value for down

	cmp	r4, #2			// check if the direction is left
	subeq	r2, #32			//update x value for left

	cmp	r4, #3			// check if the direction is right
	addeq	r2, #32			//update x value for right

	mov	r0, r2			// move modified x coordinate
	mov	r1, r3			// move modified y coordinate
	mov	r2, #0			// set r2 to 0
	mov	r3, #0			// set r3 to 0

	pop	{r4-r10}		// pop registers back to orignal value
	pop	{lr}			// pop lr
	bx 	lr			// branch back to subrouitne call


.global ReadSnes
ReadSnes:

outerLoop:
	push	{r4-r10}

	mov 	r8, #0			//counter for the inner loop
	mov 	r9, #0			//holds the value of the button that was pressed
	
	push	{lr}
	mov	r0, #1			// write the value one into the clock
	bl	Write_Clock		// call write clock
	pop	{lr}

	push	{lr}
	mov	r0, #1			// write 1 to latch
	bl	Write_Latch		//call latch
	pop	{lr}
	
	push	{lr}
	mov 	r0, #12			// set wait time to 12 micro seconds
	bl	Wait			// wait 12 microseconds
	pop	{lr}	

	push	{lr}
	mov	r0, #0			//Set Latch to 0
	bl	Write_Latch		//call write latch 
	pop	{lr}

innerloop:
	cmp	r8, #16			//compare the counter with the value 16
	bge	inputPrint		//if it is bigger than 16, then we are done reading the button input
	
	push	{lr}
	mov 	r0, #6			// set wait time to 6 micro seconds
	bl	Wait			// wait 6 microseconds
	pop	{lr}			
		
	push	{lr}
	mov	r0, #0			//set the clock to 0
	bl	Write_Clock		//call write clock
	pop	{lr}

	push	{lr}
	mov 	r0, #6			// set wait time to 6 micro seconds
	bl	Wait			// wait 6 microseconds
	pop	{lr}
	
	push	{lr}
	bl	Read_Data		//reads the bits, the bit is stored in r0
	pop	{lr}	
	
	lsl	r0, r8			//shift the counter by 1, store the value in another register (r0)
	orr	r9, r0			//orr the shifted register with the value of the button
		
	push	{lr}
	mov	r0, #1			//set the clock to 1
	bl	Write_Clock		//call write clock
	pop	{lr}

	add 	r8, #1			//increment the counter
	b	innerloop		//branch back to top of innerloop
	
inputPrint:
	
	mov	r0, r9			//move the button input value into r0 to return the value
	pop	{r4-r10}
	bx	lr			//branch back to calling code


				
.global Init_GPIO
	
Init_GPIO:
//lets set pin 9 first as 
//CLK is output (GPIO11)
//Latch is output(GPIO9) controlls is data is read
//DATA is input (code 0) (GPIO10)checks which button where pressed

	push	{r4-r10}
	
	mov	r4, r1		// r4 is the function (001 or 000...) we're writing to
	mov	r1, r0		// r1 is our PIN # (our line 9/10/11..) (p)

	ldr	r0, =0x20200000	// r0 is our BASE ADDRESS

init_loop:
	cmp 	r1, #9		// r1 contains the pin number
	subhi 	r1, #10		// if r1 > 9 then subtract 10 (r1 is now the least sig dig)
	addhi 	r0, #4		// r0 contains the base adress
	bhi 	init_loop	// loop if greater than 0

	// r0 is your GPFSEL{n} address
	// r1 is you rpin of interst in GPSEL{n}
	// r1 -> least sgnificant bit of pin #

	ldr	r10, [r0]	// get the VALUE of the BASE ADDRESS into r10 
	
	mov	r9, #3		// move a multiply value of 3 into r9
	mul	r1, r9		// r1 (least significant digit of the pin #) * 3

	mov	r8, #7		// set 0111 to r8 (3 bits) BITMASK
	lsl	r8, r1		// shift 0111 r1 times to the left 0111 0000 0000 0000 
	lsl	r4, r1		// shift FUNCTION (001 or 000..) to the left r1 times 

	bic	r10, r8		// bitclear the VALUE of the BASE ADDRESS by my BITMASK
				// whatever is the same position as the 1's in the bitmask
				// you preserve

	orr     r10, r4		// orr r4 and r10 and store in r10
	str	r10, [r0]	// write back the VALUE Of the BASE ADDRESS back into the BASE ADDRESS

	pop	{r4-r10}
	bx	lr

// NOTE:
// you do not put write_latch, write_clock in main
// you put it in READ SNES!!!!
// so in READ SNES, you call write_latch(1) to open, wait(12) and then write_latch(0) to close the latch!
.global Write_Latch
Write_Latch:
	// write a bit to the GPIO latch line
	// CALL THIS IN READ SNES --> Write_Latch(1) --> Wait(12) --> Write_Latch(0)

	ldr	r2, =0x20200000 // load BASE ADDRESS to r2
	mov	r3, #1		// set r3 = 1

	lsl	r3, #9		// shift r3 (0001) to the right 9 times to align with pin#9 (LATCH)
	teq	r0, #0		// test if VALUE (argument) TO WRITE is 0 or 1 

	streq 	r3, [r2, #40] 	// set BASE ADDRESS to GPCLR0 if VALUE is 0
	strne	r3, [r2, #28] 	// set BASE ADDRESS TO GPSET0 if VALUE is 1

	bx	lr 		// go back to calling code
.global Write_Clock
Write_Clock:
	// writes to the GPIO clock line

	ldr	r2, =0x20200000 // load BASE ADDRESS to r2
	mov	r3, #1		// set r3 = 1

	lsl	r3, #11		// shift r3 (0001) to the left 9 times to align with pin#11 bit (CLOCK)
	teq	r0, #0		// test if VALUE (argument) TO WRITE is 0 or 1 

	streq 	r3, [r2, #40] 	// set BASE ADDRESS to GPCLR0 if VALUE is 0
	strne	r3, [r2, #28] 	// set BASE ADDRESS to GPSET0 if VALUE is 1

	bx	lr 		// go back to calling code
.global Read_Data
Read_Data:
	// reads a bit from the GPIO data line

	push 	{r4}	// preserve registers 4-10

	ldr 	r2, =0x20200000 // load BASE ADDRESS to r2
	ldr 	r1, [r2, #52] 	// set BASE ADDRESS to GPLEV0	
	mov 	r3, #1 		// set r3 = 1

	lsl 	r3, #10		// shift r3 (0001) to the left 10 times to align with pin#10 bit (DATA)
	and	r1, r3 		// mask every other bit  
	teq	r1, #0		// test if the bit in r1 is 0

	moveq	r4, #0		// return 0, stored in r4
	movne	r4, #1		// return 1, stored in r4

	mov 	r0, r4		// store value in r0 *******	
	
	pop	{r4}		// preserve registers 4-10
	bx	lr
 
// r0 is used for telling how long to wait 
.global Wait
Wait:
	// waits for a time interval, passed as a parameter

	ldr 	r3, =0x20003004 // address of the CLOCK			******
	ldr 	r1, [r3]	// read the clock and load into r1	******
	add	r1, r0		// ADD 12 or 6 MICROSECONDS!!!		******

waitLoop:
	ldr	r2, [r3]	// load address of the CLOCK into r2
	cmp	r1, r2		// stop when CLOCK = r1
	bhi 	waitLoop	// if higher r1 > r2, loop again
	bx	lr		// go back to calling code





