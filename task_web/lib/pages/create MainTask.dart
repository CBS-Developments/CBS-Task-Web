
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components.dart';
import '../methods/colors.dart';

class CreateTaskDialog extends StatefulWidget {
  final String username;
  final String firstName;
  final String lastName;

  CreateTaskDialog(this.username, this.firstName, this.lastName, {Key? key})
      : super(key: key);

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  bool titleValidation = false;
  bool subTaskTitleValidation = false;
  bool descriptionValidation = false;

  int taskType = 1;
  String taskTypeString = "Top Urgent";

  List<String> assignTo = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController createTaskDueDateController = TextEditingController();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController assignToController = TextEditingController();

  void selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != controller.text) {
      print('Selected date: $picked'); // Add this line for debugging
      controller.text = DateFormat('yyyy-MM-dd').format(picked); // Adjust the date format as needed
    }
  }


  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() {});
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
    var taskId = "${widget.username}#MT$taskTimeStamp";
    var url = "http://dev.connect.cbs.lk/mainTask.php";
    var data = {
      "task_id": taskId,
      "task_title": titleController.text,
      "task_type": "$taskType",
      "task_type_name": taskTypeString,
      "due_date": createTaskDueDateController.text,
      "task_create_by_id": widget.username,
      "task_create_by": "${widget.firstName} ${widget.lastName}",
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
    var taskId = "${widget.username}#ST$taskTimeStamp";
    var url = "http://dev.connect.cbs.lk/createTask.php";

    var data = {
      "task_id": taskId,
      "main_task_id": "$mainTaskId",
      "task_title": subTitleController.text,
      "task_type": "$taskType",
      "task_type_name": taskTypeString,
      "due_date": createTaskDueDateController.text,
      "task_description": descriptionController.text,
      "task_create_by_id": widget.username,
      "task_create_by": "${widget.firstName} ${widget.lastName}",
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
      "company": dropdownvalue3,
      "priority": dropdownvalue4,
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


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 850, // Set the width of the dialog
        height: 600,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      titleController.clear();
                      descriptionController.clear();
                      subTitleController.clear();
                      assignToController.clear();
                      documentNumberController.clear();
                      createTaskDueDateController.clear();
                      assignTo.clear();
                    });
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 20,
                  ),
                ),





              ],
            ),

            Row(
              children: [
                Expanded(
                  child:
                TextField(
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Description',
                  ),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),),
                SizedBox(width: 35,)
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 650,
              height: 320,
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            bottom: 7,
                            top: 8,
                          ),
                          child: Text(
                            'Beneficiary',
                            style: TextStyle(
                              fontSize: 14, // Updated font size to 14
                              color: AppColor.drawerLight,
                            ),
                          ),
                        ),
                        SizedBox(height: 8), // Updated height to 8
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 6,
                                bottom: 7,
                                top: 10,
                              ),
                              child: Text(
                                'Due Date',
                                style: TextStyle(
                                  fontSize: 14, // Updated font size to 14
                                  color: AppColor.drawerLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8), // Updated height to 8
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            bottom: 5,
                            top: 22,
                          ),
                          child: Text(
                            'Assign To',
                            style: TextStyle(
                              fontSize: 14, // Updated font size to 14
                              color: AppColor.drawerLight,
                            ),
                          ),
                        ),
                        SizedBox(height: 8), // Updated height to 8
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            bottom: 5,
                            top: 22,
                          ),
                          child: Text(
                            'Priority',
                            style: TextStyle(
                              fontSize: 14, // Updated font size to 14
                              color: AppColor.drawerLight,
                            ),
                          ),
                        ),
                        SizedBox(height: 8), // Updated height to 8
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            bottom: 5,
                            top: 22,
                          ),
                          child: Text(
                            'Source From', // Updated text here
                            style: TextStyle(
                              fontSize: 14, // Updated font size to 14
                              color: AppColor.drawerLight,
                            ),
                          ),
                        ),
                        SizedBox(height: 8), // Updated height to 8
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            bottom: 5,
                            top: 22,
                          ),
                          child: Text(
                            'Task Category',
                            style: TextStyle(
                              fontSize: 14, // Updated font size to 14
                              color: AppColor.drawerLight,
                            ),
                          ),
                        ),
                        // Add more text fields here
                      ],
                    )



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
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue3,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                ),
                                items: items3.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
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
                            const SizedBox(height: 2),
                            SizedBox(
                              width:150,
                              child: TextField(
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
                                    icon: const Icon(
                                      Icons.date_range,
                                      color: Colors.blue,
                                      size: 14,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue2,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                ),
                                items: items2.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: const TextStyle(
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
                            const SizedBox(height: 2),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue4,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                ),
                                items: items4.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
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
                            const SizedBox(height: 2),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue1,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                ),
                                items: items1.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
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
                            const SizedBox(height: 2),
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: dropdownvalue5,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 12,
                                ),
                                items: items5.map((String item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue5 = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        )

                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 20), // Add spacing between the form and buttons
            Container(
              width: double.infinity, // Set the width to control the container's size
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align buttons at each end
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
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
                      child: const Text(
                        'CLEAR',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: MaterialButton(
                      color: Colors.deepPurple,
                      onPressed: () async {
                        bool success = await mainTask(context);
                        if (success) {
                          // Clear form fields on successful submission
                          titleController.text = "";
                          descriptionController.text = "";
                          subTitleController.text = "";
                          assignToController.text = "";
                          documentNumberController.text = "";
                          createTaskDueDateController.text = "";
                          assignTo.clear();
                        }
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text(
                        'SUBMIT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            )

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
