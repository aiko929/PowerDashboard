import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:powerdashboard/name_config.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  TextStyle title = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold
  );

  late Box box;
  late NameConfig config;

  @override
  void initState() {
    box = Hive.box("config");
    if(true){
      box.put("nameConfig", 
        NameConfig(
          names: [
            "Getränkekühler",
            "Holzhaus",
            "Wohnzimmer",
            "Aiko",
            "Kühlschrank",
            "Gefrierschrank",
            "Testgerät"
            ],
          ips: [
            "192.168.178.115",
            "192.168.178.114",
            "192.168.178.116",
            "192.168.178.128",
            "192.168.178.126",
            "192.168.178.125",
            "192.168.178.127"
            ],
          zaehlerIP: "192.168.178.118",
          pvIP: "192.168.178.113"
          )
      );
    }

    config = box.get("nameConfig");

    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Einstellungen"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: returnToMainPage
            ),
            ),
        body: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: config.names.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  SizedBox(
                    width: 130,
                    height: 50,
                    child: TextField(
                    decoration: InputDecoration(
                      labelText: config.names.elementAt(index)
                    ),
                    ),
                  ),
                  const VerticalDivider(),
                  SizedBox(
                    width: 130,
                    height: 50,
                    child: TextField(
                    decoration: InputDecoration(
                      labelText: config.ips.elementAt(index)
                    ),
                    ),
                  ),
                  ],
              );
            },
          ),
        ),

    ));

  }

  void returnToMainPage(){
    Navigator.pop(context);
  }

}