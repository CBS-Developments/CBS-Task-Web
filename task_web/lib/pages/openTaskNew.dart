import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/pages/createSubTaskNew.dart';
import 'package:task_web/pages/taskMainPage.dart';
import 'package:http/http.dart' as http;

import '../components.dart';
import '../methods/appBar.dart';
import '../methods/colors.dart';
import '../tables/subTaskTable.dart';
import '../tables/taskTable.dart';
import 'editMainTask.dart';

class OpenTaskNew extends StatefulWidget {
  final MainTask task;

  OpenTaskNew({Key? key, required this.task}) : super(key: key);

  @override
  State<OpenTaskNew> createState() => _OpenTaskNewState();
}

class _OpenTaskNewState extends State<OpenTaskNew> {
  String userName = '';

  String firstName = '';
  String lastName = '';
  String userRole = '';

  TextEditingController mainTaskCommentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieverData();
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

  void retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
  }

  Future<bool> deleteMainTask(
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
    const url = "http://dev.workspace.cbs.lk/deleteMainTask.php";

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
          snackBar(context, "Main Task Deleted successful!", Colors.redAccent);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const TaskMainPage();
            }),
          );
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
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body: Center(
        child: Container(
          width: 1120,
          height: 500,
          color: Colors.white,
          child: SizedBox(
            width: 1120,
            height: 500,
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 700,
                    height: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.task.taskTitle,
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
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditMainTaskPage(
                                                currentTitle:
                                                    widget.task.taskTitle,
                                                currentDescription: widget
                                                    .task.task_description,
                                                currentBeneficiary:
                                                    widget.task.company,
                                                currentDueDate:
                                                    widget.task.dueDate,
                                                currentAssignTo:
                                                    widget.task.assignTo,
                                                currentPriority:
                                                    widget.task.taskTypeName,
                                                currentSourceFrom:
                                                    widget.task.sourceFrom,
                                                currentCategory:
                                                    widget.task.category_name,
                                                taskID: widget.task.taskId,
                                                userName: userName,
                                                firstName: firstName,
                                              )),
                                    );
                                  },
                                  tooltip: 'Edit Task',
                                  icon: Icon(
                                    Icons.edit_note_rounded,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {

                                    deleteMainTask(widget.task.taskId,);
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
                        Text(
                          widget.task.taskId,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
                                          child: Text(
                                            'Start',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColor.drawerLight),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: AppColor.drawerLight,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
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
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Company',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Assign To',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Priority',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        'Status',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColor.drawerLight),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
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
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
                                          child: Text(
                                            widget.task.taskCreateDate,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.black,
                                          size: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4,
                                              bottom: 8,
                                              top: 8,
                                              right: 4),
                                          child: Text(
                                            widget.task.dueDate,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.company,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.assignTo,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.taskTypeName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.taskStatusName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18, bottom: 8),
                                      child: Text(
                                        widget.task.taskCreateBy,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Mark As Complete',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
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
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateSubTaskNew(
                                        username: userName,
                                        firstName: firstName, lastName: lastName, mainTaskId: widget.task.taskId,),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Add Sub Task',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.green),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Subtasks',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // SubTaskTableNew(mainTaskId: widget.task.taskId)
                        SubTaskTable(mainTaskId: widget.task.taskId)
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  Container(
                    width: 360,
                    height: 500,
                    child: Column(
                      children: [
                        Container(
                          width: 330,
                          height: 40,
                          color: Colors.grey.shade300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Special Notice',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 150,
                          color: Colors.white,
                        ),
                        Container(
                          width: 330,
                          height: 35,
                          color: Colors.grey.shade300,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Comment',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 330,
                          height: 225,
                          color: Colors.white,
                          // FutureBuilder<List<comment>>(
                          //   future: getMainTaskCommentList(mainTaskId),
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState == ConnectionState.waiting) {
                          //       return CircularProgressIndicator(); // Display a loading indicator while fetching data
                          //     } else if (snapshot.hasError) {
                          //       return Text("Error: ${snapshot.error}");
                          //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          //       return Text("No comments available"); // Replace with your custom message
                          //     } else {
                          //       List<comment>? data = snapshot.data;
                          //       return ListView.builder(
                          //         itemCount: data!.length,
                          //         itemBuilder: (context, index) {
                          //           return Card(
                          //             child: ListTile(
                          //               title: SelectableText(
                          //                 data[index].commnt,
                          //                 style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontSize: 12,
                          //                 ),
                          //               ),
                          //               subtitle: Text(
                          //                 "${data[index].commentCreateDate}      ${data[index].commentCreateBy}",
                          //                 style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontSize: 12,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //               trailing: IconButton(
                          //                 icon: Icon(
                          //                   Icons.delete,
                          //                   size: 14,
                          //                   color: Colors.red,
                          //                 ),
                          //                 onPressed: () {
                          //                   if (data[index].commentCreateById == userName) {
                          //                     deleteCommentInMainTask(
                          //                       data[index].commentId,
                          //                       "0",
                          //                       userName,
                          //                       "$firstName $lastName",
                          //                     );
                          //                   } else {
                          //                     snackBar(
                          //                       context,
                          //                       "You can't delete this comment",
                          //                       Colors.red,
                          //                     );
                          //                   }
                          //                 },
                          //               ),
                          //             ),
                          //           );
                          //         },
                          //       );
                          //     }
                          //   },
                          // )
                        ),
                        Container(
                          width: 330,
                          height: 40,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade300,
                              hintText: 'Write a Comment...',
                              helperStyle: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 14),
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.cancel_outlined, size: 20),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
