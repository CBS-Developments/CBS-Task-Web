import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/drawers/subDrawer.dart';


import '../drawers/drawerTask.dart';
import '../methods/appBar.dart';
import '../methods/taskTable.dart';
import '../methods/upMainRow.dart';


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

