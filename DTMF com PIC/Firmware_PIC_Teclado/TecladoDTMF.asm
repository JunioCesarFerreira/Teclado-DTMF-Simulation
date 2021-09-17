
_interrupt:

;TecladoDTMF.c,62 :: 		void interrupt(){
;TecladoDTMF.c,64 :: 		if (TMR0IF_bit){
	BTFSS       TMR0IF_bit+0, 2 
	GOTO        L_interrupt0
;TecladoDTMF.c,65 :: 		k1++;
	INFSNZ      _k1+0, 1 
	INCF        _k1+1, 1 
;TecladoDTMF.c,66 :: 		if (k1>L1){
	MOVF        _k1+1, 0 
	SUBWF       _L1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt71
	MOVF        _k1+0, 0 
	SUBWF       _L1+0, 0 
L__interrupt71:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt1
;TecladoDTMF.c,67 :: 		k1=0;
	CLRF        _k1+0 
	CLRF        _k1+1 
;TecladoDTMF.c,68 :: 		Sin1=~Sin1;
	BTG         PORTC+0, 1 
;TecladoDTMF.c,69 :: 		}
L_interrupt1:
;TecladoDTMF.c,71 :: 		Output = Sin1|Sin2;   // Saída da soma dos sinais
	BTFSC       PORTC+0, 1 
	GOTO        L__interrupt72
	BTFSC       PORTC+0, 2 
	GOTO        L__interrupt72
	BCF         PORTC+0, 0 
	GOTO        L__interrupt73
L__interrupt72:
	BSF         PORTC+0, 0 
L__interrupt73:
;TecladoDTMF.c,72 :: 		TMR0L = 154;
	MOVLW       154
	MOVWF       TMR0L+0 
;TecladoDTMF.c,73 :: 		TMR0IF_bit=0;
	BCF         TMR0IF_bit+0, 2 
;TecladoDTMF.c,74 :: 		}
L_interrupt0:
;TecladoDTMF.c,76 :: 		if (TMR1IF_bit){
	BTFSS       TMR1IF_bit+0, 0 
	GOTO        L_interrupt2
;TecladoDTMF.c,77 :: 		k2++;
	INFSNZ      _k2+0, 1 
	INCF        _k2+1, 1 
;TecladoDTMF.c,78 :: 		if (k2>L2){
	MOVF        _k2+1, 0 
	SUBWF       _L2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt74
	MOVF        _k2+0, 0 
	SUBWF       _L2+0, 0 
L__interrupt74:
	BTFSC       STATUS+0, 0 
	GOTO        L_interrupt3
;TecladoDTMF.c,79 :: 		k2=0;
	CLRF        _k2+0 
	CLRF        _k2+1 
;TecladoDTMF.c,80 :: 		Sin2=~Sin2;
	BTG         PORTC+0, 2 
;TecladoDTMF.c,81 :: 		}
L_interrupt3:
;TecladoDTMF.c,83 :: 		Output = Sin1|Sin2;   // Saída da soma dos sinais
	BTFSC       PORTC+0, 1 
	GOTO        L__interrupt75
	BTFSC       PORTC+0, 2 
	GOTO        L__interrupt75
	BCF         PORTC+0, 0 
	GOTO        L__interrupt76
L__interrupt75:
	BSF         PORTC+0, 0 
L__interrupt76:
;TecladoDTMF.c,84 :: 		TMR1L = 154;
	MOVLW       154
	MOVWF       TMR1L+0 
;TecladoDTMF.c,85 :: 		TMR1H = 255;
	MOVLW       255
	MOVWF       TMR1H+0 
;TecladoDTMF.c,86 :: 		TMR1IF_bit=0;
	BCF         TMR1IF_bit+0, 0 
;TecladoDTMF.c,87 :: 		}
L_interrupt2:
;TecladoDTMF.c,88 :: 		}
L__interrupt70:
	RETFIE      1
; end of _interrupt

_main:

