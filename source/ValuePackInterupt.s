
.global	initValPack

initValPack:

	ldr	r2, =25000000
	ldr	r1, =0x20003004		// adress of clock
	ldr	r1, [r1]		// get clock time
	add	r1, r2
	
	ldr	r2, =0x20003010		// get adress of the clock interupt
	str	r1, [r2]		// set condition for interupt to occur
	
	mrs	r1, cpsr		// load cpsr register into r1
	bic	r1, #0x80		// enable irq
	msr	cpsr_c, r1		// store this result back to the low 7 bits of cprc

	ldr	r0, =0x2000B210		// set irq pending register 1
	ldr	r1, [r0]		// get value in irg register
	orr	r1, #0x2		// set it with orr
	str	r1, [r0]		// store result back to irq

	bx	lr			// end subroutine

.global InstallInteruptTable


InstallInteruptTable:

	ldr		r0, =IntTable
	mov		r1, #0x00000000

	// load the first 8 words and store at the 0 address
	ldmia	r0!, {r2-r9}
	stmia	r1!, {r2-r9}

	// load the second 8 words and store at the next address
	ldmia	r0!, {r2-r9}
	stmia	r1!, {r2-r9}

	// switch to IRQ mode and set stack pointer
	mov		r0, #0xD2
	msr		cpsr_c, r0
	mov		sp, #0x8000

	// switch back to Supervisor mode, set the stack pointer
	mov		r0, #0xD3
	msr		cpsr_c, r0
	mov		sp, #0x8000000

	bx		lr	
	

irq:
	push	{lr}
	push	{r0-r12}

	mrs	r1, cpsr
	orr	r1, #0
	msr	cpsr_c, r1
	
	// test if there is an interupt pending for the clock
	ldr	r0, =0x2000B204		// adress for clock interupt
	ldr	r1, [r0]		// load value into r1
	tst	r1, #2			// tst with 2 (10)
	beq 	irqEnd			// if equal to 0 end the irq

	// if there is an iterrupt pending...

	ldr	r1, [r0]		// get value from adres of clock interupt
	bic	r1, #2			// clear the second bit
	str	r2, [r0]		// clear the interupt call and store in memeory
	
	// excute the value pack shit
	

	// check if we are on a pause or home screen

	bl	ValPack


	// reset the clock for next interupt 


	
	ldr	r2, =25000000
	ldr	r1, =0x20003004		// adress of clock
	ldr	r1, [r1]		// get clock time
	add	r1, r2
	
	ldr	r2, =0x20003010		// get adress of the clock interupt
	str	r1, [r2]		// set condition for interupt to occur

irqEnd:

	ldr	r0, =0x20003000
	ldr	r1, [r0]
	str	r1, [r0]
	pop	{r0-r12}
	pop	{lr}

	subs	pc,lr,#4

.global	disableIrq
disableIrq:
	push	{r0-r12}
	mrs	r1, cpsr
	orr	r1, #0x80
	msr	cpsr_c, r1
	pop	{r0-r12}
	bx	lr

.global	enableIrq

enableIrq:
	push	{r0-r12}
	mrs	r1, cpsr
	bic	r1, #0x80
	msr	cpsr_c, r1
	pop	{r0-r12}
	bx	lr


IntTable:
	// Interrupt Vector Table (16 words)
	ldr		pc, reset_handler
	ldr		pc, undefined_handler
	ldr		pc, swi_handler
	ldr		pc, prefetch_handler
	ldr		pc, data_handler
	ldr		pc, unused_handler
	ldr		pc, irq_handler
	ldr		pc, fiq_handler

reset_handler:		.word InstallInteruptTable
undefined_handler:	.word haltLoop$
swi_handler:		.word haltLoop$
prefetch_handler:	.word haltLoop$
data_handler:		.word haltLoop$
unused_handler:		.word haltLoop$
irq_handler:		.word irq
fiq_handler:		.word haltLoop$

	
