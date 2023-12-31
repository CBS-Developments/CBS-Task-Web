import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/methods/colors.dart';

import 'package:task_web/pages/openTaskNew.dart';
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
  String userName = "";
  String firstName = "";
  String lastName = "";
  String phone = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    getTaskList();
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
    print('User Role In Table: $userRole');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getPageWidth(context) - 395,
      height: 490,
      color: Colors.white,
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                'Task Title',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.table,
                    fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Company',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.table,
                    fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Start-Date',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.table,
                    fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Due-Date',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.table,
                    fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Assignee',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.table,
                    fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Priority',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.table,
                    fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.table,
                    fontSize: 11),
              ),
            ),
            // Add more DataColumn as needed
          ],
          rows: (searchResultAsMainTaskList.isNotEmpty ||
                  taskListController.text.isNotEmpty)
              ? searchResultAsMainTaskList.map((task) {
                  return DataRow(cells: [
                    DataCell(
                      SingleChildScrollView(
                        child: Text(
                          task.taskTitle,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OpenTaskNew(
                                    task: task,
                                    userRoleForDelete: userRole,
                                    userName: userName,
                                    firstName: firstName,
                                    lastName: lastName,
                                  )),
                        ); // Show the popup
                      },
                    ),

                    DataCell(Text(
                      task.company,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      task.taskCreateDate,
                      style: TextStyle(fontSize: 10),
                    )), // Display Start-Date
                    DataCell(Text(
                      task.dueDate,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      task.assignTo,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      task.taskTypeName,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      task.taskStatusName,
                      style: TextStyle(fontSize: 10),
                    )),

                    // Add more DataCell with other properties
                  ]);
                }).toList()
              : mainTaskList.map((task) {
                  return DataRow(cells: [
                    DataCell(
                      SingleChildScrollView(
                        child: Text(
                          task.taskTitle,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OpenTaskNew(
                                    task: task,
                                    userRoleForDelete: userRole,
                                    userName: userName,
                                    firstName: firstName,
                                    lastName: lastName,
                                  )),
                        );
                        // _showTaskDetailsDialog(
                        //     context, task); // Show the popup
                      },
                    ),

                    DataCell(Text(
                      task.company,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      task.taskCreateDate,
                      style: TextStyle(fontSize: 10),
                    )), // Display Start-Date
                    DataCell(Text(
                      task.dueDate,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      task.assignTo,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      task.taskTypeName,
                      style: TextStyle(fontSize: 10),
                    )),
                    DataCell(Text(
                      task.taskStatusName,
                      style: TextStyle(fontSize: 10),
                    )),
                    // Add more DataCell with other properties
                  ]);
                }).toList(),
        ),
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

    const url = "http://dev.workspace.cbs.lk/mainTaskList.php";
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
        mainTaskList.sort(
            (a, b) => b.taskCreatedTimestamp.compareTo(a.taskCreatedTimestamp));

        // Count tasks with taskStatus = 0
        int pendingTaskCount =
            mainTaskList.where((task) => task.taskStatus == "0").length;
        int inProgressTaskCount =
            mainTaskList.where((task) => task.taskStatus == "1").length;
        int allTaskCount = mainTaskList.length;
        print("Pending Task: $pendingTaskCount");
        print("All Task: $allTaskCount");
        print("In Progress Task: $inProgressTaskCount");
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
  String task_description;
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
  String category_name;
  String category;

  MainTask({
    required this.taskId,
    required this.taskTitle,
    required this.taskType,
    required this.taskTypeName,
    required this.dueDate,
    required this.task_description,
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
    required this.category_name,
    required this.category,
  });

  factory MainTask.fromJson(Map<String, dynamic> json) {
    return MainTask(
      taskId: json['task_id'],
      taskTitle: json['task_title'],
      taskType: json['task_type'],
      taskTypeName: json['task_type_name'],
      dueDate: json['due_date'],
      task_description: json['task_description'],
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
      category_name: json['category_name'],
      category: json['category'],
    );
  }
}
