# Ori Azulay, 206336794
    .section    .rodata
    .align 8                        # Align address to multiple of 8



Jtable:                             # JUMP TABLE   
    .quad   .L50                    # case 50 or 60           
    .quad   .defualt                # case 51 goto defualt
    .quad   .L52                    # case 52
    .quad   .L53                    # case 53
    .quad   .L54                    # case 54
    .quad   .L55                    # case 55
    .quad   .defualt                # case 51 goto defualt
    .quad   .defualt                # case 51 goto defualt
    .quad   .defualt                # case 51 goto defualt
    .quad   .defualt                # case 51 goto defualt
    .quad   .L50                    # case 60 return to case 50

    .text                           # code start
    .global run_func
    .type   run_func, @function     # define 'run_func' function
run_func:
    leaq    -50(%rdi),%rdi          # start the stack from "0"
    cmpq    $10,%rdi                # compare to 10
    ja      .defualt                # if opt > 10 or negative (ja), goto defualt
    jump    *.Jtable(,%rdi,8)       # for correct case, goto jump table
    ret
    
    .type   defualt, @function
.defualt:


    .type   .L50, @function
.L50:

   .type   .L52, @function
.L52:

   .type   .L53, @function
.L53:

   .type   .L54, @function
.L54:

   .type   .L55, @function
.L55: