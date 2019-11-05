#include "SevenSeg.h"

void display (int);

int SevenSeg()
{
unsigned int i;

while (1){

     display(SEG_5);
     for (i=0; i<0xFFFFF; i++) ;

     display(SEG_A);
     for (i=0; i<0xFFFFF; i++) ;
}

return 0;
}


void display (int num)
{
	unsigned int * seg0_addr = (unsigned int *) SevenSeg0;

	*seg0_addr = num;

	return;
}
