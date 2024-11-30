.section .data	
	TOPO_HEAP:		.quad 0
	INICIO_HEAP:	.quad 0
	AUX_HEAP:		.quad 0
	
	DISPONIVEL:		.quad 0
	FLAG:			.quad 1

	str4:			.string "#"
	str5:			.string "<vazio>\n"
	ocup:			.string "+"
	free:			.string "-"
	break_line:		.string "\n"


.section .text 
.globl iniciaAlocador, alocaMem,  finalizaAlocador, liberaMem, imprimeMapa

iniciaAlocador:
	pushq	%rbp	
	movq	%rsp, %rbp

	movq	$12, %rax						# Realiza chamada Syscall para retornar o valor corrente de Brk
	movq	$0, %rdi
	syscall

	movq	%rax, INICIO_HEAP
	movq	%rax, TOPO_HEAP
	movq	%rax, AUX_HEAP

	popq	%rbp
	ret

alocaMem:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rdi, %rbx						# Armazena o parâmetro (num_bytes) em %rbx

	movq	$0, %r8							# Armazena o espaço alocado destinado para a Heap
	movq	$0, %r9							# Armazena o menor valor maior ou igual ao solicitado (Best Fit)
	movq	$0, %r14						# Variável auxiliar que sinaliza que existe um espaço disponível
	movq	$0, %r15						# Armazena o endereço com espaço disponível

	movq	INICIO_HEAP, %rcx
	movq	TOPO_HEAP, %rdx 

	percorreHeap:
		cmpq	%rcx, %rdx
		je		verificaSeDisponivel

		movq	0(%rcx), %r12  				# Armazena a disponibilidade do bloco
		movq	8(%rcx), %r13				# Armazena o tamanho alocado do bloco

		cmpq	$1, %r12					# Verifica se o bloco esta ocupado
		je		proximoBloco 				# Se sim, busca o proximo bloco

		cmpq	%rbx, %r13					# Verifica se o tamanho do bloco é menor ou igual ao tamanho solicitado
	    jle		proximoBloco 				# Se sim, busca o proximo bloco

		cmpq $0, %r9 						# Verificação inicial: Verifica se %r9 (menor valor maior ou igual ao solicitado) não foi inicializa
		je atualizaEndereco 				# Se sim, inicializa a variavel com o primeiro valor menor ou igual ao tamanho solicitado

		cmpq %r13, %r9 						# Compara o menor valor armazenado com o tamanho do bloco
		jl proximoBloco 					# O valor disponivel não é o suficiente, buscar o proximo bloco	
		
	
	atualizaEndereco:
		movq	%r13, %r9     				# Atualiza %r9 com o tamanho do bloco
		movq	$FLAG, %r14 				# Sinaliza que existe um bloco disponivel 
		movq	%rcx, %r15 					# Armazena o endereço do endereço do bloco

		jmp		proximoBloco

	alocaEndereco:
		movq	$1, 0(%r15) 				# Altera o status do bloco para "Ocupado"
		addq	$16, %r15					# Adiciona 16 bytes no endereço

		movq	%r15, %rax					# Retorna o endereço do espaço disponível				
		jmp		fimAlocaMem

	proximoBloco:
		addq %r13, %rcx  					#Adiciona o tamanho do espaço no endereço de rcx 
		addq  $16, %rcx 					#Adiciona 16 bytes no endereço de rcx para ir até o próximo bloco
		jmp percorreHeap
	
	verificaSeDisponivel:
		cmpq $FLAG, %r14					# Verifica se foi encontrado um bloco disponível (%r14 != 0)			
		je alocaEndereco

	
	aloca:
		movq AUX_HEAP, %rdi 				# Calcula o espaço corrente disponivel na Heap
		subq TOPO_HEAP, %rdi  		
		movq %rdi, DISPONIVEL    	

		cmpq %rbx, DISPONIVEL 				# Verifica se o espaço disponível é menor do que o soliciado
		jl expandeHeap						# Se sim, é necessário expandir a Heap						
		
		movq %rbx, %r10				
		movq %r10, %r11				
		addq  $16, %r11						# Adiciona 16 bytes (informações gerenciais)
		addq TOPO_HEAP, %r11				#Soma o tamanho da Heap com o valor "alocado"

		
		movq %r11, TOPO_HEAP				#Atualiza valor do topo da heap com r11

		movq	$1, (%rcx)					# Altera o status do bloco para "Ocupado"
		addq	$8,  %rcx			
		movq	%r10, (%rcx)				# Altera o valor do tamanho do bloco para o tamanho solicitado
		addq	$8,  %rcx
	
		movq	%rcx, %rax					# Retorna o endereço do espaço disponível
		jmp		fimAlocaMem

	expandeHeap:
		addq	$4096, %r8					# Aloca múltiplos de 4096 bytes (4K) 
		cmpq	%rbx, %r8					# Verifica se o espaço alocado é menor que o valor solicitado
		jle		expandeHeap					# Se verdadeiro, retorna e aloca mais 4096 bytes (4k)

		pushq	%rcx
		pushq	%rbx

		movq	$12, %rax					# Realiza chamada Syscall para Brk, com tamanho definido em %r8
		movq	%r8, %rdi					
		syscall

		popq	%rbx
		popq	%rcx

		addq	%r8, AUX_HEAP 				#Adiciona o valor de r8 (espaço novo alocado em brk) na variavel lim_BrK
		jmp aloca

	fimAlocaMem:
		popq %rbp
		ret

