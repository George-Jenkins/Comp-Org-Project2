.data

testChar1: .asciiz "a"
testChar2: .asciiz "A"
testChar3: .asciiz "1"
newLine: .asciiz "\n"
errorMessage: .asciiz "Error \n"
userInput: .space 1
.text

	main:
		
		la $a0, userInput
		la $a1, 2
		li $v0, 8
		syscall
		
		la $a0, newLine
		li $v0, 4
		syscall
		
		la $s0, userInput
		lb $s0, 0($s0)
		
		
		la $a0, newLine
		li $v0, 4
		syscall
		
		blt $s0, 48, error
		blt $s0, 58, number
		blt $s0, 65, error
		blt $s0, 91, uppercase
		blt $s0, 97, error
		blt $s0, 123, lowercase 
		j error
		  
		lowercase:
			subi $s0, $s0, 87
			la $a0, ($s0)
			li $v0,1
			syscall 
			
			j doneCharConvert
		uppercase:
			subi $s0, $s0, 55
			la $a0, ($s0)
			li $v0, 1
			syscall
			
			j doneCharConvert
		number:
			subi $s0, $s0, 48
			la $a0, ($s0)
			li $v0, 1
			syscall
			
			j doneCharConvert
		
		error:
			la $a0, errorMessage
			li $v0, 4
			syscall	
			
			j doneCharConvert		
									
		doneCharConvert:
		
	li $v0, 10
	syscall
	
	
	