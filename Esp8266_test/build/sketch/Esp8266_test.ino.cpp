#include <Arduino.h>
#line 1 "/mnt/sdb1/Arduino/Esp8266_test/Esp8266_test.ino"
#include <ESP8266WiFi.h>

#define MAXSC 1

const uint8_t LED = D4;
const uint16_t tcp_port = 8080;

const IPAddress APlocal_IP(192, 168, 4, 1);
const IPAddress APgateway(192, 168, 4, 1);
const IPAddress APsubnet(255, 255, 255, 0);

WiFiServer tcp_server(tcp_port);
WiFiClient tcp_client = tcp_server.available();

char buffer[64];
String data;
uint8_t i = 0;
uint8_t d_index;
uint8_t readed = 0;

#line 21 "/mnt/sdb1/Arduino/Esp8266_test/Esp8266_test.ino"
void setup();
#line 49 "/mnt/sdb1/Arduino/Esp8266_test/Esp8266_test.ino"
void loop();
#line 83 "/mnt/sdb1/Arduino/Esp8266_test/Esp8266_test.ino"
uint8_t tcp_buffer_clear(char buffer[64], uint8_t *readed, uint8_t *i);
#line 92 "/mnt/sdb1/Arduino/Esp8266_test/Esp8266_test.ino"
uint8_t tcp_read(char buffer[64], uint8_t *i, char c);
#line 21 "/mnt/sdb1/Arduino/Esp8266_test/Esp8266_test.ino"
void setup()
{
    pinMode(LED, OUTPUT);
    Serial.begin(115200);
    Serial.println("Serail monitor ready!");

    WiFi.mode(WIFI_AP);
    Serial.print("Setting soft-AP...");
    WiFi.softAPConfig(APlocal_IP, APgateway, APsubnet);
    boolean result = WiFi.softAP("ESP8266", "1234567890", 1, 0, MAXSC);
    if (result == true)
    {
        Serial.println("Ready.");
    }
    else
    {
        Serial.println("Failed");
    }
    IPAddress IP = WiFi.softAPIP();

    Serial.print("AccessPoint IP : ");
    Serial.println(IP);

    tcp_server.begin();
    Serial.println("TCP server start...");
    Serial.print("wait...");
}

void loop()
{
    if (!tcp_client)
    {
        tcp_client = tcp_server.available();
    }
    if (tcp_client)
    {
        if (tcp_client.connected())
        {
            tcp_buffer_clear(buffer, &readed, &i); // reset environment
            while (tcp_client.available())
            {
                readed = tcp_read(buffer, &i, tcp_client.read());
            }
            while (Serial.available())
            {
                tcp_client.write(Serial.read());
            }
            if (readed && i)
            {
                Serial.printf("\nMessage : %s", buffer);
                data = buffer;
                digitalWrite(LED, (data == "ON") ? HIGH : LOW);
            }
        }
        else
        {
            tcp_client.stop();
            Serial.println("Stop");
        }
    }
}

uint8_t tcp_buffer_clear(char buffer[64], uint8_t *readed, uint8_t *i)
{
    for (int i = 0; buffer[i] != 0 && i < 64; i++)
        buffer[i] = 0;
    *i = 0;
    *readed = 0;
    return 0;
}

uint8_t tcp_read(char buffer[64], uint8_t *i, char c)
{
    if (*i >= 63)
    {
        return 2;
    }
    buffer[*i] = c;
    *i = *i + 1;
    return 1;
}

