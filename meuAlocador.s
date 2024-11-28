.section .text
.globl iniciaAlocador, finalizaAlocador, liberaMem, alocaMem, imprimeMapa

iniciaAlocador:
    pushq   %rbp
    movq    %rsp, %rbp

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
