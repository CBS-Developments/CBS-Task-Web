import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/pages/createSubTaskNew.dart';
import 'package:task_web/pages/taskMainPage.dart';
import 'package:http/http.dart' as http;
import 'package:task_web/pages/taskPageAll.dart';
import 'package:task_web/pages/taskPageFive.dart';
import 'package:task_web/pages/taskPageFour.dart';
import 'package:task_web/pages/taskPageOne.dart';
import 'package:task_web/pages/taskPageSix.dart';
import 'package:task_web/pages/taskPageThree.dart';
import 'package:task_web/pages/taskPageTwo.dart';

import '../components.dart';
import '../methods/appBar.dart';
import '../methods/colors.dart';
import '../tables/subTaskTable.dart';
import '../tables/taskTable.dart';
import 'editMainTask.dart';
import 'dart:html' as html;

class OpenTaskNew extends StatefulWidget {
  final String userRoleForDelete;
  final String userName;
  final String firstName;
  final String lastName;
  final MainTask task;

  OpenTaskNew(
      {Key? key,
      required this.task,
      required this.userRoleForDelete,
      required this.userName,
      required this.firstName,
      required this.lastName})
      : super(key: key);

  @override
  State<OpenTaskNew> createState() => _OpenTaskNewState();
}

class _OpenTaskNewState extends State<OpenTaskNew> {
  String userName = '';

  String firstName = '';
  String lastName = '';
  String userRole = '';
  // List<comment> commentList = []; // Initialize subtask list
  TextEditingController mainTaskCommentController = TextEditingController();
  List<comment> comments = [];

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

