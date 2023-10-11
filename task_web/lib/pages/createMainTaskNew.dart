import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components.dart';
import '../methods/appBar.dart';
import 'package:http/http.dart' as http;

import '../methods/colors.dart';
import 'package:intl/intl.dart';




class CreateMainTaskNew extends StatefulWidget {
 final String username;
 final String firstName;
 final String lastName;

  const CreateMainTaskNew(this.username, this.firstName, this.lastName, {Key? key})
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body: Center(
        child: Column(
          children: [
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
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Updated height to 8
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
                                                fontWeight: FontWeight.bold,
                                                color: AppColor.tealLog,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8), // Updated height to 8
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
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Updated height to 8
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
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Updated height to 8
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
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8), // Updated height to 8
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
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.tealLog,
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

                              Column(
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
                                      }
                                      ).toList(),
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

                            ],
                          ),
                        ),
                        const SizedBox(height: 20), // Add spacing between the form and buttons
                        SizedBox(
                          width: 750,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 40,
                                width: 140,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColor.loginF,
                                    backgroundColor: Colors.lightBlue.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5), // Rounded corners
                                    ),
                                  ),
                                  child: const
                                  Text('Create',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),


                              ),

                              Container(
                                height: 40,
                                width: 140,
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  onPressed: () {
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: AppColor.loginF,
                                    backgroundColor: Colors.lightBlue.shade50,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5), // Rounded corners
                                    ),
                                  ),
                                  child: const
                                  Text('Clear',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,color: Colors.redAccent
                                    ),
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
      ]
    ),
    ),
    );
  }
}
