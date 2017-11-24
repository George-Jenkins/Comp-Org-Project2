.data

word: .asciiz "test"
camma: .asciiz ","
newLine: .asciiz "\n"
errorMessage: .asciiz "Error \n"
userInput: .space 1000

.text

	main:
		
		la $a0, userInput
		la $a1, 1001
		li $v0, 8
		syscall
		
		la $a0, newLine
		li $v0, 4
		syscall
		
		#$s0(stores string) $s1(gets decimals added to it) $s2(stores bytes) 
		#$s3(number of chars) $s4(stores decimal when displaying) 
		#$s5 (is 1 when there is another number in input and 0 otherwise. Value gets checked after one conversion)
		#$s6 stores user input and gets its offset changed to move to next string
		
		#start conversion. 
		la $s6, userInput
		startProcess:
		move $s0, $s6
		addi $s1, $zero, 0
		addi $s3, $zero, 0
		
		
		#count number of chars in string
		countLoop:
			lb $t1, 0($s0)
			beq $t1, 44, acknowledgeNextNumber #a camma was reached
			addi $s5, $zero, 0 #set acknowledgment of camma to none
			beqz $t1, doneCounting
			beq $t1, 10, doneCounting
			addi $s0, $s0, 1
			addi $s3, $s3, 1
			j countLoop
			acknowledgeNextNumber:
				addi $s5, $zero, 1
				j doneCounting
		doneCounting:
		move $s0, $s6 #reset $s0
		
		stringConversion:
		lb $s2, 0($s0)
		
		beqz $s2, doneStringConversion
		beq $s2, 10, doneStringConversion
		
		charConversion:
		
			
			beq $s2, 44, doneStringConversion
			blt $s2, 48, error
			blt $s2, 58, number
			blt $s2, 65, error
			blt $s2, 91, uppercase
			blt $s2, 97, error
			blt $s2, 123, lowercase 
			j error
		  
			lowercase:
				subi $s2, $s2, 87
				jal calcMultiple
				add $s1, $s1, $s2 
				j doneCharConversion
			uppercase:
				subi $s2, $s2, 55
				jal calcMultiple
				add $s1, $s1, $s2
				j doneCharConversion
			number:
				subi $s2, $s2, 48
				jal calcMultiple
				add $s1, $s1, $s2
				j doneCharConversion
			error:
				la $a0, errorMessage
				li $v0, 4
				syscall	
				j done		
									
			doneCharConversion:
		
			addi $s0, $s0, 1 #add to adddress of string
			subi $s3, $s3, 1 #reduce count of chars
			
			j stringConversion
			
		doneStringConversion:
			#store in stack
			addi $sp, $sp, -4
			sw $s1, 0($sp)
		
		displayDecimal:
			lw $s4, 0($sp)
			la $a0, ($s4)
			li $v0, 1
			syscall
		
		#see if there was a camma after the number that was just converted. $s5 is 0 if there wasn't
		beqz $s5, done
		addi $s0, $s0, 1#add 1 to move past camma
		move $s6, $s0  #increase offset by number of chars to start at next word
		
		la $a0, camma
		li $v0, 4
		syscall
		
		j startProcess
		
		done:
		
	li $v0, 10
	syscall
	
	
calcMultiple:
	addi $t0, $zero, 1 #becomes the multiple of 16
	addi $t1, $zero, 16 #simply equals 16
	addi $t2, $zero, 0 #counts loops
	calcLoop:
		addi $t2, $t2, 1
		beq $t2, $s3, endCalcLoop
		mult $t0, $t1
		mflo $t0
		j calcLoop
	endCalcLoop:
	mult $s2, $t0
	mflo $s2
	jr $ra				
	