  Future<void> retrieverData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
    print('User Name: $userName');
  }

  void showDeleteConfirmationDialog(
    BuildContext context,
    String userRole,
    String taskId,
  ) {
    print('User Role in showDeleteConfirmationDialog: $userRole');
    if (userRole == '1') {
      print(userRole);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  deleteMainTask(taskId); // Call the deleteMainTask method
                  Navigator.of(context).pop(); // Close the dialog
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
            title: const Text('Permission Denied'),
            content: const Text('Only admins are allowed to delete tasks.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
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
      "action_taken_date": getCurrentDateTime(),
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
              return const TaskPageAll();
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

  Future<bool> markInProgressMainTask(
    String taskID,
  ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status": '1',
      "task_status_name": 'In Progress',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDateTime(),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const TaskPageOne();
            }),
          );
          snackBar(
              context, "Main Marked as In Progress successful!", Colors.green);

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

  Future<bool> markAsCompletedMainTask(
    String taskID,
  ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_status": '2',
      "task_status_name": 'Completed',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDateTime(),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const TaskPageOne();
            }),
          );
          snackBar(context, "Main Marked Completed successful!", Colors.green);

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

  Future<List<comment>> getCommentList(String taskId) async {
    comments
        .clear(); // Assuming that `comments` is a List<Comment> in your class

    var data = {
      "task_id": taskId,
    };

    const url = "http://dev.workspace.cbs.lk/commentListById.php";
    http.Response response = await http.post(
      Uri.parse(url),
      body: data,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        return jsonResponse.map((sec) => comment.fromJson(sec)).toList();
      }

      return [];
    } else {
      throw Exception(
          'Failed to load data from the API. Status Code: ${response.statusCode}');
    }
  }

  Future<bool> createMainTaskComment(
    BuildContext context, {
    required userName,
    required taskID,
    required firstName,
    required lastName,
  }) async {
    // Validate input fields
    if (mainTaskCommentController.text.trim().isEmpty) {
      // Show an error message if the combined fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return false;
    }

    var url = "http://dev.workspace.cbs.lk/createComment.php";

    var data = {
      "comment_id": getCurrentDateTime(),
      "task_id": taskID,
      "comment": mainTaskCommentController.text,
      "comment_create_by_id": userName,
      "comment_create_by": firstName + ' ' + lastName,
      "comment_create_date": getCurrentDate(),
      "comment_created_timestamp": getCurrentDateTime(),
      "comment_status": "1",
      "comment_edit_by": "",
      "comment_edit_by_id": '',
      "comment_edit_by_date": "",
      "comment_edit_by_timestamp": "",
      "comment_delete_by": "",
      "comment_delete_by_id": "",
      "comment_delete_by_date": "",
      "comment_delete_by_timestamp": "",
      "comment_attachment": '',
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
        if (!mounted) return true;
        mainTaskCommentController.clear();
        snackBar(context, "Comment Added Successfully", Colors.green);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OpenTaskNew(
                    task: widget.task,
                    userRoleForDelete: widget.userRoleForDelete,
                    userName: widget.userName,
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                  )),
        );
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }

  void showDeleteCommentConfirmation(
      BuildContext context,
      String commentID,
      String createBy,
      String nameNowUser,
      ) {
    print('Now user: $nameNowUser');
    if (createBy == nameNowUser) {
      print(createBy);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this Comment?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  deleteComment(commentID);
                  // deleteMainTask(taskId); // Call the deleteMainTask method
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    } else {
      // Display a message or take other actions for users who are not admins
      print(createBy);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text('Only your comments allowed to delete.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
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

  Future<bool> deleteComment(
      String commentId,
      ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "comment_id": commentId,
      "comment_delete_by": widget.userName,
      "comment_delete_by_id": widget.firstName,
      "comment_delete_by_date": getCurrentDate(),
      "comment_delete_by_timestamp": getCurrentDateTime(),
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/deleteComment.php";

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
          snackBar(context, "Comment Deleted successful!", Colors.redAccent);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OpenTaskNew(
                  task: widget.task,
                  userRoleForDelete: widget.userRoleForDelete,
                  userName: widget.userName,
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                )),
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

  void showSuccessSnackBar(BuildContext context) {
    final snackBar = const SnackBar(
      content: Text('Comment Added Successfully'),
      backgroundColor: Colors.green, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    retrieverData();

    setState(() {
      print("Done");
      getCommentList(widget.task.taskId);
    });
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
          width: 1250,
          height: 550,
          color: Colors.white,
          child: SizedBox(
            width: 1120,
            height: 550,
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 700,
                    height: 550,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.task.taskTitle,
                              style: const TextStyle(
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
                                  icon: const Icon(
                                    Icons.edit_note_rounded,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDeleteConfirmationDialog(
                                        context,
                                        widget.userRoleForDelete,
                                        widget.task.taskId);
                                  },
                                  tooltip: 'Delete Task',
                                  icon: const Icon(
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
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.task.category_name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
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
                                        const Icon(
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
                              const VerticalDivider(
                                thickness: 2,
                              ),
                              SizedBox(
                                height: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
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
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Icon(
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
                                            style: const TextStyle(
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
                                        style: const TextStyle(
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
                                        style: const TextStyle(
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
                                        style: const TextStyle(
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
                                        style: const TextStyle(
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
                                        style: const TextStyle(
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
                              onPressed: () {
                                if (widget.task.taskStatus == '0') {
                                  markInProgressMainTask(widget.task.taskId);
                                  // Handle 'Mark In Progress' action
                                } else if (widget.task.taskStatus == '1') {
                                  markAsCompletedMainTask(widget.task.taskId);
                                  // Handle 'Mark As Complete' action
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.task.taskStatus == '0'
                                      ? 'Mark In Progress'
                                      : 'Mark As Complete',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: widget.task.taskStatus == '0'
                                        ? Colors.blueAccent
                                        : Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateSubTaskNew(
                                        username: widget.userName,
                                        firstName: widget.firstName,
                                        lastName: widget.lastName,
                                        mainTaskId: widget.task.taskId,
                                        task: widget.task,
                                        userRole: widget.userRoleForDelete,
                                      ),
                                    ));
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Add Sub Task',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.green),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Subtasks',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // SubTaskTableNew(mainTaskId: widget.task.taskId)
                        SubTaskTable(mainTaskId: widget.task.taskId)
                      ],
                    ),
                  ),
                  const VerticalDivider(),
                  Container(
                    width: 490,
                    height: 550,
                    child: Column(
                      children: [
                        Container(
                          width: 460,
                          height: 40,
                          color: Colors.grey.shade300,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                          width: 460,
                          height: 5,
                          color: Colors.white,
                        ),
                        Container(
                          width: 460,
                          height: 35,
                          color: Colors.grey.shade300,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Comments',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 460,
                          height: 350,
                          color: Colors.white,
                          child: FutureBuilder<List<comment>>(
                            future: getCommentList(widget.task.taskId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<comment>? data = snapshot.data;
                                return ListView.builder(
                                  itemCount: data!.length,
                                  itemBuilder: (context, index) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data[index].commnt,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .blueAccent),
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          data[index]
                                                              .commentCreatedTimestamp,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Text(
                                                          '    by: ',
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Text(
                                                          data[index]
                                                              .commentCreateBy,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      // showDeleteCommentConfirmation(context, data[index]
                                                      //     .commentCreateBy, '${widget.firstName} ${widget.lastName}',data[index]
                                                      //     .commentId);

                                                      showDeleteCommentConfirmation(context, data[index].commentId, data[index].commentCreateBy, '${widget.firstName} ${widget.lastName}');
                                                    },
                                                    icon: Icon(
                                                      Icons.delete_rounded,
                                                      color: Colors.redAccent,
                                                      size: 16,
                                                    ))
                                              ],
                                            ),
                                            // You can add more ListTile properties as needed
                                          ),
                                          Divider()
                                          // Add dividers or spacing as needed between ListTiles
                                          // Example: Adds a divider between ListTiles
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return const Text("-Empty-");
                              }
                              return const Text("Loading...");
                            },
                          ),
                        ),
                        Container(
                          width: 460,
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: mainTaskCommentController,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  maxLines:
                                      3, // Adjust the number of lines as needed
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.shade300,
                                    hintText: 'Write a Comment...',
                                    helperStyle: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 14),
                                    filled: true,
                                  ),
                                ),
                              ),
                              const Icon(Icons
                                  .attach_file_outlined), // Replace 'icon1' with the first icon you want to use
                              const SizedBox(
                                  width:
                                      8), // Adjust the spacing between the icons
                              IconButton(
                                tooltip: 'Add Comment',
                                onPressed: () {
                                  createMainTaskComment(context,
                                      userName: widget.userName,
                                      taskID: widget.task.taskId,
                                      firstName: widget.firstName,
                                      lastName: widget.lastName);
                                  //   getCommentList(widget.task.taskId);
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () {
                      // Check the category and decide the page to navigate to
                      if (widget.task.category == "0") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPageOne()),
                        );
                      } else if (widget.task.category == "1") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPageTwo()),
                        );
                      } else if (widget.task.category == "2") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPageThree()),
                        );
                      } else if (widget.task.category == "3") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPageFour()),
                        );
                      } else if (widget.task.category == "4") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPageFive()),
                        );
                      } else if (widget.task.category == "5") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPageSix()),
                        );
                      } else {
                        // Handle other categories or provide a default navigation
                        snackBar(context, "Unknown Category", Colors.red);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskPageAll()),
                        );
                      }
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 20),
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

