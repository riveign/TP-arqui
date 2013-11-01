GLOBAL  _read_msw,_lidt
GLOBAL  _int_08_hand
GLOBAL  _mascaraPIC1,_mascaraPIC2,_Cli,_Sti
GLOBAL  _debug
GLOBAL _int_09_hand
GLOBAL outport32
GLOBAL inport32
EXTERN  int_08
EXTERN  int_09


SECTION .text


_Cli:
	cli			; limpia flag de interrupciones
	ret

_Sti:

	sti			; habilita interrupciones por flag
	ret

_mascaraPIC1:			; Escribe mascara del PIC 1
	push    ebp
        mov     ebp, esp
        mov     ax, [ss:ebp+8]  ; ax = mascara de 16 bits
        out	21h,al
        pop     ebp
        retn

_mascaraPIC2:			; Escribe mascara del PIC 2
	push    ebp
        mov     ebp, esp
        mov     ax, [ss:ebp+8]  ; ax = mascara de 16 bits
        out	0A1h,al
        pop     ebp
        retn

_read_msw:
        smsw    ax		; Obtiene la Machine Status Word
        retn


_lidt:				; Carga el IDTR
        push    ebp
        mov     ebp, esp
        push    ebx
        mov     ebx, [ss: ebp + 6] ; ds:bx = puntero a IDTR 
	rol	ebx,16		    	
	lidt    [ds: ebx]          ; carga IDTR
        pop     ebx
        pop     ebp
        retn


_int_08_hand:				; Handler de INT 8 ( Timer tick)
        push    ds
        push    es                      ; Se salvan los registros
        pusha                           ; Carga de DS y ES con el valor del selector
        mov     ax, 10h			; a utilizar.
        mov     ds, ax
        mov     es, ax                  
        call    int_08                 
        mov	al,20h			; Envio de EOI generico al PIC
	out	20h,al
	popa                            
        pop     es
        pop     ds
        iret
        
_int_09_hand:			    ; Handler de INT9 (Teclado)
    pushad                  ; Buckupea todos los registros.
    pushf                   ; Backupea todos los flags.
    mov eax,0
    in al,060h              ; Le pido el scancode al teclado.
    push eax
    call int_09
    pop eax
    mov	al,20h			    ; Le mando el EOI generico al PIC.
    out 20h,al
    popf                    ; Restauro todos los flags.
    popad                   ; Restauro todos los registros.
    iretd
    
outport32:
    push ebp
    mov ebp, esp
    
    mov dx,word[ebp + 8]    ;en EAX pongo el primer parametro port
    mov eax,dword[ebp + 12] ;en EBX pongo el segundo parametro source
    out dx, eax

    mov esp, ebp
    pop ebp
    ret
    
inport32:
    push ebp
    mov ebp, esp
    
    mov eax, 0
    mov dx, word[ebp + 8]  ;en EAX pongo el primer parametro port
    in eax, dx
    
    mov esp,ebp
    pop ebp
    ret

    

; Debug para el BOCHS, detiene la ejecució; Para continuar colocar en el BOCHSDBG: set $eax=0
;


_debug:
        push    bp
        mov     bp, sp
        push	ax
vuelve:	mov     ax, 1
        cmp	ax, 0
	jne	vuelve
	pop	ax
	pop     bp
        retn
