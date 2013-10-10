#include "../include/kasm.h"
#include "../include/defs.h"

DESCR_INT idt[0xA];			/* IDT de 10 entradas*/
IDTR idtr;				/* IDTR */

int tickpos=640;

void int_08() {

    char *video = (char *) 0xb8000;
    video[tickpos+=2]='*';

}

/**********************************************
kmain() 
Punto de entrada de cóo C.
*************************************************/

kmain() 
{
cursor=0;

        int i,num;

/* Borra la pantalla. */ 

	k_clear_screen();
	

/* CARGA DE IDT CON LA RUTINA DE ATENCION DE IRQ0    */

        setup_IDT_entry (&idt[0x08], 0x08, (dword)&_int_08_hand, ACS_INT, 0);
	
/* Carga de IDTR    */

	idtr.base = 0;  
	idtr.base +=(dword) &idt;
	idtr.limit = sizeof(idt)-1;
	
	_lidt (&idtr);	

	_Cli();
/* Habilito interrupcion de timer tick*/

        _mascaraPIC1(0xFE);
        _mascaraPIC2(0xFF);
        
	_Sti();


/* Llamo a getchar para probar mi codigo, hecho por mi*/
//char * cadena="Hola mundo";
//printf(cadena, 10, 0xb8000);
	getchar();
	
        while(1)
        {
		
        }
	
}
