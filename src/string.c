#include "../include/string.h"
/**********************************************
* strlen(capitulo 2 K&R pag 43)
*************************************************/

int strlen(char s[]){
int i;
i=0;
	while (s[i]!='\0'){
	++i;	
	}
return i;
}

/**********************************************
* reverse da vuelta un string, auxiliar de itoa
*************************************************/

void 
reverse(char s[], int size)
{
	int i;
	for(i = 0; i < size/2; i++)
	{
		char aux = s[i];
		s[i] = s[size - i - 1];
		s[size - i - 1] = aux;
	}
	s[size] = '\0';
}



/**********************************************
* http://www.acm.uiuc.edu/webmonkeys/book/c_guide/2.14.html#variables
*************************************************/

//http://clc-wiki.net/wiki/C_standard_library:string.h:strcmp
int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1==*s2))
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
