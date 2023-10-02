import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/drawers/subDrawer.dart';
import 'package:task_web/pages/taskPageOne.dart';

import '../drawers/drawerTask.dart';
import '../methods/appBar.dart';
import '../methods/colors.dart';
import '../methods/taskTable.dart';
import '../methods/upMainRow.dart';
import '../sizes/pageSizes.dart';

class TaskPageTwo extends StatefulWidget {
  const TaskPageTwo({super.key});

  @override
  State<TaskPageTwo> createState() => _TaskPageTwoState();
}

class _TaskPageTwoState extends State<TaskPageTwo> {

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

