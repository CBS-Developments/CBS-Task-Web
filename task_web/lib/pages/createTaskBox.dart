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
  _CreateTaskDialogState createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  bool titleValidation = false;
  bool subTaskTitleValidation = false;
  bool descriptionValidation = false;
  int taskType = 1;
  String taskTypeString = "Top Urgent";
  // ignore: unused_field
  menuitem _mitem = menuitem.item1;
  late String userName;
  late String firstName;
  late String lastName;
  List<String> assignTo = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController createTaskDueDateController = TextEditingController();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController assignToController = TextEditingController();
  bool _isEditingTitle = true;
  DateTime? _selectedDueDate;

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

  // @override
  // void dispose() {
  //   _titleController.dispose();
  //   _descriptionController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _isEditingTitle
          ? TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Task Title",
              ),
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  _isEditingTitle = true;
                });
              },
              child: const Text("Task Title"),
            ),
      content: Container(
        width: 800,
        height: 400,
        child: Column(
          children: [
            if (_isEditingTitle)
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.grey[400],
              //     border: Border.all(color: Colors.grey),
              //     borderRadius: BorderRadius.circular(5.0),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   // child: TextField(
              //   //   controller: descriptionController,
              //   //   textInputAction: TextInputAction.done,
              //   //   keyboardType: TextInputType.multiline,
              //   //   maxLines: null,
              //   //   decoration: const InputDecoration(
              //   //     hintText: "Add Description",
              //   //     border: InputBorder.none,
              //   //   ),
              //   // ),
              // ),
              // const SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    width: 700,
                    height: 280,
                    color: Colors.grey.shade100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                        left: 6, bottom: 10, top: 10, right: 4),
                                    child: Text(
                                      'Due Date',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColor.drawerLight),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, bottom: 18, top: 15),
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
                            ],
                          ),
                        ),
                        const VerticalDivider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (selectedDate != null) {
                                    setState(() {
                                      _selectedDueDate = selectedDate;
                                    });
                                  }
                                },
                                child: Row(
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
                                          right: 4),
                                      child: Text(
                                        _selectedDueDate != null
                                            ? _selectedDueDate!
                                                .toString()
                                                .split(' ')[0]
                                            : 'Select Due Date',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, bottom: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: dropdownvalue1,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    items: items1.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
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
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, bottom: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: dropdownvalue2,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    items: items2.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue2 = newValue!;
                                        assignTo.add(dropdownvalue2);
                                        assignToController.text =
                                            assignTo.toString();
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, bottom: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value:
                                        dropdownvalue3, // Changed to dropdownvalue3
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    items: items3.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
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
                              ),
                              // Set the initial value to '-All-'

                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 18, bottom: 10),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: dropdownvalue4,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    items: items4.map((String item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          color: Colors.deepPurple,
          onPressed: () {
            print("CLEAR button pressed"); // Add this line
            titleController.text = "";
            descriptionController.text = "";
            subTitleController.text = "";
            assignToController.text = "";
            documentNumberController.text = "";
            createTaskDueDateController.text = "";
            assignTo.clear();
          },
          child: const Text('CLEAR',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ),
        MaterialButton(
          color: Colors.deepPurple,
          onPressed: () {
            print("SUBMIT button pressed"); // Add this line
            mainTask(context);
          },
          child: const Text('SUBMIT',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
        ),
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
