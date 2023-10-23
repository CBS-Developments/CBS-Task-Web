import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_web/pages/openTaskNew.dart';
import 'package:task_web/pages/taskPageOne.dart';

import '../components.dart';
import '../createAccountPopups/assigntoPopUp.dart';
import '../createAccountPopups/beneficiaryPopUp.dart';
import '../createAccountPopups/categoryPopUp.dart';
import '../createAccountPopups/priortyPopUp.dart';
import '../createAccountPopups/sourcefromPopUp.dart';
import '../methods/appBar.dart';
import '../methods/colors.dart';
import '../tables/taskTable.dart';
import 'createMainTaskNew.dart';
import 'package:http/http.dart' as http;

class CreateSubTaskNew extends StatefulWidget {
  final String username;
  final String userRole;
  final String firstName;
  final String lastName;
  final String mainTaskId;
  final MainTask task;

  const CreateSubTaskNew({Key? key, required this.username, required this.firstName, required this.lastName, required this.mainTaskId, required this.task, required this.userRole}) : super(key: key);

  @override
  State<CreateSubTaskNew> createState() => _CreateSubTaskNewState();
}

class _CreateSubTaskNewState extends State<CreateSubTaskNew> {

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

  String getCurrentMonth() {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM').format(now);
    return formattedDate;
  }
  String generatedSubTaskId() {
    final random = Random();
    int min = 1;                  // Smallest 9-digit number
    int max = 999999999;          // Largest 9-digit number
    int randomNumber = min + random.nextInt(max - min + 1);
    return randomNumber.toString().padLeft(9, '0');
  }

  TextEditingController subTaskTitleController = TextEditingController();
  TextEditingController subTaskDescriptionController = TextEditingController();

