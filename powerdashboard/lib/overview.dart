import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

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
    return const Text("Überarbeitung");

  }

}