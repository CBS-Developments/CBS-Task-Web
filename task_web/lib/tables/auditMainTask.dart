import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_web/tables/taskTable.dart';
import 'package:http/http.dart' as http;
import '../methods/colors.dart';
import '../pages/openTaskNew.dart';
import '../sizes/pageSizes.dart';


class AuditMainTaskTable extends StatefulWidget {
  const AuditMainTaskTable({super.key});

  @override
  State<AuditMainTaskTable> createState() => _AuditMainTaskTableState();
}

class _AuditMainTaskTableState extends State<AuditMainTaskTable> {
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
          columns:  [
            DataColumn(
              label: Text(
                'Task Title',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.table,fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Company',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.table,fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Start-Date',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.table,fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Due-Date',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.table,fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Assignee',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.table,fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Priority',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.table,fontSize: 11),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.table,fontSize: 11),
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
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OpenTaskNew(
                      task: task,
                      userRoleForDelete: userRole,
                      userName: userName,
                      firstName: firstName,
                      lastName: lastName,)),); // Show the popup
                },),

              DataCell(Text(task.company,style: TextStyle(fontSize: 10),)),
              DataCell(Text(task.taskCreateDate,style: TextStyle(fontSize: 10),)), // Display Start-Date
              DataCell(Text(task.dueDate,style: TextStyle(fontSize: 10),)),
              DataCell(Text(task.assignTo,style: TextStyle(fontSize: 10),)),
              DataCell(Text(task.taskTypeName,style: TextStyle(fontSize: 10),)),
              DataCell(Text(task.taskStatusName,style: TextStyle(fontSize: 10),)),

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
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OpenTaskNew(task: task, userRoleForDelete: userRole, userName: userName,
                      firstName: firstName,
                      lastName: lastName,)),
                  );
                  // _showTaskDetailsDialog(
                  //     context, task); // Show the popup
                },
              ),


              DataCell(Text(task.company,style: TextStyle(fontSize: 10),)),
              DataCell(Text(task.taskCreateDate,style: TextStyle(fontSize: 10),)), // Display Start-Date
              DataCell(Text(task.dueDate,style: TextStyle(fontSize: 10),)),
              DataCell(Text(task.assignTo,style: TextStyle(fontSize: 10),)),
              DataCell(Text(task.taskTypeName,style: TextStyle(fontSize: 10),)),
              DataCell(Text(task.taskStatusName,style: TextStyle(fontSize: 10),)),
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

    const url = "http://dev.workspace.cbs.lk/mainTaskListAudit.php";
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
        int pendingTaskCount = mainTaskList.where((task) => task.taskStatus == "0").length;
        int inProgressTaskCount = mainTaskList.where((task) => task.taskStatus == "1").length;
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