  Future<void> createSubTask(
      BuildContext context, {
        required subTaskBeneficiary,
        required subTaskPriority,
        required subTaskDueDate,
        required subTaskSourceFrom,
        required subTaskAssignTo,
        required subTaskCategoryName,
        required subTaskCategory,
      }) async {
    // Validate input fields
    if (subTaskTitleController.text.trim().isEmpty ||
        subTaskDescriptionController.text.isEmpty) {
      // Show an error message if any of the required fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return;
    }

    // Other validation logic can be added here
    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/subTaskCreate.php";

    String firstLetterFirstName = widget.firstName.isNotEmpty ? widget.firstName[0] : '';
    String firstLetterLastName = widget.lastName.isNotEmpty ? widget.lastName[0] : '';
    String geCategory = subTaskCategoryName.substring(subTaskCategoryName.length - 3);
    String taskID = getCurrentMonth() + firstLetterFirstName + firstLetterLastName + geCategory + generatedSubTaskId();

    var data = {
      "main_task_id": widget.mainTaskId,
      "task_id": taskID,
      "task_title":  subTaskTitleController.text,
      "task_type": '0',
      "task_type_name": subTaskPriority,
      "due_date": subTaskDueDate,
      "task_description": subTaskDescriptionController.text,
      "task_create_by_id": widget.username,
      "task_create_by": '${widget.firstName} ${widget.lastName}',
      "task_create_date": getCurrentDate(),
      "task_create_month": getCurrentMonth(),
      "task_created_timestamp": getCurrentDateTime(),
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
      "source_from": subTaskSourceFrom,
      "assign_to": subTaskAssignTo,
      "company": subTaskBeneficiary,
      "document_number": '',
      "watch_list": '0',
      "action_taken_by_id": "",
      "action_taken_by": "",
      "action_taken_date": "",
      "action_taken_timestamp": "0",
      "category_name": subTaskCategoryName,
      "category": subTaskCategory,
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
        if (!mounted) return;
        showSuccessSnackBar(context);// Show the success SnackBar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OpenTaskNew(task: widget.task, userRoleForDelete:  widget.userRole, userName: widget.username,
            firstName: widget.firstName,
            lastName:  widget.lastName,)),
        );

      } else {
        if (!mounted) return;
        snackBar(context, "Error", Colors.red);
      }
    } else {
      if (!mounted) return;
      snackBar(context, "Error", Colors.yellow);
    }
  }

  void showSuccessSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Sub Task Created Successfully'),
      backgroundColor: Colors.green, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    String subTaskBeneficiary = '';
    String subTaskDueDate = '';
    String subTaskAssignToValue = ''; // Define assignToValue in the outer scope
    String subTaskPriorityValue = ''; // Define priorityValue in the outer scope
    String subTaskSourceFromValue = ''; // Define sourceFromValue in the outer scope
    String subTaskCategoryValue = '';
    String subTaskCategoryInt = '';
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Date and Time: ${getCurrentDateTime()+widget.mainTaskId}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Add other widgets as needed
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              width: 800,
              height: 550,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, // Shadow color
                    blurRadius: 5, // Spread radius
                    offset: Offset(0, 3), // Offset in x and y directions
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: subTaskTitleController,
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
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: subTaskDescriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'Description',
                                ),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                            fontSize:
                                            14, // Updated font size to 14
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 8), // Updated height to 8
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
                                                fontSize:
                                                14, // Updated font size to 14
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.tealLog,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                          height: 8), // Updated height to 8
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18,
                                          bottom: 5,
                                          top: 22,
                                        ),
                                        child: Text(
                                          'Assign To',
                                          style: TextStyle(
                                            fontSize:
                                            14, // Updated font size to 14
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 8), // Updated height to 8
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18,
                                          bottom: 5,
                                          top: 22,
                                        ),
                                        child: Text(
                                          'Priority',
                                          style: TextStyle(
                                            fontSize:
                                            14, // Updated font size to 14
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 8), // Updated height to 8
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18,
                                          bottom: 5,
                                          top: 22,
                                        ),
                                        child: Text(
                                          'Source From', // Updated text here
                                          style: TextStyle(
                                            fontSize:
                                            14, // Updated font size to 14
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 8), // Updated height to 8
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18,
                                          bottom: 5,
                                          top: 22,
                                        ),
                                        child: Text(
                                          'Task Category',
                                          style: TextStyle(
                                            fontSize:
                                            14, // Updated font size to 14
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
                                          ),
                                        ),
                                      ),
                                      // Add more text fields here
                                    ],
                                  )),
                              const VerticalDivider(
                                thickness: 2,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 7,
                                  ),

                                  Consumer<BeneficiaryState>(
                                    builder: (context, beneficiaryState, child) {
                                      subTaskBeneficiary = beneficiaryState.value ?? 'DefaultBeneficiary'; // Set beneficiaryValue based on state

                                      return TextButton(
                                        onPressed: () {
                                          beneficiaryPopupMenu(context, beneficiaryState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskBeneficiary,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                  Consumer<DueDateState>(
                                    builder: (context, dueDateState, child) {
                                      subTaskDueDate = dueDateState.selectedDate != null
                                          ? DateFormat('yyyy-MM-dd').format(dueDateState.selectedDate!)
                                          : 'No due date selected';

                                      return TextButton(
                                        onPressed: () {

                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2023),
                                            lastDate: DateTime(2030),
                                          ).then((pickedDate) {
                                            if (pickedDate != null) {
                                              dueDateState.selectedDate = pickedDate;
                                              print(dueDateState.selectedDate);
                                            }
                                          });
                                          // Your logic for dueDate popup menu
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskDueDate,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),


                                  SizedBox(
                                    height: 17,
                                  ),

                                  Consumer<AssignToState>(
                                    builder: (context, assignToState, child) {
                                      subTaskAssignToValue = assignToState.value ?? 'Assign To';

                                      return TextButton(
                                        onPressed: () {
                                          assignToPopupMenu(context, assignToState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskAssignToValue,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                  SizedBox(
                                    height: 16,
                                  ),

                                  Consumer<PriorityState>(
                                    builder: (context, priorityState, child) {
                                      subTaskPriorityValue = priorityState.value ?? 'Priority';

                                      return TextButton(
                                        onPressed: () {
                                          priorityPopupMenu(context, priorityState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskPriorityValue,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                  SizedBox(
                                    height: 13,
                                  ),

                                  Consumer<SourceFromState>(
                                    builder: (context, sourceFromState, child) {
                                      subTaskSourceFromValue = sourceFromState.value ?? 'Source From';

                                      return TextButton(
                                        onPressed: () {
                                          sourceFromPopupMenu(context, sourceFromState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskSourceFromValue,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),

                                  SizedBox(
                                    height: 11,
                                  ),

                                  Consumer<CategoryState>(
                                    builder: (context, categoryState, child) {
                                      subTaskCategoryValue = categoryState.value ?? 'Category';
                                      subTaskCategoryInt = categoryState.selectedIndex.toString();

                                      return TextButton(
                                        onPressed: () {
                                          categoryPopupMenu(context, categoryState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              subTaskCategoryValue,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),





                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                            height:
                            20), // Add spacing between the form and buttons
                        SizedBox(
                          width: 750,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 40,
                                width: 140,
                                padding:
                                const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    createSubTask(context,
                                        subTaskBeneficiary: subTaskBeneficiary,
                                        subTaskPriority: subTaskPriorityValue,
                                        subTaskDueDate: subTaskDueDate,
                                        subTaskSourceFrom: subTaskSourceFromValue,
                                        subTaskAssignTo: subTaskAssignToValue,
                                        subTaskCategoryName: subTaskCategoryValue,
                                        subTaskCategory: subTaskCategoryInt);
                                    Navigator.of(context).pop();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => const DashManin()),
                                    // );

                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColor.loginF,
                                    backgroundColor: Colors.lightBlue.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    'Create',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 140,
                                padding:
                                const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColor.loginF,
                                    backgroundColor: Colors.lightBlue.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
