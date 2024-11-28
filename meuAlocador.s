.section .data
    TOPO_HEAP: .quad 0
	INICIO_HEAP: .quad 0

.section .text
.globl iniciaAlocador, finalizaAlocador, liberaMem, alocaMem, imprimeMapa

iniciaAlocador:
    pushq   %rbp
    movq    %rsp, %rbp

    movq    $12, %rax
    movq    $0, %rdi
    syscall

    movq    %rax, INICIO_HEAP
    movq    %rax, TOPO_HEAP

    popq   %rbp
    ret

finalizaAlocador:
    pushq   %rbp
    movq    %rsp, %rbp

    popq   %rbp
    ret

liberaMem:
    pushq   %rbp
    movq    %rsp, %rbp

    popq   %rbp
    ret

alocaMem:
    pushq   %rbp
    movq    %rsp, %rbp

    popq   %rbp
    ret

imprimeMapa:
    pushq   %rbp

    movq    %rsp, %rbp
    popq   %rbp
    ret
