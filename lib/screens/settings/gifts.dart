import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_routing_app/utils/mainColors.dart';

class GiftsScreen extends StatefulWidget {
  const GiftsScreen({Key? key}) : super(key: key);

  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  bool showForm = false;
  bool updateEntry = false;
  int? updateIndex;
  String? name, coins;

  List data = [
    {
      "image": "assets/images/walking_logo.png",
      "name": "Chocolate",
      "coins": 900
    },
    {"image": "assets/images/walking_logo.png", "name": "Water", "coins": 400},
    {"image": "assets/images/walking_logo.png", "name": "Water", "coins": 400},
  ].reversed.toList();

  void addGift() {
    if (name != null &&
        name!.isNotEmpty &&
        coins != null &&
        coins!.isNotEmpty) {
      Map<String, Object> gift = {
        "image": "assets/images/walking_logo.png",
        "name": name!,
        "coins": int.parse(coins!)
      };
      setState(() {
        if (updateEntry) {
          data.removeAt(updateIndex!);
          updateEntry = false;
          updateIndex = null;
        }
        data.add(gift);
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
            padding: EdgeInsets.only(left: 28.w),
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 460.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Item Image",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp)),
                      Text(
                        "Item Name",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                      Text(
                        "Coins",
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
              padding: EdgeInsets.only(left: 20.w),
              height: 114.h,
              width: .75.sw,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 104.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.w, color: primaryColor),
                        borderRadius: BorderRadius.circular(10)),
                    width: 110.w,
                    height: 91.h,
                    child: Center(
                        child: Text(
                      "Add Image",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                          color: primaryColor),
                    )),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.w),
                    width: 191.w,
                    height: 57.h,
                    color: Colors.white,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          name = value;
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
                  Container(
                    margin: EdgeInsets.only(right: 395.w),
                    width: 127.w,
                    height: 57.h,
                    color: Colors.white,
                    child: TextFormField(
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
                  Container(
                    width: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: addGift,
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
                  height: 114.h,
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
                        margin: EdgeInsets.only(right: 110.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1.w, color: primaryColor),
                            borderRadius: BorderRadius.circular(10)),
                        width: 110.w,
                        height: 91.h,
                        child: Container(
                          color: primaryColor,
                          padding: EdgeInsets.all(20.sp),
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Center(
                              child: Image.asset(data[index]["image"],color: Colors.white)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 65.w),
                        width: 100,
                        child: Text(
                          data[index]["name"].toString(),
                          style: TextStyle(color: cardTextColor),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 380.w),
                        width: 100,
                        child: Text(
                          data[index]["coins"].toString(),
                          style: TextStyle(color: cardTextColor),
                        ),
                      ),
                      Container(
                        width: 150,
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
