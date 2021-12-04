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

# replaceChar - function that gets from the user old char to replace
# and new char to replace, and replace it on both strings
    .global replaceChar
    .type   replaceChar, @function
replaceChar:
    movq    $0,%r10             # define r10 register as counter
    for_rep:
    cmpb    (%rdi),%r10b        # check if we ran all over the string (if count==len)
    je      end_rep             # go to end
    inc     %r10                # counter ++
    cmpb    %sil,(%rdi,%r10,1)  # check if pstring[counter] == newChar
    jne     for_rep             # else, go to next itration
    mov     %dl,(%rdi,%r10,1)   # replace oldChar by the newChar
    jmp     for_rep
    end_rep:
    movq    %rdi,%rax           # return address of the string bt convention
    ret