import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_web/methods/companyPopUpMenu.dart';
import 'package:task_web/pages/loginPage.dart';
import 'package:task_web/pages/taskPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'methods/assignedPopUpMenu.dart';
import 'methods/statusPopUpMenu.dart'; // Import the DropdownState class
import 'methods/taskPopUpMenu.dart'; // Import the TaskDropdownState class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<StatusDropdownState>.value(
            value: StatusDropdownState(), // Provide an instance of StatusDropdownState
          ),
          ChangeNotifierProvider<TaskDropdownState>.value(
            value: TaskDropdownState(), // Provide an instance of TaskDropdownState
          ),
          ChangeNotifierProvider<AssignedDropdownState>.value(
            value: AssignedDropdownState(), // Provide an instance of AssignedDropdownState
          ),
          ChangeNotifierProvider<CompanyDropdownState>.value(
            value: CompanyDropdownState(), // Provide an instance of AssignedDropdownState
          ),
        ],
        child: LandingPage(prefs: prefs),
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  final SharedPreferences prefs;

  const LandingPage({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _decideMainPage(),
    );
  }

  Widget _decideMainPage() {
    if (prefs.getString('login_state') != null) {
      return const TaskPage();
    } else {
      return const LoginPage();
    }
  }
}