;TecladoDTMF.c,93 :: 		void main() {
;TecladoDTMF.c,95 :: 		char Bot=0;         // Caracter que o botão prescionado representa
	CLRF        main_Bot_L0+0 
;TecladoDTMF.c,97 :: 		Init_Sys();         // Inicializações do PIC18F2550
	CALL        _Init_Sys+0, 0
;TecladoDTMF.c,99 :: 		do{
L_main4:
;TecladoDTMF.c,100 :: 		Bot=Varre_Teclado();
	CALL        _Varre_Teclado+0, 0
	MOVF        R0, 0 
	MOVWF       main_Bot_L0+0 
;TecladoDTMF.c,101 :: 		UART1_Write(Bot);// Debug - Apenas para verificação durante simulação
	MOVF        R0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;TecladoDTMF.c,102 :: 		if (Bot){// Se detectou botão seleciona frequências e dispara Som
	MOVF        main_Bot_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main7
;TecladoDTMF.c,103 :: 		switch (Bot){
	GOTO        L_main8
;TecladoDTMF.c,104 :: 		case '1':
L_main10:
;TecladoDTMF.c,105 :: 		f1=697;
	MOVLW       185
	MOVWF       main_f1_L0+0 
	MOVLW       2
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,106 :: 		f2=1209;
	MOVLW       185
	MOVWF       main_f2_L0+0 
	MOVLW       4
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,107 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,108 :: 		case '2':
L_main11:
;TecladoDTMF.c,109 :: 		f1=697;
	MOVLW       185
	MOVWF       main_f1_L0+0 
	MOVLW       2
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,110 :: 		f2=1336;
	MOVLW       56
	MOVWF       main_f2_L0+0 
	MOVLW       5
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,111 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,112 :: 		case '3':
L_main12:
;TecladoDTMF.c,113 :: 		f1=697;
	MOVLW       185
	MOVWF       main_f1_L0+0 
	MOVLW       2
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,114 :: 		f2=1477;
	MOVLW       197
	MOVWF       main_f2_L0+0 
	MOVLW       5
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,115 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,116 :: 		case 'A':
L_main13:
;TecladoDTMF.c,117 :: 		f1=697;
	MOVLW       185
	MOVWF       main_f1_L0+0 
	MOVLW       2
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,118 :: 		f2=1633;
	MOVLW       97
	MOVWF       main_f2_L0+0 
	MOVLW       6
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,119 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,120 :: 		case '4':
L_main14:
;TecladoDTMF.c,121 :: 		f1=770;
	MOVLW       2
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,122 :: 		f2=1209;
	MOVLW       185
	MOVWF       main_f2_L0+0 
	MOVLW       4
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,123 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,124 :: 		case '5':
L_main15:
;TecladoDTMF.c,125 :: 		f1=770;
	MOVLW       2
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,126 :: 		f2=1336;
	MOVLW       56
	MOVWF       main_f2_L0+0 
	MOVLW       5
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,127 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,128 :: 		case '6':
L_main16:
;TecladoDTMF.c,129 :: 		f1=770;
	MOVLW       2
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,130 :: 		f2=1477;
	MOVLW       197
	MOVWF       main_f2_L0+0 
	MOVLW       5
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,131 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,132 :: 		case 'B':
L_main17:
;TecladoDTMF.c,133 :: 		f1=770;
	MOVLW       2
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,134 :: 		f2=1633;
	MOVLW       97
	MOVWF       main_f2_L0+0 
	MOVLW       6
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,135 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,136 :: 		case '7':
L_main18:
;TecladoDTMF.c,137 :: 		f1=852;
	MOVLW       84
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,138 :: 		f2=1209;
	MOVLW       185
	MOVWF       main_f2_L0+0 
	MOVLW       4
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,139 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,140 :: 		case '8':
L_main19:
;TecladoDTMF.c,141 :: 		f1=852;
	MOVLW       84
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,142 :: 		f2=1336;
	MOVLW       56
	MOVWF       main_f2_L0+0 
	MOVLW       5
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,143 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,144 :: 		case '9':
L_main20:
;TecladoDTMF.c,145 :: 		f1=852;
	MOVLW       84
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,146 :: 		f2=1477;
	MOVLW       197
	MOVWF       main_f2_L0+0 
	MOVLW       5
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,147 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,148 :: 		case 'C':
L_main21:
;TecladoDTMF.c,149 :: 		f1=852;
	MOVLW       84
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,150 :: 		f2=1633;
	MOVLW       97
	MOVWF       main_f2_L0+0 
	MOVLW       6
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,151 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,152 :: 		case '*':
L_main22:
;TecladoDTMF.c,153 :: 		f1=941;
	MOVLW       173
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,154 :: 		f2=1209;
	MOVLW       185
	MOVWF       main_f2_L0+0 
	MOVLW       4
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,155 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,156 :: 		case '0':
L_main23:
;TecladoDTMF.c,157 :: 		f1=941;
	MOVLW       173
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,158 :: 		f2=1336;
	MOVLW       56
	MOVWF       main_f2_L0+0 
	MOVLW       5
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,159 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,160 :: 		case '#':
L_main24:
;TecladoDTMF.c,161 :: 		f1 = 941;
	MOVLW       173
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,162 :: 		f2=1477;
	MOVLW       197
	MOVWF       main_f2_L0+0 
	MOVLW       5
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,163 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,164 :: 		case 'D':
L_main25:
;TecladoDTMF.c,165 :: 		f1=941;
	MOVLW       173
	MOVWF       main_f1_L0+0 
	MOVLW       3
	MOVWF       main_f1_L0+1 
;TecladoDTMF.c,166 :: 		f2=1633;
	MOVLW       97
	MOVWF       main_f2_L0+0 
	MOVLW       6
	MOVWF       main_f2_L0+1 
;TecladoDTMF.c,167 :: 		break;
	GOTO        L_main9
;TecladoDTMF.c,168 :: 		}
L_main8:
	MOVF        main_Bot_L0+0, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
	MOVF        main_Bot_L0+0, 0 
	XORLW       50
	BTFSC       STATUS+0, 2 
	GOTO        L_main11
	MOVF        main_Bot_L0+0, 0 
	XORLW       51
	BTFSC       STATUS+0, 2 
	GOTO        L_main12
	MOVF        main_Bot_L0+0, 0 
	XORLW       65
	BTFSC       STATUS+0, 2 
	GOTO        L_main13
	MOVF        main_Bot_L0+0, 0 
	XORLW       52
	BTFSC       STATUS+0, 2 
	GOTO        L_main14
	MOVF        main_Bot_L0+0, 0 
	XORLW       53
	BTFSC       STATUS+0, 2 
	GOTO        L_main15
	MOVF        main_Bot_L0+0, 0 
	XORLW       54
	BTFSC       STATUS+0, 2 
	GOTO        L_main16
	MOVF        main_Bot_L0+0, 0 
	XORLW       66
	BTFSC       STATUS+0, 2 
	GOTO        L_main17
	MOVF        main_Bot_L0+0, 0 
	XORLW       55
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
	MOVF        main_Bot_L0+0, 0 
	XORLW       56
	BTFSC       STATUS+0, 2 
	GOTO        L_main19
	MOVF        main_Bot_L0+0, 0 
	XORLW       57
	BTFSC       STATUS+0, 2 
	GOTO        L_main20
	MOVF        main_Bot_L0+0, 0 
	XORLW       67
	BTFSC       STATUS+0, 2 
	GOTO        L_main21
	MOVF        main_Bot_L0+0, 0 
	XORLW       42
	BTFSC       STATUS+0, 2 
	GOTO        L_main22
	MOVF        main_Bot_L0+0, 0 
	XORLW       48
	BTFSC       STATUS+0, 2 
	GOTO        L_main23
	MOVF        main_Bot_L0+0, 0 
	XORLW       35
	BTFSC       STATUS+0, 2 
	GOTO        L_main24
	MOVF        main_Bot_L0+0, 0 
	XORLW       68
	BTFSC       STATUS+0, 2 
	GOTO        L_main25
L_main9:
;TecladoDTMF.c,169 :: 		Som(f1,f2);
	MOVF        main_f1_L0+0, 0 
	MOVWF       FARG_Som_F1+0 
	MOVF        main_f1_L0+1, 0 
	MOVWF       FARG_Som_F1+1 
	MOVF        main_f2_L0+0, 0 
	MOVWF       FARG_Som_F2+0 
	MOVF        main_f2_L0+1, 0 
	MOVWF       FARG_Som_F2+1 
	CALL        _Som+0, 0
;TecladoDTMF.c,170 :: 		Delay_ms(40);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_main26:
	DECFSZ      R13, 1, 0
	BRA         L_main26
	DECFSZ      R12, 1, 0
	BRA         L_main26
	DECFSZ      R11, 1, 0
	BRA         L_main26
	NOP
;TecladoDTMF.c,171 :: 		}
L_main7:
;TecladoDTMF.c,172 :: 		}while(1);
	GOTO        L_main4
;TecladoDTMF.c,173 :: 		}
	GOTO        $+0
