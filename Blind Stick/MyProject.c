unsigned int T1overflow;
unsigned long T1counts;
unsigned long T1time;
unsigned long Distance;
unsigned int tick, reading,reading1,temp;
unsigned char myVoltage;
void usDelay(unsigned int);
void msDelay(unsigned int);

void ADC_init(unsigned int );
unsigned int ADC_read(void);
void init_sonar(void);
void read_sonar(void);
void buzzerOn(unsigned int);
void interrupt(void){
if(INTCON&0x04){// will get here every 1ms
TMR0=248;
 tick++;

  if(tick==350){
  ADC_init(0);

   reading = ADC_read();
   temp =(reading*100*5)/(3*1023);
   if(temp>20)
    buzzerOn(2);
   else
   PORTC=PORTC | 0x00;}
   if (tick==700){
   read_sonar();

if(Distance<50)
{
PORTB=PORTB | 0x40;
  buzzerOn(1);
  }
else  {

  PORTB=PORTB | 0x00;
}}
if(tick==1050){//after 500ms
    tick=0;


 ADC_init(1);
   reading1 = ADC_read();
   myVoltage= (reading1*5)/1023;
   if(myVoltage>0)
   buzzerOn(3);
   else
   PORTC=PORTC | 0x00;

  }
  INTCON = INTCON & 0xFB; //clear T0IF
  }
if(PIR1&0x04){//CCP1 interrupt

PIR1=PIR1&0xFB;
}
if(PIR1&0x01){//TMR1 ovwerflow

T1overflow++;
PIR1=PIR1&0xFE;
}
if(INTCON&0x02){//External Interrupt
INTCON=INTCON&0xFD;
}
}




void main() {
TRISD =0x00;//PORTD for testing
PORTD=0x00;
TRISC = 0x00;//PORTC Output
PORTC=0x00;// Last LED ON
ADCON1=0x06;//PORTA is Digital
TRISA=0x00;


TMR0=248;
tick=0;


CCP1CON=0x00;// Disable CCP. Capture on rising for the first time. Capture on Rising: 0x05, Capture on Falling: 0x04


OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
INTCON=0xF0;//enable TMR0 overflow, TMR1 overflow, External interrupts and peripheral interrupts;

init_sonar();
//ADC_init();

while(1){
}

}


 void read_sonar(void){

T1overflow=0;
TMR1H=0;
TMR1L=0;

PORTB=0x04;//Trigger the ultrasonic sensor (RB2 connected to trigger)
usDelay(10);//keep trigger for 10uS
PORTB=0x00;//Remove trigger
while(!(PORTB&0x02));
T1CON=0x19;//TMR1 ON, Fosc/4 (inc 1uS) with 1:2 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
while(PORTB&0x02);
T1CON=0x18;//TMR1 OFF, Fosc/4 (inc 1uS) with 1:1 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
T1counts=((TMR1H<<8)|TMR1L)+(T1overflow*65536);
//if(TMR1L>100) PORTC=0xFF;
T1time=T1counts;//in microseconds
Distance=((T1time*34)/(1000))/2; //in cm, shift left twice to divide by 2
//range=high level time(usec)*velocity(340m/sec)/2 >> range=(time*0.034cm/usec)/2
//time is in usec and distance is in cm so 340m/sec >> 0.034cm/usec
//divide by 2 since the travelled distance is twice that of the range from the object leaving the sensor then returning when hitting an object)
}

void init_sonar(void){
T1overflow=0;
T1counts=0;
T1time=0;
Distance=0;
TMR1H=0;
TMR1L=0;
TRISB=0x02; //RB2 for trigger, RB1 for echo
PORTB=0x00;
INTCON=INTCON|0xC0;//GIE and PIE
PIE1=PIE1|0x01;// Enable TMR1 Overflow interrupt

T1CON=0x18;//TMR1 OFF, Fosc/4 (inc 1uS) with 1:2 prescaler (TMR1 overflow after 0xFFFF counts ==65536)==> 65.536ms
}




void ADC_init(unsigned int k){
  unsigned int i;
  i=k<<3;
  ADCON1=0xCE;//Right Justify, Fosc/16, AN0 other PORTA and PORTE are digital
  ADCON0= 0x41 | i ;// ADC ON, Channel 0, Fosc/16
  TRISA=0x00 | (k+1);

}
unsigned int ADC_read(void){
  ADCON0 = ADCON0 | 0x04;// GO
  while(ADCON0&0x04);
  return (ADRESH<<8)| ADRESL;


}






void usDelay(unsigned int usCnt){
unsigned int us=0;

for(us=0;us<usCnt;us++){
asm NOP;//0.5 uS
asm NOP;//0.5uS
}

}
void msDelay(unsigned int msCnt){
unsigned int ms=0;
unsigned int cc=0;
for(ms=0;ms<(msCnt);ms++){
for(cc=0;cc<155;cc++);//1ms
}

}

void buzzerOn(unsigned int i){

while(i>0){
 PORTC = PORTC | 0x80;
 msDelay(1000);
  PORTC =0x00;
 msDelay(1000);
 i--;
 }
}