
//====================================================================================
//                                    SmartPlanter
//====================================================================================
//SmartPlanter Project for UTA CSE 4317
//SmartPlanter was created by team PlantWays as a smart solution to taking care of 
//house plants. The SmartPlanter is able to automatically water the plant as well as
//monitor it's environment. The SmartPlanter is also an IoT device that allows for users
//to set up the calibration settings through a smartphone. From the application, users can
//select plants from the database to customize the amount of water the plant receives. 
//====================================================================================
//                                    Equipment
//====================================================================================
//Low Voltage Water Pump
//Capactive Soil Moisture Sensor
//5v Relay
//1N4007 Diode
//DHT11 Temperature and Moisture Sensor
//Photoresistor GL5516 LDR
//5k Ohm Resistor
//ESP32-Wroom-32
//Optical infrared Water Liquid Sensor
//1.28inch Round LCD IPS Module
//====================================================================================
//                           Libraries
//====================================================================================
#include "DHT.h" //DHT Library
#include <PNGdec.h> //PND Decoder
#include "gort.h" // Image is stored here in an 8 bit array
#include "logo.h"
#include "devscreen.h"
#include "temperature.h"
#include "humidity.h"
#include "light_exposure.h"
#include "soil_moisture.h"
#include "SPI.h" // SPI Library for LCD
#include <TFT_eSPI.h>              // Hardware-specific library
#include "NotoSansBold36.h"  //Text Style for LCD Screen
//====================================================================================
//                           ESP32 Pins
//====================================================================================
const int waterPumpPin = 26;
const int waterLevelPin = 35;
const int sunlightPin = 25;
const int soilMoisturePin = 32;
const int tempHumidityPin = 33;
const int bluetoothButtonPin = 13;
//ESP32 Pins enabled in User_Setup.h of the TFT Library
//#define TFT_MOSI 23 // In some display driver board, it might be written as "SDA" and so on.
//#define TFT_SCLK 18
//#define TFT_CS   5  // Chip select control pin
//#define TFT_DC   16  // Data Command control pin
//#define TFT_RST  4  // Reset pin (could connect to Arduino RESET pin)
//====================================================================================
//                           Sensor Globals
//====================================================================================
#define Type DHT11
DHT HT(tempHumidityPin,Type);
int setTime=500;
int dt=2000;

int waterLevel;
int lightLevel;
int moistureLevel;
float humidityLevel;
float temperatureLevel;

