bits 16
org 0x7C00

jmp init_boot_loader

cleanreg:
  xor ax, ax
  xor bx, bx
  xor cx, cx
ret

__BL_TITLE: db "Control System 3.1", 0x0a, 0x0d, 0
__nl: db 0x0a, 0x0d, 0

%macro print 1
 push si
    mov si, %1
    %%char_loop:
        mov cl, [si]
        inc si
        cmp cl, 0 
        je  %%exit_loop
        mov al, cl
        mov ah, 0x0e
        int 0x10
    call %%char_loop
  %%exit_loop:
 pop si
%endmacro

init_boot_loader:
  print __BL_TITLE
  pusha
     mov ah, 0x02
     mov dl, 0 ;drive
     mov ch, 0 ;cylinder
     mov dh, 0 ;head
     mov al, 32 ;sectors
     mov cl, 2 ;start
     mov bx, 0x7C00 + 512 ;location
     int 0x13 
  popa
  call cleanreg
  mov bx, 0
jmp init_run_loader

jmp $

times 510-($-$$) db 0
dw 0xAA55

__core times 256 db 0 ;core buffer

init_run_loader:

boot_loader_main:

jmp $

jump_out:
times (512*32)-($-$$) db 0