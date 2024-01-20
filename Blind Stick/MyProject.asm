
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,15 :: 		void interrupt(void){
;MyProject.c,16 :: 		if(INTCON&0x04){// will get here every 1ms
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;MyProject.c,17 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;MyProject.c,18 :: 		tick++;
	INCF       _tick+0, 1
	BTFSC      STATUS+0, 2
	INCF       _tick+1, 1
;MyProject.c,20 :: 		if(tick==350){
	MOVF       _tick+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt34
	MOVLW      94
	XORWF      _tick+0, 0
L__interrupt34:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;MyProject.c,21 :: 		ADC_init(0);
	CLRF       FARG_ADC_init+0
	CLRF       FARG_ADC_init+1
	CALL       _ADC_init+0
;MyProject.c,23 :: 		reading = ADC_read();
	CALL       _ADC_read+0
	MOVF       R0+0, 0
	MOVWF      _reading+0
	MOVF       R0+1, 0
	MOVWF      _reading+1
;MyProject.c,24 :: 		temp =(reading*100*5)/(3*1023);
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      253
	MOVWF      R4+0
	MOVLW      11
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;MyProject.c,25 :: 		if(temp>20)
	MOVF       R0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt35
	MOVF       R0+0, 0
	SUBLW      20
L__interrupt35:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt2
;MyProject.c,26 :: 		buzzerOn(2);
	MOVLW      2
	MOVWF      FARG_buzzerOn+0
	MOVLW      0
	MOVWF      FARG_buzzerOn+1
	CALL       _buzzerOn+0
	GOTO       L_interrupt3
L_interrupt2:
;MyProject.c,28 :: 		PORTC=PORTC | 0x00;}
L_interrupt3:
L_interrupt1:
;MyProject.c,29 :: 		if (tick==700){
	MOVF       _tick+1, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt36
	MOVLW      188
	XORWF      _tick+0, 0
L__interrupt36:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;MyProject.c,30 :: 		read_sonar();
	CALL       _read_sonar+0
;MyProject.c,32 :: 		if(Distance<50)
	MOVLW      0
	SUBWF      _Distance+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt37
	MOVLW      0
	SUBWF      _Distance+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt37
	MOVLW      0
	SUBWF      _Distance+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt37
	MOVLW      50
	SUBWF      _Distance+0, 0
L__interrupt37:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt5
;MyProject.c,34 :: 		PORTB=PORTB | 0x40;
	BSF        PORTB+0, 6
;MyProject.c,35 :: 		buzzerOn(1);
	MOVLW      1
	MOVWF      FARG_buzzerOn+0
	MOVLW      0
	MOVWF      FARG_buzzerOn+1
	CALL       _buzzerOn+0
;MyProject.c,36 :: 		}
	GOTO       L_interrupt6
L_interrupt5:
;MyProject.c,39 :: 		PORTB=PORTB | 0x00;
;MyProject.c,40 :: 		}}
L_interrupt6:
L_interrupt4:
;MyProject.c,41 :: 		if(tick==1050){//after 500ms
	MOVF       _tick+1, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt38
	MOVLW      26
	XORWF      _tick+0, 0
L__interrupt38:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt7
;MyProject.c,42 :: 		tick=0;
	CLRF       _tick+0
	CLRF       _tick+1
;MyProject.c,45 :: 		ADC_init(1);
	MOVLW      1
	MOVWF      FARG_ADC_init+0
	MOVLW      0
	MOVWF      FARG_ADC_init+1
	CALL       _ADC_init+0
;MyProject.c,46 :: 		reading1 = ADC_read();
	CALL       _ADC_read+0
	MOVF       R0+0, 0
	MOVWF      _reading1+0
	MOVF       R0+1, 0
	MOVWF      _reading1+1
;MyProject.c,47 :: 		myVoltage= (reading1*5)/1023;
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _myVoltage+0
;MyProject.c,48 :: 		if(myVoltage>0)
	MOVF       R0+0, 0
	SUBLW      0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt8
;MyProject.c,49 :: 		buzzerOn(3);
	MOVLW      3
	MOVWF      FARG_buzzerOn+0
	MOVLW      0
	MOVWF      FARG_buzzerOn+1
	CALL       _buzzerOn+0
	GOTO       L_interrupt9
L_interrupt8:
;MyProject.c,51 :: 		PORTC=PORTC | 0x00;
L_interrupt9:
;MyProject.c,53 :: 		}
L_interrupt7:
;MyProject.c,54 :: 		INTCON = INTCON & 0xFB; //clear T0IF
	MOVLW      251
	ANDWF      INTCON+0, 1
