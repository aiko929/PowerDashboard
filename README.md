# PowerDashboard: small homemade smarthome system

This project is a hobby project to gain some experience regarding flutter and to train the costumer feedback loop.
The backend (currently not available on github) is running on a raspberry pi 4.
This application should only be used INSIDE your local network (or through your home VPN), its not secure to open up your backend to the internet.
To collect data i used smart plugs with tasmota flashed onto them. Every 5 minutes they send their data to my backend via MQTT and there the data is stored into a small sqlite database.
Also i collect data from our electric meter, these are collected via an IR interface and send to the database via MQTT.

## Application features: 

### Pie-Chart:

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/8e569561-8569-47b6-be37-c4e85a1944dc)

(still in development)
Shows you how much power each plug used up during the day.

### Plug-Controll:

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/53ac778f-837c-48cf-8cb2-4ab02223a0bb)

Here you can control all plugs installed in your home. You can see if a plug is currently activated and how much power the plug is using right now. You can also turn each plug on and off.
General information about your electric meter is shown. If your solar system is producing more energy then you are consuming you can see negative values in your consumption card.

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/c5f7f463-a0f4-435a-85cf-88033b40e622)

For each plug you can see its history in a linechart.

### Day-Overview:

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/2db5d4e3-5ad9-409f-9e7f-fcb1fff2440f)

Here you can select which day you want an overview of.
Then a linechart is presented with an overview of consumption/production of power.

![image](https://github.com/aiko929/PowerDashboard/assets/26790700/fc192a28-8334-40e3-9c4d-45509d131d1b)

Its also possible to switch to the meter reading mode.
