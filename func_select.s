# Ori Azulay, 206336794
    .section    .rodata
    .align 8                        # Align address to multiple of 8

# string to printf
case_50:        .string "first pstring length: %d, second pstring length: %d\n"
case_52:        .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
case_53:        .string "length: %d, string: %s\n"
def_option:     .string "invalid option!\n"

# values for scanf
char_in:        .string " %c %c"
uchar_in:       .string " %hhu"     # a char for number-input

jump_table:                         # JUMP TABLE   
    .quad   .L50                    # case 50 or 60           
    .quad   .default                # case 51 not exist, goto defualt
    .quad   .L52                    # case 52
    .quad   .L53                    # case 53
    .quad   .L54                    # case 54
    .quad   .L55                    # case 55
    .quad   .default                # case 56 not exist, goto defualt
    .quad   .default                # case 57 not exist, goto defualt
    .quad   .default                # case 58 not exist, goto defualt
    .quad   .default                # case 59 not exist, goto defualt
    .quad   .L50                    # case 60 return to case 50

    .text                           # code start
    .global run_func
    .type   run_func, @function     # define 'run_func' function
run_func:
    subq    $50,%rdi                # compute opti = opt-50
    cmpq    $10,%rdi                # compare opii to 10 
    ja      .default                # if 'opt' > 10 or negative (ja), goto defualt
    jmp     *jump_table(,%rdi,8)    # for correct case, goto jump table[opti]
    ret
    
# case defualt - if opt <50 , opt > 60 or opt==51,56,57,58,59
    .type   default, @function
.default:
    movq    $def_option, %rdi       # load format of printf %d for 'invalid'
    movq    $0, %rax                # clear rex before printf
    call printf                     # call message
    ret

# case 50 or 60 - function to return strings length
    .type   L50, @function
.L50:
    movq    %rsi,%rdi               # move 1st pstrlen's address to rdi (by convention)
    movq    $0,%rax                 # clear rax before calling a function
    call    pstrlen                 # call func to get 1st string size
    pushq   %rax                    # keep the answer for later
    movq    %rdx,%rdi               # move 2nd pstrlen's address to rdi (by convention)
    movq    $0,%rax                 # clear rax before calling a function
    call    pstrlen                 # call func to get 2nd string size
    popq    %rsi                    # pop 1st string's size to rsi for printing
    movq    %rax,%rdx               # move the second string size for printing
    movq    $case_50,%rdi           # load format string for printing
    movq    $0,%rax                 # clear rax before printf
    call printf                     # print
    ret
    
# case 52 - function to replace oldChar by newChar
    .type   L52, @function
.L52:
    pushq   %rsi                    # push address of pstring1
    pushq    %rdx                    # push address of pstring2
    subq    $8,%rsp                 # load space for user's input
    movq    $char_in,%rdi           # format %c for user input
    leaq    (%rsp),%rsi             # register rsi for oldChar
    leaq    1(%rsp),%rdx            # register rdi for newChar
    movq    $0,%rax                 # clear rax before scanf
    call    scanf
    movzbq  (%rsp),%rsi             # move first byte of oldChar to register
    movzbq  1(%rsp),%rdx            # move first byte of newChar to register
    movq    16(%rsp),%rdi           # move pstring1's address to rdi before function
    movq    $0,%rax                 # clear rax before calling a function
    call    replaceChar             # for pstring-1
    movzbq  (%rsp),%rsi             # move first byte of oldChar to register
    movzbq  1(%rsp),%rdx            # move first byte of newChar to register
    movq    8(%rsp),%rdi            # move pstring2's address to rdi before function
    movq    $0,%rax                 # clear rax before calling a function
    call    replaceChar             # for pstring-2
    movq    $case_52,%rdi            # format for printing message
    movq    (%rsp),%rsi             # first char to rsi
    movq    1(%rsp),%rdx            # second char to rdi
    addq    $8,%rsp                 # deallocate char's space
    popq    %r8                     # pop pstring2 to r8
    leaq    1(%r8),%r8              # set address of r8 to start of pstring2
    popq    %rcx                    # pop pstring1 to rcx   
    leaq    1(%rcx),%rcx            # set address of rcx to start of pstring1
    movq    $0,%rax                 # clear rax before printf
    call    printf
    ret
    
# case 53 - function to replace charecters by given i-j index
    .type   L53, @function
.L53:
    pushq   %r12                    # tempurary1 value
    pushq   %r13                    # tempurery2 value
    pushq   %rsi                    # address of pstring1
    pushq   %rdx                    # address of pstring2
    subq    $8,%rsp                 # load space for i
    movq    $uchar_in,%rdi          # load format index
    leaq    (%rsp),%rsi             # saving value of first scaned int
    movq    $0,%rax                 # clear rax before scanf
    call    scanf

    movzbq  (%rsp),%r12             # save i in tempurary1 
    movq    $uchar_in,%rdi          # load format index
    leaq    1(%rsp),%rsi            # saving value of second scaned int
    movq    $0,%rax                 # clear rax before scanf
    call    scanf

    movzbq  1(%rsp),%rcx            # save the value of j in rcx
    movq    %r12,%rdx               # save the value of i in rdx
    addq    $8,%rsp                 # deallocate the indexes space
    movq    (%rsp),%rsi             # address of pstring2
    movq    8(%rsp),%rdi           # address of pstring1
    movq    $0,%rax                 # clear rax before function
    call    pstrijcpy

    popq    %r12                    # pop second string to r12
    popq    %r13                    # pop first string to r13
    movq    $0,%rsi                 # clear rsi 
    movb    (%r13),%sil             # move pstring1 size to sil
    leaq    1(%r13),%rdx            # move string's address to rdx
    movq    $case_53,%rdi           # load format for printing message
    movq    $0,%rax                 # clear rax before printf
    call    printf
    
    movq    $0,%rsi                 # clear register rsi
    movb    (%r12),%sil             # move pstring2 size to sil
    leaq    1(%r12),%rdx            # move string's address to rdx
    movq    $case_53,%rdi           # load format for printing
    movq    $0,%rax                 # clear rax before printf
    call    printf 
    popq    %r13                    # clear stack
    popq    %r12                    # clear stack
    ret

    .type   L54, @function
.L54:
    ret

    .type   L55, @function
.L55:
    ret