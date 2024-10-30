assume cs:code, ds:data
data segment
        db 'Welcome to masm!',0
data ends

code segment

start:  mov dh,8              ;dh装行号(范围:1--25)
        mov dl,3              ;dl装列号(范围:1--80)[注:每超过80等于行号自动加1]
        mov cl,0cah           ;cl中存放颜色属性(0cah为红底高亮闪烁绿色属性)
        mov ax,data
        mov ds,ax

        mov si,0
        call show_str

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
        mov es:[di],al
        inc di
        mov es:[di],cl
        inc di
        inc si
        cmp ds:[si],0
        jne n1lp1
        ret

code ends
end start
