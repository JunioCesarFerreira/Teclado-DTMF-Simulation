#line 1 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Decodifica/DTMF_Decode.c"
#line 8 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Decodifica/DTMF_Decode.c"
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;








unsigned short v[ 256 ];
double FAG[8];
char txt[7] = {0,0,0,0,0,0,0};
#line 36 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Decodifica/DTMF_Decode.c"
double Goertzel_Algorithm(double Fr){


 double w;
 double cosw;
 double sinw;
 double coefk;

 double z0=0, z1=0, z2=0;

 unsigned int n;
 w = 2* 3.141592653589793238 *Fr/ 16000 ;
 cosw = cos(w);
 sinw = sin(w);
 coefk = 2*cosw;

 for (n=0; n< 256 ; n++){
 z0 = coefk*z1-z2+v[n];
 z2=z1;
 z1=z0;
 }
 z0=(z1-z2*cosw)/ 256 ;
 z1=(z2*sinw)/ 256 ;
 z2=sqrt(z0*z0+z1*z1);
 return z2;
}
#line 66 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Decodifica/DTMF_Decode.c"
char Detect_key(){
 unsigned short j;
 double Max=0;
 char Ind1=0, Ind2=0;

 for (j = 0; j < 8; j++){
 if (FAG[j] > Max){
 Max = FAG[j];
 Ind1 = j;
 }
 }
 Max = 0;
 for (j = 0; j < 8; j++){
 if (j!=Ind1 && FAG[j] > Max){
 Max = FAG[j];
 Ind2 = j;
 }
 }

 if (Ind1 > Ind2){
 j = Ind1;
 Ind1 = Ind2;
 Ind2 = j;
 }

 Ind2*=10;
 Ind1 += Ind2;
 switch (Ind1){
 case 40:
 return '1';
 case 50:
 return '2';
 case 60:
 return '3';
 case 70:
 return 'A';
 case 41:
 return '4';
 case 51:
 return '5';
 case 61:
 return '6';
 case 71:
 return 'B';
 case 42:
 return '7';
 case 52:
 return '8';
 case 62:
 return '9';
 case 72:
 return 'C';
 case 43:
 return '*';
 case 53:
 return '0';
 case 63:
 return '#';
 case 73:
 return 'D';
 }
 return ' ';
}




void main() {
 unsigned int k;
 unsigned short Lcd_Count = 0;
 char Resultado;
 bit Data_Received;

 TRISB = 0;
 TRISC = 1;

 Lcd_Init();
 Lcd_Cmd(1);
 Lcd_Out(1,1,"DTMF Decode");
 Lcd_Out(2,1,">");

 UART1_Init(9600);

 Data_Received=0;
 do{

 if (Data_Received){

 FAG[0]=Goertzel_Algorithm(697);
 FAG[1]=Goertzel_Algorithm(770);
 FAG[2]=Goertzel_Algorithm(852);
 FAG[3]=Goertzel_Algorithm(941);
 FAG[4]=Goertzel_Algorithm(1209);
 FAG[5]=Goertzel_Algorithm(1336);
 FAG[6]=Goertzel_Algorithm(1477);
 FAG[7]=Goertzel_Algorithm(1633);
 Resultado = Detect_key();
 Data_Received=0;

 UART1_Write_Text("Resultado Goertzel:\r\n");
 for (k=0;k<8;k++){
 FloatToStr(FAG[k], txt);
 txt[6]=0;
 UART1_Write_Text(txt);
 UART1_Write(';');
 }
 UART1_Write_Text("\r\nResultado filtragem:\r\n");
 UART1_Write(Resultado);
 UART1_Write_Text("\r\n");

 Lcd_Chr_CP(Resultado);
 Lcd_Count++;
 if (Lcd_Count>15){
 Lcd_Chr(2,2,Resultado);
 Lcd_Count=0;
 }
 }

 if (RC0_bit){
 RB0_bit=1;

 for (k=0;k< 256 ;k++){
 v[k]=RC0_bit;
 Delay_us( 60 );
 }

 Data_Received=1;
 RB0_bit=0;
#line 203 "C:/Users/Junio/Desktop/Desktop/Setor 0/TecladoDTMF/DTMF com PIC/Firmware_PIC_Decodifica/DTMF_Decode.c"
 }
 }while(1);
}
