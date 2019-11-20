# -------------------------------------------------------------------------
#	Makefile to generate MIPS testvector for Computer Architecture course
#
#	Author:	Prof. Taeweon Suh
#          	Computer Science & Engineering
#          	Korea University
#
#	Date:	2010-09-04
#
#	Target:	Milestone4
# -------------------------------------------------------------------------
#	Update:	2014-11-19 (Sunhee Kong)
#               - added target MIPS option
#               - hazard detection is not supported in MIPS1
# -------------------------------------------------------------------------

    HOME=c:/cygwin/home/Merseong
    MIPSBIN=$(HOME)/mips-elf/bin
    AS=$(MIPSBIN)/mips-elf-as
    LD=$(MIPSBIN)/mips-elf-ld
	CC=$(MIPSBIN)/mips-elf-gcc
	CPP=$(MIPSBIN)/mips-elf-cpp        
    OBJDUMP=$(MIPSBIN)/mips-elf-objdump
    OBJCOPY=$(MIPSBIN)/mips-elf-objcopy
#   ASFLAGS= -Wall -O2 -g
#   ASFLAGS= -g
    ASFLAGS= -g -mips32
    LDFLAGS= -N -X -Ttestvec.lds
    CCFLAGS= -c -g
    
    all: testvec 

    testvec: testvec.o 
	$(LD) $(LDFLAGS)  testvec.o -o testvec
	$(OBJDUMP) -xS  testvec > testvec.dump
	$(OBJCOPY) -O  binary testvec testvec.bin
	./bin2hex.perl > testvec.hex
	./hex2mif.perl	
	 
    testvec.o: testvec.s
	$(AS) $(ASFLAGS) testvec.s -o testvec.o
	
    clean:
	rm -f *.o *.mif *.dump *.hex *.bin testvec