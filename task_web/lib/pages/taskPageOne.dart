import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/drawers/subDrawer.dart';
import 'package:task_web/methods/appBar.dart';
import 'package:task_web/drawers/drawerTask.dart';
import 'package:task_web/tables/taskTable.dart';
import 'package:task_web/methods/upMainRow.dart';




class TaskPageOne extends StatefulWidget {
  const TaskPageOne({super.key});

  @override
  State<TaskPageOne> createState() => _TaskPageOneState();
}

class _TaskPageOneState extends State<TaskPageOne> {

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

      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body:
      Row(
        children: [
          const LeftDrawer(),

          const SubDrawer(),

          Column(
            children:  [
              const UpMainRow(),
              const SizedBox(height: 20,),
              TaskTable(
              ),

              const SizedBox(height: 18),



            ],
          )
        ],
      ),

    );
  }
}
