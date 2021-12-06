# Ori Azulay, 206336794
.section    .rodata
.align  8                       # Align address to multiple of 8   
invalid:    .string "invalid input!\n"
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

# replaceChar - function that takes from the user i,j 
# and replace charectrs between pstring1 & pstring2
    .global pstrijcpy
    .type   pstrijcpy, @function
pstrijcpy:
    movq    %rdx,%r10           # rdx last byte=i, rcx last byte=j, rdi is pstring1 & rsi is pstring2
    check_valid:
    cmpb    (%rdi),%cl          # j > sizeof(pstring1) ?
    jae     not_valid           # else, go to not_valid label & pring msg
    cmpb    %cl,%dl             # i > j ?
    ja      not_valid           # print not valid message
    cmpb    (%rsi),%cl          # j > sizeof(pstring2) ?
    jae     not_valid           # print message - j out of boundery
    for_pstrijcpy:  
    cmpb    %cl,%r10b           # if j == r10b (counter)
    ja      ret_arr             # else, j<counter & return value
    inc     %r10                # counter ++
    movq    $0,%r11             # define temp value
    movb    (%rsi,%r10,1),%r11b # char of src.str[i] to temp
    movb    %r11b,(%rdi,%r10,1) # replace old character to new
    jmp     for_pstrijcpy       # next iteraton
    not_valid:
    movq    $invalid,%rdi       # move format for printing
    movq    $0,%rax            # clear rax before printf
    call printf
    ret_arr:
    movq    %rdi,%rax           # return value of array
    ret
