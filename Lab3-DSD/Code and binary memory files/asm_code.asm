data segment:
arr dc16 20,11,2,23,14,35,6,7,48,39,10,11,12,13
res ds16 1

code segment:
ld  r1,4(r0)
ld  r2,8(r0)
mov r3,31
mov r4,1
and r1,r1,r3
and r2,r2,r3
sub r6,r2,r1
jc  2
add r6,r1,r0
jmp 1
add r6,r0,r0
st  r6,14(r0)
done
nop
jmp -2

