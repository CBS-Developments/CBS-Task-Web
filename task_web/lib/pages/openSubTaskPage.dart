import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/pages/editSubTask.dart';
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
import 'openTaskNew.dart';

class OpenSubTaskNew extends StatefulWidget {
  final String userRoleForDelete;
  final String userName;
  final String firstName;
  final String lastName;
  final Task task; // Make sure Task is imported and defined
  OpenSubTaskNew(
      {Key? key,
      required this.task,
      required this.userRoleForDelete,
      required this.userName,
      required this.firstName,
      required this.lastName})
      : super(key: key);

  @override
  State<OpenSubTaskNew> createState() => _OpenSubTaskNewState();
}

class _OpenSubTaskNewState extends State<OpenSubTaskNew> {
  String userName = '';
  String firstName = '';
  String lastName = '';
  String userRole = '';
  List<comment> comments = [];
  TextEditingController subTaskCommentController = TextEditingController();
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
      "action_taken_date": getCurrentDateTime(),
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

  Future<bool> createMainTaskComment(
    BuildContext context, {
    required userName,
    required taskID,
    required firstName,
    required lastName,
  }) async {
    // Validate input fields
    if (subTaskCommentController.text.trim().isEmpty) {
      // Show an error message if the combined fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return false;
    }

    var url = "http://dev.workspace.cbs.lk/createComment.php";

    var data = {
      "comment_id": getCurrentDateTime(),
      "task_id": taskID,
      "comment": subTaskCommentController.text,
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
        subTaskCommentController.clear();
        snackBar(context, "Comment Added Successfully", Colors.green);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OpenSubTaskNew(
                  task: widget.task,
                  userRoleForDelete: widget.userRoleForDelete,
                  userName: widget.userName,
                  firstName: widget.firstName,
                  lastName: widget.lastName)),
        );
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
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
            content:
                const Text('Are you sure you want to delete this Comment?'),
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
                builder: (context) => OpenSubTaskNew(
                    task: widget.task,
                    userRoleForDelete: widget.userRoleForDelete,
                    userName: widget.userName,
                    firstName: widget.firstName,
                    lastName: widget.lastName)),
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
                  width: 500,
                  height: 500,
                  // color: Colors.greenAccent,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          tooltip: 'Back To List',
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
                          icon: Icon(Icons.arrow_back_rounded),
                        ),
                        SizedBox(height: 5,),
                        SizedBox(
                          width: 500,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sub Task ID : ${task.taskId}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                '${task.categoryName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 500,
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
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditSubTaskPage(
                                                        currentTitle:
                                                            task.taskTitle,
                                                        currentDescription: task
                                                            .taskDescription,
                                                        currentBeneficiary:
                                                            task.company,
                                                        currentDueDate:
                                                            task.dueDate,
                                                        currentAssignTo:
                                                            task.assignTo,
                                                        currentPriority:
                                                            task.taskTypeName,
                                                        currentSourceFrom:
                                                            task.sourceFrom,
                                                        currentCategory:
                                                            task.categoryName,
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
                                      showDeleteConfirmationDialog(
                                          context,
                                          widget.userRoleForDelete,
                                          widget.task.taskId);
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
                                            '${task.taskCreateDate}',
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
                                            '${task.dueDate}',
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
                                        '${task.company}',
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
                                        '${task.assignTo}',
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
                                        '${task.taskTypeName}',
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
                                        '${task.taskStatusName}',
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
                                        '${task.taskCreateBy}',
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
                        SizedBox(
                          height: 10,
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
                                  onPressed: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Mark As Complete',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.green),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 480,
                          height: 35,
                          color: Colors.grey.shade300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                          height: 50,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(),
                Container(
                  width: 560,
                  height: 500,
                  // color: Colors.lightBlueAccent,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),

                      Container(
                        width: 560,
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
                        width: 560,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data[index].commnt,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.blueAccent),
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
                                                            color: Colors.grey),
                                                      ),
                                                      Text(
                                                        '    by: ',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.grey),
                                                      ),
                                                      Text(
                                                        data[index]
                                                            .commentCreateBy,
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.grey),
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

                                                    showDeleteCommentConfirmation(
                                                        context,
                                                        data[index].commentId,
                                                        data[index]
                                                            .commentCreateBy,
                                                        '${widget.firstName} ${widget.lastName}');
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
                        width: 560,
                        height: 80,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: subTaskCommentController,
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
              ],
            )),
      ),
    );
  }
}
