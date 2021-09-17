/*
  Teclado matricial com saída codificada em DTMF
  Desenvolvido por Junio Cesar Ferreira
  11/11/2018
*/
// Conexõe do Teclado
#define Line1  PORTB.F0
#define Line2  PORTB.F1
#define Line3  PORTB.F2
#define Line4  PORTB.F3
#define Colun1 PORTB.F4
#define Colun2 PORTB.F5
#define Colun3 PORTB.F6
#define Colun4 PORTB.F7

// Sinais de saída
#define Output PORTC.F0 // Saída de soma dos sinais de som
#define Samp   PORTC.F4 // Ponto de teste para verificar frequência de amostragem
#define Sin1   PORTC.F1 // Sinal de som "puro" 1
#define Sin2   PORTC.F2 // Sinal de som "puro" 2

// Auxiliares Varredura teclado
#define Clear  PORTB=0xFF
#define V_Col1 Clear;PORTB&=0xEF
#define V_Col2 Clear;PORTB&=0xDF
#define V_Col3 Clear;PORTB&=0xBF
#define V_Col4 Clear;PORTB&=0x7F

// Constantes calculadas para gerar as frequências
/*
 K = 1/(F*T)
 Onde:
 K é constante definida abaixo.
 F é a frequência desejada
 T é a base de tempo das interrupções utilizadas, no caso, ~ 27 us
*/
#define F0697  27
#define F0770  24
#define F0852  22
#define F0941  20
#define F1209  15
#define F1336  14
#define F1477  13
#define F1633  11

// Vetores com as constates e frequências para busca
unsigned const int Lim[8] = {F0697, F0770, F0852, F0941, F1209, F1336, F1477, F1633};
unsigned const int Freq[8] = {697, 770, 852, 941, 1209, 1336, 1477, 1633};

// Variaveis globais relacionadas ao som
unsigned int k1, k2;     // Contadores
unsigned int L1, L2;

// Protótipos de funções a serem utilizadas
void Init_Sys();                            // Inicializa o sistema
char Varre_Teclado();                       // Varredura do teclado matricial
void Som(unsigned int F1, unsigned int F2); // Gerador e somador do sinal sonoro

// *****************************************************************************
// ***** Rotina de Interrupção
// *****************************************************************************
void interrupt(){
     // Interrupção Timer 0 responsável pelo sinal 1
     if (TMR0IF_bit){
        k1++;
        if (k1>L1){
           k1=0;
           Sin1=~Sin1;
        }
        //Samp=~Samp;           // Saída para verificação da constante de tempo
        Output = Sin1|Sin2;   // Saída da soma dos sinais
        TMR0L = 154;
        TMR0IF_bit=0;
     }
     // Interrupção Timer 1 responsável pelo sinal 2
     if (TMR1IF_bit){
        k2++;
        if (k2>L2){
           k2=0;
           Sin2=~Sin2;
        }
        //Samp=~Samp;           // Saída para verificação da constante de tempo
        Output = Sin1|Sin2;   // Saída da soma dos sinais
        TMR1L = 154;
        TMR1H = 255;
        TMR1IF_bit=0;
     }
}

// ****************************************************************************
// ***** Rotina principal
// ****************************************************************************
void main() {
     unsigned int f1,f2; // Auxiliares para seleção das frequências
     char Bot=0;         // Caracter que o botão prescionado representa

     Init_Sys();         // Inicializações do PIC18F2550

     do{
        Bot=Varre_Teclado();
        UART1_Write(Bot);// Debug - Apenas para verificação durante simulação
        if (Bot){// Se detectou botão seleciona frequências e dispara Som
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


/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Rotina de Inicialização do sistema
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
void Init_Sys(){
     // Configura SFRs
     TRISB=0x0F;   // Nibble alto como saída e nibble baixo como entrada
     TRISC=0;      // Zera port c
     //INTCON bits: GIE/GIEH PEIE/GIEL TMR0IE INT0IE RBIE TMR0IF INT0IF RBIF
     INTCON  = 0b11000000;
     // T0CON bits: TMR0ON T08BIT T0CS T0SE PSA T0PS2 T0PS1 T0PS0
     T0CON = 0b11001000;
     // RD16 T1RUN T1CKPS1 T1CKPS0 T1OSCEN T1SYNC TMR1CS TMR1ON
     T1CON = 0b00000001;
     // Desabilita timer 1
     TMR1IE_bit = 0;
     // Inicializa comunicação serial - Utilizei isto apenas para debug nas simulações
     UART1_Init(9600);
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Rotina converte frequência em limite do contador para tal frequência
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
unsigned int Limiter (unsigned int F){
         unsigned short i;
         for (i=0; i<8;i++){
             if (Freq[i]==F){
                return Lim[i];
             }
         }
         return 0;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Rotina geradora de Som em frequência (F)
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
void Som(unsigned int F1, unsigned int F2){
     L1 = Limiter(F1);
     L2 = Limiter(F2);
     TMR0IE_bit=1;
     TMR1IE_bit=1;
     Delay_ms(50);
     TMR0IE_bit=0;
     TMR1IE_bit=0;
     Output=0;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Rotina de leitura linha a linha para coluna de entrada
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
unsigned short Varre_Col_Ret_L(unsigned short C){
         unsigned short Ret;
         // Zera a Coluna a ser verificada
         switch (C){
                case 1:
                     V_Col1;
                     break;
                case 2:
                     V_Col2;
                     break;
                case 3:
                     V_Col3;
                     break;
                case 4:
                     V_Col4;
                     break;
                default:
                     return 0;
         }
         Delay_ms(50);
         // Leitura do nibble de linhas
         Ret=PORTB;
         Ret&=0x0F;
         // Verifica valor e retorna
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

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  Rotina de leitura do teclado
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
char Varre_Teclado(){
     unsigned short i, Rzero, R=0;
     // Varredura do Teclado
     for (i=1;i<5;i++){
         Rzero = Varre_Col_Ret_L(i);
         if (Rzero!=0) R = Rzero + 8 * i;
     }
     // Converte dados de saída
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
