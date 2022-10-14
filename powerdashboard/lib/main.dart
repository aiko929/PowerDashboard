import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:powerdashboard/name_config.dart';
import 'package:powerdashboard/usage.dart';
import 'overview.dart';
import 'plugs.dart';
import 'settings.dart';

late Box box;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<NameConfig>(NameConfigAdapter());
  box = await Hive.openBox("config");
  runApp(const PowerDashboard());
}

class PowerDashboard extends StatefulWidget {
  const PowerDashboard({Key? key}) : super(key: key);

  @override
  State<PowerDashboard> createState() => _PowerDashboardState();
}

class _PowerDashboardState extends State<PowerDashboard> {



  int pageIndex = 0;
  List<Widget> pages = <Widget>[];
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    pages = [const OverView(), const Plugs(), const Usage()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pages = [const OverView(), const Plugs(), const Usage()];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Power Dashboard"),
          actions: [
            IconButton(onPressed: openSettingsPage, icon: const Icon(Icons.settings))
          ],
          ),
        
        body: pages.elementAt(pageIndex),

        bottomNavigationBar: BottomNavigationBar(
          items: const[

              BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Übersicht"
              ),

              BottomNavigationBarItem(
              icon: Icon(Icons.power),
              label: "Steckdosen"
              ),

              BottomNavigationBarItem(
              icon: Icon(Icons.power_settings_new),
              label: "Stromverbrauch"
              )
          ],
          currentIndex: pageIndex,
          selectedItemColor: Colors.greenAccent,
          onTap: onTabbed,
        ),
        ),
        navigatorKey: navigatorKey

    );

    
  }

  void openSettingsPage(){
    Navigator.push(navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

  void onTabbed(int index) {
    setState(() {
      pageIndex = index;
    });
  }

}
