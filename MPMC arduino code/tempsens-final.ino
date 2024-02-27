#include <LiquidCrystal.h>

LiquidCrystal lcd(12, 11, 5, 4, 3, 2);
const int sensor = A1;  // Assigning analog pin A1 to variable 'sensor'
const int contrastPin = 6;  // Digital pin connected to the contrast pin of the LCD

float tempc;  // Variable to store temperature in degrees Celsius
float tempf;  // Variable to store temperature in Fahrenheit
float vout;   // Temporary variable to hold sensor reading

void setup() {
  pinMode(sensor, INPUT);        // Configuring pin A1 as input
  pinMode(contrastPin, OUTPUT);  // Configuring contrast pin as output
  Serial.begin(9600);
  lcd.begin(16, 2);
  delay(500);
}

void loop() {
  vout = analogRead(sensor);
  vout = (vout * 500) / 1023;
  tempc = vout;               // Storing value in degrees Celsius
  tempf = (vout * 1.8) + 32;  // Converting to Fahrenheit

  lcd.setCursor(0, 0);
  lcd.print("in DegreeC= ");
  lcd.print(tempc);
  lcd.setCursor(0, 1);
  lcd.print("in Fahrenheit=");
  lcd.print(tempf);

  // Adjusting LCD contrast
  analogWrite(contrastPin, 120);  // Modify the value (0-255) to adjust the contrast

  // Displaying temperature on the serial monitor
  Serial.print("Temperature in Celsius: ");
  Serial.print(tempc);
  Serial.print("°C, Temperature in Fahrenheit: ");
  Serial.print(tempf);
  Serial.println("°F");

  // Displaying temperature on the serial plotter
  Serial.print(tempc);
  Serial.print(",");
  Serial.println(tempf);

  delay(1000);  // Delay of 1 second (for serial monitor)
}
