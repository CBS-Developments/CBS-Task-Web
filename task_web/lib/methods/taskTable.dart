import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this package for date formatting
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../sizes/pageSizes.dart';

class TaskTable extends StatefulWidget {
  @override
  _TaskTableState createState() => _TaskTableState();
}

class _TaskTableState extends State<TaskTable> {
  List<MainTask> mainTaskList = [];
  List<MainTask> searchResultAsMainTaskList = [];
  TextEditingController taskListController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getPageWidth(context) - 260,
      height: 450,
      color: Colors.white,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Task Title')),
          DataColumn(label: Text('Company')),
          DataColumn(label: Text('Start-Date')),
          DataColumn(label: Text('Due-Date')),
          DataColumn(label: Text('Assignee')),
          DataColumn(label: Text('Priority')),
          DataColumn(label: Text('Status')),
          // Add more DataColumn as needed
        ],
        rows: (searchResultAsMainTaskList.isNotEmpty ||
            taskListController.text.isNotEmpty)
            ? searchResultAsMainTaskList.map((task) {
          return DataRow(cells: [
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(task.taskTitle),
                Text(task.taskId)
              ],
            )),
            DataCell(Text(task.company)),
            DataCell(Text(task.taskCreateDate)), // Display Start-Date
            DataCell(Text(task.dueDate)),
            DataCell(Text(task.assignTo)),
            DataCell(Text(task.taskTypeName)),
            DataCell(Text(task.taskStatusName)),

            // Add more DataCell with other properties
          ]);
        }).toList()
            : mainTaskList.map((task) {
          return DataRow(cells: [
            DataCell(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(task.taskTitle),
                Text(task.taskId)
              ],
            )),
            DataCell(Text(task.company)),
            DataCell(Text(task.taskCreateDate)), // Display Start-Date
            DataCell(Text(task.dueDate)),
            DataCell(Text(task.assignTo)),
            DataCell(Text(task.taskTypeName)),
            DataCell(Text(task.taskStatusName)),
            // Add more DataCell with other properties
          ]);
        }).toList(),
      ),
    );
  }

  void onSearchTextChangedUser(String text) {
    searchResultAsMainTaskList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    for (var taskList in mainTaskList) {
      if (taskList.taskId.contains(text) ||
          taskList.taskId.toLowerCase().contains(text) ||
          // Add more conditions for other properties
          taskList.taskStatusName.toUpperCase().contains(text)) {
        searchResultAsMainTaskList.add(taskList);
      }
    }

    setState(() {});
  }

  Future<void> getTaskList() async {
    mainTaskList.clear();
    var data = {};

    const url = "http://dev.connect.cbs.lk/mainTaskList.php";
    http.Response res = await http.post(
      url,
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
      });
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}

class MainTask {
  String taskId;
  String taskTitle;
  String taskType;
  String taskTypeName;
  String dueDate;
  String taskCreateById;
  String taskCreateBy;
  String taskCreateDate;
  String taskCreateMonth;
  String taskCreatedTimestamp;
  String taskStatus;
  String taskStatusName;
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

  MainTask({
    required this.taskId,
    required this.taskTitle,
    required this.taskType,
    required this.taskTypeName,
    required this.dueDate,
    required this.taskCreateById,
    required this.taskCreateBy,
    required this.taskCreateDate,
    required this.taskCreateMonth,
    required this.taskCreatedTimestamp,
    required this.taskStatus,
    required this.taskStatusName,
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
    required this.documentNumber,
  });

  factory MainTask.fromJson(Map<String, dynamic> json) {
    return MainTask(
      taskId: json['task_id'],
      taskTitle: json['task_title'],
      taskType: json['task_type'],
      taskTypeName: json['task_type_name'],
      dueDate: json['due_date'],
      taskCreateById: json['task_create_by_id'],
      taskCreateBy: json['task_create_by'],
      taskCreateDate: json['task_create_date'],
      taskCreateMonth: json['task_create_month'],
      taskCreatedTimestamp: json['task_created_timestamp'],
      taskStatus: json['task_status'],
      taskStatusName: json['task_status_name'],
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
      documentNumber: json['document_number'],
    );
  }
}
