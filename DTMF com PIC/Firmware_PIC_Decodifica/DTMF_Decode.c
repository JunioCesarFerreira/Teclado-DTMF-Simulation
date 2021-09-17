/*
  Decodificador de sinal DTMF com algoritmo de Goertzel
  Desenvolvido por Junio Cesar Ferreira
  11/11/2018
*/
// Referencias de pinos para uso da bibliteca de LDC alphanumerico do MikroC
// Atribui��o pinos de controle do LCD
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;
// Direcionamento dos pinos do Display
sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;

// Constantes do programa
#define Pi 3.141592653589793238 // Pi
#define N  256                  // Comprimento do vetor de entrada para amostragem
#define FS 16000                // Frequ�ncia de amostragem em Hz
#define TS 60                   // Tempo de amostragem em us

// Variaveis globais
unsigned short v[N];            // Vetor receber� o sinal amostrado
double FAG[8];                  // Vetor receber� as componentes espectrais resultantes
char txt[7] = {0,0,0,0,0,0,0};  // String para textos de Debug

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Fun��o computa o algoritmo de Goertzel
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
double Goertzel_Algorithm(double Fr){
       // Fr � a frequ�ncia desejada, retorna a magnetude desta frequ�ncia.
       // Constantes
       double w;
       double cosw;
       double sinw;
       double coefk;
       // Vetor auxiliar para contas
       double z0=0, z1=0, z2=0;
       // Indexador
       unsigned int n;
       w = 2*Pi*Fr/FS;
       cosw = cos(w);
       sinw = sin(w);
       coefk = 2*cosw;
       // Computa Algoritmo de Goertzel
       for (n=0; n<N; n++){
           z0 = coefk*z1-z2+v[n];
           z2=z1;
           z1=z0;
       }
       z0=(z1-z2*cosw)/N;        // Componente Real
       z1=(z2*sinw)/N;           // Componente imagin�ria
       z2=sqrt(z0*z0+z1*z1);     // Magnetude
       return z2;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Fun��o de detec��o das teclas precionadas por an�lise espectral
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
char Detect_key(){
     unsigned short j;     // Indexador
     double Max=0;         // Variavel auxiliar para encontrar os m�ximos
     char Ind1=0, Ind2=0;  // Indexadores dos m�ximos
     // Encontra indeces dos pontos m�ximos do espectro
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
     // Ordena indices dos m�ximos
     if (Ind1 > Ind2){
        j = Ind1;
        Ind1 = Ind2;
        Ind2 = j;
     }
     // Realiza filtragem
     Ind2*=10;     // Para que Ind2 corresponda a um valor v�lido ele deve ser ou 4,5,6,7,
     Ind1 += Ind2; // Comp�e um n�mero decimal para verifica��o
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
     return ' ';  // Caso a verifica��o falhe retorna espa�o
}

// ****************************************************************************
// ***** Rotina principal
// ****************************************************************************
void main() {
     unsigned int k;                     // Indexador
     unsigned short Lcd_Count = 0;       // Contador para reiniciar escrita no display
     char Resultado;                     // Receber� o resultado da filtragem
     bit Data_Received;                  // Flag indicador de dado amostrado
     // Configura pinos de I/O
     TRISB = 0; // Todos como sa�das
     TRISC = 1; // RC0 como entrada
     // Inicializa o display (Bibliteca do MikroC)
     Lcd_Init();
     Lcd_Cmd(1);
     Lcd_Out(1,1,"DTMF Decode");
     Lcd_Out(2,1,">");
     // Inicializa UART para debug na simula��o
     UART1_Init(9600);
     // Inicializa indicando que nenhuma amostra est� dispon�vel
     Data_Received=0;
     do{
        // Verifica se tem amostra
        if (Data_Received){
           // Monta o vetor com as componentes espectrais
           FAG[0]=Goertzel_Algorithm(697);
           FAG[1]=Goertzel_Algorithm(770);
           FAG[2]=Goertzel_Algorithm(852);
           FAG[3]=Goertzel_Algorithm(941);
           FAG[4]=Goertzel_Algorithm(1209);
           FAG[5]=Goertzel_Algorithm(1336);
           FAG[6]=Goertzel_Algorithm(1477);
           FAG[7]=Goertzel_Algorithm(1633);
           Resultado = Detect_key();
           Data_Received=0; // Indica que dados amostrais j� foram processados
           // *** Apenas para Debug em simula��o
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
           // *** Fim da parte de debug
           Lcd_Chr_CP(Resultado);
           Lcd_Count++;
           if (Lcd_Count>15){
              Lcd_Chr(2,2,Resultado);
              Lcd_Count=0;
            }
        }
        // Verifica se inicia a amostragem
        if (RC0_bit){
           RB0_bit=1;
           // Amostragem do sinal
           for (k=0;k<N;k++){
               v[k]=RC0_bit;
               Delay_us(TS);
           }
           // Indica que tem dados novos para processar
           Data_Received=1;
           RB0_bit=0;
           /*
           // *** Apenas para Debug em simula��o
           UART1_Write_Text("Vetor de entrada:\r\n");
           for (k=0;k<N;k++){
               UART1_Write(v[k]+48);
           }
           UART1_Write_Text("\r\n");
           // *** Fim da parte de debug
           */
        }
     }while(1);
}
