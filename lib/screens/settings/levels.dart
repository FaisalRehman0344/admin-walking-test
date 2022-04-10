import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_routing_app/utils/mainColors.dart';

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({Key? key}) : super(key: key);

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  var stepsKey = GlobalKey<FormState>();
  var coinEarnKey = GlobalKey<FormState>();
  bool showForm = false;
  bool updateEntry = false;
  int? updateIndex;
  String? steps, coins;

  List data = [
    {"levelNo": 1, "steps": 52978, "coins": 156116},
    {"levelNo": 2, "steps": 52978, "coins": 156116},
    {"levelNo": 3, "steps": 52978, "coins": 156116},
  ].reversed.toList();

  void addLevel() {
    if (steps != null &&
        steps!.isNotEmpty &&
        coins != null &&
        coins!.isNotEmpty) {
      Map<String, int> lvl = {
        "levelNo": data.length + 1,
        "steps": int.parse(steps!),
        "coins": int.parse(coins!)
      };
      setState(() {
        if (updateEntry) {
          data.removeAt(updateIndex!);
          updateEntry = false;
          updateIndex = null;
        }
        data.add(lvl);
        showForm = false;
      });
      data = data.reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            child: ListView.builder(
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
                          data[index]["steps"].toString(),
                          style: TextStyle(color: cardTextColor),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 145),
                        width: 100,
                        child: Text(
                          data[index]["coins"].toString(),
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
                                    updateEntry = true;
                                    updateIndex = index;
                                    showForm = true;
                                  });
                                },
                                child: Text(
                                  "Update",
                                  style: TextStyle(color: updateButtonColor),
                                )),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  data.remove(data[index]);
                                });
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
          ),
        ],
      ),
    );
  }
}
