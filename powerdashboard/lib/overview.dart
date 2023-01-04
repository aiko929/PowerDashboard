import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class OverView extends StatefulWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: 0,
          sections: [
            PieChartSectionData(
              value: 100,
              radius: 150
            ),
            PieChartSectionData(
              value: 100,
              radius: 150
            ),PieChartSectionData(
              value: 100,
              radius: 150
            ),
            PieChartSectionData(
              value: 100,
              radius: 150
            ),
          ]
        )
      ),
    );
  }

}