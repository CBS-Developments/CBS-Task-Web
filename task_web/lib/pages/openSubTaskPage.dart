import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/pages/editSubTask.dart';
import 'package:task_web/pages/taskMainPage.dart';
import 'package:http/http.dart' as http;
import '../components.dart';
import '../methods/appBar.dart';
import '../methods/colors.dart';
import '../tables/subTaskTable.dart';

class OpenSubTaskNew extends StatefulWidget {
  final String userRoleForDelete;
  final Task task; // Make sure Task is imported and defined
  OpenSubTaskNew({Key? key, required this.task, required this.userRoleForDelete}) : super(key: key);

  @override
  State<OpenSubTaskNew> createState() => _OpenSubTaskNewState();
}

class _OpenSubTaskNewState extends State<OpenSubTaskNew> {
  String userName = '';
  String firstName = '';
  String lastName = '';
  String userRole = '';


  @override
  void initState() {
    super.initState();
    retrieverData();
  }

  void retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
  }

  String getCurrentDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return formattedDate;
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  void showDeleteConfirmationDialog(
      BuildContext context,
      String userRole,
      String taskId,

      ) {
    print('User Role in showDeleteConfirmationDialog Sub: $userRole');
    if (userRole == '1') {
      print(userRole);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this task?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop();
                  deleteSubTask(taskId);
                  // Call the deleteMainTask method// Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      // Display a message or take other actions for users who are not admins
      print(userRole);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text('Only admins are allowed to delete tasks.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }


  Future<bool> deleteSubTask(
      String taskID,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status": '99',
      "task_status_name": 'Deleted',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date":getCurrentDateTime(),
      "action_taken_timestamp": getCurrentDate(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteSubTask.php";

    try {
      final res = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);

        // Debugging: Print the response data.
        print("Response from PHP script: $responseBody");

        if (responseBody == "true") {
          print('Successful');
          snackBar(context, "Sub Task Deleted successful!", Colors.redAccent);

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) {
          //     return const TaskMainPage();
          //   }),
          // );
          return true; // PHP code was successful.
        } else {
          print('PHP code returned "false".');
          return false; // PHP code returned "false."
        }
      } else {
        print('HTTP request failed with status code: ${res.statusCode}');
        return false; // HTTP request failed.
      }
    } catch (e) {
      print('Error occurred: $e');
      return false; // An error occurred.
    }
  }


  @override
  Widget build(BuildContext context) {
    Task task = widget.task;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),

      body: Center(
        child: Container(
            width: 1076, // Set the width of the dialog
            height: 500, // Set the height of the dialog
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: 700,
                  height: 500,
                  // color: Colors.greenAccent,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back_rounded),
                        ),

                        Text(
                          'Sub Task ID:${task.taskId}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(
                          width: 480,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${task.taskTitle}',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => EditSubTaskPage(
                                            currentTitle: task.taskTitle,
                                            currentDescription: task.taskDescription,
                                            currentBeneficiary: task.company,
                                            currentDueDate: task.dueDate,
                                            currentAssignTo:task.assignTo,
                                            currentPriority: task.taskTypeName,
                                            currentSourceFrom: task.sourceFrom,
                                            currentCategory: task.categoryName,
                                            taskID: task.taskId,
                                            userName: userName,
                                            firstName: firstName)));
                                      },
                                      tooltip: 'Edit Task',
                                      icon: Icon(
                                        Icons.edit_note_rounded,
                                        color: Colors.black,
                                        size: 22,
                                      )),

                                  IconButton(
                                    onPressed: () {
                                      showDeleteConfirmationDialog(context, widget.userRoleForDelete, widget.task.taskId);
                                    },
                                    tooltip: 'Delete Task',
                                    icon: Icon(
                                      Icons.delete_rounded,
                                      color: Colors.redAccent,
                                      size: 19,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),


                        Text(
                          '${task.taskDescription}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 480,
                          height: 160,
                          color: Colors.grey.shade100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 160,
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      children: [
                                        Icon(Icons.calendar_month_rounded,size: 15,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8,right: 4 ),
                                          child: Text(
                                            'Start',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.drawerLight),
                                          ),
                                        ),

                                        Icon(Icons.arrow_forward,color: AppColor.drawerLight,size: 15,),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8,right: 4 ),
                                          child: Text(
                                            'Due',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.drawerLight),
                                          ),
                                        ),

                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        'Company',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        'Assign To',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        'Priority',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        'Created By',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              VerticalDivider(
                                thickness: 2,
                              ),

                              SizedBox(
                                height: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      children: [
                                        Icon(Icons.calendar_month_rounded,size: 15,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8,right: 4 ),
                                          child: Text(
                                            '${task.taskCreateDate}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,),
                                          ),
                                        ),

                                        Icon(Icons.arrow_forward,color: Colors.black,size: 15,),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8,right: 4 ),
                                          child: Text(
                                            '${task.dueDate}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,),
                                          ),
                                        ),

                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        '${task.company}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        '${task.assignTo}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        '${task.taskTypeName}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        '${task.taskStatusName}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 18,bottom: 8),
                                      child: Text(
                                        '${task.taskCreateBy}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,),
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),


                        SizedBox(
                          width: 480,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              TextButton(
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Mark In Progress',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.blueAccent),
                                  ),
                                ),
                              ),

                              TextButton(
                                  onPressed: (){},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Mark As Complete',style:
                                    TextStyle(fontSize: 14,color: Colors.green),),
                                  ) ),

                            ],
                          ),
                        ),

                        SizedBox(height: 15,),

                        Container(
                          width: 480,
                          height: 35,
                          color: Colors.grey.shade300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Special Notice',style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                ),),
                              ),

                            ],
                          ),
                        ),

                        Container(
                          width:300,
                          height: 150,
                          color: Colors.white,
                        ),

                        SizedBox(height: 5,),


                      ],
                    ),
                  ),
                ),

                VerticalDivider(),

                Container(
                  width: 360,
                  height: 500,
                  // color: Colors.lightBlueAccent,
                  child: Column(
                    children: [


                      Container(
                        width: 330,
                        height: 35,
                        color: Colors.grey.shade300,
                        child: Align(alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Comment',style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                            ),),
                          ),
                        ),
                      ),

                      Container(
                        width: 330,
                        height: 225,
                        color: Colors.white,
                      ),

                      Container(
                        width: 330,
                        height: 40,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade300,
                              hintText: 'Write a Comment...',
                              helperStyle: TextStyle(color: Colors.grey.shade700,fontSize: 14),
                              filled: true
                          ),

                        ),
                      ),



                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
