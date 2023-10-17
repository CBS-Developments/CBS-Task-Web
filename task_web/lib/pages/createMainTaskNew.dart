import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_web/pages/taskPageOne.dart';

import '../components.dart';
import '../createAccountPopups/assigntoPopUp.dart';
import '../createAccountPopups/beneficiaryPopUp.dart';
import '../createAccountPopups/categoryPopUp.dart';
import '../createAccountPopups/priortyPopUp.dart';
import '../createAccountPopups/sourcefromPopUp.dart';
import '../methods/appBar.dart';
import 'package:http/http.dart' as http;

import '../methods/colors.dart';
import 'package:intl/intl.dart';

import '../methods/taskPopUpMenu.dart';

class CreateMainTaskNew extends StatefulWidget {
  final String username;
  final String firstName;
  final String lastName;

  const CreateMainTaskNew(
      {Key? key, required this.lastName, required this.username, required this.firstName})
      : super(key: key);

  @override
  State<CreateMainTaskNew> createState() => _CreateMainTaskNewState();
}

class _CreateMainTaskNewState extends State<CreateMainTaskNew> {


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
    final formattedDate = DateFormat('yy-MM').format(now);
    return formattedDate;
  }

  String generatedTaskId() {
    final random = Random();
    int min = 1;                  // Smallest 9-digit number
    int max = 999999999;          // Largest 9-digit number
    int randomNumber = min + random.nextInt(max - min + 1);
    return randomNumber.toString().padLeft(9, '0');
  }



  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  Future<void> createMainTask(
      BuildContext context, {
        required beneficiary,
        required priority,
        required due_date,
        required sourceFrom,
        required assignTo,
        required categoryName,
        required category,
      }) async {
    // Validate input fields
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.isEmpty) {
      // Show an error message if any of the required fields are empty
      snackBar(context, "Please fill in all required fields", Colors.red);
      return;
    }

    // Other validation logic can be added here
    // If all validations pass, proceed with the registration
    var url = "http://dev.workspace.cbs.lk/mainTaskCreate.php";

    String firstLetterFirstName = widget.firstName.isNotEmpty ? widget.firstName[0] : '';
    String firstLetterLastName = widget.lastName.isNotEmpty ? widget.lastName[0] : '';
    String geCategory = categoryName.substring(categoryName.length - 3);
    String taskID = getCurrentMonth() + firstLetterFirstName + firstLetterLastName + geCategory + generatedTaskId();


    var data = {
      "task_id": taskID,
      "task_title":  titleController.text,
      "task_type": '0',
      "task_type_name": priority,
      "due_date": due_date,
      "task_description": descriptionController.text,
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
      "source_from": sourceFrom,
      "assign_to": assignTo,
      "company": beneficiary,
      "document_number": '',
      "action_taken_by_id": "",
      "action_taken_by": "",
      "action_taken_date": "",
      "action_taken_timestamp": "0",
      "category_name": categoryName,
      "category": category,
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
          MaterialPageRoute(builder: (context) => TaskPageOne()),
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
      content: Text('Main Task Created Successfully'),
      backgroundColor: Colors.green, // You can customize the color
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  void selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != controller.text) {
      print('Selected date: $picked'); // Add this line for debugging
      controller.text = DateFormat('yyyy-MM-dd')
          .format(picked); // Adjust the date format as needed
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

  @override
  Widget build(BuildContext context) {

    String beneficiary = '';
    String dueDate = '';
    String assignToValue = ''; // Define assignToValue in the outer scope
    String priorityValue = ''; // Define priorityValue in the outer scope
    String sourceFromValue = ''; // Define sourceFromValue in the outer scope
    String categoryValue = '';
    String categoryInt = '';

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
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: descriptionController,
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
                                      beneficiary = beneficiaryState.value ?? 'DefaultBeneficiary'; // Set beneficiaryValue based on state

                                      return TextButton(
                                        onPressed: () {
                                          beneficiaryPopupMenu(context, beneficiaryState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              beneficiary,
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
                                      dueDate = dueDateState.selectedDate != null
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
                                              dueDate,
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
                                      assignToValue = assignToState.value ?? 'Assign To';

                                      return TextButton(
                                        onPressed: () {
                                          assignToPopupMenu(context, assignToState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              assignToValue,
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
                                      priorityValue = priorityState.value ?? 'Priority';

                                      return TextButton(
                                        onPressed: () {
                                          priorityPopupMenu(context, priorityState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              priorityValue,
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
                                      sourceFromValue = sourceFromState.value ?? 'Source From';

                                      return TextButton(
                                        onPressed: () {
                                          sourceFromPopupMenu(context, sourceFromState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              sourceFromValue,
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
                                      categoryValue = categoryState.value ?? 'Category';
                                      categoryInt = categoryState.selectedIndex.toString();

                                      return TextButton(
                                        onPressed: () {
                                          categoryPopupMenu(context, categoryState);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              categoryValue,
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
                                    createMainTask(context,
                                        beneficiary: beneficiary,
                                        priority: priorityValue,
                                        due_date: dueDate,
                                        sourceFrom: sourceFromValue,
                                        assignTo: assignToValue, categoryName: categoryValue, category: categoryInt);
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

class DueDateState extends ChangeNotifier {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}