finalizaAlocador:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	INICIO_HEAP, %rdi 				# Realiza chamada Syscall para retornar o valor inicial de Brk ao inicio
	movq	$12, %rax					
	syscall

	popq	%rbp
	ret

liberaMem:
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, %rbx 						# Armazena a variável a ser desalocada

	subq $16, %rbx 							#Remove o ponteiro 
	movq $0, (%rbx) 						# Altera o status do bloco para "Livre"

	movq %rbx, %rax 				

	popq %rbp
	ret

imprimeMapa:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	INICIO_HEAP, %r13
	movq	TOPO_HEAP, %r14

	cmpq %r13, %r14                     	# Verifica se início e topo da Heap coincidem
	je saida_vazia                      	# Se sim, implica que não há valores armazenados na Heap

	inicio_while:
		cmpq	%r13, %r14					# Verifica se topo da Heap foi alcançado
		je		fim_while

		movq	0(%r13), %r12				# Armazena a disponibilidade do bloco
		movq 	8(%r13), %r15				# Armazena o tamanho do bloco

		movq	$0, %rbx					# Zera variável auxiliar
		movq	$0, %rcx					# Zera variável auxiliar

		beginInfoGerenciais:
			cmpq	$16, %rbx          		# %rbx é usado como contador para o laço de repeitção
			je		endInfoGerencial       	# Encerra o laço após ler 16 bytes

			mov		$str4, %rdi             # Imprime "#"
			call	printf

			addq	$1, %rbx
			jmp		beginInfoGerenciais

		endInfoGerencial:

		cmpq	$0, %r12              		# Verifica disponibilidade do bloco
		je		imprime_livre
		jne		imprimeOcupado

		imprimeOcupado:                
			cmpq %r15, %rcx        			# Compara rcx com tamanho do bloco
			jge saida_padrao            	# Se for maior ou igual, encerra o laço e pula pra saida

			pushq %rcx
			pushq %rbx

			mov $ocup, %rdi             	# Imprime '+'
			call printf

			popq %rbx
			popq %rcx

			addq $1, %rcx

			jmp imprimeOcupado

		imprime_livre:					
			cmpq %r15, %rcx 				# Compara rcx com tamanho do bloco
			jge saida_padrao				# Se for maior ou igual, encerra o laço e pula pra saida

			pushq %rcx
			pushq %rbx

			mov $free, %rdi  				# Imprime '-'
			call printf

			popq %rbx
			popq %rcx

			addq $1, %rcx

			jmp imprime_livre

		saida_padrao:
			addq %r15, %r13
			addq $16, %r13
			jmp inicio_while

	fim_while:
		pushq %rcx
		pushq %rbx

		mov $break_line, %rdi 				# Imprime '\n'
		call printf

		popq %rbx
		popq %rcx
		
		jmp the_end
	
	saida_vazia:
		pushq %rcx
		pushq %rbx

		mov $str5, %rdi  					# Imprime '<vazio>'
		call printf

		popq %rbx
		popq %rcx

	the_end:

	popq %rbp
	ret