; end of _main

_Init_Sys:

;TecladoDTMF.c,179 :: 		void Init_Sys(){
;TecladoDTMF.c,181 :: 		TRISB=0x0F;   // Nibble alto como saída e nibble baixo como entrada
	MOVLW       15
	MOVWF       TRISB+0 
;TecladoDTMF.c,182 :: 		TRISC=0;      // Zera port c
	CLRF        TRISC+0 
;TecladoDTMF.c,184 :: 		INTCON  = 0b11000000;
	MOVLW       192
	MOVWF       INTCON+0 
;TecladoDTMF.c,186 :: 		T0CON = 0b11001000;
	MOVLW       200
	MOVWF       T0CON+0 
;TecladoDTMF.c,188 :: 		T1CON = 0b00000001;
	MOVLW       1
	MOVWF       T1CON+0 
;TecladoDTMF.c,190 :: 		TMR1IE_bit = 0;
	BCF         TMR1IE_bit+0, 0 
;TecladoDTMF.c,192 :: 		UART1_Init(9600);
	MOVLW       129
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;TecladoDTMF.c,193 :: 		}
	RETURN      0
; end of _Init_Sys

_Limiter:

;TecladoDTMF.c,198 :: 		unsigned int Limiter (unsigned int F){
;TecladoDTMF.c,200 :: 		for (i=0; i<8;i++){
	CLRF        R5 
L_Limiter27:
	MOVLW       8
	SUBWF       R5, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Limiter28
;TecladoDTMF.c,201 :: 		if (Freq[i]==F){
	MOVF        R5, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	MOVLW       _Freq+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Freq+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_Freq+0)
	ADDWFC      R2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	TBLRD*+
	MOVFF       TABLAT+0, R2
	MOVF        R2, 0 
	XORWF       FARG_Limiter_F+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Limiter77
	MOVF        FARG_Limiter_F+0, 0 
	XORWF       R1, 0 
L__Limiter77:
	BTFSS       STATUS+0, 2 
	GOTO        L_Limiter30
;TecladoDTMF.c,202 :: 		return Lim[i];
	MOVF        R5, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	MOVLW       _Lim+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_Lim+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_Lim+0)
	ADDWFC      R2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	TBLRD*+
	MOVFF       TABLAT+0, R1
	RETURN      0
;TecladoDTMF.c,203 :: 		}
L_Limiter30:
;TecladoDTMF.c,200 :: 		for (i=0; i<8;i++){
	INCF        R5, 1 
;TecladoDTMF.c,204 :: 		}
	GOTO        L_Limiter27
