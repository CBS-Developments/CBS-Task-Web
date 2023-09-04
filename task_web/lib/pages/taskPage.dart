import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/methods/appBar.dart';
import 'package:task_web/drawers/drawerTask.dart';
import 'package:task_web/methods/taskTable.dart';
import 'package:task_web/methods/upMainRow.dart';
import 'package:task_web/pages/createTaskBox.dart';



class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {

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

          Column(
            children:  [
              UpMainRow(),
              SizedBox(height: 20,),
              TaskTable(
              ),

              SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: () { showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreateTaskDialog(); // Use the dialog widget here
                  },
                );
                  },
                icon: Icon(Icons.add_circle_outline_rounded, color: Colors.red,),
                label: Text("Add Task"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white, // Text color
                ),
              ),

            ],
          )
        ],
      ),

    );
  }
}
