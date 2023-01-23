#include "DHT.h"
#define Type DHT11
int sensePin=7;
DHT HT(sensePin,Type);
float humidity;
float tempC;
float tempF;
int setTime=500;
int dt=1000;
 
void setup() {
  // put your setup code here, to run once:
Serial.begin(9600);
HT.begin();
delay(setTime);
}
 
void loop() {
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
 
 
}
