import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components.dart';
import '../methods/colors.dart';

enum menuitem {
  item1,
  item2,
  item3,
  item4,
  item5,
  item6,
  item7,
  item8,
  item9,
  item10,
  item11
}

class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({Key? key}) : super(key: key);

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  bool titleValidation = false;
  bool subTaskTitleValidation = false;
  bool descriptionValidation = false;
  int taskType = 1;
  String taskTypeString = "Top Urgent";
  // ignore: unused_field
  menuitem _mitem = menuitem.item1;
  late String userName = '';
  late String firstName = '';
  late String lastName = '';
  List<String> assignTo = [];

  TextEditingController titleController = TextEditingController();
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
      userName = (prefs.getString('user_name') ?? '');
      firstName = (prefs.getString('first_name') ?? '').toUpperCase();
      lastName = (prefs.getString('last_name') ?? '').toUpperCase();
    });
  }
  Future<bool> mainTask(BuildContext context) async {
    if (titleController.text.trim().isEmpty) {
      setState(() {
        titleValidation = true;
        snackBar(context, "Task title can't be empty", Colors.redAccent);
      });
      return false;
    } else {
      setState(() {
        titleValidation = false;
      });
    }

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int taskTimeStamp = timestamp;
    var timeSt = taskTimeStamp;
    var dt = DateTime.fromMillisecondsSinceEpoch(taskTimeStamp);
    var stringDate = DateFormat('MM/dd/yyyy').format(dt);
    var stringMonth = DateFormat('MM/yyyy').format(dt);
    var taskId = "$userName#MT$taskTimeStamp";
    var url = "http://dev.connect.cbs.lk/mainTask.php";
    var data = {
      "task_id": taskId,
      "task_title": titleController.text,
      "task_type": "$taskType",
      "task_type_name": taskTypeString,
      "due_date": createTaskDueDateController.text,
      "task_create_by_id": userName,
      "task_create_by": "$firstName $lastName",
      "task_create_date": stringDate,
      "task_create_month": stringMonth,
      "task_created_timestamp": '$timeSt',
      "task_status": "0",
      "task_status_name": "Pending",
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
      "company": dropdownvalue3,
      "document_number": documentNumberController.text,
      "action_taken_by_id": "",
      "action_taken_by": "",
      "priority": dropdownvalue4,
      "action_taken_date": "",
      "action_taken_timestamp": "0"
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
        createTask(context, taskId);
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
  Future<bool> createTask(BuildContext context, var mainTaskId) async {
    if (titleController.text.trim().isEmpty) {
      setState(() {
        titleValidation = true;
        snackBar(context, "Task title can't be empty", Colors.redAccent);
      });
      return false;
    } else {
      setState(() {
        titleValidation = false;
      });
    }

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
        width: 700, // Set the width of the dialog
        height: 500,
        color: Colors.white70,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      hintText: 'Task Title',
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 600,
              height: 280,
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 6,
                                bottom: 10,
                                top: 10,
                                right: 4,
                              ),
                              child: Text(
                                'Due Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColor.drawerLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18, bottom: 18, top: 18),
                          child: Text(
                            'Source From', // Updated text here
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColor.drawerLight),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18, bottom: 18, top: 18),
                          child: Text(
                            'Assign To',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColor.drawerLight),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18, bottom: 18, top: 18),
                          child: Text(
                            'Company',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColor.drawerLight),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 18, bottom: 18, top: 18),
                          child: Text(
                            'Priority',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColor.drawerLight),
                          ),
                        ),
                        // Add more text fields here
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 2,
                  ),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: createTaskDueDateController,
                              onTap: () {
                                selectDate(context, createTaskDueDateController);
                              },
                              decoration: InputDecoration(
                                hintText: 'Due Date',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    selectDate(context, createTaskDueDateController);
                                  },
                                  icon: Icon(
                                    Icons.date_range,
                                    color: Colors.blue,
                                    size: 12,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue1,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                ),
                                items: items1.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue1 = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 2),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue2,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                ),
                                items: items2.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue2 = newValue!;
                                    assignTo.add(dropdownvalue2);
                                    assignToController.text = assignTo.toString();
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 2),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue3,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                ),
                                items: items3.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue3 = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue4,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                ),
                                items: items4.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue4 = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 20), // Add spacing between the form and buttons
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: MaterialButton(
                      color: Colors.deepPurple,
                      onPressed: () {
                        titleController.text = "";
                        descriptionController.text = "";
                        subTitleController.text = "";
                        assignToController.text = "";
                        documentNumberController.text = "";
                        createTaskDueDateController.text = "";
                        assignTo.clear();
                      },
                      child: Text(
                        'CLEAR',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: MaterialButton(
                      color: Colors.deepPurple,
                      onPressed: () {
                        mainTask(context);
                      },
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
