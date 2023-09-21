import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components.dart';

class CreateSubTask extends StatefulWidget {
  const CreateSubTask({super.key});

  @override
  State<CreateSubTask> createState() => _CreateSubTaskState();
}

class _CreateSubTaskState extends State<CreateSubTask> {

  bool titleValidation = false;
  bool subTaskTitleValidation = false;
  bool descriptionValidation = false;
  int taskType = 1;
  String taskTypeString = "Top Urgent";
  String userName ='';
  String firstName ='';
  String lastName ='';
  String intentFrom ='';
  String userRole ='';
  String mainTaskId ='';
  String mainTaskTitle ='';
  List<String> assignTo = [];

  TextEditingController subTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController createTaskDueDateController = TextEditingController();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController assignToController = TextEditingController();

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
      intentFrom = (prefs.getString('intent_from') ?? '');
    });
  }


  Future<bool> createTask(BuildContext context, var mainTaskId) async {

    if (subTitleController.text.trim().isEmpty) {
      setState(() {
        subTaskTitleValidation = true;
        snackBar(context, "Sub task title can't be empty", Colors.redAccent);
      });
      return false;
    } else {
      setState(() {
        subTaskTitleValidation = false;
      });
    }

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;
    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);
    var stringDate = DateFormat('MM/dd/yyyy').format(dt);
    var stringMonth = DateFormat('MM/yyyy').format(dt);
    var taskId = "$userName#ST$taskTimeStamp";
    var url = "http://dev.connect.cbs.lk/createTask.php";

    var data = {
      "task_id": taskId,
      "main_task_id": "$mainTaskId",
      "task_title": subTitleController.text,
      "task_type": "$taskType",
      "task_type_name": taskTypeString,
      "due_date": createTaskDueDateController.text,
      "task_description": descriptionController.text,
      "task_create_by_id": userName,
      "task_create_by": "$firstName $lastName",
      "task_create_date": stringDate,
      "task_create_month": stringMonth,
      "task_created_timestamp": '$timeSt',
      "task_status": "0",
      "task_status_name": "Pending",
      "action_taken_by_id": "",
      "action_taken_by": "",
      "action_taken_date": "",
      "action_taken_timestamp": "0",
      "task_reopen_by": "",
      "task_reopen_by_id": "",
      "task_reopen_date": "",
      "task_reopen_timestamp": "0",
      "task_finished_by": "",
      "task_finished_by_id": "",
      "task_finished_by_date": "",
      "task_finished_by_timestamp": "0",
      "task_edit_by": "",
      "task_edit_by_id": "",
      "task_edit_by_date": "",
      "task_edit_by_timestamp": "0",
      "task_delete_by": "",
      "task_delete_by_id": "",
      "task_delete_by_date": "",
      "task_delete_by_timestamp": "0",
      "source_from": dropdownvalue1,
      "assign_to": assignToController.text,
      "company": dropdownvalue3
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
        descriptionController.text = "";
        subTitleController.text = "";
        assignToController.text = "";
        documentNumberController.text = "";
        createTaskDueDateController.text = "";
        assignTo.clear();
        snackBar(context, "Done", Colors.green);
        return true;
      } else {
        if (!mounted) return false;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return false;
      snackBar(context, "Error", Colors.redAccent);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 850, // Set the width of the dialog
        height: 500,
        color: Colors.white70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                const Text('Create Sub Task',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.cancel_outlined, size: 20),
                )
              ],
            ),

            Row(
              children: [
                Text(
                  mainTaskTitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),

    );
  }
}

