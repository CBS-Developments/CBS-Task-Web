import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components.dart';
import '../createAccountPopups/assigntoPopUp.dart';
import '../createAccountPopups/beneficiaryPopUp.dart';
import '../methods/appBar.dart';
import 'package:http/http.dart' as http;

import '../methods/colors.dart';
import 'package:intl/intl.dart';

import '../methods/taskPopUpMenu.dart';

class CreateMainTaskNew extends StatefulWidget {
  final String username;
  final String firstName;
  final String lastName;

  const CreateMainTaskNew(this.username, this.firstName, this.lastName,
      {Key? key})
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

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController createTaskDueDateController = TextEditingController();
  TextEditingController documentNumberController = TextEditingController();
  TextEditingController assignToController = TextEditingController();

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskDropdownState()),
      ],
      child: Scaffold(
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
                                      builder:
                                          (context, beneficiaryState, child) {
                                        return TextButton(
                                          onPressed: () {
                                            beneficiaryPopupMenu(
                                                context, beneficiaryState);
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                beneficiaryState.value ?? 'Beneficiary',
                                                style: TextStyle(
                                                  fontSize:
                                                      14, // Updated font size to 14
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

                                    SizedBox(
                                      height: 6,
                                    ),


                                    Consumer<DueDateState>(
                                      builder: (context, dueDateState, child) {
                                        return Row(
                                          children: [
                                            TextButton(
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
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.calendar_today, color: Colors.teal),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Due Date : ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '${dueDateState.selectedDate != null ? DateFormat('yyyy-MM-dd').format(dueDateState.selectedDate!) : ''}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),

                                    SizedBox(
                                      height: 12,
                                    ),

                                    Consumer<AssignToState>(
                                      builder: (context, assignToState, child) {
                                        return TextButton(
                                          onPressed: () {
                                            assignToPopupMenu(context, assignToState);
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                assignToState.value ?? 'Assign To',
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
                                    )


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

