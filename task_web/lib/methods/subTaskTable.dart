import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SubTaskTable extends StatefulWidget {
  final List<Task> subtasks; // Add this parameter

  SubTaskTable({Key? key, required this.subtasks}) : super(key: key);

  @override
  State<SubTaskTable> createState() => _SubTaskTableState();
}

class _SubTaskTableState extends State<SubTaskTable> {
  String mainTaskId = ''; // Define the necessary variables
  String mainTaskTitle = '';
  String taskType = '';
  String taskTypeName = '';
  String taskCreateBy = '';
  String mainTaskFinishedBy = '';
  String mainTaskFinishedByDate = '';
  String dueDate = '';
  String taskCreateDate = '';
  String taskCreatedTimestamp = '';
  String taskStatusName = '';
  String taskStatus = '';
  String company = '';
  String sourceFrom = '';
  String assignTo = '';
  String userName = '';
  String userRole = '';
  String firstName = '';
  String lastName = '';
  List<Task> subTaskList = []; // Initialize subtask list

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
      taskType = (prefs.getString('main_task_type') ?? '');
      taskTypeName = (prefs.getString('main_task_type_name') ?? '');
      taskCreateBy = (prefs.getString('main_task_create_by') ?? '');
      mainTaskFinishedBy = (prefs.getString('main_task_finished_by') ?? '');
      mainTaskFinishedByDate =
      (prefs.getString('main_task_finished_by_date') ?? '');
      dueDate = (prefs.getString('main_task_due_date') ?? '');
      taskCreateDate = (prefs.getString('main_task_create_date') ?? '');
      taskCreatedTimestamp =
      (prefs.getString('main_task_created_timestamp') ?? '');
      taskStatusName = (prefs.getString('main_task_status_name') ?? '');
      taskStatus = (prefs.getString('main_task_status') ?? '');
      company = (prefs.getString('main_task_company') ?? '').toUpperCase();
      sourceFrom =
          (prefs.getString('main_task_source_from') ?? '').toUpperCase();
      assignTo = (prefs.getString('main_task_assign_to') ?? '').toUpperCase();
      userName = (prefs.getString('user_name') ?? '');
      userRole = (prefs.getString('user_role') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
      // ... Assign values from SharedPreferences ...
    });
    await getSubTaskListByMainTaskId(mainTaskId);
  }

  Future<void> getSubTaskListByMainTaskId(var taskId) async {
    subTaskList.clear();
    var data = {
      "main_task_id": "$taskId",
    };

    const url = "http://dev.connect.cbs.lk/subTaskListByMainTaskId.php";
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
      final responseJson = json.decode(res.body);
      setState(() {
        for (Map<String, dynamic> details in responseJson.cast<Map<String, dynamic>>()) {
          subTaskList.add(Task.fromJson(details));
        }
      });
    } else {
      throw Exception('Failed to load subtasks from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      height: 200,
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text('Subtask Title')),
            DataColumn(label: Text('Due Date')),
            DataColumn(label: Text('Assign To')),
            // Add more DataColumn widgets as needed
          ],
          rows: subTaskList.map((subtask) {
            return DataRow(
              cells: [
                DataCell(Text(subtask.taskTitle)),
                DataCell(Text(subtask.dueDate)),
                DataCell(Text(subtask.assignTo)),
                // Add more DataCell widgets as needed
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Task {
  String taskId;
  String taskTitle;
  String taskType;
  String dueDate;
  String taskTypeName;
  String taskDescription;
  String taskCreateById;
  String taskCreateBy;
  String taskCreateDate;
  String taskCreateMonth;
  String taskCreatedTimestamp;
  String taskStatus;
  String taskStatusName;
  String actionTakenById;
  String actionTakenBy;
  String actionTakenDate;
  String actionTakenTimestamp;
  String taskReopenBy;
  String taskReopenById;
  String taskReopenDate;
  String taskReopenTimestamp;
  String taskFinishedBy;
  String taskFinishedById;
  String taskFinishedByDate;
  String taskFinishedByTimestamp;
  String taskEditBy;
  String taskEditById;
  String taskEditByDate;
  String taskEditByTimestamp;
  String taskDeleteBy;
  String taskDeleteById;
  String taskDeleteByDate;
  String taskDeleteByTimestamp;
  String sourceFrom;
  String assignTo;
  String company;
  String documentNumber;

  Task(
      {required this.taskId,
        required this.taskTitle,
        required this.taskType,
        required this.dueDate,
        required this.taskTypeName,
        required this.taskDescription,
        required this.taskCreateById,
        required this.taskCreateBy,
        required this.taskCreateDate,
        required this.taskCreateMonth,
        required this.taskCreatedTimestamp,
        required this.taskStatus,
        required this.taskStatusName,
        required this.actionTakenById,
        required this.actionTakenBy,
        required this.actionTakenDate,
        required this.actionTakenTimestamp,
        required this.taskReopenBy,
        required this.taskReopenById,
        required this.taskReopenDate,
        required this.taskReopenTimestamp,
        required this.taskFinishedBy,
        required this.taskFinishedById,
        required this.taskFinishedByDate,
        required this.taskFinishedByTimestamp,
        required this.taskEditBy,
        required this.taskEditById,
        required this.taskEditByDate,
        required this.taskEditByTimestamp,
        required this.taskDeleteBy,
        required this.taskDeleteById,
        required this.taskDeleteByDate,
        required this.taskDeleteByTimestamp,
        required this.sourceFrom,
        required this.assignTo,
        required this.company,
        required this.documentNumber});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        taskId: json['task_id'],
        taskTitle: json['task_title'],
        taskType: json['task_type'],
        dueDate: json['due_date'],
        taskTypeName: json['task_type_name'],
        taskDescription: json['task_description'],
        taskCreateById: json['task_create_by_id'],
        taskCreateBy: json['task_create_by'],
        taskCreateDate: json['task_create_date'],
        taskCreateMonth: json['task_create_month'],
        taskCreatedTimestamp: json['task_created_timestamp'],
        taskStatus: json['task_status'],
        taskStatusName: json['task_status_name'],
        actionTakenById: json['action_taken_by_id'],
        actionTakenBy: json['action_taken_by'],
        actionTakenDate: json['action_taken_date'],
        actionTakenTimestamp: json['action_taken_timestamp'],
        taskReopenBy: json['task_reopen_by'],
        taskReopenById: json['task_reopen_by_id'],
        taskReopenDate: json['task_reopen_date'],
        taskReopenTimestamp: json['task_reopen_timestamp'],
        taskFinishedBy: json['task_finished_by'],
        taskFinishedById: json['task_finished_by_id'],
        taskFinishedByDate: json['task_finished_by_date'],
        taskFinishedByTimestamp: json['task_finished_by_timestamp'],
        taskEditBy: json['task_edit_by'],
        taskEditById: json['task_edit_by_id'],
        taskEditByDate: json['task_edit_by_date'],
        taskEditByTimestamp: json['task_edit_by_timestamp'],
        taskDeleteBy: json['task_delete_by'],
        taskDeleteById: json['task_delete_by_id'],
        taskDeleteByDate: json['task_delete_by_date'],
        taskDeleteByTimestamp: json['task_delete_by_timestamp'],
        sourceFrom: json['source_from'],
        assignTo: json['assign_to'],
        company: json['company'],
        documentNumber: json['document_number']);
  }
}
