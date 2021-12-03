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
    .global  run_main
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

    movq    $in_string2,%rdi    # load register for Pstring2
    leaq    -511(%rbp),%rsi     # set address for 2md Pstring, string goes from bottum->top
    movq    $0,%rax             # clear rax before scanf   
    call    scanf

    movq    $in_opt,%rdi        # load register for the user option
    subq    $16,%rsp            # make more room for the option    
    leaq    (%rsp),%rsi         # configure where is the option scanned          
    movq    $0,%rax             # clear rax before scanf
    call    scanf               # call the function

    movq    (%rsp),%rdi         # put stack pointer to first argument
    leaq    -256(%rbp),%rsi     # load the first argument as pstring1 for run_func
    leaq    -512(%rbp),%rdx     # load the second argument as pstring2 for run_func
    addq    $16,%rsp            # give more space to the stack frame
    call    run_func

    addq    $512,%rsp           # end of the main function
    movq    $0,%rax             # clear rax
    popq    %rbp                # end the stack-frame 
    ret

    # we are on func_select brench - to change do:
    # git checkout master , and then git merge