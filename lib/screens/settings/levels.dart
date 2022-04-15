import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:web_routing_app/utils/mainColors.dart';
import 'package:web_routing_app/utils/toast.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  DocumentSnapshot<Object?>? firstDocument;
  DocumentSnapshot<Object?>? lastDocument;
  int currentPage = 0;
  int pageLimit = 10;
  var formatter = NumberFormat('###,000');
  var stepsKey = GlobalKey<FormState>();
  var coinEarnKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isUpdate = false;
  String updateId = "";
  bool showForm = false;
  int? updateIndex;
  String? steps, coins;

  List data = [];

  void addLevel() {
    if (coins == null || steps == null) {
      showToast("Please enter level, coins and steps");
    } else {
      var lvl = {
        "levelNo": data.length + 1,
        "steps": int.parse(steps!),
        "coins": int.parse(coins!)
      };
      setState(() {
        isLoading = true;
      });
      CollectionReference level =
          FirebaseFirestore.instance.collection("Level");
      if (isUpdate) {
        level.doc(updateId).update(lvl);
        isUpdate = false;
        updateId = "";
      } else {
        level.add(lvl);
      }
      setState(() {
        isLoading = false;
        showForm = false;
      });
    }
  }

  void fetchData() {
    CollectionReference level = FirebaseFirestore.instance.collection("Level");
    List _levelData = [];
    var val;
    setState(() {
      isLoading = true;
    });
    level.limit(pageLimit).snapshots().listen((event) {
      event.docs.forEach((element) {
        val = element.data();
        val!["id"] = element.id;
        _levelData.add(val);
      });
      setState(() {
        data = _levelData.reversed.toList();
        firstDocument = event.docChanges.first.doc;
        lastDocument = event.docChanges.last.doc;
        _levelData = [];
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
    CollectionReference level = FirebaseFirestore.instance.collection("Level");
    level
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
    CollectionReference level = FirebaseFirestore.instance.collection("Level");
    level
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

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isLoading,
      replacement: Container(
          width: 1.sw - 300,
          height: 1.sh - 200,
          child: Center(
            child: CircularProgressIndicator(),
          )),
      child: Container(
        width: .75.sw,
        padding:
            EdgeInsets.only(top: 15.h, left: 15.w, right: 15.w, bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 600.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Level No",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp)),
                        Text(
                          "Steps",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp),
                        ),
                        Text(
                          "Coin Earn",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          showForm = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Text(
                          "+Create",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ButtonStyle(backgroundColor: materialBorderColor),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: showForm,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 54.h,
                width: .75.sw,
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20.w, right: 150.w),
                      width: 50,
                      child: Text(
                        (data.length + 1).toString(),
                        style: TextStyle(color: cardTextColor),
                      ),
                    ),
                    Form(
                      key: stepsKey,
                      child: Container(
                        margin: EdgeInsets.only(right: 135.w),
                        width: 122.w,
                        height: 33.h,
                        color: Colors.white,
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            setState(() {
                              steps = value;
                            });
                          },
                          textAlignVertical: TextAlignVertical.top,
                          style: TextStyle(fontSize: 20.sp),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 15.w, right: 15.w),
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(
                                color: Colors.white,
                                width: 0.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Form(
                      key: coinEarnKey,
                      child: Container(
                        margin: EdgeInsets.only(right: 210.w),
                        width: 122.w,
                        height: 33.h,
                        color: Colors.white,
                        child: TextFormField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(fontSize: 20.sp),
                          onChanged: (value) {
                            setState(() {
                              coins = value;
                            });
                          },
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 15.w, right: 15.w),
                            border: OutlineInputBorder(
                              borderSide: new BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 170),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: addLevel,
                              child: Text(
                                "Save",
                                style: TextStyle(color: updateButtonColor),
                              )),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isUpdate = false;
                                updateId = "";
                                showForm = false;
                              });
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: deleteButtonColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 54.h,
                      margin: EdgeInsets.only(top: 10),
                      width: .7.sw,
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20.w, right: 68.w),
                            width: 100,
                            child: Text(
                              data[index]["levelNo"].toString(),
                              style: TextStyle(color: cardTextColor),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 118.w),
                            width: 100,
                            child: Text(
                              formatter.format(data[index]["steps"]),
                              style: TextStyle(color: cardTextColor),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 145),
                            width: 100,
                            child: Text(
                              formatter.format(data[index]["coins"]),
                              style: TextStyle(color: cardTextColor),
                            ),
                          ),
                          Container(
                            width: 150,
                            margin: EdgeInsets.only(right: 170),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isUpdate = true;
                                        updateId = data[index]["id"];
                                        showForm = true;
                                      });
                                    },
                                    child: Text(
                                      "Update",
                                      style:
                                          TextStyle(color: updateButtonColor),
                                    )),
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Level")
                                        .doc(data[index]["id"])
                                        .delete();
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: deleteButtonColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                        style: TextStyle(color: drawerText, fontSize: 20.sp),
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 30.sp,
                        onPressed: () async {
                          CollectionReference level =
                              FirebaseFirestore.instance.collection("Level");
                          level
                              .limit(1)
                              .endAtDocument(firstDocument!)
                              .snapshots()
                              .listen((event) {
                            if (event.docChanges.isEmpty) {
                              fetchPrevious();
                            } else {
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
                        style:
                            TextStyle(color: secondaryColor, fontSize: 30.sp),
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        iconSize: 30.sp,
                        onPressed: () async {
                          CollectionReference level =
                              FirebaseFirestore.instance.collection("Level");
                          level
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
    );
  }
}
