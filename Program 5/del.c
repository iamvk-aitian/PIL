#include<stdio.h>
#include<dos.h>
union REGS reg1,reg2;
void main()
{
 char dirname[100];
 int ch;
 char filename[10];
 clrscr();

printf("\n 1. Create a Directory \n 2. Delete a File \n 3.Copy The File\n 4. Exit \n");
scanf("%d",&ch);
do{
switch(ch)
{
 case 1:
 printf("\n Enter THE NAME OF THE DIRECTORY...\n");
 scanf("%s",dirname);
 reg1.h.ah = 0x39;
 reg1.x.dx=FP_OFF(dirname);
 intdos(&reg1,&reg2) ;

 //check to create
 if(reg2.x.cflag==0)
  {

	printf("\n Successfull.... \n");
  }


 else if(reg2.x.ax==3)
  {
	printf("\n Path Not Found.... \n");
  }
else if(reg2.x.ax==5)
  {
	printf("\n Access Denied....  \n");
  }
else
	printf("Some Other Problem... ");
break;

case 2:
	printf("\n DELETING ..... \n");
	printf("\n ENTER THE FILE NAME TO BE DELETED ..... \n");
	 scanf("%s",filename);
	 reg1.h.ah = 0x41;
	 reg1.x.dx=FP_OFF(filename);
	 int86(0x21,&reg1,&reg2) ;

	//check to delete

 if(reg2.x.cflag==0)
  {
	printf("\n Successfull.... \n");
  }
 else if(reg2.x.ax==2)
  {
 	printf("\n File Not Found.... \n");
  }
 else if(reg2.x.ax==3)
  {
 	printf("\n Path Not Found.... \n");
  }
else if(reg2.x.ax==5)
  {
 	printf("\n Access Denied....  \n");
  }
else
	printf("Some Other Problem... ");
break;
case3 :

 printf("\n Enter THE NAME OF THE FILE to copy...\nh");
 scanf("%s",dirname);

case 4:

\*Create File*\
printf("\n Enter THE NAME OF THE DIRECTORY...\n");
 scanf("%s",dirname);
 reg1.h.ah = 0x3C;
 reg1.x.dx=FP_OFF(filename);
 intdos(&reg1,&reg2) ;

 //check to create
 if(reg2.x.cflag==0)
  {

	printf("\n Successfull.... \n");
  }


 else if(reg2.x.ax==3)
  {
	printf("\n Path Not Found.... \n");
  }
else if(reg2.x.ax==5)
  {
	printf("\n Access Denied....  \n");
  }
else
	printf("Some Other Problem... ");
exit();
break;
}
}while(ch>3);
getch();
}
