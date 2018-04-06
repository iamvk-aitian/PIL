#include<dos.h>
#include<stdio.h>
#include<conio.h>
#include<stdlib.h>

void CRDIR()
{
	char dirname[50];
	union REGS inreg;
	union REGS outreg;
	struct SREGS segreg;
	printf("Enter the directory name:\n");
	scanf("%s",dirname);
	inreg.h.ah=0x39;
	inreg.x.dx=FP_OFF(dirname);
	segreg.ds=FP_SEG(dirname);
	intdosx(&inreg,&outreg,&segreg);
	if(outreg.x.cflag)
		printf("\nError in creation\n");
	else
		printf("\nDIRECTORY IS CREATED\n");
}
void DELFILE()
{
	char filename[50];
	union REGS inreg;
	union REGS outreg;
	struct SREGS segreg;
	printf("\nEnter the filename to be deleted\n");
	scanf("%s",filename);
	inreg.h.ah=0x41;
	inreg.x.dx=FP_OFF(filename);
	segreg.ds=FP_SEG(filename);
	intdosx(&inreg,&outreg,&segreg);
	if(outreg.x.cflag)
		printf("\n error\n");
	else
		printf("\nFILE IS DELETED");
}
void DELDIR()
{
	char dirname[50];
	union REGS inreg;
	union REGS outreg;
	struct SREGS segreg;
	printf("\nEnter the directory name\n");
	scanf("%s",dirname);
	inreg.h.ah=0x3a;
	inreg.x.dx=FP_OFF(dirname);
	segreg.ds=FP_SEG(dirname);
	intdosx(&inreg,&outreg,&segreg);
	if(outreg.x.cflag)
		printf("\n Error");
	else
		printf("\nDIRECTORY IS DELETED");
}
void CPY()
{
	union REGS inreg;
	union REGS outreg;
	struct SREGS segreg;
	char fname1[128];
	char fname2[128];
	char buffer[256];
	int h1,h2,h3;
	clrscr();

	//*******************opening file 1 for reading content******
	printf("\nEnter File1 Name to be copied:");
	scanf("%s",fname1);
	inreg.h.ah=0X3D;
	inreg.x.dx=FP_OFF(fname1);
	segreg.ds=FP_SEG(fname1);
	inreg.h.al=0X00;
	intdosx(&inreg,&outreg,&segreg);
	h1=outreg.x.ax;
	if(outreg.x.cflag)
		printf("\n Error");
	else
		printf("\nFILE1 READING");

	//*********************creating file 2********************
	printf("\n\nEnter new File2 name to be created:");
	scanf("%s",fname2);
	inreg.h.ah=0X3C;
	inreg.x.dx=FP_OFF(fname2);
	segreg.ds=FP_SEG(fname2);
	inreg.h.al=0X01;
	intdosx(&inreg,&outreg,&segreg);
	h2=outreg.x.ax;
	if(outreg.x.cflag)
		printf("\n Error");
	else
		printf("\nFILE2 CFREATED");

	
	//*********************open file 2 in write mode**********
	inreg.h.ah=0X3D;
	inreg.x.dx=FP_OFF(fname2);
	segreg.ds=FP_SEG(fname2);
	inreg.h.al=0X01;
	intdosx(&inreg,&outreg,&segreg);
	h2=outreg.x.ax;
	if(outreg.x.cflag==0)
	{
		printf("\n\t%s File2 has opened in write mode",fname2);
	}
	//**************************reading data from file 1*******
	inreg.h.ah=0X3F;
	inreg.x.bx=h1;
	inreg.x.cx=0XFF;

	intdos(&inreg,&outreg);
	h3=outreg.x.ax;
	if(outreg.x.cflag==0)
	{
		printf("\n\t%s File1 reading.",fname1);
	}
	//**************************writing data to file 2*******
	inreg.h.ah=0X40;
	inreg.x.bx=h2;
	inreg.x.cx=h3;

	intdos(&inreg,&outreg);
	if(outreg.x.cflag==0)
	{
		printf("\n\t%s File1 writing",fname1);
	}
	inreg.h.ah=0X3E;
	inreg.x.bx=h1;
	intdos(&inreg,&outreg);

	inreg.h.ah=0X3E;
	inreg.x.bx=h2;
	intdos(&inreg,&outreg);

	printf("FILE COPIED");
	getch();
	
}
int main()
{

	void  CRDIR();
	void DELFILE();
	void DELDIR();
	void CPY();
	int ch,t;
	clrscr();
	do{
	printf("\nENTER YOUR CHOICE\n1.CREATE A FILE\n2.CREATE A DIRECTORY\n3.DELETE A FILE\n4.DELETE A DIRECTORY\n5.COPY A FILE\n6.EXIT\n");
	scanf("%d",&ch);
	switch(ch)
	{
		case 1:CRDIR();
		break;
		case 2:DELFILE();
		break;
		case 3:DELDIR();
		break;
		case 4:CPY();
		break;
		case 5:exit(1);
	}
	}while(ch!=5);
	getch();
	return 0;
}
/*


DOS INT 21h - DOS Function Codes

The follow abridged list of DOS interrupts has been extracted from a large list compiled by Ralf Brown. These are available on any Simtel mirror (e.g. sunsite.anu.edu.au) under the directory ms-dos/info/interNNp.zip

AH 	Description 	AH 	Description
01 	Read character from STDIN 	02 	Write character to STDOUT
05 	Write character to printer 	06 	Console Input/Output
07 	Direct char read (STDIN), no echo 	08 	Char read from STDIN, no echo
09 	Write string to STDOUT 	0A 	Buffered input
0B 	Get STDIN status 	0C 	Flush buffer for STDIN
0D 	Disk reset 	0E 	Select default drive
19 	Get current default drive 	25 	Set interrupt vector
2A 	Get system date 	2B 	Set system date
2C 	Get system time 	2D 	Set system time
2E 	Set verify flag 	30 	Get DOS version
35 	Get Interrupt vector
36 	Get free disk space 	39 	Create subdirectory
3A 	Remove subdirectory 	3B 	Set working directory
3C 	Create file 	3D 	Open file
3E 	Close file 	3F 	Read file
40 	Write file 	41 	Delete file
42 	Seek file 	43 	Get/Set file attributes
47 	Get current directory 	4C 	Exit program
4D 	Get return code 	54 	Get verify flag
56 	Rename file 	57 	Get/Set file date


*/
