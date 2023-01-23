/*
 * Senior Design Project 
 * by: Samuel Ruiz
 * 11/07/2022
 * 
 * Equipment needed:
 * 3-5V Low voltage water pump
 * Capacitive Moisture Sensor
 * IRLB8721 MOSFET
 * 1N4007 Diode
 * H20
 * pushbutton
 * 10kohm resistor
 * Temperature and humidity sensor
 * Photoresister
 * 5k ohm resistor
 */

 /*/
  * Assumed moisture level for no dirt
  * High Moisture = 590 analog read
  * Low Moisture = 320 analog read
  */

 #include "DHT.h"
#define Type DHT11
 //Constants

 //MWater Pump
const int motor = 10;
//Moisture Sensor
int moistureLevel;
//Humidity and Temperature Sensor
int tempPin=11;
DHT HT(tempPin,Type);
float humidity;
float tempC;
float tempF;
int setTime=500;
int dt=1000;
//Light Sensor
int lightPin = 5;   
//Moisture Sensor
int moisturePin = 0;

void LightSensor(int pin, int speed)
{
  int lightVal = analogRead(lightPin);
  char light[10] = "";
    if (lightVal > 400){
      Serial.print("Full Sunlight");
    }
    else if (lightVal <= 400 && lightVal >= 100){
      Serial.print("Partial Sunlight"); 
    }
    else if (lightVal < 100){
      Serial.print("No Sunlight");
    }
  Serial.print("Light: ");
  Serial.println(lightVal);
  delay(speed);
}

void setup() {
  Serial.begin(115200);
  //Water Pump
  pinMode(motor,OUTPUT);
  //H&F sensor
  HT.begin();
  delay(setTime);
}

void loop() {
  digitalWrite(motor,LOW);
  moistureLevel = analogRead(moisturePin);
  Serial.print("Moisture: ");
  Serial.print(moistureLevel);
  Serial.print('\n'); 
  
  while(moistureLevel > 500){
    digitalWrite(motor, HIGH);
    Serial.print("Motor ON ");
    delay(50000);
    moistureLevel = analogRead(moisturePin);
    Serial.print("Moisture: ");
    Serial.print(moistureLevel);
    Serial.print('\n'); 
  }
  humidity=HT.readHumidity();
  delay(1000);
  tempC=HT.readTemperature();
  delay(1000);
  tempF=HT.readTemperature(true);
   
  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.print("% Temperature ");
  Serial.print(tempC);
  Serial.print(" C ");
  Serial.print(tempF);
  Serial.println(" F ");
  delay(dt);
  LightSensor(lightPin, 100);


}