uint16_t  spr_width = 0;
uint16_t  bg_color =0;
//====================================================================================
//                           Bluetooth Globals
//====================================================================================
int bluetoothPairing;
//====================================================================================
//                           LCD Screen Globals
//====================================================================================
//#define GC9A01_DRIVER enabled in User_Setup.h of the TFT Library
PNG png; // PNG decoder inatance
#define MAX_IMAGE_WDITH 240 // Adjust for your images
int16_t xpos = 0;
int16_t ypos = 0;
// Include the TFT library https://github.com/Bodmer/TFT_eSPI
TFT_eSPI tft = TFT_eSPI();         // Invoke custom library
TFT_eSprite spr    = TFT_eSprite(&tft); // Sprite for meter reading
// Font attached to this sketch
#define AA_FONT_LARGE NotoSansBold36
//====================================================================================
//                          PNG Draw
//====================================================================================
// This next function will be called during decoding of the png file to
// render each image line to the TFT.  If you use a different TFT library
// you will need to adapt this function to suit.
// Callback function to draw pixels to the display
//====================================================================================
void pngDraw(PNGDRAW *pDraw) {
  uint16_t lineBuffer[MAX_IMAGE_WDITH];
  png.getLineAsRGB565(pDraw, lineBuffer, PNG_RGB565_BIG_ENDIAN, 0xffffffff);
  tft.pushImage(xpos, ypos + pDraw->y, pDraw->iWidth, 1, lineBuffer);
}
//====================================================================================
//                           Automatic Water Pump Function
//====================================================================================
//Waters the planter when soil moisture is low
//Shuts off water pump if water level is too low to avoid damage to the motor
//Moisture values will need to be extracted from database for indivudual plants
//====================================================================================
void runWaterPump()
{
  moistureLevel = analogRead(soilMoisturePin);
  Serial.print("Moisture Level: ");
  Serial.print(moistureLevel);
  Serial.print('\n'); 
  delay(500);
  waterLevel = analogRead(waterLevelPin);
  Serial.print("Water Level: ");
  Serial.print(waterLevel);
  Serial.print("\n");
  delay(2000);
  while(moistureLevel >= 3000){
   
    if(waterLevel <= 1000){
      digitalWrite(waterPumpPin, HIGH);
      Serial.print("Motor ON\n ");
      tft.fillScreen(TFT_RED);
      tft.setTextColor(TFT_WHITE, 0);
      tft.setTextDatum(MC_DATUM);
      tft.drawString("(Watering)", 120, 120 + 48, 2);
      delay(1000);
      digitalWrite(waterPumpPin, LOW);
      Serial.print("Motor OFF\n ");

    }
    else{
      Serial.print("LOW WATER");
      tft.fillScreen(TFT_RED);
      tft.setTextColor(TFT_WHITE, 0);
      tft.setTextDatum(MC_DATUM);
      tft.drawString("(LOW WATER)", 120, 120 + 48, 2);
    }
    moistureLevel = analogRead(soilMoisturePin);
    Serial.print("Moisture: ");
    Serial.print(moistureLevel);
    Serial.print('\n'); 
    delay(1000);
    waterLevel = analogRead(waterLevelPin);
    Serial.print("Water Level: ");
    Serial.print(waterLevel);
    Serial.print("\n");
    
  }
}
//====================================================================================
//                           Temperature Function
//====================================================================================
//Measures the temperature reading from the DHT11 Sensor
//====================================================================================
void getTemperature(){

  temperatureLevel = (HT.readTemperature(true));
  Serial.print("Temperature ");
  Serial.print(temperatureLevel);
  Serial.println(" F ");
  
  delay(1000);

}
//====================================================================================
//                          Humidity Function
//====================================================================================
//Measures the temperature reading from the DHT11 Sensor
//====================================================================================
void getHumidity(){
  humidityLevel = HT.readHumidity();
  Serial.print("Humidity: ");
  Serial.print(humidityLevel);
  Serial.print('\n'); 
  delay(dt);
  delay(1000);
}
//====================================================================================
//                          Sunlight Function
//====================================================================================
//Measures the light level from the photoresistor
//====================================================================================
void getLightLevel()
{
  //This code checks the light sensor value and prints out the amount of sunlight
  //Hardcoded values were recorded by measuring the analog read at different lighting
  
  //Needs more obtimization since esp32 reads in different values than the arduino
    lightLevel = analogRead(sunlightPin);
    if (lightLevel > 400){
      Serial.print("Full Sunlight");
    }
    else if (lightLevel <= 400 && lightLevel >= 100){
      Serial.print("Partial Sunlight"); 
    }
    else if (lightLevel < 100){
      Serial.print("No Sunlight");
    }
  Serial.print("Light: ");
  Serial.println(lightLevel);

}
//====================================================================================
//                          LCD DevScreen
//====================================================================================
//Dev screen is used to get an LCD screen of all the raw measurement data
//This will be used to easily calibrate the prototype with real soil and sunlight
//====================================================================================
void devScreen(){
  int16_t rc = png.openFLASH((uint8_t *)devscreen, sizeof(devscreen), pngDraw);
  if (rc == PNG_SUCCESS) {
    tft.startWrite();
    uint32_t dt = millis();
    rc = png.decode(NULL, 0);
    tft.endWrite();  
    // png.close(); // not needed for memory->memory decode
     // Plot the label text
    tft.setTextColor(TFT_WHITE);
    tft.setTextDatum(MC_DATUM);
    tft.drawString(String(temperatureLevel), 170, 76, 4);
    tft.drawString(String(humidityLevel), 170, 98, 4);
    tft.drawString(String(lightLevel), 170, 122, 4);
    tft.drawString(String(waterLevel), 170, 146, 4);
    tft.drawString(String(moistureLevel), 170, 170, 4);
    }

    delay(1000);
}
//====================================================================================
//                          LCD Home 
//====================================================================================
//Function is used to display homescreen for the LCD Display
//====================================================================================
void displayHome(){
  //Home Screen
      tft.fillScreen(TFT_BLACK);
      tft.setTextColor(TFT_WHITE, 0);
      tft.setTextDatum(MC_DATUM);
      tft.drawString("(Home Screen)", 120, 120 + 48, 2);
  delay(5000);
}
//====================================================================================
//                          LCD Temperature
//====================================================================================
//Function is used to display temperature for the LCD Display
//====================================================================================
void displayTemperature(){
       // Plot the label text
    int16_t rc = png.openFLASH((uint8_t *)temperature, sizeof(temperature), pngDraw);
    if (rc == PNG_SUCCESS) {
    tft.startWrite();
    uint32_t dt = millis();
    rc = png.decode(NULL, 0);
    tft.endWrite();  
    }
    // Update the number at the centre of the dial
    tft.setTextColor(TFT_WHITE);
    tft.setTextDatum(MC_DATUM);
    tft.drawString(String((int)temperatureLevel), 100, 120, 8);
    delay(2000);
}
//====================================================================================
//                          LCD Humidity
//====================================================================================
//Function is used to display humidity for the LCD Display
//====================================================================================
void displayHumidity(){
       // Plot the label text
    int16_t rc = png.openFLASH((uint8_t *)humidity, sizeof(humidity), pngDraw);
  if (rc == PNG_SUCCESS) {
    tft.startWrite();
    uint32_t dt = millis();
    rc = png.decode(NULL, 0);
    tft.endWrite();  
  }
    // Update the number at the centre of the dial
    tft.setTextColor(TFT_WHITE);
    tft.setTextDatum(MC_DATUM);
    tft.drawString(String((int)humidityLevel), 100, 120, 8);
    delay(2000);
}
//====================================================================================
//                          LCD Sunlight
//====================================================================================
//Function is used to display Sunlight for the LCD Display
//====================================================================================
void displaySunlight(){
       // Plot the label text
    int16_t rc = png.openFLASH((uint8_t *)light_exposure, sizeof(light_exposure), pngDraw);
  if (rc == PNG_SUCCESS) {
    tft.startWrite();
    uint32_t dt = millis();
    rc = png.decode(NULL, 0);
    tft.endWrite();  
  }
    // Update the number at the centre of the dial
    tft.setTextColor(TFT_WHITE);
    tft.setTextDatum(MC_DATUM);
    tft.drawString(String(lightLevel), 100, 120, 8);
    delay(2000);
}
//====================================================================================
//                          LCD Moisture
//====================================================================================
//Function is used to display Moisture for the LCD Display
//====================================================================================
void displayMoisture(){
       // Plot the label text
    int16_t rc = png.openFLASH((uint8_t *)soil_moisture, sizeof(soil_moisture), pngDraw);
  if (rc == PNG_SUCCESS) {
    tft.startWrite();
    uint32_t dt = millis();
    rc = png.decode(NULL, 0);
    tft.endWrite();  
  }
    // Update the number at the centre of the dial
    tft.setTextColor(TFT_WHITE);
    tft.setTextDatum(MC_DATUM);
    tft.drawString(String(moistureLevel), 100, 120, 8);
    delay(2000);
}

