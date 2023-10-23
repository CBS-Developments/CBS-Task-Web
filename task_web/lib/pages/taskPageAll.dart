import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../drawers/drawerTask.dart';
import '../drawers/subDrawer.dart';
import '../methods/appBar.dart';
import '../methods/upMainRow.dart';
import '../sizes/pageSizes.dart';
import '../tables/taskTable.dart';

class TaskPageAll extends StatefulWidget {
  const TaskPageAll({super.key});

  @override
  State<TaskPageAll> createState() => _TaskPageAllState();
}

class _TaskPageAllState extends State<TaskPageAll> {
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
    print('User Role In Page One: $userRole');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body: Row(
        children: [
          const LeftDrawer(),
          const SubDrawer(),
          Column(
            children: [
              const UpMainRow(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: getPageWidth(context) - 395,
                height: 35,
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'All Tasks',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              TaskTable(),
            ],
          )
        ],
      ),
    );
  }
}
