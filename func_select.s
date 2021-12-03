# Ori Azulay, 206336794
    .section    .rodata
    .align 8                        # Align address to multiple of 8

# string to printf
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
    movq    $def_option, %rdi
    movq    $0, %rax                # clear rex before printf
    call printf
    ret

    .type   L50, @function
.L50:
    ret

    .type   L50, @function
.L52:
    ret
    
    .type   L50, @function
.L53:
    ret

    .type   L50, @function
.L54:
    ret

    .type   L50, @function
.L55:
    ret