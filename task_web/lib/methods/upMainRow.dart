import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_web/methods/colors.dart';
import 'package:task_web/methods/statusPopUpMenu.dart';
import 'package:task_web/methods/taskPopUpMenu.dart';


import '../sizes/pageSizes.dart';
import 'assignedPopUpMenu.dart';

class UpMainRow extends StatefulWidget {
  const UpMainRow({super.key});

  @override
  State<UpMainRow> createState() => _UpMainRowState();
}

class _UpMainRowState extends State<UpMainRow> {

  TextEditingController taskListController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    StatusDropdownState dropdownState = Provider.of<StatusDropdownState>(context);
    // ignore: unused_local_variable
    TaskDropdownState taskDropdownState = Provider.of<TaskDropdownState>(context);
    // ignore: unused_local_variable
    AssignedDropdownState assignedDropdownState = Provider.of<AssignedDropdownState>(context);
    return Container(
      width: getPageWidth(context)-240,
      height: 50,
      // color: Colors.blue,
      child: Row(
        children: [
          Container(
            // width: 420,
            width: getPageWidth(context)-1020,
           
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            // color: Colors.redAccent,
            child: TextField(
              controller: taskListController,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                prefixIcon:Icon(Icons.search,color: Colors.grey,) ,
                  suffixIcon: IconButton(onPressed:(){} ,
                      icon: Icon(Icons.cancel_outlined,color: Colors.grey,)),
                  enabledBorder:  OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey[500],fontSize: 16
                  )
              ),

            ),
          ),

          SizedBox(width: 160,),


          Container(
            width: 120,
            height: 50,
            // color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    statusPopupMenu(context);
                  },
                  child: Text('Status :',style: TextStyle(
                    color: AppColor.filteT,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.filteT,
                  ),),
                ),

                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      margin: EdgeInsets.only(left: 3),
                      child: Image.asset('images/messageEdit.png',
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Consumer<StatusDropdownState>(
                        builder: (context, statusdropdownState, _) {
                          return Text(
                            statusdropdownState.value ?? '',
                            style: TextStyle(
                              color: AppColor.filterDrop,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )


              ],
            ),
          ),

          SizedBox(width: 5,),

          Container(
            width: 120,
            height: 50,
            // color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () { 
                    taskPopupMenu(context);
                  },
                  child: Text('Task :',style: TextStyle(
                    color: AppColor.filteT,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.filteT,
                  ),),
                ),
                
                Row(
                  children: [
                   Container(
                     margin: EdgeInsets.only(left: 3),
                     width: 18,
                     height: 18,
                     child: Image.asset('images/taskSquare.png',
                       ),
                   ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Consumer<TaskDropdownState>(
                        builder: (context, taskDropdownState, _) { // Use the taskDropdownState
                          return Text(
                            taskDropdownState.value ?? '',
                            style: TextStyle(
                              color: AppColor.filterDrop,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    )

                  ],
                )
                
                
              ],
            ),
          ),

          SizedBox(width: 5,),

          Container(
            width: 120,
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    assignedPopupMenu(context);
                  },
                  child: Text('Assigned :', style: TextStyle(
                    color: AppColor.filteT,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.filteT,
                  ),),
                ),

                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 3),
                      width: 18,
                      height: 18,
                      child: Image.asset('images/profileUser.png'),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Consumer<AssignedDropdownState>(
                        builder: (context, assignedDropdownState, _) {
                          return Text(
                            assignedDropdownState.value ?? '',
                            style: TextStyle(
                              color: AppColor.filterDrop,
                              fontSize: 14,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(width: 5,),

          Container(
            width: 120,
            height: 50,
            // color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {  },
                  child: Text('Company :',style: TextStyle(
                    color: AppColor.filteT,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.filteT,
                  ),),
                ),

                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 3),
                      width: 18,
                      height: 18,
                      child: Image.asset('images/bank.png',
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text('-All-',
                        style: TextStyle(
                          color: AppColor.filterDrop,
                          fontSize: 14,
                        ),),
                    )

                  ],
                )


              ],
            ),
          ),

          SizedBox(width: 5,),

          Container(
            width: 120,
            height: 50,
            // color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {  },
                  child: Text('Labels :',style: TextStyle(
                    color: AppColor.filteT,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.filteT,
                  ),),
                ),

                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 3),
                      width: 18,
                      height: 18,
                      child: Image.asset('images/tag.png',
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text('Medium',
                        style: TextStyle(
                          color: AppColor.filterDrop,
                          fontSize: 14,
                        ),),
                    )

                  ],
                )


              ],
            ),
          ),


        ],
      ),

    );
  }
}