;MyProject.c,55 :: 		}
L_interrupt0:
;MyProject.c,56 :: 		if(PIR1&0x04){//CCP1 interrupt
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt10
;MyProject.c,58 :: 		PIR1=PIR1&0xFB;
	MOVLW      251
	ANDWF      PIR1+0, 1
;MyProject.c,59 :: 		}
L_interrupt10:
;MyProject.c,60 :: 		if(PIR1&0x01){//TMR1 ovwerflow
	BTFSS      PIR1+0, 0
	GOTO       L_interrupt11
;MyProject.c,62 :: 		T1overflow++;
	INCF       _T1overflow+0, 1
	BTFSC      STATUS+0, 2
	INCF       _T1overflow+1, 1
;MyProject.c,63 :: 		PIR1=PIR1&0xFE;
	MOVLW      254
	ANDWF      PIR1+0, 1
;MyProject.c,64 :: 		}
L_interrupt11:
;MyProject.c,65 :: 		if(INTCON&0x02){//External Interrupt
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt12
;MyProject.c,66 :: 		INTCON=INTCON&0xFD;
	MOVLW      253
	ANDWF      INTCON+0, 1
;MyProject.c,67 :: 		}
L_interrupt12:
;MyProject.c,68 :: 		}
L_end_interrupt:
L__interrupt33:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MyProject.c,73 :: 		void main() {
;MyProject.c,74 :: 		TRISD =0x00;//PORTD for testing
	CLRF       TRISD+0
;MyProject.c,75 :: 		PORTD=0x00;
	CLRF       PORTD+0
;MyProject.c,76 :: 		TRISC = 0x00;//PORTC Output
	CLRF       TRISC+0
;MyProject.c,77 :: 		PORTC=0x00;// Last LED ON
	CLRF       PORTC+0
;MyProject.c,78 :: 		ADCON1=0x06;//PORTA is Digital
	MOVLW      6
	MOVWF      ADCON1+0
;MyProject.c,79 :: 		TRISA=0x00;
	CLRF       TRISA+0
;MyProject.c,82 :: 		TMR0=248;
	MOVLW      248
	MOVWF      TMR0+0
;MyProject.c,83 :: 		tick=0;
	CLRF       _tick+0
	CLRF       _tick+1
;MyProject.c,86 :: 		CCP1CON=0x00;// Disable CCP. Capture on rising for the first time. Capture on Rising: 0x05, Capture on Falling: 0x04
	CLRF       CCP1CON+0
;MyProject.c,89 :: 		OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
	MOVLW      135
	MOVWF      OPTION_REG+0
;MyProject.c,90 :: 		INTCON=0xF0;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;
	MOVLW      240
	MOVWF      INTCON+0
;MyProject.c,92 :: 		init_sonar();
	CALL       _init_sonar+0
;MyProject.c,95 :: 		while(1){
L_main13:
;MyProject.c,96 :: 		}
	GOTO       L_main13
;MyProject.c,98 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_read_sonar:

;MyProject.c,101 :: 		void read_sonar(void){
;MyProject.c,103 :: 		T1overflow=0;
	CLRF       _T1overflow+0
	CLRF       _T1overflow+1
;MyProject.c,104 :: 		TMR1H=0;
	CLRF       TMR1H+0
;MyProject.c,105 :: 		TMR1L=0;
	CLRF       TMR1L+0
;MyProject.c,107 :: 		PORTB=0x04;//Trigger the ultrasonic sensor (RB2 connected to trigger)
	MOVLW      4
	MOVWF      PORTB+0
;MyProject.c,108 :: 		usDelay(10);//keep trigger for 10uS
	MOVLW      10
	MOVWF      FARG_usDelay+0
	MOVLW      0
	MOVWF      FARG_usDelay+1
	CALL       _usDelay+0
;MyProject.c,109 :: 		PORTB=0x00;//Remove trigger
	CLRF       PORTB+0
;MyProject.c,110 :: 		while(!(PORTB&0x02));
L_read_sonar15:
	BTFSC      PORTB+0, 1
	GOTO       L_read_sonar16
	GOTO       L_read_sonar15
L_read_sonar16:
;MyProject.c,111 :: 		T1CON=0x19;//TMR1 ON, Fosc/4 (inc 1uS) with 1:2 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
	MOVLW      25
	MOVWF      T1CON+0
;MyProject.c,112 :: 		while(PORTB&0x02);
L_read_sonar17:
	BTFSS      PORTB+0, 1
	GOTO       L_read_sonar18
	GOTO       L_read_sonar17
L_read_sonar18:
;MyProject.c,113 :: 		T1CON=0x18;//TMR1 OFF, Fosc/4 (inc 1uS) with 1:1 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
	MOVLW      24
	MOVWF      T1CON+0
;MyProject.c,114 :: 		T1counts=((TMR1H<<8)|TMR1L)+(T1overflow*65536);
	MOVF       TMR1H+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       TMR1L+0, 0
	IORWF      R0+0, 0
	MOVWF      R8+0
	MOVF       R0+1, 0
	MOVWF      R8+1
	MOVLW      0
	IORWF      R8+1, 1
	MOVF       _T1overflow+1, 0
	MOVWF      R4+3
	MOVF       _T1overflow+0, 0
	MOVWF      R4+2
	CLRF       R4+0
	CLRF       R4+1
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       R4+0, 0
	ADDWF      R0+0, 1
	MOVF       R4+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R4+1, 0
	ADDWF      R0+1, 1
	MOVF       R4+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R4+2, 0
	ADDWF      R0+2, 1
	MOVF       R4+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R4+3, 0
	ADDWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _T1counts+0
	MOVF       R0+1, 0
	MOVWF      _T1counts+1
	MOVF       R0+2, 0
	MOVWF      _T1counts+2
	MOVF       R0+3, 0
	MOVWF      _T1counts+3
;MyProject.c,116 :: 		T1time=T1counts;//in microseconds
	MOVF       R0+0, 0
	MOVWF      _T1time+0
	MOVF       R0+1, 0
	MOVWF      _T1time+1
	MOVF       R0+2, 0
	MOVWF      _T1time+2
	MOVF       R0+3, 0
	MOVWF      _T1time+3
;MyProject.c,117 :: 		Distance=((T1time*34)/(1000))/2; //in cm, shift left twice to divide by 2
	MOVLW      34
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _Distance+0
	MOVF       R0+1, 0
	MOVWF      _Distance+1
	MOVF       R0+2, 0
	MOVWF      _Distance+2
	MOVF       R0+3, 0
	MOVWF      _Distance+3
	RRF        _Distance+3, 1
	RRF        _Distance+2, 1
	RRF        _Distance+1, 1
	RRF        _Distance+0, 1
	BCF        _Distance+3, 7
;MyProject.c,121 :: 		}
L_end_read_sonar:
	RETURN
; end of _read_sonar

_init_sonar:

;MyProject.c,123 :: 		void init_sonar(void){
;MyProject.c,124 :: 		T1overflow=0;
	CLRF       _T1overflow+0
	CLRF       _T1overflow+1
;MyProject.c,125 :: 		T1counts=0;
	CLRF       _T1counts+0
	CLRF       _T1counts+1
	CLRF       _T1counts+2
	CLRF       _T1counts+3
;MyProject.c,126 :: 		T1time=0;
	CLRF       _T1time+0
	CLRF       _T1time+1
	CLRF       _T1time+2
	CLRF       _T1time+3
;MyProject.c,127 :: 		Distance=0;
	CLRF       _Distance+0
	CLRF       _Distance+1
	CLRF       _Distance+2
	CLRF       _Distance+3
;MyProject.c,128 :: 		TMR1H=0;
	CLRF       TMR1H+0
;MyProject.c,129 :: 		TMR1L=0;
	CLRF       TMR1L+0
;MyProject.c,130 :: 		TRISB=0x02; //RB2 for trigger, RB1 for echo
	MOVLW      2
	MOVWF      TRISB+0
;MyProject.c,131 :: 		PORTB=0x00;
	CLRF       PORTB+0
;MyProject.c,132 :: 		INTCON=INTCON|0xC0;//GIE and PIE
	MOVLW      192
	IORWF      INTCON+0, 1
;MyProject.c,133 :: 		PIE1=PIE1|0x01;// Enable TMR1 Overflow interrupt
	BSF        PIE1+0, 0
;MyProject.c,135 :: 		T1CON=0x18;//TMR1 OFF, Fosc/4 (inc 1uS) with 1:2 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
	MOVLW      24
	MOVWF      T1CON+0
;MyProject.c,136 :: 		}
L_end_init_sonar:
	RETURN
; end of _init_sonar

_ADC_init:

;MyProject.c,141 :: 		void ADC_init(unsigned int k){
;MyProject.c,143 :: 		i=k<<3;
	MOVF       FARG_ADC_init_k+0, 0
	MOVWF      R0+0
	MOVF       FARG_ADC_init_k+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
;MyProject.c,144 :: 		ADCON1=0xCE;//Right Justify, Fosc/16, AN0 other PORTA and PORTE are digital
	MOVLW      206
	MOVWF      ADCON1+0
;MyProject.c,145 :: 		ADCON0= 0x41 | i ;// ADC ON, Channel 0, Fosc/16
	MOVLW      65
	IORWF      R0+0, 0
	MOVWF      ADCON0+0
;MyProject.c,146 :: 		TRISA=0x00 | (k+1);
	INCF       FARG_ADC_init_k+0, 0
	MOVWF      TRISA+0
;MyProject.c,148 :: 		}
L_end_ADC_init:
	RETURN
; end of _ADC_init

_ADC_read:

;MyProject.c,149 :: 		unsigned int ADC_read(void){
;MyProject.c,150 :: 		ADCON0 = ADCON0 | 0x04;// GO
	BSF        ADCON0+0, 2
;MyProject.c,151 :: 		while(ADCON0&0x04);
L_ADC_read19:
	BTFSS      ADCON0+0, 2
	GOTO       L_ADC_read20
	GOTO       L_ADC_read19
L_ADC_read20:
;MyProject.c,152 :: 		return (ADRESH<<8)| ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;MyProject.c,155 :: 		}
L_end_ADC_read:
	RETURN
; end of _ADC_read

_usDelay:

;MyProject.c,162 :: 		void usDelay(unsigned int usCnt){
;MyProject.c,163 :: 		unsigned int us=0;
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
;MyProject.c,165 :: 		for(us=0;us<usCnt;us++){
	CLRF       usDelay_us_L0+0
	CLRF       usDelay_us_L0+1
L_usDelay21:
	MOVF       FARG_usDelay_usCnt+1, 0
	SUBWF      usDelay_us_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__usDelay45
	MOVF       FARG_usDelay_usCnt+0, 0
	SUBWF      usDelay_us_L0+0, 0
L__usDelay45:
	BTFSC      STATUS+0, 0
	GOTO       L_usDelay22
;MyProject.c,166 :: 		asm NOP;//0.5 uS
	NOP
;MyProject.c,167 :: 		asm NOP;//0.5uS
	NOP
;MyProject.c,165 :: 		for(us=0;us<usCnt;us++){
	INCF       usDelay_us_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       usDelay_us_L0+1, 1
;MyProject.c,168 :: 		}
	GOTO       L_usDelay21
L_usDelay22:
;MyProject.c,170 :: 		}
L_end_usDelay:
	RETURN
; end of _usDelay

_msDelay:

;MyProject.c,171 :: 		void msDelay(unsigned int msCnt){
;MyProject.c,172 :: 		unsigned int ms=0;
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
;MyProject.c,174 :: 		for(ms=0;ms<(msCnt);ms++){
	CLRF       msDelay_ms_L0+0
	CLRF       msDelay_ms_L0+1
L_msDelay24:
	MOVF       FARG_msDelay_msCnt+1, 0
	SUBWF      msDelay_ms_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay47
	MOVF       FARG_msDelay_msCnt+0, 0
	SUBWF      msDelay_ms_L0+0, 0
L__msDelay47:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay25
;MyProject.c,175 :: 		for(cc=0;cc<155;cc++);//1ms
	CLRF       msDelay_cc_L0+0
	CLRF       msDelay_cc_L0+1
L_msDelay27:
	MOVLW      0
	SUBWF      msDelay_cc_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__msDelay48
	MOVLW      155
	SUBWF      msDelay_cc_L0+0, 0
L__msDelay48:
	BTFSC      STATUS+0, 0
	GOTO       L_msDelay28
	INCF       msDelay_cc_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_cc_L0+1, 1
	GOTO       L_msDelay27
L_msDelay28:
;MyProject.c,174 :: 		for(ms=0;ms<(msCnt);ms++){
	INCF       msDelay_ms_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       msDelay_ms_L0+1, 1
;MyProject.c,176 :: 		}
	GOTO       L_msDelay24
L_msDelay25:
;MyProject.c,178 :: 		}
L_end_msDelay:
	RETURN
; end of _msDelay

_buzzerOn:

;MyProject.c,180 :: 		void buzzerOn(unsigned int i){
;MyProject.c,182 :: 		while(i>0){
L_buzzerOn30:
	MOVF       FARG_buzzerOn_i+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__buzzerOn50
	MOVF       FARG_buzzerOn_i+0, 0
	SUBLW      0
L__buzzerOn50:
	BTFSC      STATUS+0, 0
	GOTO       L_buzzerOn31
;MyProject.c,183 :: 		PORTC = PORTC | 0x80;
	BSF        PORTC+0, 7
;MyProject.c,184 :: 		msDelay(1000);
	MOVLW      232
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      3
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;MyProject.c,185 :: 		PORTC =0x00;
	CLRF       PORTC+0
;MyProject.c,186 :: 		msDelay(1000);
	MOVLW      232
	MOVWF      FARG_msDelay_msCnt+0
	MOVLW      3
	MOVWF      FARG_msDelay_msCnt+1
	CALL       _msDelay+0
;MyProject.c,187 :: 		i--;
	MOVLW      1
	SUBWF      FARG_buzzerOn_i+0, 1
	BTFSS      STATUS+0, 0
	DECF       FARG_buzzerOn_i+1, 1
;MyProject.c,188 :: 		}
	GOTO       L_buzzerOn30
L_buzzerOn31:
;MyProject.c,189 :: 		}
L_end_buzzerOn:
	RETURN
; end of _buzzerOn
