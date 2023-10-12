import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_web/methods/companyPopUpMenu.dart';
import 'package:task_web/pages/createMainTaskNew.dart';
import 'package:task_web/pages/dashboard/dashMain.dart';
import 'package:task_web/pages/taskMainPage.dart';
import 'package:task_web/pages/loginPage.dart';
import 'package:task_web/pages/taskPageOne.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'createAccountPopups/assigntoPopUp.dart';
import 'createAccountPopups/beneficiaryPopUp.dart';
import 'createAccountPopups/categoryPopUp.dart';
import 'createAccountPopups/priortyPopUp.dart';
import 'createAccountPopups/sourcefromPopUp.dart';
import 'methods/assignedPopUpMenu.dart';
import 'methods/labelPopUpMenu.dart';
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
            value:
                StatusDropdownState(), // Provide an instance of StatusDropdownState
          ),
          ChangeNotifierProvider<TaskDropdownState>.value(
            value:
                TaskDropdownState(), // Provide an instance of TaskDropdownState
          ),
          ChangeNotifierProvider<AssignedDropdownState>.value(
            value:
                AssignedDropdownState(), // Provide an instance of AssignedDropdownState
          ),
          ChangeNotifierProvider<CompanyDropdownState>.value(
            value:
                CompanyDropdownState(), // Provide an instance of AssignedDropdownState
          ),
          ChangeNotifierProvider<LabelDropdownState>.value(
            value:
                LabelDropdownState(), // Provide an instance of AssignedDropdownState
          ),
          ChangeNotifierProvider<BeneficiaryState>(
            create: (context) => BeneficiaryState(),
          ),
          ChangeNotifierProvider<DueDateState>(
            create: (context) => DueDateState(),
          ),
          ChangeNotifierProvider<AssignToState>.value(
            value: AssignToState(),
          ),

          ChangeNotifierProvider<PriorityState>.value(
            value: PriorityState(), // Provide an instance of PriorityState
          ),

          ChangeNotifierProvider<SourceFromState>.value(
            value: SourceFromState(),
          ),

          ChangeNotifierProvider<CategoryState>.value(
            value: CategoryState(),
          ),

        ],
        child: LandingPage(
            prefs: prefs), // Pass the plugin instance to LandingPage
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  final SharedPreferences prefs; // Add this line

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
      return const DashManin();
    } else {
      return const LoginPage();
    }
  }
}
