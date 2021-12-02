# Ori Azulay, 206336794
.section    .rodata
.align 8                        # Align address to multiple of 8
# values for scanf
in_len1:    .string "%d"        # len1
in_string1: .string "%s"        # Pstring1
in_len2:    .string "%d"        # len2
in_string2: .string "%s"        # Pstring2
in_opt:     .string "%d"        # opt

    .text
    .global run_main
    .type   run_main, @function # define 'run_main' function
run_main:
    pushq   %rbp                # start the stack-frame by the callee-saver
    movq    %rsp,%rbp           # call rsp as pointer to the end of stack
    subq    $512,%rsp           # make room for 2 Pstrings and two ('\0')

    movq    $in_len1,%rdi       # load register for Pstring1 size
    leaq    -256(%rbp),%rsi     # set address for 1st size, len1, at end of 1st string
    movq    $0,%rax             # clear rax before scanf   
    call    scanf

    movq    $in_string1,%rdi    # load register for Pstring1 
    leaq    -255(%rbp),%rsi     # set address for 1st string, string goes from bottum->top
    movq    $0,%rax             # clear rax before scanf   
    call    scanf

    movq    $in_len2,%rdi       # load register for Pstring1 size
    leaq    -512(%rbp),%rsi     # set address for 2nd size, len1, at the end of 2nd string
    movq    $0,%rax             # clear rax before scanf   
    call    scanf

    movq    $in_string2,%rdi    # load register for Pstring2, string goes from bottum->top
    leaq    -511(%rbp),%rsi     # set address for 2md Pstring
    movq    $0,%rax             # clear rax before scanf   
    call    scanf

    movq    $in_opt,%rdi         # load register for the user option
    subq    $16,%rsp            # make more room for the option    
    leaq    (%rsp),%rsi         # configure where is the option scanned          
    addq    $16,%rsp            # deallocate space
    call    run_func            # call the function

    addq    $512,%rsp           # end of the main function
    movq    $0,%rax             # clear rax
    popq    %rbp                # end the stack-frame 
    ret