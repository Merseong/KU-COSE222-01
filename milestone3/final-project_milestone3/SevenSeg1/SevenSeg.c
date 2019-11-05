#include "SevenSeg.h"

int SevenSeg()
{
unsigned int * seg0_addr = (unsigned int *) SevenSeg0;
unsigned int i;

while (1){

  	 *seg0_addr = SEG_5;
     for (i=0; i<0xFFFFF; i++) ;

     *seg0_addr = SEG_A;
     for (i=0; i<0xFFFFF; i++) ;
}

return 0;
}