class comment {
  String commentId;
  String taskId;
  String commnt;
  String commentCreateById;
  String commentCreateBy;
  String commentCreateDate;
  String commentCreatedTimestamp;
  String commentStatus;
  String commentEditBy;
  String commentEditById;
  String commentEditByDate;
  String commentEditByTimestamp;
  String commentDeleteBy;
  String commentDeleteById;
  String commentDeleteByDate;
  String commentDeleteByTimestamp;
  String commentAttachment;

  comment({
    required this.commentId,
    required this.taskId,
    required this.commnt,
    required this.commentCreateById,
    required this.commentCreateBy,
    required this.commentCreateDate,
    required this.commentCreatedTimestamp,
    required this.commentStatus,
    required this.commentEditBy,
    required this.commentEditById,
    required this.commentEditByDate,
    required this.commentEditByTimestamp,
    required this.commentDeleteBy,
    required this.commentDeleteById,
    required this.commentDeleteByDate,
    required this.commentDeleteByTimestamp,
    required this.commentAttachment,
  });

  factory comment.fromJson(Map<String, dynamic> json) {
    return comment(
        commentId: json['comment_id'],
        taskId: json['task_id'],
        commnt: json['comment'],
        commentCreateById: json['comment_create_by_id'],
        commentCreateBy: json['comment_create_by'],
        commentCreateDate: json['comment_create_date'],
        commentCreatedTimestamp: json['comment_created_timestamp'],
        commentStatus: json['comment_status'],
        commentEditBy: json['comment_edit_by'],
        commentEditById: json['comment_edit_by_id'],
        commentEditByDate: json['comment_edit_by_date'],
        commentEditByTimestamp: json['comment_edit_by_timestamp'],
        commentDeleteBy: json['comment_delete_by'],
        commentDeleteById: json['comment_delete_by_id'],
        commentDeleteByDate: json['comment_delete_by_date'],
        commentDeleteByTimestamp: json['comment_delete_by_timestamp'],
        commentAttachment: json['comment_attachment']);
  }
}
