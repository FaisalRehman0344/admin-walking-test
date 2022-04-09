import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:web_routing_app/components/layout.dart';
import 'package:web_routing_app/utils/mainColors.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String? statusValue;
  String? filterValue;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  List<String> filters = ["By Time", "By Status"];
  List<String> filterStatus = ["Completed", "In Progress"];
  List columns = [
    {
      "title": "View",
      "gap": 100.w,
    },
    {
      "title": "Full Name",
      "gap": 130.w,
    },
    {
      "title": "Country",
      "gap": 100.w,
    },
    {
      "title": "City",
      "gap": 100.w,
    },
    {
      "title": "Email",
      "gap": 160.w,
    },
    {
      "title": "Chart No",
      "gap": 100.w,
    },
    {
      "title": "Level",
      "gap": 100.w,
    },
    {
      "title": "Total Steps",
      "gap": 100.w,
    },
    {
      "title": "Active/Suspend",
      "gap": 100.w,
    }
  ];

  List data = [
    {
      "fullName": "xxxxxxxxxxx",
      "country": "Pakistan",
      "city": "Karachi",
      "email": "xxxxxxxxxxxxxxxxxx",
      "chartNo": "23",
      "level": "5",
      "totalSteps": "103,000",
      "status": true
    },
    {
      "fullName": "xxxxxxxxxxx",
      "country": "Pakistan",
      "city": "Karachi",
      "email": "xxxxxxxxxxxxxxxxxx",
      "chartNo": "23",
      "level": "5",
      "totalSteps": "103,000",
      "status": true
    },
    {
      "fullName": "xxxxxxxxxxx",
      "country": "Pakistan",
      "city": "Karachi",
      "email": "xxxxxxxxxxxxxxxxxx",
      "chartNo": "23",
      "level": "5",
      "totalSteps": "103,000",
      "status": true
    }
  ];

  @override
  Widget build(BuildContext context) {
    return NavLayout(
      url: "/users",
      child: Container(
        margin: EdgeInsets.only(left: 25.w, top: 40.h),
        width: 0.75.sw,
        child: Column(
          children: [
            Container(
              width: 0.75.sw,
              height: 50.h,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: columns.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: columns[index]["gap"]),
                    child: Text(
                      columns[index]["title"],
                      style: TextStyle(
                        color: drawerText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: 0.75.sw,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(right: 102.w),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.remove_red_eye,
                                size: 33.w,
                                color: cardTextColor,
                              )),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 100.w,
                        height: 50.h,
                        margin: EdgeInsets.only(right: 100.w),
                        child: Text(
                          data[index]["fullName"],
                          style: TextStyle(
                            color: drawerText,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 100.w,
                        height: 50.h,
                        margin: EdgeInsets.only(right: 55.w),
                        child: Text(
                          data[index]["country"],
                          style: TextStyle(
                            color: drawerText,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 100.w,
                        height: 50.h,
                        margin: EdgeInsets.only(right: 28.w),
                        child: Text(
                          data[index]["city"],
                          style: TextStyle(
                            color: drawerText,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 150.w,
                        height: 50.h,
                        margin: EdgeInsets.only(right: 70.w),
                        child: Text(
                          data[index]["email"],
                          style: TextStyle(
                            color: drawerText,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 100.w,
                        height: 50.h,
                        margin: EdgeInsets.only(right: 55.w),
                        child: Text(
                          data[index]["chartNo"],
                          style: TextStyle(
                            color: drawerText,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 100.w,
                        height: 50.h,
                        margin: EdgeInsets.only(right: 33.w),
                        child: Text(
                          data[index]["level"],
                          style: TextStyle(
                            color: drawerText,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: 100.w,
                        height: 50.h,
                        margin: EdgeInsets.only(right: 70.w),
                        child: Text(
                          data[index]["totalSteps"],
                          style: TextStyle(
                            color: drawerText,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          width: 100.w,
                          height: 50.h,
                          child: Switch(
                            value: data[index]["status"],
                            onChanged: (val) {
                              setState(() {
                                data[index]["status"] = val;
                              });
                            },
                          )),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      filterWidget: Row(
        children: [
          Container(
            width: 150,
            child: DropdownButton<String>(
                focusColor: Colors.transparent,
                underline: Divider(height: 1, color: Colors.white),
                iconEnabledColor: Colors.white,
                dropdownColor: Colors.white,
                autofocus: false,
                itemHeight: 50,
                style: TextStyle(color: Colors.white),
                hint: Text(
                  filterValue ?? "Filters",
                  style: TextStyle(color: Colors.white),
                ),
                isExpanded: true,
                items: filters
                    .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                          value: e,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 1))),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(Icons.arrow_right_outlined),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (val) => {
                      setState(() {
                        filterValue = val;
                      })
                    }),
          ),
          filterDateField(
              context, "From", fromController, filterValue == "By Time"),
          filterDateField(context, "To", toController, filterValue == "By Time"),
          Visibility(
            visible: filterValue == "By Status",
            child: Container(
              margin: EdgeInsets.only(left: 20),
              width: 100,
              child: DropdownButton<String>(
                  focusColor: Colors.transparent,
                  underline: Divider(height: 1, color: Colors.white),
                  iconEnabledColor: Colors.white,
                  dropdownColor: Colors.white,
                  autofocus: false,
                  itemHeight: 50,
                  style: TextStyle(color: Colors.white),
                  hint: Text(
                    statusValue ?? "Status",
                    style: TextStyle(color: Colors.white),
                  ),
                  isExpanded: true,
                  items: filterStatus
                      .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.black, width: 1))),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) => {
                        setState(() {
                          statusValue = val;
                        })
                      }),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterDateField(BuildContext context, String text,
      TextEditingController controller, bool condition) {
    return Visibility(
      visible: condition,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: controller,
                decoration: InputDecoration(
                  hintText: "yyyy/mm/dd",
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.only(bottom: 20, left: 30),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now());

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      controller.text = formattedDate;
                      if (fromController.text.isNotEmpty &&
                          toController.text.isNotEmpty) {
                        print(fromController.text);
                        print(toController.text);
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
