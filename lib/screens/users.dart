import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:web_routing_app/components/layout.dart';
import 'package:web_routing_app/utils/mainColors.dart';
import 'package:web_routing_app/utils/toast.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  DocumentSnapshot<Object?>? firstDocument;
  DocumentSnapshot<Object?>? lastDocument;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  var formatter = NumberFormat('###,000');
  bool showView = false;
  int pageLimit = 10;
  String? statusValue;
  String? filterValue;
  bool isLoading = false;
  int currentPage = 0;
  bool goNext = true;
  bool goBack = true;

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

  List data = [];

  var userStats = {
    "win": 25,
    "loose": 10,
    "coin": 2633,
    "usd": 23,
    "follower": 440
  };

  List cardData = [
    {"title": "Win", "img": "assets/images/happy.png"},
    {"title": "Loose", "img": "assets/images/sad.png"},
    {"title": "Coin", "img": "assets/images/coins.png"},
    {"title": "USD", "img": "assets/images/dollars.png"},
    {"title": "Follower", "img": "assets/images/people.png"},
  ];

  void setUserStats(var user) {
    setState(() {
      userStats["win"] = user["win"];
      userStats["loose"] = user["loose"];
      userStats["coin"] = user["coin"];
      userStats["usd"] = user["usd"];
      userStats["follower"] = user["follower"];
      showView = true;
    });
  }

  void fetchData() {
    List _userData = [];
    var val;
    setState(() {
      isLoading = true;
    });
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    users.limit(pageLimit).snapshots().listen((event) {
      event.docs.forEach((element) {
        val = element.data();
        val!["id"] = element.id;
        _userData.add(val);
      });
      setState(() {
        data = _userData.reversed.toList();
        firstDocument = event.docChanges.first.doc;
        lastDocument = event.docChanges.last.doc;
        _userData = [];
        isLoading = false;
      });
    });
  }

  void fetchNext() {
    currentPage++;
    List _userData = [];
    var val;
    setState(() {
      isLoading = true;
    });
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    users
        .startAfterDocument(lastDocument!)
        .limit(pageLimit)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        event.docs.forEach((element) {
          val = element.data();
          val!["id"] = element.id;
          _userData.add(val);
        });
        setState(() {
          data = _userData.reversed.toList();
          firstDocument = event.docChanges.first.doc;
          lastDocument = event.docChanges.last.doc;
          _userData = [];
          isLoading = false;
        });
      } else {
        setState(() {
          data = [];
          isLoading = false;
        });
      }
    });
  }

  void fetchPrevious() {
    currentPage--;
    List _userData = [];
    var val;
    setState(() {
      isLoading = true;
    });
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    users
        .endBeforeDocument(lastDocument!)
        .limit(pageLimit)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        event.docs.forEach((element) {
          val = element.data();
          val!["id"] = element.id;
          _userData.add(val);
        });
        setState(() {
          data = _userData.reversed.toList();
          firstDocument = event.docChanges.first.doc;
          lastDocument = event.docChanges.last.doc;
          _userData = [];
          isLoading = false;
        });
      } else {
        setState(() {
          data = [];
          isLoading = false;
        });
      }
    });
  }

  void fetchByStatus() {

    List _userData = [];
    var val;
    setState(() {
      isLoading = true;
    });
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    users
        .limit(pageLimit)
        .where("status", isEqualTo: statusValue)
        .snapshots()
        .listen((event) {
      event.docs.forEach((element) {
        val = element.data();
        val!["id"] = element.id;
        _userData.add(val);
      });
      setState(() {
        data = _userData;
        _userData = [];
        isLoading = false;
      });
    });
  }

  void fetchByDate() {
    if (fromController.text.isNotEmpty && toController.text.isNotEmpty) {
      List _userData = [];
      var val;
      setState(() {
        isLoading = true;
      });
      CollectionReference users =
          FirebaseFirestore.instance.collection("Users");
      users
          .limit(pageLimit)
          .where("createdOn",
              isGreaterThanOrEqualTo: DateTime.parse(fromController.text),
              isLessThanOrEqualTo: DateTime.parse(toController.text))
          .snapshots()
          .listen((event) {
        event.docs.forEach((element) {
          val = element.data();
          val!["id"] = element.id;
          _userData.add(val);
        });
        setState(() {
          data = _userData;
          _userData = [];
          isLoading = false;
        });
      });
    }
  }

  void changeUserStatus(Map<String, dynamic> obj) {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    obj["status"] = !obj["status"];
    String docId = obj["id"];
    obj.remove("id");
    users.doc(docId).update(obj);
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
      url: "/users",
      child: Visibility(
        visible: !isLoading,
        replacement: Container(
          width: size.width - 260,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 25.w, top: 40.h),
              width: 0.75.sw,
              child: Column(
                children: [
                  Container(
                    height: 50.h,
                    width: 0.75.sw,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                                        onTap: () =>
                                            setUserStats(data[index]),
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
                                  width: 200.w,
                                  height: 50.h,
                                  margin: EdgeInsets.only(right: 20.w),
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
                                    data[index]["chartNo"].toString(),
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
                                    data[index]["level"].toString(),
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
                                    formatter
                                        .format(data[index]["totalSteps"]),
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
                                      onChanged: (val) =>
                                          changeUserStatus(data[index])),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.h),
                        width: 200.w,
                        height: 50.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Page: ",
                              style:
                                  TextStyle(color: drawerText, fontSize: 20.sp),
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              iconSize: 30.sp,
                              onPressed: () async {
                                CollectionReference users = FirebaseFirestore
                                    .instance
                                    .collection("Users");
                                users
                                    .limit(1)
                                    .endAtDocument(firstDocument!)
                                    .snapshots()
                                    .listen((event) {
                                  if (event.docChanges.isEmpty) {
                                    fetchPrevious();
                                  }else {
                                  showToast("No data available");
                                }
                                });
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: secondaryColor,
                              ),
                            ),
                            Text(
                              currentPage.toString(),
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 30.sp),
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              iconSize: 30.sp,
                              onPressed: () async {
                                CollectionReference users = FirebaseFirestore
                                    .instance
                                    .collection("Users");
                                users
                                    .startAfterDocument(lastDocument!)
                                    .limit(1)
                                    .snapshots()
                                    .listen((event) {
                                  if (event.docChanges.isNotEmpty) {
                                    fetchNext();
                                  } else {
                                    showToast("No data available");
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showView,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showView = false;
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: size.width - 250,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.only(left: 20.w, top: 110.26.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            border:
                                Border.all(width: 1, color: Color(0xFF707070)),
                            color: Colors.white),
                        width: 250,
                        height: size.height,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 60.w,
                              height: 550.h,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: cardData.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 64.24.h),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          cardData[index]["img"],
                                          width: 33.88.w,
                                        ),
                                        Text(
                                          cardData[index]["title"],
                                          style: TextStyle(
                                            color: drawerText,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 70.w, top: 8.h),
                              width: 60.w,
                              height: 550.h,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.only(bottom: 98.h),
                                    child: Text(
                                      userStats["win"].toString(),
                                      style: TextStyle(
                                        color: drawerText,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.only(bottom: 98.h),
                                    child: Text(
                                      userStats["loose"].toString(),
                                      style: TextStyle(
                                        color: drawerText,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.only(bottom: 98.h),
                                    child: Text(
                                      userStats["coin"].toString(),
                                      style: TextStyle(
                                        color: drawerText,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    margin: EdgeInsets.only(bottom: 98.h),
                                    child: Text(
                                      userStats["usd"].toString(),
                                      style: TextStyle(
                                        color: drawerText,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      userStats["follower"].toString(),
                                      style: TextStyle(
                                        color: drawerText,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
                              bottom: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
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
                setState(
                  () {
                    filterValue = val;
                  },
                )
              },
            ),
          ),
          filterDateField(
            context,
            "From",
            fromController,
            filterValue == "By Time",
          ),
          filterDateField(
            context,
            "To",
            toController,
            filterValue == "By Time",
          ),
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
                    .map<DropdownMenuItem<String>>(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => {
                  setState(() {
                    statusValue = val;
                  }),
                  // fetchByStatus()
                },
              ),
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
