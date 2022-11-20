/*
 * Senior Design Project 
 * by: Samuel Ruiz
 * 9/27/2022
 * 
 * Equipment needed:
 * 3-5V Low voltage water pump
 * IRLB8721 MOSFET
 * 1N4007 Diode
 * H20
 * pushbutton
 * 10kohm resistor
 */

 //Constants
const int pushButton = 2;
const int motor = 9;

int pushState = 0;

void setup() {
  // put your setup code here, to run once:

  pinMode(pushState, INPUT);
  pinMode(motor,OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:

  pushState = digitalRead(pushButton);

  if(pushState == HIGH){
    digitalWrite(motor, HIGH);
  }
  else{
    digitalWrite(motor,LOW);
  }
}
