void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int val;
  val = analogRead(0);
  Serial.print(val);
  delay(100);
  Serial.print('\n'); 
}