L_Limiter28:
;TecladoDTMF.c,205 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;TecladoDTMF.c,206 :: 		}
	RETURN      0
; end of _Limiter

_Som:

;TecladoDTMF.c,211 :: 		void Som(unsigned int F1, unsigned int F2){
;TecladoDTMF.c,212 :: 		L1 = Limiter(F1);
	MOVF        FARG_Som_F1+0, 0 
	MOVWF       FARG_Limiter_F+0 
	MOVF        FARG_Som_F1+1, 0 
	MOVWF       FARG_Limiter_F+1 
	CALL        _Limiter+0, 0
	MOVF        R0, 0 
	MOVWF       _L1+0 
	MOVF        R1, 0 
	MOVWF       _L1+1 
;TecladoDTMF.c,213 :: 		L2 = Limiter(F2);
	MOVF        FARG_Som_F2+0, 0 
	MOVWF       FARG_Limiter_F+0 
	MOVF        FARG_Som_F2+1, 0 
	MOVWF       FARG_Limiter_F+1 
	CALL        _Limiter+0, 0
	MOVF        R0, 0 
	MOVWF       _L2+0 
	MOVF        R1, 0 
	MOVWF       _L2+1 
;TecladoDTMF.c,214 :: 		TMR0IE_bit=1;
	BSF         TMR0IE_bit+0, 5 
;TecladoDTMF.c,215 :: 		TMR1IE_bit=1;
	BSF         TMR1IE_bit+0, 0 
;TecladoDTMF.c,216 :: 		Delay_ms(50);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_Som31:
	DECFSZ      R13, 1, 0
	BRA         L_Som31
	DECFSZ      R12, 1, 0
	BRA         L_Som31
	DECFSZ      R11, 1, 0
	BRA         L_Som31
	NOP
	NOP
;TecladoDTMF.c,217 :: 		TMR0IE_bit=0;
	BCF         TMR0IE_bit+0, 5 
;TecladoDTMF.c,218 :: 		TMR1IE_bit=0;
	BCF         TMR1IE_bit+0, 0 
;TecladoDTMF.c,219 :: 		Output=0;
	BCF         PORTC+0, 0 
;TecladoDTMF.c,220 :: 		}
	RETURN      0
