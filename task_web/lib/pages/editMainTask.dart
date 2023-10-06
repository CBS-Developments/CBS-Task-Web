import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components.dart';
import '../methods/colors.dart';

enum menuitem {
  item1,
  item2,
  item9,
  item10,
  item11
}

class EditMainTask extends StatefulWidget {
  final String userName;
  final String firstName;
  final String lastName;
  final String mainTaskId;
  final String taskTitle;
  final String taskType;
  final String taskTypeName;
  final String taskCreateBy;
  final String company;
  final String sourceFrom;
  final String assign_to;
  final String dueDate;
  final String taskStatusName;
  final String taskStatus;
  final String taskCreateDate;
  final String documentNumber;
  final String taskCreatedTimestamp;

  const EditMainTask({
    Key? key,
    required this.lastName,
    required this.firstName,
    required this.userName,
    required this.assign_to,
    required this.company,
    required this.documentNumber,
    required this.dueDate,
    required this.mainTaskId,
    required this.sourceFrom,
    required this.taskCreateBy,
    required this.taskCreateDate,
    required this.taskCreatedTimestamp,
    required this.taskStatus,
    required this.taskStatusName,
    required this.taskTitle,
    required this.taskType,
    required this.taskTypeName,
  }) : super(key: key);

  @override
  EditMainTaskState createState() => EditMainTaskState();
}

class EditMainTaskState extends State<EditMainTask> {
  String userName = '';
  String firstName = '';
  String lastName = '';
  String mainTaskId = '';
  String taskTitle = '';
  String taskType = '';
  String taskTypeName = '';
  String taskCreateBy = '';
  String company = '';
  String sourceFrom = '';
  String assign_to = '';
  String dueDate = '';
  String taskStatusName = '';
  String taskStatus = '';
  String taskCreateDate = '';
  String documentNumber = '';
  String taskCreatedTimestamp = '';

  bool titleValidation = false;

  int taskTypePosition = 1;
  String taskTypeString = "Top Urgent";
  menuitem mitem = menuitem.item1;
  List<String> assignTo = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController assignToController = TextEditingController();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController editDueDateController = TextEditingController();

  textListenerDueDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('due_date', editDueDateController.text);
    retrieverData(6);
  }

  @override
  void dispose() {
    super.dispose();
    editDueDateController.dispose();
  }

  @override
  void initState() {
    super.initState();
    mainTaskId = widget.mainTaskId;
    firstName = widget.firstName;
    lastName = widget.lastName;
    retrieverData(0);
    editDueDateController.addListener(textListenerDueDate);

   // mitem = menuitem.item1;

    setTaskType();
  }

  void retrieverData(int type) async {
    final prefs = await SharedPreferences.getInstance();
    if (type == 0) {
      setState(() {
        taskTitle = widget.taskTitle;
        taskType = widget.taskType;
        taskTypeName = widget.taskTypeName;
        taskCreateBy = widget.taskCreateBy;
        dueDate = widget.dueDate;
        taskCreateDate = widget.taskCreateDate;
        taskCreatedTimestamp = widget.taskCreatedTimestamp;
        taskStatusName = widget.taskStatusName;
        taskStatus = widget.taskStatus;
        company = widget.company;
        sourceFrom = widget.sourceFrom;
        assign_to = widget.assign_to;
        userName = widget.userName;
        documentNumber = widget.documentNumber;
      });

      titleController.text = taskTitle;
      editDueDateController.text = dueDate;
      assignToController.text = assign_to;
      documentNumberController.text = documentNumber;

      setTaskType();
    } else if (type == 2) {
      setTaskType();
    } else if (type == 3) {
      setState(() {
        sourceFrom = widget.sourceFrom;
      });
    } else if (type == 4) {
      setState(() {
        assign_to = widget.assign_to;
      });
    } else if (type == 5) {
      setState(() {
        company = widget.company;
      });
    } else if (type == 6) {
      setState(() {
        dueDate = prefs.getString('due_date') ?? '';
      });
    }
  }

  void setTaskType() {
    if (taskType == '1') {
      taskTypePosition = 1;
      taskTypeString = "Top Urgent";
      mitem = menuitem.item1;
    } else if (taskType == '2') {
      taskTypePosition = 2;
      taskTypeString = "Urgent 24Hr";
      mitem = menuitem.item2;
    } else if (taskType == '9') {
      taskTypePosition = 9;
      taskTypeString = "Regular";
      mitem = menuitem.item9;
    } else if (taskType == '10') {
      taskTypePosition = 10;
      taskTypeString = "Medium";
      mitem = menuitem.item10;
    } else if (taskType == '11') {
      taskTypePosition = 11;
      taskTypeString = "Low";
      mitem = menuitem.item11;
    }
  }

  Future<bool> updateTask(
      BuildContext context,
      String taskId,
      String sourceFrom,
      String assignTo,
      String company,
      String dueDate,
      String documentNumber,
      ) async {
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
    var url = "http://dev.connect.cbs.lk/updateMainTask.php";
    var data = {
      "task_id": taskId,
      "task_title": titleController.text,
      "task_type": taskType,
      "task_type_name": taskTypeString,
      "due_date": dueDate,
      "task_edit_by": "$firstName $lastName",
      "task_edit_by_id": userName,
      "task_edit_by_date": stringDate,
      "task_edit_by_timestamp": "$timeSt",
      "source_from": sourceFrom,
      "assign_to": assign_to,
      "company": company,
      "document_number": documentNumber,
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('task_title', titleController.text);
        prefs.setString('document_number', documentNumber);

        retrieverData(0);
        if (!mounted) return true;
        snackBar(context, "Updated", Colors.green);

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
        width: 1000,
        height: 600,
        color: Colors.white70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 400,
              height: 500,
              //color: Colors.greenAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Edit Main Task',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SelectableText(
                        "Task ID : ${widget.mainTaskId}",
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "This task create by:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                       " ${widget.taskCreateBy}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Company name:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.company,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'This source from: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                       " ${widget.sourceFrom}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'This task assign to: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.assign_to,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Task due date: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.dueDate,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Task status: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                       " ${widget.taskStatusName}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Document Number:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                       " ${widget.documentNumber}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Task create date: ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.taskCreateDate,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(),

            SizedBox(
              width: 500,
              height: 600,
              //color: Colors.amberAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: titleController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Task Title',
                            hintText: 'Task Title',
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 20,
                        ),
                      ),
                    ],
                  ),


                  ListTile(
                    title: const Text(
                      'Top Urgent',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Radio<menuitem>(
                      activeColor: const Color(0xffff0000),
                      value: menuitem.item1,
                      groupValue: mitem,
                      onChanged: (menuitem? value) {
                        if (value != null) {
                          setState(() {
                            mitem = value;
                            taskTypePosition = 1;
                            taskTypeString = "Top Urgent";
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Urgent with in 24 hour',
                      style: TextStyle(fontSize: 14),
                    ),
                    minLeadingWidth: 1,
                    trailing: Radio<menuitem>(
                      value: menuitem.item2,
                      activeColor: const Color(0xff800000),
                      groupValue: mitem,
                      onChanged: (menuitem? value) {
                        if (value != null) {
                          setState(() {
                            mitem = value;
                            taskTypePosition = 2;
                            taskTypeString = "Urgent 24Hr";
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Regular',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Radio<menuitem>(
                      activeColor: const Color.fromARGB(255, 190, 114, 0),
                      value: menuitem.item9,
                      groupValue: mitem,
                      onChanged: (menuitem? value) {
                        if (value != null) {
                          setState(() {
                            mitem = value;
                            taskTypePosition = 9;
                            taskTypeString = "Regular";
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Medium',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Radio<menuitem>(
                      activeColor: const Color.fromARGB(255, 0, 3, 190),
                      value: menuitem.item10,
                      groupValue: mitem,
                      onChanged: (menuitem? value) {
                        if (value != null) {
                          setState(() {
                            mitem = value;
                            taskTypePosition = 10;
                            taskTypeString = "Medium";
                          });
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Low',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Radio<menuitem>(
                      activeColor: const Color.fromARGB(255, 14, 168, 0),
                      value: menuitem.item11,
                      groupValue: mitem,
                      onChanged: (menuitem? value) {
                        if (value != null) {
                          setState(() {
                            mitem = value;
                            taskTypePosition = 11;
                            taskTypeString = "Low";
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 2,),

                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: dropdownvalue1,
                          items: items1.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
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
                      );
                    },
                  ),
                  const SizedBox(height: 10,),

                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: dropdownvalue2,
                          items: items2.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue2 = newValue!;
                            });
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 2,),

                  SizedBox(
                    width: 250,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: editDueDateController,
                            onTap: () {
                              selectDate(context, editDueDateController);
                            },
                            decoration: const InputDecoration(
                              //border: const OutlineInputBorder(),
                              hintText: 'Due Date',
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // Add your icon button functionality here
                          },
                          icon: const Icon(
                            Icons.date_range,
                            color: Colors.deepPurple,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),



                  const SizedBox(height: 2,),

                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: dropdownvalue3,
                          items: items3.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
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
                      );
                    },
                  ),

                  const SizedBox(height: 10,),


                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: MaterialButton(
                            color: Colors.deepPurple,
                            onPressed: () {
                              // titleController.text = "";
                              // descriptionController.text = "";
                              // assignToController.text = "";
                              // documentNumberController.text = "";
                              // editDueDateController.text = "";
                              // assignTo.clear();
                            },
                            child: const Text(
                              'CLEAR',
                              style: TextStyle(
                                fontSize: 10,
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
                          padding: const EdgeInsets.all(10),
                          child: MaterialButton(
                            color: Colors.deepPurple,
                            onPressed: () {
                              updateTask(
                                context,
                                mainTaskId,
                                sourceFrom,
                                assign_to,
                                company,
                                editDueDateController.text,
                                documentNumberController.text,
                              );
                            },
                            child: const Text(
                              'UPDATE',
                              style: TextStyle(
                                fontSize: 10,
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
            )
          ],
        ),
      ),
    );
  }
}
