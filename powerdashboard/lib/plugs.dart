import 'dart:async';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:powerdashboard/name_config.dart';

class Plugs extends StatefulWidget {
  const Plugs({Key? key}) : super(key: key);

  @override
  State<Plugs> createState() => _PlugsState();
}

class _PlugsState extends State<Plugs> {
  
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  late NameConfig config;
  late Box box;
  late TextStyle ownTextStyle;

  @override
  void initState() {
    box = Hive.box("config");
    ownTextStyle = const TextStyle(fontSize: 24);
    config = box.get("nameConfig");

    for(int i = 0; i < config.names.length; i++){
      usages.add(0);
      activated.add(false);
      spotData.add([]);
    }

    updateValues();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      updateValues();
      if(mounted == false){
        timer.cancel();
      }
    });
    super.initState();
  }

  double zaehlerstand = 0;
  int zaehlerverbrauch = 0;
  int pvWattage = 0;
  List<List<FlSpot>> spotData = [];
  late List<int> usages = [];
  late List<bool> activated = [];

  void updateValues() async {
    
    var client = http.Client();
    
    //Update Zähler:
    var uri = Uri.parse("http://127.0.0.1:6060/get/zaehler");
    client.get(uri).then((response) {
      if(response.statusCode == 200){
      
      Map<String,dynamic> json = jsonDecode(response.body);
      zaehlerstand = json["stand"];
      zaehlerverbrauch = json["usage"];
      setMountedState();
      }
    });

    //Update PV-Anlage:
    uri = Uri.parse("http://127.0.0.1:6060/get/info/${config.pvIP}");
    client.get(uri).then((response) {
      if(response.statusCode == 200){
        Map<String,dynamic> json = jsonDecode(response.body);
        pvWattage = json["power"];
        setMountedState();
      }
    });

    for(int i = 0; i < config.names.length; i++){
      uri = Uri.parse("http://127.0.0.1:6060/get/info/${config.ips[i]}");
      client.get(uri).then((response) {
        if(response.statusCode == 200){

          Map<String,dynamic> json = jsonDecode(response.body);
          usages[i] = json["power"];
          activated[i] = json["status"];
          setMountedState();

        }
      });
    }

  }

  void setMountedState(){
    if(mounted){
      setState(() {
        
      });
    }
  }

  TextStyle title = const TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ExpansionTile(
            title: Text("Zähler", style: title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChoiceChip(
                  label: Text("Zählerstand: $zaehlerstand kw/h"),
                  avatar: const Icon(Icons.battery_saver),
                  onSelected: (value) {},
                  selected: true,
                  selectedColor: Colors.white10),

                ChoiceChip(
                  label: Text("Verbrauch: $zaehlerverbrauch Watt"),
                  avatar: const Icon(Icons.power),
                  onSelected: (value) {},
                  selected: true,
                  selectedColor: zaehlerverbrauch > 0 ? Colors.redAccent : Colors.lightGreenAccent),
                ],
            ),
          ),
        ),

        Card(
          child: ExpansionTile(
            title: Text("Solar-Anlage", style: title),
            subtitle: Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChoiceChip(
                  label: Text("Erzeugt: $pvWattage Watt"),
                  avatar: const Icon(Icons.solar_power),
                  onSelected: (value) {},
                  selected: true,
                  selectedColor: Colors.lightGreenAccent),
                ],
            ),
          ),
        ),
        
        
        ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: config.names.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Card(
              child: ExpansionTile(
                  title: Text(config.names.elementAt(index), style: title),
                  initiallyExpanded: false,
                  onExpansionChanged: (value) {
                    updateExpandedSpots(index);
                  },
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: (){
                          setState(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                          return alertToggleAutoMode(index);
                                        });
                          });
                        },
                        icon: const Icon(Icons.auto_mode),
                        iconSize: 24),
                      Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 4, color: activated[index] ? Colors.yellow : Colors.grey)
                      ),
                      child: IconButton(
                                          icon: const Icon(Icons.bolt),
                                          color: activated[index] ? Colors.yellow : Colors.grey,
                                          onPressed: () {
                                              setState(() {
                                                showDialog(
                                                  context: context,//Problem bei zu schnellem umschalten
                                                  builder: (BuildContext context) {
                                                    return alertTogglePlug(index);
                                                  });
                                             });
                                           },),
                    ),
                    ]
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChoiceChip(
                              label: Text("Verbrauch: ${usages[index]} Watt"),
                              avatar: const Icon(Icons.power),
                              onSelected: (value) {},
                              selected: true,
                              selectedColor: usages[index] > 0 ? Colors.orangeAccent : Colors.white10),
                    ],
                  ),
                  children: [
                    SizedBox(
                      width: 1500,
                      height: 400,
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              dotData: FlDotData(show: false),
                              spots: spotData.elementAt(index),
                              preventCurveOvershootingThreshold: 0,
                            )
                          ],
                          minX: 0,
                          maxX: 23.99,
                          minY: 0,
                          maxY: 500,
                        )
                      ),
                    )
                  ],
                ),
            );
          },
          ),
    ]);
  }

  AlertDialog alertToggleAutoMode(index){
    return AlertDialog(
    title: Text(config.names.elementAt(index)),
    content: SizedBox(
      height: 100,
      child: Column(
        children: [
          const Text("Ab wie viel überschüssigem Strom (Watt) soll das Gerät gestartet werden?"),
          TextField(
            onEditingComplete: () {
              
            },
          )
        ],
      ),
    ),
    actions: [
      TextButton(
      child: const Text("Abbrechen"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
      ),
      TextButton(
      child: const Text("Starte automatischen Modus"),
      onPressed:  () {
        //TODO start auto mode
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Noch keine Funktion!")));
        Navigator.of(context).pop();
      },
      ),
    ],
  );
  }


  AlertDialog alertTogglePlug(index){
    return AlertDialog(
    title: Text(config.names.elementAt(index)),
    content: const Text("Bist du dir sicher das du die Steckdose umschalten möchtest?"),
    actions: [
      TextButton(
      child: const Text("Abbrechen"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
      ),
      TextButton(
      child: const Text("Umschalten"),
      onPressed:  () {
        togglePlug(config.ips.elementAt(index));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${config.names[index]} umgeschaltet.")));
        Navigator.of(context).pop();
      },
      ),
    ],
  );
  }


  void togglePlug(String ip) async {
    var client = http.Client();
    var uri = Uri.parse("http://127.0.0.1:6060/do/toggle/$ip");
    await client.get(uri);
    updateValues();
  }


  void updateExpandedSpots(int index){

    String name = config.ips.elementAt(index);
    var client = http.Client();
    var uri = Uri.parse("http://127.0.0.1:6060/get/day/$name");

    var response = client.get(uri);

    List<FlSpot> flSpots = [];
    List<dynamic> json;

    response.then((response) {

      if(response.statusCode == 200){

        json = jsonDecode(response.body);

        for(int i = 0; i < json.length; i++){
          
          double y = json[i][0].toDouble();
          double x = double.parse(json[i][1]) + (double.parse(json[i][2])/60);

          flSpots.add(
            FlSpot(x, y)
          );
        }

        spotData.insert(index, flSpots);
        setMountedState();

      }

    });

  }

}
