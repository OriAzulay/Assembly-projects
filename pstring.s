# Ori Azulay, 206336794
.section    .rodata
.align  8                       # Align address to multiple of 8   

.text
# Pstrlen - function that returns string's length
# The function use the 1st byte of string where the length is stored
    .global pstrlen
    .type   pstrlen, @function
pstrlen:
    movb    (%rdi),%al          # go to the first byte of the string, there's the size
    ret