
_Goertzel_Algorithm:

;DTMF_Decode.c,36 :: 		double Goertzel_Algorithm(double Fr){
;DTMF_Decode.c,44 :: 		double z0=0, z1=0, z2=0;
	CLRF        Goertzel_Algorithm_z0_L0+0 
	CLRF        Goertzel_Algorithm_z0_L0+1 
	CLRF        Goertzel_Algorithm_z0_L0+2 
	CLRF        Goertzel_Algorithm_z0_L0+3 
	CLRF        Goertzel_Algorithm_z1_L0+0 
	CLRF        Goertzel_Algorithm_z1_L0+1 
	CLRF        Goertzel_Algorithm_z1_L0+2 
	CLRF        Goertzel_Algorithm_z1_L0+3 
	CLRF        Goertzel_Algorithm_z2_L0+0 
	CLRF        Goertzel_Algorithm_z2_L0+1 
	CLRF        Goertzel_Algorithm_z2_L0+2 
	CLRF        Goertzel_Algorithm_z2_L0+3 
;DTMF_Decode.c,47 :: 		w = 2*Pi*Fr/FS;
	MOVLW       219
	MOVWF       R0 
	MOVLW       15
	MOVWF       R1 
	MOVLW       73
	MOVWF       R2 
	MOVLW       129
	MOVWF       R3 
	MOVF        FARG_Goertzel_Algorithm_Fr+0, 0 
	MOVWF       R4 
	MOVF        FARG_Goertzel_Algorithm_Fr+1, 0 
	MOVWF       R5 
	MOVF        FARG_Goertzel_Algorithm_Fr+2, 0 
	MOVWF       R6 
	MOVF        FARG_Goertzel_Algorithm_Fr+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       140
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Goertzel_Algorithm_w_L0+0 
	MOVF        R1, 0 
	MOVWF       Goertzel_Algorithm_w_L0+1 
	MOVF        R2, 0 
	MOVWF       Goertzel_Algorithm_w_L0+2 
	MOVF        R3, 0 
	MOVWF       Goertzel_Algorithm_w_L0+3 
;DTMF_Decode.c,48 :: 		cosw = cos(w);
	MOVF        R0, 0 
	MOVWF       FARG_cos_f+0 
	MOVF        R1, 0 
	MOVWF       FARG_cos_f+1 
	MOVF        R2, 0 
	MOVWF       FARG_cos_f+2 
	MOVF        R3, 0 
	MOVWF       FARG_cos_f+3 
	CALL        _cos+0, 0
	MOVF        R0, 0 
	MOVWF       Goertzel_Algorithm_cosw_L0+0 
	MOVF        R1, 0 
	MOVWF       Goertzel_Algorithm_cosw_L0+1 
	MOVF        R2, 0 
	MOVWF       Goertzel_Algorithm_cosw_L0+2 
	MOVF        R3, 0 
	MOVWF       Goertzel_Algorithm_cosw_L0+3 
;DTMF_Decode.c,49 :: 		sinw = sin(w);
	MOVF        Goertzel_Algorithm_w_L0+0, 0 
	MOVWF       FARG_sin_f+0 
	MOVF        Goertzel_Algorithm_w_L0+1, 0 
	MOVWF       FARG_sin_f+1 
	MOVF        Goertzel_Algorithm_w_L0+2, 0 
	MOVWF       FARG_sin_f+2 
	MOVF        Goertzel_Algorithm_w_L0+3, 0 
	MOVWF       FARG_sin_f+3 
	CALL        _sin+0, 0
	MOVF        R0, 0 
	MOVWF       Goertzel_Algorithm_sinw_L0+0 
	MOVF        R1, 0 
	MOVWF       Goertzel_Algorithm_sinw_L0+1 
	MOVF        R2, 0 
	MOVWF       Goertzel_Algorithm_sinw_L0+2 
	MOVF        R3, 0 
	MOVWF       Goertzel_Algorithm_sinw_L0+3 
;DTMF_Decode.c,50 :: 		coefk = 2*cosw;
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVLW       128
	MOVWF       R3 
	MOVF        Goertzel_Algorithm_cosw_L0+0, 0 
	MOVWF       R4 
	MOVF        Goertzel_Algorithm_cosw_L0+1, 0 
	MOVWF       R5 
	MOVF        Goertzel_Algorithm_cosw_L0+2, 0 
	MOVWF       R6 
	MOVF        Goertzel_Algorithm_cosw_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Goertzel_Algorithm_coefk_L0+0 
	MOVF        R1, 0 
	MOVWF       Goertzel_Algorithm_coefk_L0+1 
	MOVF        R2, 0 
	MOVWF       Goertzel_Algorithm_coefk_L0+2 
	MOVF        R3, 0 
	MOVWF       Goertzel_Algorithm_coefk_L0+3 
;DTMF_Decode.c,52 :: 		for (n=0; n<N; n++){
	CLRF        Goertzel_Algorithm_n_L0+0 
	CLRF        Goertzel_Algorithm_n_L0+1 
L_Goertzel_Algorithm0:
	MOVLW       1
	SUBWF       Goertzel_Algorithm_n_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Goertzel_Algorithm46
	MOVLW       0
	SUBWF       Goertzel_Algorithm_n_L0+0, 0 
L__Goertzel_Algorithm46:
	BTFSC       STATUS+0, 0 
	GOTO        L_Goertzel_Algorithm1
;DTMF_Decode.c,53 :: 		z0 = coefk*z1-z2+v[n];
	MOVF        Goertzel_Algorithm_coefk_L0+0, 0 
	MOVWF       R0 
	MOVF        Goertzel_Algorithm_coefk_L0+1, 0 
	MOVWF       R1 
	MOVF        Goertzel_Algorithm_coefk_L0+2, 0 
	MOVWF       R2 
	MOVF        Goertzel_Algorithm_coefk_L0+3, 0 
	MOVWF       R3 
	MOVF        Goertzel_Algorithm_z1_L0+0, 0 
	MOVWF       R4 
	MOVF        Goertzel_Algorithm_z1_L0+1, 0 
	MOVWF       R5 
	MOVF        Goertzel_Algorithm_z1_L0+2, 0 
	MOVWF       R6 
	MOVF        Goertzel_Algorithm_z1_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        Goertzel_Algorithm_z2_L0+0, 0 
	MOVWF       R4 
	MOVF        Goertzel_Algorithm_z2_L0+1, 0 
	MOVWF       R5 
	MOVF        Goertzel_Algorithm_z2_L0+2, 0 
	MOVWF       R6 
	MOVF        Goertzel_Algorithm_z2_L0+3, 0 
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Goertzel_Algorithm+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Goertzel_Algorithm+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Goertzel_Algorithm+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Goertzel_Algorithm+3 
	MOVLW       _v+0
	ADDWF       Goertzel_Algorithm_n_L0+0, 0 
	MOVWF       R0 
	MOVLW       hi_addr(_v+0)
	ADDWFC      Goertzel_Algorithm_n_L0+1, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0L
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	CALL        _Byte2Double+0, 0
	MOVF        FLOC__Goertzel_Algorithm+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Goertzel_Algorithm+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Goertzel_Algorithm+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Goertzel_Algorithm+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Goertzel_Algorithm_z0_L0+0 
	MOVF        R1, 0 
	MOVWF       Goertzel_Algorithm_z0_L0+1 
	MOVF        R2, 0 
	MOVWF       Goertzel_Algorithm_z0_L0+2 
	MOVF        R3, 0 
	MOVWF       Goertzel_Algorithm_z0_L0+3 
;DTMF_Decode.c,54 :: 		z2=z1;
	MOVF        Goertzel_Algorithm_z1_L0+0, 0 
	MOVWF       Goertzel_Algorithm_z2_L0+0 
	MOVF        Goertzel_Algorithm_z1_L0+1, 0 
	MOVWF       Goertzel_Algorithm_z2_L0+1 
	MOVF        Goertzel_Algorithm_z1_L0+2, 0 
	MOVWF       Goertzel_Algorithm_z2_L0+2 
	MOVF        Goertzel_Algorithm_z1_L0+3, 0 
	MOVWF       Goertzel_Algorithm_z2_L0+3 
;DTMF_Decode.c,55 :: 		z1=z0;
	MOVF        R0, 0 
	MOVWF       Goertzel_Algorithm_z1_L0+0 
	MOVF        R1, 0 
	MOVWF       Goertzel_Algorithm_z1_L0+1 
	MOVF        R2, 0 
	MOVWF       Goertzel_Algorithm_z1_L0+2 
	MOVF        R3, 0 
	MOVWF       Goertzel_Algorithm_z1_L0+3 
;DTMF_Decode.c,52 :: 		for (n=0; n<N; n++){
	INFSNZ      Goertzel_Algorithm_n_L0+0, 1 
	INCF        Goertzel_Algorithm_n_L0+1, 1 
;DTMF_Decode.c,56 :: 		}
	GOTO        L_Goertzel_Algorithm0
L_Goertzel_Algorithm1:
;DTMF_Decode.c,57 :: 		z0=(z1-z2*cosw)/N;        // Componente Real
	MOVF        Goertzel_Algorithm_z2_L0+0, 0 
	MOVWF       R0 
	MOVF        Goertzel_Algorithm_z2_L0+1, 0 
	MOVWF       R1 
	MOVF        Goertzel_Algorithm_z2_L0+2, 0 
	MOVWF       R2 
	MOVF        Goertzel_Algorithm_z2_L0+3, 0 
	MOVWF       R3 
	MOVF        Goertzel_Algorithm_cosw_L0+0, 0 
	MOVWF       R4 
	MOVF        Goertzel_Algorithm_cosw_L0+1, 0 
	MOVWF       R5 
	MOVF        Goertzel_Algorithm_cosw_L0+2, 0 
	MOVWF       R6 
	MOVF        Goertzel_Algorithm_cosw_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        Goertzel_Algorithm_z1_L0+0, 0 
	MOVWF       R0 
	MOVF        Goertzel_Algorithm_z1_L0+1, 0 
	MOVWF       R1 
	MOVF        Goertzel_Algorithm_z1_L0+2, 0 
	MOVWF       R2 
	MOVF        Goertzel_Algorithm_z1_L0+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       135
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Goertzel_Algorithm_z0_L0+0 
	MOVF        R1, 0 
	MOVWF       Goertzel_Algorithm_z0_L0+1 
	MOVF        R2, 0 
	MOVWF       Goertzel_Algorithm_z0_L0+2 
	MOVF        R3, 0 
	MOVWF       Goertzel_Algorithm_z0_L0+3 
;DTMF_Decode.c,58 :: 		z1=(z2*sinw)/N;           // Componente imaginária
	MOVF        Goertzel_Algorithm_z2_L0+0, 0 
	MOVWF       R0 
	MOVF        Goertzel_Algorithm_z2_L0+1, 0 
	MOVWF       R1 
	MOVF        Goertzel_Algorithm_z2_L0+2, 0 
	MOVWF       R2 
	MOVF        Goertzel_Algorithm_z2_L0+3, 0 
	MOVWF       R3 
	MOVF        Goertzel_Algorithm_sinw_L0+0, 0 
	MOVWF       R4 
	MOVF        Goertzel_Algorithm_sinw_L0+1, 0 
	MOVWF       R5 
	MOVF        Goertzel_Algorithm_sinw_L0+2, 0 
	MOVWF       R6 
	MOVF        Goertzel_Algorithm_sinw_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       135
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       Goertzel_Algorithm_z1_L0+0 
	MOVF        R1, 0 
	MOVWF       Goertzel_Algorithm_z1_L0+1 
	MOVF        R2, 0 
	MOVWF       Goertzel_Algorithm_z1_L0+2 
	MOVF        R3, 0 
	MOVWF       Goertzel_Algorithm_z1_L0+3 
;DTMF_Decode.c,59 :: 		z2=sqrt(z0*z0+z1*z1);     // Magnetude
	MOVF        Goertzel_Algorithm_z0_L0+0, 0 
	MOVWF       R0 
	MOVF        Goertzel_Algorithm_z0_L0+1, 0 
	MOVWF       R1 
	MOVF        Goertzel_Algorithm_z0_L0+2, 0 
	MOVWF       R2 
	MOVF        Goertzel_Algorithm_z0_L0+3, 0 
	MOVWF       R3 
	MOVF        Goertzel_Algorithm_z0_L0+0, 0 
	MOVWF       R4 
	MOVF        Goertzel_Algorithm_z0_L0+1, 0 
	MOVWF       R5 
	MOVF        Goertzel_Algorithm_z0_L0+2, 0 
	MOVWF       R6 
	MOVF        Goertzel_Algorithm_z0_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__Goertzel_Algorithm+0 
	MOVF        R1, 0 
	MOVWF       FLOC__Goertzel_Algorithm+1 
	MOVF        R2, 0 
	MOVWF       FLOC__Goertzel_Algorithm+2 
	MOVF        R3, 0 
	MOVWF       FLOC__Goertzel_Algorithm+3 
	MOVF        Goertzel_Algorithm_z1_L0+0, 0 
	MOVWF       R0 
	MOVF        Goertzel_Algorithm_z1_L0+1, 0 
	MOVWF       R1 
	MOVF        Goertzel_Algorithm_z1_L0+2, 0 
	MOVWF       R2 
	MOVF        Goertzel_Algorithm_z1_L0+3, 0 
	MOVWF       R3 
	MOVF        Goertzel_Algorithm_z1_L0+0, 0 
	MOVWF       R4 
	MOVF        Goertzel_Algorithm_z1_L0+1, 0 
	MOVWF       R5 
	MOVF        Goertzel_Algorithm_z1_L0+2, 0 
	MOVWF       R6 
	MOVF        Goertzel_Algorithm_z1_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        FLOC__Goertzel_Algorithm+0, 0 
	MOVWF       R4 
	MOVF        FLOC__Goertzel_Algorithm+1, 0 
	MOVWF       R5 
	MOVF        FLOC__Goertzel_Algorithm+2, 0 
	MOVWF       R6 
	MOVF        FLOC__Goertzel_Algorithm+3, 0 
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sqrt_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_sqrt_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_sqrt_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_sqrt_x+3 
	CALL        _sqrt+0, 0
	MOVF        R0, 0 
	MOVWF       Goertzel_Algorithm_z2_L0+0 
	MOVF        R1, 0 
	MOVWF       Goertzel_Algorithm_z2_L0+1 
	MOVF        R2, 0 
	MOVWF       Goertzel_Algorithm_z2_L0+2 
	MOVF        R3, 0 
	MOVWF       Goertzel_Algorithm_z2_L0+3 
;DTMF_Decode.c,60 :: 		return z2;
;DTMF_Decode.c,61 :: 		}
	RETURN      0
; end of _Goertzel_Algorithm

_Detect_key:

;DTMF_Decode.c,66 :: 		char Detect_key(){
;DTMF_Decode.c,68 :: 		double Max=0;         // Variavel auxiliar para encontrar os máximos
	CLRF        Detect_key_Max_L0+0 
	CLRF        Detect_key_Max_L0+1 
	CLRF        Detect_key_Max_L0+2 
	CLRF        Detect_key_Max_L0+3 
;DTMF_Decode.c,69 :: 		char Ind1=0, Ind2=0;  // Indexadores dos máximos
	CLRF        Detect_key_Ind1_L0+0 
	CLRF        Detect_key_Ind2_L0+0 
;DTMF_Decode.c,71 :: 		for (j = 0; j < 8; j++){
	CLRF        Detect_key_j_L0+0 
L_Detect_key3:
	MOVLW       8
	SUBWF       Detect_key_j_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Detect_key4
;DTMF_Decode.c,72 :: 		if (FAG[j] > Max){
	MOVF        Detect_key_j_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _FAG+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_FAG+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        Detect_key_Max_L0+0, 0 
	MOVWF       R0 
	MOVF        Detect_key_Max_L0+1, 0 
	MOVWF       R1 
	MOVF        Detect_key_Max_L0+2, 0 
	MOVWF       R2 
	MOVF        Detect_key_Max_L0+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key6
;DTMF_Decode.c,73 :: 		Max = FAG[j];
	MOVF        Detect_key_j_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _FAG+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_FAG+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       Detect_key_Max_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       Detect_key_Max_L0+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       Detect_key_Max_L0+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       Detect_key_Max_L0+3 
;DTMF_Decode.c,74 :: 		Ind1 = j;
	MOVF        Detect_key_j_L0+0, 0 
	MOVWF       Detect_key_Ind1_L0+0 
;DTMF_Decode.c,75 :: 		}
L_Detect_key6:
;DTMF_Decode.c,71 :: 		for (j = 0; j < 8; j++){
	INCF        Detect_key_j_L0+0, 1 
;DTMF_Decode.c,76 :: 		}
	GOTO        L_Detect_key3
L_Detect_key4:
;DTMF_Decode.c,77 :: 		Max = 0;
	CLRF        Detect_key_Max_L0+0 
	CLRF        Detect_key_Max_L0+1 
	CLRF        Detect_key_Max_L0+2 
	CLRF        Detect_key_Max_L0+3 
;DTMF_Decode.c,78 :: 		for (j = 0; j < 8; j++){
	CLRF        Detect_key_j_L0+0 
L_Detect_key7:
	MOVLW       8
	SUBWF       Detect_key_j_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Detect_key8
;DTMF_Decode.c,79 :: 		if (j!=Ind1 && FAG[j] > Max){
	MOVF        Detect_key_j_L0+0, 0 
	XORWF       Detect_key_Ind1_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key12
	MOVF        Detect_key_j_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _FAG+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_FAG+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        Detect_key_Max_L0+0, 0 
	MOVWF       R0 
	MOVF        Detect_key_Max_L0+1, 0 
	MOVWF       R1 
	MOVF        Detect_key_Max_L0+2, 0 
	MOVWF       R2 
	MOVF        Detect_key_Max_L0+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key12
L__Detect_key45:
;DTMF_Decode.c,80 :: 		Max = FAG[j];
	MOVF        Detect_key_j_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _FAG+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_FAG+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       Detect_key_Max_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       Detect_key_Max_L0+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       Detect_key_Max_L0+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       Detect_key_Max_L0+3 
;DTMF_Decode.c,81 :: 		Ind2 = j;
	MOVF        Detect_key_j_L0+0, 0 
	MOVWF       Detect_key_Ind2_L0+0 
;DTMF_Decode.c,82 :: 		}
L_Detect_key12:
;DTMF_Decode.c,78 :: 		for (j = 0; j < 8; j++){
	INCF        Detect_key_j_L0+0, 1 
;DTMF_Decode.c,83 :: 		}
	GOTO        L_Detect_key7
L_Detect_key8:
;DTMF_Decode.c,85 :: 		if (Ind1 > Ind2){
	MOVF        Detect_key_Ind1_L0+0, 0 
	SUBWF       Detect_key_Ind2_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Detect_key13
;DTMF_Decode.c,86 :: 		j = Ind1;
	MOVF        Detect_key_Ind1_L0+0, 0 
	MOVWF       Detect_key_j_L0+0 
;DTMF_Decode.c,87 :: 		Ind1 = Ind2;
	MOVF        Detect_key_Ind2_L0+0, 0 
	MOVWF       Detect_key_Ind1_L0+0 
;DTMF_Decode.c,88 :: 		Ind2 = j;
	MOVF        Detect_key_j_L0+0, 0 
	MOVWF       Detect_key_Ind2_L0+0 
;DTMF_Decode.c,89 :: 		}
L_Detect_key13:
;DTMF_Decode.c,91 :: 		Ind2*=10;     // Para que Ind2 corresponda a um valor válido ele deve ser ou 4,5,6,7,
	MOVLW       10
	MULWF       Detect_key_Ind2_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Detect_key_Ind2_L0+0 
;DTMF_Decode.c,92 :: 		Ind1 += Ind2; // Compõe um número decimal para verificação
	MOVF        R0, 0 
	ADDWF       Detect_key_Ind1_L0+0, 1 
;DTMF_Decode.c,93 :: 		switch (Ind1){
	GOTO        L_Detect_key14
;DTMF_Decode.c,94 :: 		case 40:
L_Detect_key16:
;DTMF_Decode.c,95 :: 		return '1';
	MOVLW       49
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,96 :: 		case 50:
L_Detect_key17:
;DTMF_Decode.c,97 :: 		return '2';
	MOVLW       50
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,98 :: 		case 60:
L_Detect_key18:
;DTMF_Decode.c,99 :: 		return '3';
	MOVLW       51
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,100 :: 		case 70:
L_Detect_key19:
;DTMF_Decode.c,101 :: 		return 'A';
	MOVLW       65
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,102 :: 		case 41:
L_Detect_key20:
;DTMF_Decode.c,103 :: 		return '4';
	MOVLW       52
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,104 :: 		case 51:
L_Detect_key21:
;DTMF_Decode.c,105 :: 		return '5';
	MOVLW       53
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,106 :: 		case 61:
L_Detect_key22:
;DTMF_Decode.c,107 :: 		return '6';
	MOVLW       54
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,108 :: 		case 71:
L_Detect_key23:
;DTMF_Decode.c,109 :: 		return 'B';
	MOVLW       66
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,110 :: 		case 42:
L_Detect_key24:
;DTMF_Decode.c,111 :: 		return '7';
	MOVLW       55
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,112 :: 		case 52:
L_Detect_key25:
;DTMF_Decode.c,113 :: 		return '8';
	MOVLW       56
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,114 :: 		case 62:
L_Detect_key26:
;DTMF_Decode.c,115 :: 		return '9';
	MOVLW       57
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,116 :: 		case 72:
L_Detect_key27:
;DTMF_Decode.c,117 :: 		return 'C';
	MOVLW       67
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,118 :: 		case 43:
L_Detect_key28:
;DTMF_Decode.c,119 :: 		return '*';
	MOVLW       42
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,120 :: 		case 53:
L_Detect_key29:
;DTMF_Decode.c,121 :: 		return '0';
	MOVLW       48
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,122 :: 		case 63:
L_Detect_key30:
;DTMF_Decode.c,123 :: 		return '#';
	MOVLW       35
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,124 :: 		case 73:
L_Detect_key31:
;DTMF_Decode.c,125 :: 		return 'D';
	MOVLW       68
	MOVWF       R0 
	RETURN      0
;DTMF_Decode.c,126 :: 		}
L_Detect_key14:
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       40
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key16
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       50
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key17
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       60
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key18
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       70
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key19
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       41
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key20
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       51
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key21
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       61
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key22
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       71
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key23
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       42
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key24
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       52
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key25
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       62
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key26
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       72
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key27
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       43
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key28
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       53
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key29
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       63
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key30
	MOVF        Detect_key_Ind1_L0+0, 0 
	XORLW       73
	BTFSC       STATUS+0, 2 
	GOTO        L_Detect_key31
;DTMF_Decode.c,127 :: 		return ' ';  // Caso a verificação falhe retorna espaço
	MOVLW       32
	MOVWF       R0 
;DTMF_Decode.c,128 :: 		}
	RETURN      0
; end of _Detect_key

_main:

;DTMF_Decode.c,133 :: 		void main() {
;DTMF_Decode.c,135 :: 		unsigned short Lcd_Count = 0;       // Contador para reiniciar escrita no display
	CLRF        main_Lcd_Count_L0+0 
;DTMF_Decode.c,139 :: 		TRISB = 0; // Todos como saídas
	CLRF        TRISB+0 
;DTMF_Decode.c,140 :: 		TRISC = 1; // RC0 como entrada
	MOVLW       1
	MOVWF       TRISC+0 
;DTMF_Decode.c,142 :: 		Lcd_Init();
	CALL        _Lcd_Init+0, 0
;DTMF_Decode.c,143 :: 		Lcd_Cmd(1);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;DTMF_Decode.c,144 :: 		Lcd_Out(1,1,"DTMF Decode");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_DTMF_Decode+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_DTMF_Decode+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;DTMF_Decode.c,145 :: 		Lcd_Out(2,1,">");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_DTMF_Decode+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_DTMF_Decode+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;DTMF_Decode.c,147 :: 		UART1_Init(9600);
	MOVLW       129
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;DTMF_Decode.c,149 :: 		Data_Received=0;
	BCF         main_Data_Received_L0+0, BitPos(main_Data_Received_L0+0) 
;DTMF_Decode.c,150 :: 		do{
L_main32:
;DTMF_Decode.c,152 :: 		if (Data_Received){
	BTFSS       main_Data_Received_L0+0, BitPos(main_Data_Received_L0+0) 
	GOTO        L_main35
;DTMF_Decode.c,154 :: 		FAG[0]=Goertzel_Algorithm(697);
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+0 
	MOVLW       64
	MOVWF       FARG_Goertzel_Algorithm_Fr+1 
	MOVLW       46
	MOVWF       FARG_Goertzel_Algorithm_Fr+2 
	MOVLW       136
	MOVWF       FARG_Goertzel_Algorithm_Fr+3 
	CALL        _Goertzel_Algorithm+0, 0
	MOVF        R0, 0 
	MOVWF       _FAG+0 
	MOVF        R1, 0 
	MOVWF       _FAG+1 
	MOVF        R2, 0 
	MOVWF       _FAG+2 
	MOVF        R3, 0 
	MOVWF       _FAG+3 
;DTMF_Decode.c,155 :: 		FAG[1]=Goertzel_Algorithm(770);
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+0 
	MOVLW       128
	MOVWF       FARG_Goertzel_Algorithm_Fr+1 
	MOVLW       64
	MOVWF       FARG_Goertzel_Algorithm_Fr+2 
	MOVLW       136
	MOVWF       FARG_Goertzel_Algorithm_Fr+3 
	CALL        _Goertzel_Algorithm+0, 0
	MOVF        R0, 0 
	MOVWF       _FAG+4 
	MOVF        R1, 0 
	MOVWF       _FAG+5 
	MOVF        R2, 0 
	MOVWF       _FAG+6 
	MOVF        R3, 0 
	MOVWF       _FAG+7 
;DTMF_Decode.c,156 :: 		FAG[2]=Goertzel_Algorithm(852);
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+0 
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+1 
	MOVLW       85
	MOVWF       FARG_Goertzel_Algorithm_Fr+2 
	MOVLW       136
	MOVWF       FARG_Goertzel_Algorithm_Fr+3 
	CALL        _Goertzel_Algorithm+0, 0
	MOVF        R0, 0 
	MOVWF       _FAG+8 
	MOVF        R1, 0 
	MOVWF       _FAG+9 
	MOVF        R2, 0 
	MOVWF       _FAG+10 
	MOVF        R3, 0 
	MOVWF       _FAG+11 
;DTMF_Decode.c,157 :: 		FAG[3]=Goertzel_Algorithm(941);
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+0 
	MOVLW       64
	MOVWF       FARG_Goertzel_Algorithm_Fr+1 
	MOVLW       107
	MOVWF       FARG_Goertzel_Algorithm_Fr+2 
	MOVLW       136
	MOVWF       FARG_Goertzel_Algorithm_Fr+3 
	CALL        _Goertzel_Algorithm+0, 0
	MOVF        R0, 0 
	MOVWF       _FAG+12 
	MOVF        R1, 0 
	MOVWF       _FAG+13 
	MOVF        R2, 0 
	MOVWF       _FAG+14 
	MOVF        R3, 0 
	MOVWF       _FAG+15 
;DTMF_Decode.c,158 :: 		FAG[4]=Goertzel_Algorithm(1209);
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+0 
	MOVLW       32
	MOVWF       FARG_Goertzel_Algorithm_Fr+1 
	MOVLW       23
	MOVWF       FARG_Goertzel_Algorithm_Fr+2 
	MOVLW       137
	MOVWF       FARG_Goertzel_Algorithm_Fr+3 
	CALL        _Goertzel_Algorithm+0, 0
	MOVF        R0, 0 
	MOVWF       _FAG+16 
	MOVF        R1, 0 
	MOVWF       _FAG+17 
	MOVF        R2, 0 
	MOVWF       _FAG+18 
	MOVF        R3, 0 
	MOVWF       _FAG+19 
;DTMF_Decode.c,159 :: 		FAG[5]=Goertzel_Algorithm(1336);
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+0 
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+1 
	MOVLW       39
	MOVWF       FARG_Goertzel_Algorithm_Fr+2 
	MOVLW       137
	MOVWF       FARG_Goertzel_Algorithm_Fr+3 
	CALL        _Goertzel_Algorithm+0, 0
	MOVF        R0, 0 
	MOVWF       _FAG+20 
	MOVF        R1, 0 
	MOVWF       _FAG+21 
	MOVF        R2, 0 
	MOVWF       _FAG+22 
	MOVF        R3, 0 
	MOVWF       _FAG+23 
;DTMF_Decode.c,160 :: 		FAG[6]=Goertzel_Algorithm(1477);
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+0 
	MOVLW       160
	MOVWF       FARG_Goertzel_Algorithm_Fr+1 
	MOVLW       56
	MOVWF       FARG_Goertzel_Algorithm_Fr+2 
	MOVLW       137
	MOVWF       FARG_Goertzel_Algorithm_Fr+3 
	CALL        _Goertzel_Algorithm+0, 0
	MOVF        R0, 0 
	MOVWF       _FAG+24 
	MOVF        R1, 0 
	MOVWF       _FAG+25 
	MOVF        R2, 0 
	MOVWF       _FAG+26 
	MOVF        R3, 0 
	MOVWF       _FAG+27 
;DTMF_Decode.c,161 :: 		FAG[7]=Goertzel_Algorithm(1633);
	MOVLW       0
	MOVWF       FARG_Goertzel_Algorithm_Fr+0 
	MOVLW       32
	MOVWF       FARG_Goertzel_Algorithm_Fr+1 
	MOVLW       76
	MOVWF       FARG_Goertzel_Algorithm_Fr+2 
	MOVLW       137
	MOVWF       FARG_Goertzel_Algorithm_Fr+3 
	CALL        _Goertzel_Algorithm+0, 0
	MOVF        R0, 0 
	MOVWF       _FAG+28 
	MOVF        R1, 0 
	MOVWF       _FAG+29 
	MOVF        R2, 0 
	MOVWF       _FAG+30 
	MOVF        R3, 0 
	MOVWF       _FAG+31 
;DTMF_Decode.c,162 :: 		Resultado = Detect_key();
	CALL        _Detect_key+0, 0
	MOVF        R0, 0 
	MOVWF       main_Resultado_L0+0 
;DTMF_Decode.c,163 :: 		Data_Received=0; // Indica que dados amostrais já foram processados
	BCF         main_Data_Received_L0+0, BitPos(main_Data_Received_L0+0) 
;DTMF_Decode.c,165 :: 		UART1_Write_Text("Resultado Goertzel:\r\n");
	MOVLW       ?lstr3_DTMF_Decode+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_DTMF_Decode+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;DTMF_Decode.c,166 :: 		for (k=0;k<8;k++){
	CLRF        main_k_L0+0 
	CLRF        main_k_L0+1 
L_main36:
	MOVLW       0
	SUBWF       main_k_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main47
	MOVLW       8
	SUBWF       main_k_L0+0, 0 
L__main47:
	BTFSC       STATUS+0, 0 
	GOTO        L_main37
;DTMF_Decode.c,167 :: 		FloatToStr(FAG[k], txt);
	MOVF        main_k_L0+0, 0 
	MOVWF       R0 
	MOVF        main_k_L0+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _FAG+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_FAG+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       _txt+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;DTMF_Decode.c,168 :: 		txt[6]=0;
	CLRF        _txt+6 
;DTMF_Decode.c,169 :: 		UART1_Write_Text(txt);
	MOVLW       _txt+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_txt+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;DTMF_Decode.c,170 :: 		UART1_Write(';');
	MOVLW       59
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;DTMF_Decode.c,166 :: 		for (k=0;k<8;k++){
	INFSNZ      main_k_L0+0, 1 
	INCF        main_k_L0+1, 1 
;DTMF_Decode.c,171 :: 		}
	GOTO        L_main36
L_main37:
;DTMF_Decode.c,172 :: 		UART1_Write_Text("\r\nResultado filtragem:\r\n");
	MOVLW       ?lstr4_DTMF_Decode+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr4_DTMF_Decode+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;DTMF_Decode.c,173 :: 		UART1_Write(Resultado);
	MOVF        main_Resultado_L0+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;DTMF_Decode.c,174 :: 		UART1_Write_Text("\r\n");
	MOVLW       ?lstr5_DTMF_Decode+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr5_DTMF_Decode+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;DTMF_Decode.c,176 :: 		Lcd_Chr_CP(Resultado);
	MOVF        main_Resultado_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;DTMF_Decode.c,177 :: 		Lcd_Count++;
	INCF        main_Lcd_Count_L0+0, 1 
;DTMF_Decode.c,178 :: 		if (Lcd_Count>15){
	MOVF        main_Lcd_Count_L0+0, 0 
	SUBLW       15
	BTFSC       STATUS+0, 0 
	GOTO        L_main39
;DTMF_Decode.c,179 :: 		Lcd_Chr(2,2,Resultado);
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVF        main_Resultado_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;DTMF_Decode.c,180 :: 		Lcd_Count=0;
	CLRF        main_Lcd_Count_L0+0 
;DTMF_Decode.c,181 :: 		}
L_main39:
;DTMF_Decode.c,182 :: 		}
L_main35:
;DTMF_Decode.c,184 :: 		if (RC0_bit){
	BTFSS       RC0_bit+0, 0 
	GOTO        L_main40
;DTMF_Decode.c,185 :: 		RB0_bit=1;
	BSF         RB0_bit+0, 0 
;DTMF_Decode.c,187 :: 		for (k=0;k<N;k++){
	CLRF        main_k_L0+0 
	CLRF        main_k_L0+1 
L_main41:
	MOVLW       1
	SUBWF       main_k_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main48
	MOVLW       0
	SUBWF       main_k_L0+0, 0 
L__main48:
	BTFSC       STATUS+0, 0 
	GOTO        L_main42
;DTMF_Decode.c,188 :: 		v[k]=RC0_bit;
	MOVLW       _v+0
	ADDWF       main_k_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_v+0)
	ADDWFC      main_k_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       0
	BTFSC       RC0_bit+0, 0 
	MOVLW       1
	MOVWF       POSTINC1+0 
;DTMF_Decode.c,189 :: 		Delay_us(TS);
	MOVLW       99
	MOVWF       R13, 0
L_main44:
	DECFSZ      R13, 1, 0
	BRA         L_main44
	NOP
	NOP
;DTMF_Decode.c,187 :: 		for (k=0;k<N;k++){
	INFSNZ      main_k_L0+0, 1 
	INCF        main_k_L0+1, 1 
;DTMF_Decode.c,190 :: 		}
	GOTO        L_main41
L_main42:
;DTMF_Decode.c,192 :: 		Data_Received=1;
	BSF         main_Data_Received_L0+0, BitPos(main_Data_Received_L0+0) 
;DTMF_Decode.c,193 :: 		RB0_bit=0;
	BCF         RB0_bit+0, 0 
;DTMF_Decode.c,203 :: 		}
L_main40:
;DTMF_Decode.c,204 :: 		}while(1);
	GOTO        L_main32
;DTMF_Decode.c,205 :: 		}
	GOTO        $+0
; end of _main
