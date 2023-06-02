import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Usage extends StatefulWidget {
  const Usage({Key? key}) : super(key: key);

  @override
  State<Usage> createState() => _UsageState();
}

class _UsageState extends State<Usage> {

  @override
  void initState() {
    paintNewLines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getUsageChart();
  }

  double ownminX = 0;
  double ownmaxX = 24;
  double ownminY = 0.0;
  double ownmaxY = 0.0;
  String mode = "verbrauch";
  LineChartBarData line = LineChartBarData();
  int stepSize = 1;
  TextEditingController dateInput = TextEditingController();
  DateTime currentPickedDate = DateTime.now();
  

  ListView getUsageChart(){

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        SizedBox(
          width: 100,
          height: 500,
          child: LineChart(
            LineChartData(
              minX: ownminX,
              maxX: ownmaxX, 
              minY: ownminY,
              maxY: ownmaxY,

              lineBarsData: [line],


              titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                )
            )
          )
        ),

        TextField(
          controller: dateInput,
          decoration: InputDecoration(
                      icon: const Icon(Icons.calendar_today), //icon of text field
                      labelText: DateFormat("dd.MM.yyyy").format(DateTime.now()).toString() //label text of field
                      ),
          readOnly: true,
          onTap: () async {

            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: currentPickedDate,
              firstDate: DateTime.parse("2022-08-18"), 
              lastDate: DateTime.now()) ;

              pickedDate ??= DateTime.now();

              currentPickedDate = pickedDate;

              setState(() {
                dateInput.text = DateFormat("dd.MM.yyyy").format(pickedDate!).toString();
                paintNewLines();
              });
              
          }
        )
        ,
        
        DropdownButton(
          value: mode,
          items: ["verbrauch", "zaehlerstand"]
            .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
            }).toList(),
          onChanged: (String? newValue){
            onChanged(newValue!);
          })
      ]
    );

  }

  String getDateFromDateTime(DateTime datetime){
    return DateFormat("yyyy-MM-dd").format(datetime).toString();
  }

  void onChanged(String newValue){
    mode = newValue.toLowerCase();
    if(mounted){ 
      setState(() {
        paintNewLines();
      });
    }
  }

  void paintNewLines() async {

    String time = DateFormat("yyyy-MM-dd").format(currentPickedDate).toString();
    var client = http.Client();
    var uri = Uri.parse("http://127.0.0.1:6060/get/zaehler/$time");

    int yIndex = 0;

    if(mode == "zaehlerstand"){
      //Für die Anzeige des Zählerstandes:
      yIndex = 0;
    }
    else{
      //Für die Anzeige von dem Verbrauch:
      yIndex = 1;
    }

    var response = await client.get(uri);

    if(response.statusCode == 200){
      List<FlSpot> spots = [];
      List<dynamic> json = jsonDecode(response.body);
      List<double> yWerte = [];

      for(int i = 0; i < json.length; i++){
          yWerte.add(json[i][yIndex].toDouble());
      }

      if(yIndex == 0){
        //Für den Zählerstand:
        ownminY = yWerte.reduce(min);
        ownminY = ownminY.floorToDouble();
        ownmaxY = yWerte.reduce(max);
        ownmaxY= ownmaxY.ceilToDouble();
      }
      else{
        //Für die Verbrauchsanzeige:
        ownminY = yWerte.reduce(min);
        ownminY = ownminY * 1.2;
        ownmaxY = yWerte.reduce(max);
        ownmaxY= ownmaxY * 1.2;
      }
      

      if(time == "day"){
        ownminX = 0;
        ownmaxX = 24;
      }
      
      for(int i = 0; i < json.length; i = i + stepSize){
        double y = yWerte[i];
        double x = double.parse(json[i][2]) + double.parse(json[i][3])/60;
        spots.add(FlSpot(x, y));
      }

      line = LineChartBarData(
      spots: spots,
      isCurved: false,
      preventCurveOvershootingThreshold: 10,
      color: Colors.black54,
      barWidth: 3,
      belowBarData: BarAreaData(
        show: true,
        color: Colors.red.withOpacity(0.4),
        cutOffY: 0,
        applyCutOffY: true,
      ),
      aboveBarData: BarAreaData(
      show: true,
      color: Colors.green.withOpacity(0.6),
      cutOffY: 0,
      applyCutOffY: true,
      ),
      dotData: FlDotData(
        show: false
      )
      );
    }

    if(mounted){
      setState(() {
        
      });
    }

  }
}
