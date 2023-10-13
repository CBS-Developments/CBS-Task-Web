import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


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
  EditMainTaskPage(
      {super.key, required this.currentTitle, required this.currentDescription, required this.currentBeneficiary, required this.currentDueDate, required this.currentAssignTo, required this.currentPriority, required this.currentSourceFrom, required this.currentCategory,}
     );

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
                                        builder: (context, beneficiaryState, child) {
                                          newBeneficiary = beneficiaryState.value ?? 'DefaultBeneficiary'; // Set beneficiaryValue based on state

                                          return TextButton(
                                            onPressed: () {
                                              beneficiaryPopupMenu(context, beneficiaryState);
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
                                        builder: (context, dueDateState, child) {
                                          newDueDate = dueDateState.selectedDate != null
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
                                                  newDueDate,
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
                                        builder: (context, assignToState, child) {
                                          newAssignToValue = assignToState.value ?? 'Assign To';

                                          return TextButton(
                                            onPressed: () {
                                              assignToPopupMenu(context, assignToState);
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
                                        builder: (context, priorityState, child) {
                                          newPriorityValue = priorityState.value ?? 'Priority';

                                          return TextButton(
                                            onPressed: () {
                                              priorityPopupMenu(context, priorityState);
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
                                        builder: (context, sourceFromState, child) {
                                          newSourceFromValue = sourceFromState.value ?? 'Source From';

                                          return TextButton(
                                            onPressed: () {
                                              sourceFromPopupMenu(context, sourceFromState);
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
                                        builder: (context, categoryState, child) {
                                          newCategoryValue = categoryState.value ?? 'Category';
                                          newCategoryInt = categoryState.selectedIndex.toString();

                                          return TextButton(
                                            onPressed: () {
                                              categoryPopupMenu(context, categoryState);
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
    );
  }
}
