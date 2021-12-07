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
    movq    $0,%rax             # clear rax before printf
    call printf
    ret_arr:
    movq    %rdi,%rax           # return value of array
    ret

# swapCase - function that replace every uppercase to lowercase and the oposite, 
# for pstring1 & pstring2
    .global swapCase
    .type   swapCase, @function
swapCase:
    movq    $0,%r10              # counter = 0
    for_swapcase:
    cmpb    (%rsi),%r10b         # counter >= sizeof(pstring)
    jg      end_swapcase         # finish loop
    inc     %r10                 # counter ++
    movb    (%rdi,%r10,1),%r11b  # replace character to r11b
    cmpb    $65,%r11b            # check if character is lower then string (ascii)
    jl      for_swapcase         # then new iteration
    cmpb    $122,%r11b           # check if character is greater (uppercase) then string (ascii)
    jg      for_swapcase         # then new iteration
    cmpb    $97,%r11b            # check if letter greater then 'a' in ascii
    jge     upper_case           # replace it by uppercase
    cmpb    $90,%r11b            # check if letter lower then 'Z' in ascii
    jle     lower_case           # replace it by lowercase
    jmp     for_swapcase         # new itearation
    upper_case:
    subb    $32,%r11b            # the 'delta' between the upper & lower case in ascii
    movb    %r11b,(%rdi,%r10,1)  # replace the old letter by the case
    jmp     for_swapcase         # return to iteration
    lower_case:
    addb    $32,%r11b            # take the 'delta' from upper & lower
    movb    %r11b,(%rdi,%r10)    # replace old letter
    jmp     for_swapcase
    end_swapcase:
    movq    %rdi,%rax            # return address
    ret


# pstrijcmp - function that gets poiter of string & i-j range, 
# and checks lexicographiclly who's string is greater
    .global pstrijcmp
    .type   pstrijcmp, @function
pstrijcmp:
movq    %rdx,%r10                # start the check by i in r10
    pushq   %r12                 # calle saved
    valid_cmp:
    cmpb    (%rdi),%cl           # if j>size of(pstring1)
    jae     not_valid_cmp        # then jump to not valid input error msg
    cmpb    %cl,%dl              # if i>j
    ja      not_valid_cmp        # then invalid input - go to error label
    cmpb    (%rsi),%cl           # if j>size of(pstring2)
    jae     not_valid_cmp        # then jump to not valid input error msg
    for_pstrijcmp:
    cmpb    %cl,%r10b            # if j == counter (i in range)
    ja      equal_size           # return 0 in message
    inc     %r10                 # i++
    movq    $0,%r11              # clear temp for pstring1 pointer r11
    movb    (%rdi,%r10,1),%r11b  # move character is pstring1[i] to temp1
    movq    $0,%r12              # clear temp2 for pstring2 pointer r12
    movb    (%rsi,%r10,1),%r12b  # move character is pstring2[i] to temp2
    cmpq    %r12,%r11            # compare between the strings
    je      for_pstrijcmp        # if the're equal, it will return to second line of loop
    jg      large_cmp            # pstring1[i] > pstring2[i]
    jl      small_cmp            # pstring1[i] < pstring2[i]
    not_valid_cmp:
    movq    $invalid,%rdi        # load invalid message
    movq    $0,%rax              # clear rax before printf
    call    printf
    movq    $-2,%rax             # return -2 for invalid input
    jmp     end_cmp
    large_cmp:
    movq    $1,%rax              # return 1 if pstring1 is bigger
    jmp     end_cmp
    small_cmp:
    movq    $-1,%rax             # return -1 if pstring is smaller
    jmp     end_cmp
    equal_size:
    movq    $0,%rax              # return 0 if strings are equal
    jmp     end_cmp
    end_cmp:
    popq    %r12                 # return calle saver
    ret