//====================================================================================
//                                    Setup
//====================================================================================
void setup() {
  Serial.begin(115200);
  Serial.println("\n\n Using the PNGdec library");
  // Initialise the TFT
  tft.begin();
  int16_t rc = png.openFLASH((uint8_t *)logo, sizeof(logo), pngDraw);
  if (rc == PNG_SUCCESS) {
    tft.startWrite();
    uint32_t dt = millis();
    rc = png.decode(NULL, 0);
    tft.endWrite();  
    // png.close(); // not needed for memory->memory decode
     // Plot the label text
    tft.setTextColor(TFT_WHITE, TFT_BLACK, true);
    tft.setTextDatum(MC_DATUM);
    for(int i = 0; i < 101; i++){
      tft.drawString("Booting.."+String(i) + "%", 120, 120 + 48, 4);
      delay(50);
    }
    }

    // Load the font and create the Sprite for reporting the value
    spr.loadFont(AA_FONT_LARGE);
    spr_width = spr.textWidth("777"); // 7 is widest numeral in this font
    spr.createSprite(spr_width, spr.fontHeight());
    bg_color = tft.readPixel(120, 120); // Get colour from dial centre
    spr.fillSprite(bg_color);
    spr.setTextColor(TFT_WHITE, bg_color, true);
    spr.setTextDatum(MC_DATUM);
    spr.setTextPadding(spr_width);
    
  //Water Pump
  pinMode(waterPumpPin,OUTPUT);
  digitalWrite(waterPumpPin,LOW);
  //H&F sensor
  HT.begin();
  delay(1000);

  //Bluetooth
  pinMode(bluetoothButtonPin, INPUT);

}

void loop() {
  getTemperature();
  displayTemperature();
 
  getHumidity();
  displayHumidity();
  
  getLightLevel();
  displaySunlight();
  
  runWaterPump();
  displayMoisture();
  
  devScreen();
  delay(1000);

bluetoothPairing = digitalRead(bluetoothButtonPin);

  if(bluetoothPairing == HIGH){
    Serial.print("Button pushed\n ");
  }
  else{
    Serial.print("Button Off\n ");
  }
}
