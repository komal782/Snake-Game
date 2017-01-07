.global division

//r0 is numerator
//r1 is denominator
//r2 is local to this subroutine
division:
	push	{lr}
	push 	{r2}		//store r2 in memory
	mov 	r2, #0		//set counter to 0

divLoop:
	subs 	r0,r0,r1		//subtract numerator by the denominator
	blt	divEnd		//branch if operation in subs is less than 0
	add 	r2, #1		//increment r2 otherwise
	b 	divLoop		//branch back to loop
	
divEnd:

	cmp	r0, #0
	addlt	r0, r0, r1


	mov 	r1, r0		// move remainder into r1
	mov 	r0, r2		// store the quotient into r0
	pop 	{r2}		// return r2 to original value
	pop	{lr}
	bx	lr		// branch back to callig code
	

// r0 is your dividend (numerator) RA
// r1 is your divisor (denoinator) RB
// r3 is RC
.global newDiv
newDiv:
	push	{r4-r10}
	mov	r2, #1		//counter
Div1:	
	cmp 	r1, #0x80000000
	cmpcc	r1,r0
	lslcc	r1, r1, #1
	lslcc 	r2, r2, #1
	bcc	Div1
	
	mov	r3, #0
	
Div2:	cmp	r0, r1
	subcs	r0,r0,r1
	addcs	r3,r3,r2
	lsrs	r2, r2, #1
	lsrne	r1,r1,#1

	bne	Div2
done:
	mov	r1, r0
	mov	r0, r3
	

	pop	{r4-r10}
	bx	lr



