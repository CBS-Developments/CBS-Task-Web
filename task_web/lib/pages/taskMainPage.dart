import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/drawers/subDrawer.dart';
import 'package:task_web/methods/taskLog.dart';
import 'package:task_web/sizes/pageSizes.dart';
import 'package:http/http.dart' as http;

import '../drawers/drawerTask.dart';
import '../methods/appBar.dart';
import '../methods/chartBox.dart';
import '../tables/taskTable.dart';

class TaskMainPage extends StatefulWidget {
  const TaskMainPage({super.key});

  @override
  State<TaskMainPage> createState() => _TaskMainPageState();
}

class _TaskMainPageState extends State<TaskMainPage> {
  List<MainTask> mainTaskList = [];

  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  String get taskCount => '20';

  int allTaskCount = 0;
  int inProgressTaskCount = 0;
  double inProgressPercent = 0.0;
  double inProgressPercentText = 0.00;

  int pendingTaskCount = 0;
  double pendingTaskPercent = 0.0;
  double pendingTaskPercentText = 0.00;



  @override
  void initState() {
    super.initState();
    loadData();
    getTaskList();
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),

      body: Row(
        children: [
          const LeftDrawer(),

          const SubDrawer(),

          SizedBox(width: getPageWidth(context) - 440,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Welcome $firstName $lastName!",
                    style: const TextStyle(color: Colors.black, fontSize: 30.0),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 60,
                      width: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Text('Total Tasks', style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0),
                            child: Text('$allTaskCount', style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),),
                          )
                        ],
                      ),
                    ),

                    // Container(
                    //   width: 360,
                    //   height: 40,
                    //   color: Colors.white,
                    //   margin: EdgeInsets.symmetric(horizontal: 10),
                    //   child: Row(
                    //     children: [
                    //       TextButton(
                    //           onPressed: () {},
                    //           child: Row(
                    //             children: [
                    //               Icon(Icons.add_circle_outline,
                    //                 color: Colors.red,),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 8.0),
                    //                 child: Text('User Creation', style:
                    //                 TextStyle(
                    //                     fontSize: 16,
                    //                     color: Colors.black
                    //                 ),
                    //                 ),
                    //               )
                    //             ],
                    //           )
                    //       ),
                    //
                    //       VerticalDivider(
                    //         thickness: 2,
                    //       ),
                    //
                    //       TextButton(
                    //           onPressed: () {},
                    //           child: Row(
                    //             children: [
                    //               Icon(Icons.add_circle_outline,
                    //                 color: Colors.red,),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 8.0),
                    //                 child: Text('Company Creation', style:
                    //                 TextStyle(
                    //                     fontSize: 16, color: Colors.black),),
                    //               )
                    //             ],
                    //           )
                    //       ),
                    //
                    //
                    //     ],
                    //   ),
                    // )
                  ],
                ),

                const SizedBox(height: 10,),

                SizedBox(
                  width: getPageWidth(context) - 240,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      ChartBox(
                        centerText: '$inProgressPercentText%',
                        percent: inProgressPercent,
                        footerText: 'In-Progress Task: $inProgressTaskCount',
                      ),

                      ChartBox(
                        centerText: '$pendingTaskPercentText%',
                        percent: pendingTaskPercent,
                        footerText: 'Pending Task: $pendingTaskCount',
                      ),


                    ],
                  ),
                ),

                const SizedBox(height: 25,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Container(
                    //   width: 450,
                    //   height: 250,
                    //   margin: EdgeInsets.symmetric(horizontal: 15),
                    //   decoration: BoxDecoration(
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.5),
                    //         spreadRadius: 2,
                    //         blurRadius: 5,
                    //         offset: Offset(0, 3),
                    //       ),
                    //     ],
                    //     color: Colors.white,
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //         padding: EdgeInsets.all(8),
                    //         color: Colors.white,
                    //         // Background color for the "Notification" text
                    //         child: Row(
                    //           children: [
                    //             Icon(Icons.notifications_active,
                    //                 color: Colors.red),
                    //             SizedBox(width: 8),
                    //             Text(
                    //               "Notification",
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // TaskLog(),
                  ],
                )


              ],
            ),
          )

        ],
      ),

    );
  }



  Future<void> getTaskList() async {
    mainTaskList.clear();
    var data = {};

    const url = "http://dev.connect.cbs.lk/mainTaskList.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );

    if (res.statusCode == 200) {
      final responseJson = json.decode(res.body) as List<dynamic>;
      setState(() {
        for (Map<String, dynamic> details in responseJson) {
          mainTaskList.add(MainTask.fromJson(details));
        }
        mainTaskList.sort((a, b) =>
            b.taskCreatedTimestamp.compareTo(a.taskCreatedTimestamp));

        // Count tasks with taskStatus = 0
        pendingTaskCount = mainTaskList
            .where((task) => task.taskStatus == "0")
            .length;
        inProgressTaskCount = mainTaskList
            .where((task) => task.taskStatus == "1")
            .length;
        int completedTaskCount = mainTaskList
            .where((task) => task.taskStatus == "2")
            .length;
        allTaskCount = mainTaskList.length;
        print("Pending Task: $pendingTaskCount");
        print("All Task: $allTaskCount");
        print("In Progress Task: $inProgressTaskCount");
        print("In Completed Task: $completedTaskCount");

        // Calculate the percentage of in-progress tasks
        if (allTaskCount > 0) {
          inProgressPercent = (inProgressTaskCount / allTaskCount);
          inProgressPercent = double.parse(inProgressPercent.toStringAsFixed(2));
          print("In Progress Percent: $inProgressPercent");
        }

        if (allTaskCount > 0) {
          inProgressPercentText = ((inProgressTaskCount / allTaskCount)*100);
          inProgressPercentText = double.parse(inProgressPercentText.toStringAsFixed(2));
          print("In Progress Percent Text: $inProgressPercentText");
        }

        // Calculate the percentage of to-do tasks
        if (allTaskCount > 0) {
          pendingTaskPercent = (pendingTaskCount / allTaskCount);
          pendingTaskPercent = double.parse(pendingTaskPercent.toStringAsFixed(2));
          print("To-Do Percent: $pendingTaskPercent");
        }

        if (allTaskCount > 0) {
          pendingTaskPercentText = ((pendingTaskCount / allTaskCount)*100);
          pendingTaskPercentText = double.parse(pendingTaskPercentText.toStringAsFixed(2));
          print("To-Do Percent Text: $pendingTaskPercentText");
        }

      });
    } else {
      throw Exception('Failed to load jobs from API');
    }


  }




}

