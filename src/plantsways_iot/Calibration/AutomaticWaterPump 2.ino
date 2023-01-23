/*
 * Senior Design Project 
 * by: Samuel Ruiz
 * 9/27/2022
 * 
 * Equipment needed:
 * 3-5V Low voltage water pump
 * Capacitive Moisture Sensor
 * IRLB8721 MOSFET
 * 1N4007 Diode
 * H20
 * pushbutton
 * 10kohm resistor
 */

 /*/
  * Assumed moisture level for no dirt
  * High Moisture = 590 analog read
  * Low Moisture = 320 analog read
  */
 //Constants
const int motor = 13;
int moistureLevel;
void setup() {
  pinMode(motor,OUTPUT);
  Serial.begin(9600);
}

void loop() {
  moistureLevel = analogRead(0);
  Serial.print(moistureLevel);
  Serial.print('\n'); 
  
  if(moistureLevel > 500){
    digitalWrite(motor, HIGH);
    char motorStatus[] = "Motor ON";
    Serial.print(motorStatus); 
  }
  else{
    digitalWrite(motor,LOW);
  }
  delay(1000);
}
