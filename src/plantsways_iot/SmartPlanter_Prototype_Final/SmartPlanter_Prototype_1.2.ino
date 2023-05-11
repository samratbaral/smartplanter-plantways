  
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
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <EEPROM.h>
#include "DHT.h" //DHT Library
#include <PNGdec.h> //PND Decoder
#include "gort.h" // Image is stored here in an 8 bit array
#include "logo.h"
#include "home.h"
#include "devscreen.h"
#include "temperature.h"
#include "humidity.h"
#include "light_exposure.h"
#include "soil_moisture.h"
#include "device_setup.h"
#include "SPI.h" // SPI Library for LCD
#include <TFT_eSPI.h>              // Hardware-specific library
#include "NotoSansBold36.h"  //Text Style for LCD Screen
#include <Preferences.h>
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
#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

bool bleConnected = false;
bool wifiConnected = false;
bool deviceReady = false;
String nodata = "No data received";
BLECharacteristic *writeCharacteristic;
char* ssid; 
const char* password;
char* receivedData;
BLEServer *pServer;
BLEService *pService;
String mac_address;
String ssid_string;
String password_string;
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
//                           PREFERENCES
//====================================================================================
Preferences preferences;
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
  delay(1000);
  waterLevel = analogRead(waterLevelPin);
  Serial.print("Water Level: ");
  Serial.print(waterLevel);
  Serial.print("\n");
  delay(2000);
 if(moistureLevel >= 3000){
  
   if(waterLevel <= 1000){
     digitalWrite(waterPumpPin, HIGH);
     Serial.print("Motor ON\n ");
     tft.fillScreen(TFT_RED);
     tft.setTextColor(TFT_WHITE, 0);
     tft.setTextDatum(MC_DATUM);
     tft.drawString("(Watering)", 120, 120 + 48, 2);
     delay(1500);
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
   delay(1000);
   waterLevel = analogRead(waterLevelPin);
   delay(1000);
   
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
  int light = analogRead(25);
  Serial.println(light);
  delay(100);
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
void displayHomePage() {
  //Get time
  struct tm timeinfo;
  char time_buf[64];
  char date_buf[64];
  getLocalTime(&timeinfo);
  strftime(time_buf, sizeof(time_buf), "%I:%M%p", &timeinfo);
  strftime(date_buf, sizeof(date_buf), "%B %d, %Y", &timeinfo);

  int16_t rc = png.openFLASH((uint8_t *)home, sizeof(home), pngDraw);
  if (rc == PNG_SUCCESS) {
    tft.startWrite();
    uint32_t dt = millis();
    rc = png.decode(NULL, 0);
    tft.endWrite();

    //Time Sprite
    TFT_eSprite timeSpr = TFT_eSprite(&tft);  // Sprite for meter reading
    timeSpr.setColorDepth(8);
    timeSpr.loadFont(AA_FONT_LARGE);
    spr_width = timeSpr.textWidth("777");
    timeSpr.createSprite(spr_width * 8, timeSpr.fontHeight() * 8);
    timeSpr.fillSprite(TFT_BLACK);
    timeSpr.setTextDatum(MC_DATUM);
    timeSpr.setTextColor(TFT_WHITE, TFT_BLACK);
    timeSpr.setCursor(0, 0);
    timeSpr.setTextPadding(spr_width);
    timeSpr.setTextSize(4);
    //Date sprite
    TFT_eSprite dateSpr = TFT_eSprite(&tft);  // Sprite for meter reading
    dateSpr.setColorDepth(8);
    dateSpr.loadFont(AA_FONT_LARGE);
    spr_width = dateSpr.textWidth("777");
    dateSpr.createSprite(spr_width * 2, dateSpr.fontHeight() * 2);
    dateSpr.fillSprite(TFT_BLACK);
    dateSpr.setTextDatum(MC_DATUM);
    dateSpr.setTextColor(TFT_WHITE, TFT_BLACK);
    dateSpr.setCursor(0, 0);
    dateSpr.setTextPadding(spr_width);
    dateSpr.setTextSize(2);


    tft.drawString(time_buf, 120, 100, 4);  //(string, x, y , ?)
    tft.drawString(date_buf, 120, 120 + 10, 4);
  }
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
    tft.drawString("(OK)", 120, 120 + 48, 2);
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
    if(moistureLevel >= 2500){
      tft.drawString("(DRY)", 120, 120 + 48, 2);
    }
    else {
      tft.drawString("(OK)", 120, 120 + 48, 2);
    }
    delay(2000);
}
//====================================================================================
//                          Device Setup
//====================================================================================
//Function is used to display the device set up page
//====================================================================================
void displayDeviceSetup(){
    int16_t rc = png.openFLASH((uint8_t *)device_setup, sizeof(device_setup), pngDraw);
    if (rc == PNG_SUCCESS) {
    tft.startWrite();
    uint32_t dt = millis();
    rc = png.decode(NULL, 0);
    tft.endWrite();  
    }
}
void displayBlePairing(){
      tft.fillScreen(TFT_BLACK);
      tft.setTextColor(TFT_WHITE, 0);
      tft.setTextDatum(MC_DATUM);
      tft.drawString("(BLE PAIRING ON)", 120, 120 + 48, 2);
}
void displayWifiPairing(){
      tft.fillScreen(TFT_BLACK);
      tft.setTextColor(TFT_WHITE, 0);
      tft.setTextDatum(MC_DATUM);
      tft.drawString("(CONNECTING WIFI)", 120, 120 + 48, 2);
}
//====================================================================================
//                          MongoDB
//====================================================================================
//Function is used to post sensor data into database
//====================================================================================
void postData(){
  StaticJsonDocument<1024> docUpdate;
  docUpdate["dataSource"] = "PlantWays";
  docUpdate["database"] = "todo";
  docUpdate["collection"] = "PlantUserData";
  JsonObject filter = docUpdate.createNestedObject("filter");
  filter["potMac"] = mac_address;
  JsonObject updateInfo = docUpdate.createNestedObject("update");
  JsonObject setInfo = updateInfo.createNestedObject("$set");
  JsonArray potSensorData = setInfo.createNestedArray("potSensorData");
  potSensorData.add("High Humidity");
  potSensorData.add("High Light");
  potSensorData.add("Moist Soil");
  potSensorData.add("High Level");
  potSensorData.add("High Temperature");

  String json, jsonUpdate;
  serializeJson(docUpdate, jsonUpdate);

  if(WiFi.status() == WL_CONNECTED){

    HTTPClient http;
    int httpResponseCode;
    http.begin(" ");
    http.addHeader("Content-Type", "application/json");
    http.addHeader("apiKey", " ");
    httpResponseCode = http.POST(jsonUpdate);
    Serial.print("Updating document (status code): ");
    Serial.println(httpResponseCode);
    http.end();
  }
}
//====================================================================================
//                          WIFI
//====================================================================================
//Function is used to connect ESP32 to internet through wifi
//====================================================================================
void connectToWifi(){
 char ssid_char[32], password_char[32];
  
  strcpy(ssid_char, ssid);
  strcpy(password_char, password);
 WiFi.begin(ssid_char, password_char);
 uint8_t count = 0;
 while(WiFi.status() != WL_CONNECTED){
   delay(1000);
   //Serial.println("Connecting to WiFi...attempt: " + count);
   Serial.println("Connecting to WiFi...attempt: ");
   Serial.println(ssid_char);
   Serial.println(password_char);
  //  count++;
  //  if(count == 10){
  //    break;
  //  }
  }
  // if(WiFi.status() == WL_CONNECTED){
    Serial.println("Connected to WiFi");
    wifiConnected = true;
    ssid_string = String(ssid);
    password_string = String(password);
    preferences.putString("ssid",ssid_string);
    preferences.putString("password",password_string);
  // }
configTime(-21600, 3600, "pool.ntp.org");  //Central Timezone
}
//====================================================================================
//                          BLUETOOTH
//====================================================================================
//Functions are used to open bluetooth connection and wait until there is a call back
//====================================================================================
class MyServerCallbacks : public BLEServerCallbacks{
 void onConnect(BLEServer* pServer){
 };
};

class onWriteCallback : public BLECharacteristicCallbacks{
 void onWrite(BLECharacteristic *pCharacteristic){
   receivedData = const_cast<char*>(pCharacteristic -> getValue().c_str());
  //  char* ssidChar = strtok(receivedData, ",");
  //  const char* passwordChar = strtok(NULL, ",");
  //  ssid = ssidChar;
  //  password = passwordChar;
  ssid = strtok(receivedData, ",");
  password = strtok(NULL, ",");
   Serial.println(ssid);
   Serial.println(password);
   //if((ssidChar == NULL)||(passwordChar == NULL)){
    if((ssid == NULL)||(password == NULL)){
     Serial.println("Issues with wifi credentials passed from app");
   }
   else{
    bleConnected = true;
   connectToWifi();
   }
 }; 
};
void startBluetoothPairing(){
  displayBlePairing();
  BLEDevice::init("SmartPlanter");
  BLEAddress bleAddress = BLEDevice::getAddress();
  mac_address = String(bleAddress.toString().c_str());
  Serial.println(mac_address);
  pServer = BLEDevice::createServer();
  pServer -> setCallbacks(new MyServerCallbacks());
  pService = pServer->createService(SERVICE_UUID);
 writeCharacteristic = pService->createCharacteristic(
                                        CHARACTERISTIC_UUID,
                                        BLECharacteristic::PROPERTY_READ |
                                        BLECharacteristic::PROPERTY_WRITE
                                      );
 writeCharacteristic->setValue("WRITE_HERE");
 writeCharacteristic->setCallbacks(new onWriteCallback());
 pService->start();
 // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
 BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
 pAdvertising->addServiceUUID(SERVICE_UUID);
 pAdvertising->setScanResponse(true);
 pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
 pAdvertising->setMinPreferred(0x12);
 BLEDevice::startAdvertising();
}

void setUpDevice(){
      displayDeviceSetup();
    while(!bleConnected){
      bluetoothPairing = digitalRead(bluetoothButtonPin);
      // if(bluetoothPairing == HIGH){
         startBluetoothPairing();      
        delay(100000000);         
      // }
    }
    //  pServer -> removeService(pService);
}

//====================================================================================
//                                    Setup
//====================================================================================
void setup() {
  Serial.begin(115200);
    //-------------------------------------------------------------------
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

  //Pull credentials from flash memory
  preferences.begin("wifi",false);
  
  // ssid = preferences.getString("ssid", "");
  // password  = preferences.getString("password", "");
  // String temp_ssid = preferences.getString("ssid", "");
  // String temp_password  = preferences.getString("password", "");
  // ssid = (char*)temp_ssid.c_str();
  // password = temp_password.c_str();
  // if(ssid == NULL || password == NULL){
  //   Serial.println("No ssid or pass saved!!!\n");
  //   //If not set up yet, enter device setup
  //   //user must connect through the app bluetooth and hit the bluetooth pairing button on the device.
  //   setUpDevice();
  // }
  // else{
    
  //   connectToWifi();
  // }

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
  
  //devScreen();
  displayHomePage();
  delay(10000);
  postData();


}
