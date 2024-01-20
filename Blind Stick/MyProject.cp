#line 1 "C:/Users/aldwe/OneDrive/Documents/Maria/PSUT/Senior year/Courses/Embedded/Blind Stick/MyProject.c"
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
if(INTCON&0x04){
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
else {

 PORTB=PORTB | 0x00;
}}
if(tick==1050){
 tick=0;


 ADC_init(1);
 reading1 = ADC_read();
 myVoltage= (reading1*5)/1023;
 if(myVoltage>0)
 buzzerOn(3);
 else
 PORTC=PORTC | 0x00;

 }
 INTCON = INTCON & 0xFB;
 }
if(PIR1&0x04){

PIR1=PIR1&0xFB;
}
if(PIR1&0x01){

T1overflow++;
PIR1=PIR1&0xFE;
}
if(INTCON&0x02){
INTCON=INTCON&0xFD;
}
}




void main() {
TRISD =0x00;
PORTD=0x00;
TRISC = 0x00;
PORTC=0x00;
ADCON1=0x06;
TRISA=0x00;


TMR0=248;
tick=0;


CCP1CON=0x00;


OPTION_REG = 0x87;
INTCON=0xF0;

init_sonar();


while(1){
}

}


 void read_sonar(void){

T1overflow=0;
TMR1H=0;
TMR1L=0;

PORTB=0x04;
usDelay(10);
PORTB=0x00;
while(!(PORTB&0x02));
T1CON=0x19;
while(PORTB&0x02);
T1CON=0x18;
T1counts=((TMR1H<<8)|TMR1L)+(T1overflow*65536);

T1time=T1counts;
Distance=((T1time*34)/(1000))/2;



}

void init_sonar(void){
T1overflow=0;
T1counts=0;
T1time=0;
Distance=0;
TMR1H=0;
TMR1L=0;
TRISB=0x02;
PORTB=0x00;
INTCON=INTCON|0xC0;
PIE1=PIE1|0x01;

T1CON=0x18;
}




void ADC_init(unsigned int k){
 unsigned int i;
 i=k<<3;
 ADCON1=0xCE;
 ADCON0= 0x41 | i ;
 TRISA=0x00 | (k+1);

}
unsigned int ADC_read(void){
 ADCON0 = ADCON0 | 0x04;
 while(ADCON0&0x04);
 return (ADRESH<<8)| ADRESL;


}






void usDelay(unsigned int usCnt){
unsigned int us=0;

for(us=0;us<usCnt;us++){
asm NOP;
asm NOP;
}

}
void msDelay(unsigned int msCnt){
unsigned int ms=0;
unsigned int cc=0;
for(ms=0;ms<(msCnt);ms++){
for(cc=0;cc<155;cc++);
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
