import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:task_web/pages/taskPageOne.dart';

import '../components.dart';
import '../createAccountPopups/assigntoPopUp.dart';
import '../createAccountPopups/beneficiaryPopUp.dart';
import '../createAccountPopups/categoryPopUp.dart';
import '../createAccountPopups/priortyPopUp.dart';
import '../createAccountPopups/sourcefromPopUp.dart';
import '../methods/appBar.dart';
import '../methods/colors.dart';
import 'createMainTaskNew.dart';

class EditMainTaskPage extends StatefulWidget {
  final String currentTitle;
  final String currentDescription;
  final String currentBeneficiary;
  final String currentDueDate;
  final String currentAssignTo;
  final String currentPriority;
  final String currentSourceFrom;
  final String currentCategory;
  final String taskID;
  final String userName;
  final String firstName;
  EditMainTaskPage({
    super.key,
    required this.currentTitle,
    required this.currentDescription,
    required this.currentBeneficiary,
    required this.currentDueDate,
    required this.currentAssignTo,
    required this.currentPriority,
    required this.currentSourceFrom,
    required this.currentCategory,
    required this.taskID,
    required this.userName,
    required this.firstName,
  });

  @override
  State<EditMainTaskPage> createState() => _EditMainTaskPageState();
}

class _EditMainTaskPageState extends State<EditMainTaskPage> {
  TextEditingController newTitleController = TextEditingController();
  TextEditingController newDescriptionController = TextEditingController();

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

  Future<bool> editMainTask(
    String taskID,
    String taskTitle,
    String taskTypeName,
    String description,
    String userName,
    String firstName,
    String newCompany,
    String dueDate,
    String assignTo,
    String sourceFrom,
    String categoryName,
    String category,
  ) async {
    // Prepare the data to be sent to the PHP script.
    var data = {
      "task_id": taskID,
      "task_title": taskTitle,
      "task_type_name": taskTypeName,
      "task_description": description,
      "task_status_name": 'Pending',
      "action_taken_by_id": userName,
      "action_taken_by": firstName,
      "action_taken_date": getCurrentDate(),
      "action_taken_timestamp": getCurrentDate(),
      "task_edit_by": userName,
      "task_edit_by_id": firstName,
      "task_edit_by_date": getCurrentDate(),
      "task_edit_by_timestamp": getCurrentDate(),
      "company": newCompany,
      "due_date": dueDate,
      "assign_to": assignTo,
      "source_from": sourceFrom,
      "category_name": categoryName,
      "category": category,
    };

    // URL of your PHP script.
    const url = "http://dev.workspace.cbs.lk/editMainTask.php";

    try {
      final res = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (res.statusCode == 200) {
        final responseBody = jsonDecode(res.body);

        // Debugging: Print the response data.
        print("Response from PHP script: $responseBody");

        if (responseBody == "true") {
          print('Successful');
          snackBar(context, " Edit Main Task successful!", Colors.green);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const TaskPageOne();
            }),
          );
          return true; // PHP code was successful.
        } else {
          print('PHP code returned "false".');
          return false; // PHP code returned "false."
        }
      } else {
        print('HTTP request failed with status code: ${res.statusCode}');
        return false; // HTTP request failed.
      }
    } catch (e) {
      print('Error occurred: $e');
      return false; // An error occurred.
    }
  }

  @override
  Widget build(BuildContext context) {
    String newBeneficiary = '';
    String newDueDate = '';
    String newAssignToValue = ''; // Define assignToValue in the outer scope
    String newPriorityValue = ''; // Define priorityValue in the outer scope
    String newSourceFromValue = ''; // Define sourceFromValue in the outer scope
    String newCategoryValue = '';
    String newCategoryInt = '';

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
                    'Date and Time: ${getCurrentDateTime()}',
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
                                controller: newTitleController,
                                decoration: InputDecoration(
                                  // labelText: 'Task Title',
                                  hintText: widget.currentTitle,
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
                                controller: newDescriptionController,
                                decoration: InputDecoration(
                                  // labelText: 'Description',
                                  hintText: widget.currentDescription,
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
                                  Row(
                                    children: [
                                      Text(
                                        widget.currentBeneficiary,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Consumer<BeneficiaryState>(
                                        builder:
                                            (context, beneficiaryState, child) {
                                          newBeneficiary = beneficiaryState
                                                  .value ??
                                              'DefaultBeneficiary'; // Set beneficiaryValue based on state

                                          return TextButton(
                                            onPressed: () {
                                              beneficiaryPopupMenu(
                                                  context, beneficiaryState);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  newBeneficiary,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.currentDueDate,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Consumer<DueDateState>(
                                        builder:
                                            (context, dueDateState, child) {
                                          newDueDate = dueDateState
                                                      .selectedDate !=
                                                  null
                                              ? DateFormat('yyyy-MM-dd').format(
                                                  dueDateState.selectedDate!)
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
                                                  dueDateState.selectedDate =
                                                      pickedDate;
                                                  print(dueDateState
                                                      .selectedDate);
                                                }
                                              });
                                              // Your logic for dueDate popup menu
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  newDueDate,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.currentAssignTo,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Consumer<AssignToState>(
                                        builder:
                                            (context, assignToState, child) {
                                          newAssignToValue =
                                              assignToState.value ??
                                                  'Assign To';

                                          return TextButton(
                                            onPressed: () {
                                              assignToPopupMenu(
                                                  context, assignToState);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  newAssignToValue,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.currentPriority,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Consumer<PriorityState>(
                                        builder:
                                            (context, priorityState, child) {
                                          newPriorityValue =
                                              priorityState.value ?? 'Priority';

                                          return TextButton(
                                            onPressed: () {
                                              priorityPopupMenu(
                                                  context, priorityState);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  newPriorityValue,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 13,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.currentSourceFrom,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Consumer<SourceFromState>(
                                        builder:
                                            (context, sourceFromState, child) {
                                          newSourceFromValue =
                                              sourceFromState.value ??
                                                  'Source From';

                                          return TextButton(
                                            onPressed: () {
                                              sourceFromPopupMenu(
                                                  context, sourceFromState);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  newSourceFromValue,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 11,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        widget.currentCategory,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Consumer<CategoryState>(
                                        builder:
                                            (context, categoryState, child) {
                                          newCategoryValue =
                                              categoryState.value ?? 'Category';
                                          newCategoryInt = categoryState
                                              .selectedIndex
                                              .toString();

                                          return TextButton(
                                            onPressed: () {
                                              categoryPopupMenu(
                                                  context, categoryState);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  newCategoryValue,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
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
                                    editMainTask(
                                        widget.taskID,
                                        newTitleController.text,
                                        newPriorityValue,
                                        newDescriptionController.text,
                                        widget.userName,
                                        widget.firstName,
                                        newBeneficiary,
                                        newDueDate,
                                        newAssignToValue,
                                        newSourceFromValue,
                                        newCategoryValue,
                                        newCategoryInt);
                                    // createMainTask(context,
                                    //     beneficiary: beneficiary,
                                    //     priority: priorityValue,
                                    //     due_date: dueDate,
                                    //     sourceFrom: sourceFromValue,
                                    //     assignTo: assignToValue, categoryName: categoryValue, category: categoryInt);
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
                                    'Save',
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
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColor.loginF,
                                    backgroundColor: Colors.lightBlue.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Rounded corners
                                    ),
                                  ),
                                  child: const Text(
                                    'Clear',
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
