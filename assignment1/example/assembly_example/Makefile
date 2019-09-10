#
#  Makefile to generate MIPS testvector for Computer Architecture course
#
#  Author: Prof. Taeweon Suh
#          Computer Science Education
#          Korea University
#
#  Date:   2010-09-04
#

    HOME=c:/cygwin/home/esca
    MIPSBIN=$(HOME)/mips-elf/bin
    AS=$(MIPSBIN)/mips-elf-as
    LD=$(MIPSBIN)/mips-elf-ld
	CC=$(MIPSBIN)/mips-elf-gcc
	CPP=$(MIPSBIN)/mips-elf-cpp        
    OBJDUMP=$(MIPSBIN)/mips-elf-objdump
    OBJCOPY=$(MIPSBIN)/mips-elf-objcopy
#   ASFLAGS= -Wall -O2 -g
    ASFLAGS= -g
    LDFLAGS= -N -X -Ttestvec.lds
    CCFLAGS= -c -g
    
    all: testvec 

    testvec: testvec.o 
	$(LD) $(LDFLAGS)  testvec.o -o testvec
	$(OBJDUMP) -xS  testvec > testvec.dump
	$(OBJCOPY) -O  binary testvec testvec.bin
	./bin2hex.perl > testvec.hex
	./hex2mif.perl	
#	./mipsel-readelf -a testvec > testvec.r
#	./mipsel-nm testvec > testvec.n
	 
    testvec.o: testvec.s
	$(AS) $(ASFLAGS) testvec.s -o testvec.o
	
    clean:
	rm -rf *.o *.mif *.dump *.hex *.bin *.mif testvec