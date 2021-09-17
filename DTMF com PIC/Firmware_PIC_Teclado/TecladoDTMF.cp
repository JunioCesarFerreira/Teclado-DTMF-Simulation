#line 1 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Teclado/TecladoDTMF.c"
#line 47 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Teclado/TecladoDTMF.c"
unsigned const int Lim[8] = { 27 ,  24 ,  22 ,  20 ,  15 ,  14 ,  13 ,  11 };
unsigned const int Freq[8] = {697, 770, 852, 941, 1209, 1336, 1477, 1633};


unsigned int k1, k2;
unsigned int L1, L2;


void Init_Sys();
char Varre_Teclado();
void Som(unsigned int F1, unsigned int F2);




void interrupt(){

 if (TMR0IF_bit){
 k1++;
 if (k1>L1){
 k1=0;
  PORTC.F1 =~ PORTC.F1 ;
 }

  PORTC.F0  =  PORTC.F1 | PORTC.F2 ;
 TMR0L = 154;
 TMR0IF_bit=0;
 }

 if (TMR1IF_bit){
 k2++;
 if (k2>L2){
 k2=0;
  PORTC.F2 =~ PORTC.F2 ;
 }

  PORTC.F0  =  PORTC.F1 | PORTC.F2 ;
 TMR1L = 154;
 TMR1H = 255;
 TMR1IF_bit=0;
 }
}




void main() {
 unsigned int f1,f2;
 char Bot=0;

 Init_Sys();

 do{
 Bot=Varre_Teclado();
 UART1_Write(Bot);
 if (Bot){
 switch (Bot){
 case '1':
 f1=697;
 f2=1209;
 break;
 case '2':
 f1=697;
 f2=1336;
 break;
 case '3':
 f1=697;
 f2=1477;
 break;
 case 'A':
 f1=697;
 f2=1633;
 break;
 case '4':
 f1=770;
 f2=1209;
 break;
 case '5':
 f1=770;
 f2=1336;
 break;
 case '6':
 f1=770;
 f2=1477;
 break;
 case 'B':
 f1=770;
 f2=1633;
 break;
 case '7':
 f1=852;
 f2=1209;
 break;
 case '8':
 f1=852;
 f2=1336;
 break;
 case '9':
 f1=852;
 f2=1477;
 break;
 case 'C':
 f1=852;
 f2=1633;
 break;
 case '*':
 f1=941;
 f2=1209;
 break;
 case '0':
 f1=941;
 f2=1336;
 break;
 case '#':
 f1 = 941;
 f2=1477;
 break;
 case 'D':
 f1=941;
 f2=1633;
 break;
 }
 Som(f1,f2);
 Delay_ms(40);
 }
 }while(1);
}
#line 179 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Teclado/TecladoDTMF.c"
void Init_Sys(){

 TRISB=0x0F;
 TRISC=0;

 INTCON = 0b11000000;

 T0CON = 0b11001000;

 T1CON = 0b00000001;

 TMR1IE_bit = 0;

 UART1_Init(9600);
}
#line 198 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Teclado/TecladoDTMF.c"
unsigned int Limiter (unsigned int F){
 unsigned short i;
 for (i=0; i<8;i++){
 if (Freq[i]==F){
 return Lim[i];
 }
 }
 return 0;
}
#line 211 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Teclado/TecladoDTMF.c"
void Som(unsigned int F1, unsigned int F2){
 L1 = Limiter(F1);
 L2 = Limiter(F2);
 TMR0IE_bit=1;
 TMR1IE_bit=1;
 Delay_ms(50);
 TMR0IE_bit=0;
 TMR1IE_bit=0;
  PORTC.F0 =0;
}
#line 225 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Teclado/TecladoDTMF.c"
unsigned short Varre_Col_Ret_L(unsigned short C){
 unsigned short Ret;

 switch (C){
 case 1:
  PORTB=0xFF ;PORTB&=0xEF ;
 break;
 case 2:
  PORTB=0xFF ;PORTB&=0xDF ;
 break;
 case 3:
  PORTB=0xFF ;PORTB&=0xBF ;
 break;
 case 4:
  PORTB=0xFF ;PORTB&=0x7F ;
 break;
 default:
 return 0;
 }
 Delay_ms(50);

 Ret=PORTB;
 Ret&=0x0F;

 switch (Ret){
 case 0x07:
 return 1;
 case 0x0B:
 return 2;
 case 0x0D:
 return 3;
 case 0x0E:
 return 4;
 default:
 return 0;
 }
}
#line 266 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Teclado/TecladoDTMF.c"
char Varre_Teclado(){
 unsigned short i, Rzero, R=0;

 for (i=1;i<5;i++){
 Rzero = Varre_Col_Ret_L(i);
 if (Rzero!=0) R = Rzero + 8 * i;
 }

 switch (R){
 case 9:
 return '1';
 case 10:
 return '4';
 case 11:
 return '7';
 case 12:
 return '*';
 case 17:
 return '2';
 case 18:
 return '5';
 case 19:
 return '8';
 case 20:
 return '0';
 case 25:
 return '3';
 case 26:
 return '6';
 case 27:
 return '9';
 case 28:
 return '#';
 case 33:
 return 'A';
 case 34:
 return 'B';
 case 35:
 return 'C';
 case 36:
 return 'D';
 default:
 return 0;
 }

}
