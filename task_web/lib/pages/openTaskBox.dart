import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/methods/colors.dart';
import 'package:task_web/methods/subTaskTable.dart';
import 'package:task_web/pages/editMainTask.dart';
import '../components.dart';
import '../methods/taskTable.dart';
import 'package:http/http.dart' as http;

import 'createSubTask.dart';

class TaskDetailsDialog extends StatefulWidget {
  final MainTask task;

  TaskDetailsDialog(this.task);

  @override
  State<TaskDetailsDialog> createState() => _TaskDetailsDialogState();
}

class _TaskDetailsDialogState extends State<TaskDetailsDialog> {
  String userName ='';
  String firstName='';
  String lastName='';
  String userRole='';
  String mainTaskId='';
  String mainTaskTitle='';

  TextEditingController mainTaskCommentController = TextEditingController();

  Future<bool> createCommentMainTask(BuildContext context) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;

    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);

    var stringDate = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);

    var string = mainTaskCommentController.text.replaceAll("u0027", "'");

    var url = "http://dev.connect.cbs.lk/" + "createComment.php";
    var data = {
      "comment_id": "$timeSt",
      "task_id": mainTaskId,
      "comment": string,
      "comment_create_by_id": userName,
      "comment_create_by": "$firstName $lastName",
      "comment_create_date": stringDate,
      "comment_created_timestamp": "$timeSt",
      "comment_status": "1",
      "comment_edit_by": "",
      "comment_edit_by_id": '',
      "comment_edit_by_date": "",
      "comment_edit_by_timestamp": "",
      "comment_delete_by": "",
      "comment_delete_by_id": "",
      "comment_delete_by_date": "",
      "comment_delete_by_timestamp": "",
    };

    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode.toString() == "200") {
      if (jsonDecode(res.body) == "true") {
        mainTaskCommentController.text = "";

        setState(() {
          getMainTaskCommentList(mainTaskId);
        });
        return true;
      } else {
        if (!mounted) return false;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return false; // Return false in case of error
  }

  Future<List<comment>> getMainTaskCommentList(var taskId) async {
    var data = {
      "task_id": "$taskId",
    };

    const url = "http://dev.connect.cbs.lk/commentListById.php";
    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode == 200) {
      if (jsonDecode(res.body) != "Error") {
        List jsonResponse = json.decode(res.body);
        if (jsonResponse != null) {
          return jsonResponse.map((sec) => comment.fromJson(sec)).toList();
        }
      }
    } else {
      throw Exception('Failed to load jobs from API');
    }
    return []; // Return an empty list in case of error
  }

  Future<void> deleteCommentInMainTask(
      var commentId, var commentStatus, var userName, var name) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;

    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);

    var stringDate = DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
    String url;

    url = "http://dev.connect.cbs.lk/deleteComment.php";
    var data = {
      "comment_id": "$commentId",
      "comment_delete_by": "$userName",
      "comment_delete_by_id": "$name",
      "action_taken_by": "$name",
      "comment_delete_by_date": stringDate,
      "comment_delete_by_timestamp": "$timeSt",
    };

    http.Response res = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (res.statusCode.toString() == "200") {
      if (jsonDecode(res.body) == "true") {
        setState(() {
          getMainTaskCommentList(mainTaskId);
        });
        snackBar(context, "Delete", Colors.redAccent);
      }
    } else {
      snackBar(context, "Error", Colors.redAccent);
    }
  }

  @override
  void initState() {
    super.initState();
    retrieverData();
  }

  void retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mainTaskId = (prefs.getString('main_task_id') ?? '');
      mainTaskTitle = (prefs.getString('main_task_title') ?? '');
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
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
                          '${widget.task.taskTitle}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditMainTask(
                                      lastName: '',
                                      firstName: '',
                                      userName: '',
                                      assign_to: '',
                                      company: widget.task.company,
                                      documentNumber: widget.task.documentNumber,
                                      dueDate: widget.task.dueDate,
                                      mainTaskId: widget.task.taskId,
                                      sourceFrom: widget.task.sourceFrom,
                                      taskCreateBy: widget.task.taskCreateBy,
                                      taskCreateDate: widget.task.taskCreateDate,
                                      taskCreatedTimestamp:
                                      widget.task.taskCreatedTimestamp,
                                      taskStatus: widget.task.taskStatus,
                                      taskStatusName: widget.task.taskStatusName,
                                      taskTitle: widget.task.taskTitle,
                                      taskType: widget.task.taskType,
                                      taskTypeName: widget.task.taskTypeName,
                                    );
                                  },
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
                              onPressed: () {},
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
                      '${widget.task.taskId}',
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
                                          left: 4, bottom: 8, top: 8, right: 4),
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
                                          left: 4, bottom: 8, top: 8, right: 4),
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
                                          left: 4, bottom: 8, top: 8, right: 4),
                                      child: Text(
                                        '${widget.task.taskCreateDate}',
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
                                          left: 4, bottom: 8, top: 8, right: 4),
                                      child: Text(
                                        '${widget.task.dueDate}',
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
                                    '${widget.task.company}',
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
                                    '${widget.task.assignTo}',
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
                                    '${widget.task.taskTypeName}',
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
                                    '${widget.task.taskStatusName}',
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
                                    '${widget.task.taskCreateBy}',
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
                    SubTaskTable(subtasks: const []),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      child:FutureBuilder<List<comment>>(
                        future: getMainTaskCommentList(mainTaskId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Display a loading indicator while fetching data
                          } else if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text("No comments available"); // Replace with your custom message
                          } else {
                            List<comment>? data = snapshot.data;
                            return ListView.builder(
                              itemCount: data!.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    title: SelectableText(
                                      data[index].commnt,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${data[index].commentCreateDate}      ${data[index].commentCreateBy}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        size: 14,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        if (data[index].commentCreateById == userName) {
                                          deleteCommentInMainTask(
                                            data[index].commentId,
                                            "0",
                                            userName,
                                            "$firstName $lastName",
                                          );
                                        } else {
                                          snackBar(
                                            context,
                                            "You can't delete this comment",
                                            Colors.red,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      )

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
    );
  }
}
