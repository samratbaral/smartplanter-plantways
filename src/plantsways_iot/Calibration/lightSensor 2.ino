void LightSensor(int pin, int speed)
{
  int light = analogRead(pin);
  Serial.println(light);
  delay(speed);
}
void setup() 
{
  Serial.begin(9600);
}
void loop() 
{
  LightSensor(A5, 100);
}
//Photoresistor Sensor value
//500 and more there light in the room 
//500 and less can be a dark room 
//60 and less can be almost a complete dark room
//10 and less dark room
