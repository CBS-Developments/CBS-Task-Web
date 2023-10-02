import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/drawers/subDrawer.dart';
import 'package:task_web/pages/taskPageOne.dart';
import 'package:task_web/pages/taskPageTwo.dart';

import '../drawers/drawerTask.dart';
import '../methods/appBar.dart';
import '../methods/colors.dart';
import '../methods/taskTable.dart';
import '../methods/upMainRow.dart';
import '../sizes/pageSizes.dart';

class TaskPageThree extends StatefulWidget {
  const TaskPageThree({super.key});

  @override
  State<TaskPageThree> createState() => _TaskPageThreeState();
}

class _TaskPageThreeState extends State<TaskPageThree> {

  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "";
      firstName = prefs.getString('first_name') ?? "";
      lastName = prefs.getString('last_name') ?? "";
      phone = prefs.getString('phone') ?? "";
      userRole = prefs.getString('user_role') ?? "";

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body:
      Row(
        children: [
          const LeftDrawer(),

          SubDrawer(),

          Column(
            children:  [
              UpMainRow(),
              SizedBox(height: 20,),
              TaskTable(
              ),

              SizedBox(height: 18),



            ],
          )
        ],
      ),

    );
  }
}

