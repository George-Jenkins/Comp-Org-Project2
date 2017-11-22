.data

newLine: .asciiz "\n"
errorMessage: .asciiz "Error \n"
userInput: .space 4

.text

	main:
		
		la $a0, userInput
		la $a1, 5
		li $v0, 8
		syscall
		
		la $a0, newLine
		li $v0, 4
		syscall
		
		#start conversion. $s0(stores string) $s1(gets decimals added to it) $s2(stores bytes) $s3(number of chars) 
		la $s0, userInput
		addi $s1, $zero, 0
		addi $s3, $zero, 0
		
		#count number of chars in string
		countLoop:
			lb $t1, 0($s0)
			beqz $t1, doneCounting
			beq $t1, 10, doneCounting
			addi $s0, $s0, 1
			addi $s3, $s3, 1
			j countLoop
		doneCounting:
		la $s0, userInput #reset $s0
		
		stringConversion:
		lb $s2, 0($s0)
		
		beqz $s2, doneStringConversion
		beq $s2, 10, doneStringConversion
		
		charConversion:
		
			la $a0, newLine
			li $v0, 4
			syscall
		
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
				j doneCharConversion		
									
			doneCharConversion:
		
			addi $s0, $s0, 1 #add to adddress of string
			subi $s3, $s3, 1 #reduce count of chars
			
			j stringConversion
			
		doneStringConversion:
		
		la $a0, ($s1)
		li $v0, 1
		syscall
		
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
	