; end of _Som

_Varre_Col_Ret_L:

;TecladoDTMF.c,225 :: 		unsigned short Varre_Col_Ret_L(unsigned short C){
;TecladoDTMF.c,228 :: 		switch (C){
	GOTO        L_Varre_Col_Ret_L32
;TecladoDTMF.c,229 :: 		case 1:
L_Varre_Col_Ret_L34:
;TecladoDTMF.c,230 :: 		V_Col1;
	MOVLW       255
	MOVWF       PORTB+0 
	MOVLW       239
	ANDWF       PORTB+0, 1 
;TecladoDTMF.c,231 :: 		break;
	GOTO        L_Varre_Col_Ret_L33
;TecladoDTMF.c,232 :: 		case 2:
L_Varre_Col_Ret_L35:
;TecladoDTMF.c,233 :: 		V_Col2;
	MOVLW       255
	MOVWF       PORTB+0 
	MOVLW       223
	ANDWF       PORTB+0, 1 
;TecladoDTMF.c,234 :: 		break;
	GOTO        L_Varre_Col_Ret_L33
;TecladoDTMF.c,235 :: 		case 3:
L_Varre_Col_Ret_L36:
;TecladoDTMF.c,236 :: 		V_Col3;
	MOVLW       255
	MOVWF       PORTB+0 
	MOVLW       191
	ANDWF       PORTB+0, 1 
;TecladoDTMF.c,237 :: 		break;
	GOTO        L_Varre_Col_Ret_L33
;TecladoDTMF.c,238 :: 		case 4:
L_Varre_Col_Ret_L37:
;TecladoDTMF.c,239 :: 		V_Col4;
	MOVLW       255
	MOVWF       PORTB+0 
	MOVLW       127
	ANDWF       PORTB+0, 1 
;TecladoDTMF.c,240 :: 		break;
	GOTO        L_Varre_Col_Ret_L33
;TecladoDTMF.c,241 :: 		default:
L_Varre_Col_Ret_L38:
;TecladoDTMF.c,242 :: 		return 0;
	CLRF        R0 
	RETURN      0
;TecladoDTMF.c,243 :: 		}
L_Varre_Col_Ret_L32:
	MOVF        FARG_Varre_Col_Ret_L_C+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Col_Ret_L34
	MOVF        FARG_Varre_Col_Ret_L_C+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Col_Ret_L35
	MOVF        FARG_Varre_Col_Ret_L_C+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Col_Ret_L36
	MOVF        FARG_Varre_Col_Ret_L_C+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Col_Ret_L37
	GOTO        L_Varre_Col_Ret_L38
L_Varre_Col_Ret_L33:
;TecladoDTMF.c,244 :: 		Delay_ms(50);
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       69
	MOVWF       R12, 0
	MOVLW       169
	MOVWF       R13, 0
L_Varre_Col_Ret_L39:
	DECFSZ      R13, 1, 0
	BRA         L_Varre_Col_Ret_L39
	DECFSZ      R12, 1, 0
	BRA         L_Varre_Col_Ret_L39
	DECFSZ      R11, 1, 0
	BRA         L_Varre_Col_Ret_L39
	NOP
	NOP
;TecladoDTMF.c,246 :: 		Ret=PORTB;
	MOVF        PORTB+0, 0 
	MOVWF       R1 
;TecladoDTMF.c,247 :: 		Ret&=0x0F;
	MOVLW       15
	ANDWF       R1, 1 
;TecladoDTMF.c,249 :: 		switch (Ret){
	GOTO        L_Varre_Col_Ret_L40
;TecladoDTMF.c,250 :: 		case 0x07:
L_Varre_Col_Ret_L42:
;TecladoDTMF.c,251 :: 		return 1;
	MOVLW       1
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,252 :: 		case 0x0B:
L_Varre_Col_Ret_L43:
;TecladoDTMF.c,253 :: 		return 2;
	MOVLW       2
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,254 :: 		case 0x0D:
L_Varre_Col_Ret_L44:
;TecladoDTMF.c,255 :: 		return 3;
	MOVLW       3
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,256 :: 		case 0x0E:
L_Varre_Col_Ret_L45:
;TecladoDTMF.c,257 :: 		return 4;
	MOVLW       4
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,258 :: 		default:
L_Varre_Col_Ret_L46:
;TecladoDTMF.c,259 :: 		return 0;
	CLRF        R0 
	RETURN      0
;TecladoDTMF.c,260 :: 		}
L_Varre_Col_Ret_L40:
	MOVF        R1, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Col_Ret_L42
	MOVF        R1, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Col_Ret_L43
	MOVF        R1, 0 
	XORLW       13
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Col_Ret_L44
	MOVF        R1, 0 
	XORLW       14
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Col_Ret_L45
	GOTO        L_Varre_Col_Ret_L46
;TecladoDTMF.c,261 :: 		}
	RETURN      0
