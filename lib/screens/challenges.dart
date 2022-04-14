import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:web_routing_app/components/layout.dart';
import 'package:web_routing_app/utils/mainColors.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({Key? key}) : super(key: key);

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  bool isLoding = false;
  var formatter = NumberFormat('#,##,000');
  String? statusValue;
  String? filterValue;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  List<String> filters = ["Custom", "By Status"];
  List<String> filterStatus = ["Completed", "In Progress"];
  List data = [];

  void fetchData() {
    List _userData = [];
    setState(() {
      isLoding = true;
    });
    CollectionReference users =
        FirebaseFirestore.instance.collection("Challenges");
    users.snapshots().listen((event) {
      event.docs.forEach((element) {
        _userData.add(element.data());
      });
      setState(() {
        data = _userData.reversed.toList();
        _userData = [];
        isLoding = false;
      });
    });
  }

  void fetchByStatus() {
    List _userData = [];
    setState(() {
      isLoding = true;
    });
    CollectionReference users =
        FirebaseFirestore.instance.collection("Challenges");
    users.where("status", isEqualTo: statusValue).snapshots().listen((event) {
      event.docs.forEach((element) {
        _userData.add(element.data());
      });
      setState(() {
        data = _userData.reversed.toList();
        _userData = [];
        isLoding = false;
      });
    });
  }

  void fetchByDate() {
    if (fromController.text.isNotEmpty && toController.text.isNotEmpty) {
      List _userData = [];
      setState(() {
        isLoding = true;
      });
      CollectionReference users =
          FirebaseFirestore.instance.collection("Challenges");
      users
          .where("createdOn",
              isGreaterThanOrEqualTo: DateTime.parse(fromController.text),
              isLessThanOrEqualTo: DateTime.parse(toController.text))
          .snapshots()
          .listen((event) {
        event.docs.forEach((element) {
          _userData.add(element.data());
        });
        setState(() {
          data = _userData.reversed.toList();
          _userData = [];
          isLoding = false;
        });
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return NavLayout(
      url: "/challenges",
      child: Visibility(
        visible: !isLoding,
        replacement: Container(
          width: size.width - 260,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        child: Container(
          width: size.width * .5,
          margin: EdgeInsets.only(left: 15, top: 20),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Challenger",
                      style: TextStyle(
                          color: drawerText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Opponent",
                      style: TextStyle(
                          color: drawerText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Total Time",
                      style: TextStyle(
                          color: drawerText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Coin",
                      style: TextStyle(
                          color: drawerText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Status",
                      style: TextStyle(
                          color: drawerText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Winner",
                      style: TextStyle(
                          color: drawerText,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(left: 15),
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120.w,
                          child: Text(
                            data[index]["challenger"],
                            style: TextStyle(
                              color: drawerText,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 26),
                          width: 120.w,
                          child: Text(
                            data[index]["opponent"],
                            style: TextStyle(
                              color: drawerText,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 27),
                          alignment: Alignment.center,
                          width: 60.w,
                          child: Text(
                            data[index]["totalTime"],
                            style: TextStyle(
                              color: drawerText,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 50),
                          alignment: Alignment.center,
                          width: 70.w,
                          child: Text(
                            formatter.format(data[index]["coin"]),
                            style: TextStyle(
                              color: drawerText,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          alignment: Alignment.center,
                          width: 100.w,
                          child: Text(
                            data[index]["status"],
                            style: TextStyle(
                              color: drawerText,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25),
                          alignment: Alignment.center,
                          width: 120.w,
                          child: Text(
                            data[index]["winner"] ?? "--",
                            style: TextStyle(
                              color: drawerText,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
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
              context, "From", fromController, filterValue == "Custom"),
          filterDateField(context, "To", toController, filterValue == "Custom"),
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
                        }),
                        fetchByStatus()
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
                    });
                    fetchByDate();
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
