# PowerDashboard: small homemade smarthome system

This project is a hobby project to gain some experience regarding flutter and to train the costumer feedback loop.
The backend (currently not available on github) is running on a raspberry pi 4.
This application should only be used INSIDE your local network (or through your home VPN), its not secure to open up your backend to the internet.
To collect data i used smart plugs with tasmota flashed onto them. Every 5 minutes they send their data to my backend via MQTT and there the data is stored into a small sqlite database.
Also i collect data from our electric meter, these are collected via an IR interface and send to the database via MQTT.

## Application features: 

### Pie-Chart:

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/8ff8d3a2-1cd3-4e67-8d8d-998885518998)

(still in development)
Shows you how much power each plug used up during the day.

### Plug-Controll:

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/c7e530af-01c4-4d69-ada9-f429fa1b46bd)

Here you can control all plugs installed in your home. You can see if a plug is currently activated and how much power the plug is using right now. You can also turn each plug on and off.
General information about your electric meter is shown. If your solar system is producing more energy then you are consuming you can see negative values in your consumption card.

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/3d5f95f9-56fa-472b-b272-d4806aa805ab)

For each plug you can see its history in a linechart.

### Day-Overview:

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/3fba5e40-f3c5-4ca9-9773-41d5893f870c)

Here you can select which day you want an overview of.
Then a linechart is presented with an overview of consumption/production of power.

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/aac2360e-e14d-4712-bf6c-c80dc7429490)

Its also possible to switch to the meter reading mode.
