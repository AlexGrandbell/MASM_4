assume cs:code, ds:data, ss:stack
data segment
    dw 1234,1234,1234,1123,13213,1124  ;16bit
data ends

stack segment
    dw 100 dup(0)
stack ends

code segment

start:
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,100
    mov si,0
    mov di,12
    lp1:
        mov ax,ds:[si]
        mov cx,0 ;位数计数器
        jp1:
            inc cx
            mov dx,0
            mov bx,0ah
            div bx
            add dx,030h
            push dx
            cmp ax,0
        jne jp1
        ;出栈
        jp2:
            pop bx
            mov byte ptr ds:[di],bl
            inc di
        loop jp2
        mov word ptr ds:[di],0
        add di,2
        add si,2

        cmp si,12
    jne lp1

    ;输出
    mov cx,6
    mov si,12
    mov dl,3
    mov dh,8
    lp2:
        call show_str
        mov dl,3
        mov dh,8
        add dh,7
        sub dh,cl
        add si,2
    loop lp2

    mov ax,4c00h
    int 21h

show_str:
        ;计算列偏移地址
        mov bx,0
        mov bl,dl
        sub bl,1
        add bl,bl
        mov di,bx
        ;计算行偏移地址
        mov bx,00a0h
        mov ax,0
        mov al,dh
        mul bx
        add di,ax
        ;写入显示器段地址
        mov bx,0b800h
        mov es,bx
        
n1lp1:  mov al,ds:[si]
        mov byte ptr es:[di],al
        inc di
        mov word ptr es:[di],04fh
        inc di
        inc si
        cmp word ptr ds:[si],0
        jne n1lp1
        ret

code ends
end start