; end of _Varre_Col_Ret_L

_Varre_Teclado:

;TecladoDTMF.c,266 :: 		char Varre_Teclado(){
;TecladoDTMF.c,267 :: 		unsigned short i, Rzero, R=0;
	CLRF        Varre_Teclado_R_L0+0 
;TecladoDTMF.c,269 :: 		for (i=1;i<5;i++){
	MOVLW       1
	MOVWF       Varre_Teclado_i_L0+0 
L_Varre_Teclado47:
	MOVLW       5
	SUBWF       Varre_Teclado_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Varre_Teclado48
;TecladoDTMF.c,270 :: 		Rzero = Varre_Col_Ret_L(i);
	MOVF        Varre_Teclado_i_L0+0, 0 
	MOVWF       FARG_Varre_Col_Ret_L_C+0 
	CALL        _Varre_Col_Ret_L+0, 0
	MOVF        R0, 0 
	MOVWF       Varre_Teclado_Rzero_L0+0 
;TecladoDTMF.c,271 :: 		if (Rzero!=0) R = Rzero + 8 * i;
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado50
	MOVF        Varre_Teclado_i_L0+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	ADDWF       Varre_Teclado_Rzero_L0+0, 0 
	MOVWF       Varre_Teclado_R_L0+0 
L_Varre_Teclado50:
;TecladoDTMF.c,269 :: 		for (i=1;i<5;i++){
	INCF        Varre_Teclado_i_L0+0, 1 
;TecladoDTMF.c,272 :: 		}
	GOTO        L_Varre_Teclado47
L_Varre_Teclado48:
;TecladoDTMF.c,274 :: 		switch (R){
	GOTO        L_Varre_Teclado51
;TecladoDTMF.c,275 :: 		case 9:
L_Varre_Teclado53:
;TecladoDTMF.c,276 :: 		return '1';
	MOVLW       49
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,277 :: 		case 10:
L_Varre_Teclado54:
;TecladoDTMF.c,278 :: 		return '4';
	MOVLW       52
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,279 :: 		case 11:
L_Varre_Teclado55:
;TecladoDTMF.c,280 :: 		return '7';
	MOVLW       55
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,281 :: 		case 12:
L_Varre_Teclado56:
;TecladoDTMF.c,282 :: 		return '*';
	MOVLW       42
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,283 :: 		case 17:
L_Varre_Teclado57:
;TecladoDTMF.c,284 :: 		return '2';
	MOVLW       50
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,285 :: 		case 18:
L_Varre_Teclado58:
;TecladoDTMF.c,286 :: 		return '5';
	MOVLW       53
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,287 :: 		case 19:
L_Varre_Teclado59:
;TecladoDTMF.c,288 :: 		return '8';
	MOVLW       56
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,289 :: 		case 20:
L_Varre_Teclado60:
;TecladoDTMF.c,290 :: 		return '0';
	MOVLW       48
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,291 :: 		case 25:
L_Varre_Teclado61:
;TecladoDTMF.c,292 :: 		return '3';
	MOVLW       51
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,293 :: 		case 26:
L_Varre_Teclado62:
;TecladoDTMF.c,294 :: 		return '6';
	MOVLW       54
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,295 :: 		case 27:
L_Varre_Teclado63:
;TecladoDTMF.c,296 :: 		return '9';
	MOVLW       57
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,297 :: 		case 28:
L_Varre_Teclado64:
;TecladoDTMF.c,298 :: 		return '#';
	MOVLW       35
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,299 :: 		case 33:
L_Varre_Teclado65:
;TecladoDTMF.c,300 :: 		return 'A';
	MOVLW       65
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,301 :: 		case 34:
L_Varre_Teclado66:
;TecladoDTMF.c,302 :: 		return 'B';
	MOVLW       66
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,303 :: 		case 35:
L_Varre_Teclado67:
;TecladoDTMF.c,304 :: 		return 'C';
	MOVLW       67
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,305 :: 		case 36:
L_Varre_Teclado68:
;TecladoDTMF.c,306 :: 		return 'D';
	MOVLW       68
	MOVWF       R0 
	RETURN      0
;TecladoDTMF.c,307 :: 		default:
L_Varre_Teclado69:
;TecladoDTMF.c,308 :: 		return 0;
	CLRF        R0 
	RETURN      0
;TecladoDTMF.c,309 :: 		}
L_Varre_Teclado51:
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       9
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado53
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado54
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado55
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       12
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado56
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       17
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado57
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       18
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado58
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       19
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado59
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       20
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado60
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       25
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado61
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       26
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado62
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       27
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado63
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       28
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado64
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       33
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado65
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       34
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado66
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       35
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado67
	MOVF        Varre_Teclado_R_L0+0, 0 
	XORLW       36
	BTFSC       STATUS+0, 2 
	GOTO        L_Varre_Teclado68
	GOTO        L_Varre_Teclado69
;TecladoDTMF.c,311 :: 		}
	RETURN      0
; end of _Varre_Teclado
