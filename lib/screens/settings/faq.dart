import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_routing_app/utils/mainColors.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  bool showForm = false;
  bool updateEntry = false;
  int? updateIndex;
  String? question, description;

  List data = [
    {
      "no": "Qno 1: \n",
      "question": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
      "description":
          "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    }
  ].reversed.toList();

  void addQuestion() {
    if (question != null &&
        question!.isNotEmpty &&
        description != null &&
        description!.isNotEmpty) {
      Map<String, String> questionData = {
        "no": "Qno " + (data.length + 1).toString() + ": \n",
        "question": question!,
        "description": description!
      };
      setState(() {
        if (updateEntry) {
          questionData["no"] = data[updateIndex!]["no"];
          data.removeAt(updateIndex!);
          updateEntry = false;
          updateIndex = null;
        }
        data.add(questionData);
        print(data);
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
                  width: 400.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Questions Title",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp)),
                      Text(
                        "Description",
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
              height: 143.h,
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
                    margin: EdgeInsets.only(right: 22.w),
                    width: 280.w,
                    height: 108.h,
                    color: Colors.white,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          question = value;
                        });
                      },
                      style: TextStyle(fontSize: 20.sp),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.sp),
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
                    margin: EdgeInsets.only(right: 50.w),
                    width: 587.w,
                    height: 108.h,
                    color: Colors.white,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      maxLines: null,
                      style: TextStyle(fontSize: 20.sp),
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.sp),
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
                    width: 200.w,
                    height: 130.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: addQuestion,
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
                  height: 150.h,
                  margin: EdgeInsets.only(top: 10),
                  width: .7.sw,
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 68.w),
                        width: 237.w,
                        height: 115.h,
                        child: Text(
                          data[index]["no"] + data[index]["question"],
                          maxLines: 4,
                          style: TextStyle(color: cardTextColor),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 180.w),
                        width: 451.w,
                        height: 115.h,
                        child: Text(
                          data[index]["description"].toString(),
                          maxLines: 4,
                          style: TextStyle(color: cardTextColor),
                        ),
                      ),
                      Container(
                        width: 200.w,
                        height: 130.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
