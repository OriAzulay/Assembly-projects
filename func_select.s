# Ori Azulay, 206336794
    .section    .rodata
    .align 8                        # Align address to multiple of 8

# string to printf
len_50:         .string "first pstring length: %d, second pstring length: %d\n"
def_option:     .string "invalid option!\n"

jump_table:                         # JUMP TABLE   
    .quad   .L50                    # case 50 or 60           
    .quad   .default                # case 51 not exist, goto defualt
    .quad   .L52                    # case 52
    .quad   .L53                    # case 53
    .quad   .L54                    # case 54
    .quad   .L55                    # case 55
    .quad   .default                # case 51 not exist, goto defualt
    .quad   .default                # case 51 not exist, goto defualt
    .quad   .default                # case 51 not exist, goto defualt
    .quad   .default                # case 51 not exist, goto defualt
    .quad   .L50                    # case 60 return to case 50

    .text                           # code start
    .global run_func
    .type   run_func, @function     # define 'run_func' function
run_func:
    subq    $50,%rdi                # start the switch-case from "0"
    cmpq    $10,%rdi                # compare to 10 
    ja      .default                # if 'opt' > 10 or negative (ja), goto defualt
    jmp     *jump_table(,%rdi,8)    # for correct case, goto jump table
    ret
    
    .type   default, @function
.default:
    movq    $def_option, %rdi       # load format of printf %d for 'invalid'
    movq    $0, %rax                # clear rex before printf
    call printf                     # call message
    ret

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
    movq    $len_50,%rdi            # load format string for printing
    movq    $0,%rax                 # clear rax before printf
    call printf                     # print
    ret
    
    .type   L52, @function
.L52:
    ret
    
    .type   L53, @function
.L53:
    ret

    .type   L54, @function
.L54:
    ret

    .type   L55, @function
.L55:
    ret