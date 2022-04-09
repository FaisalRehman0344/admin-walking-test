import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_routing_app/components/layout.dart';
import 'package:web_routing_app/utils/mainColors.dart';
import 'package:web_routing_app/utils/toast.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool showView = false;
  var emailKey = GlobalKey<FormState>();
  var passwordKey = GlobalKey<FormState>();
  bool showForm = false;
  String? email, password;

  List data = [
    {
      "email": "Reebok@gmail.com",
      "password": "abc123456789",
    }
  ];

  List cardData = [
    {"name": "ProductName", "rating": 5, "price": 500},
    {"name": "ProductName", "rating": 5, "price": 500}
  ];

  void addEmail() {
    if (email == null || password == null) {
      showToast("Please enter email and password");
    } else {
      setState(() {
        data.add({"email": email, "password": password});
        showForm = false;
      });
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return NavLayout(
      url: "/store",
      child: Stack(
        children: [
          Container(
            width: size.width * .8,
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 140),
                        child: Row(
                          children: [
                            Text(
                              "Password",
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 120,
                            ),
                            Text(
                              "View",
                              style: TextStyle(color: Colors.white),
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
                          style:
                              ButtonStyle(backgroundColor: materialBorderColor),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: showForm,
                  child: Container(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      width: size.width * .8,
                      padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Form(
                            key: emailKey,
                            child: Container(
                              width: 190,
                              height: 35,
                              color: Colors.white,
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                textAlignVertical: TextAlignVertical.top,
                                decoration: InputDecoration(
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
                          Container(
                            margin: EdgeInsets.only(right: 65),
                            child: Row(
                              children: [
                                Form(
                                  key: passwordKey,
                                  child: Container(
                                    width: 150,
                                    height: 35,
                                    color: Colors.white,
                                    child: TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          password = value;
                                        });
                                      },
                                      textAlignVertical: TextAlignVertical.top,
                                      decoration: InputDecoration(
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
                                SizedBox(
                                  width: 28,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 150,
                            margin: EdgeInsets.only(right: 170),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: addEmail,
                                    child: Text(
                                      "Save",
                                      style:
                                          TextStyle(color: updateButtonColor),
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
                ),
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 10),
                        width: size.width * .8,
                        padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              child: Text(
                                data[index]["email"],
                                style: TextStyle(color: cardTextColor),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 25),
                              width: 220,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data[index]["password"],
                                    style: TextStyle(color: cardTextColor),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showView = true;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              width: 150,
                              margin: EdgeInsets.only(right: 170),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Update",
                                        style:
                                            TextStyle(color: updateButtonColor),
                                      )),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Delete",
                                      style:
                                          TextStyle(color: deleteButtonColor),
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          border:
                              Border.all(width: 1, color: Color(0xFF707070)),
                          color: Colors.white),
                      width: 250,
                      height: size.height,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 35.h,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: cardData.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            color: primaryColor,
                                            width: 75.w,
                                            height: 75.w,
                                            child: Image.asset("assets/images/walking_logo.png"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            height: 50,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(cardData[index]["name"],style: TextStyle(fontSize: 14,color: drawerText),),
                                                SizedBox(height: 5.h,),
                                                Container(
                                                  margin: EdgeInsets.only(bottom: 10),
                                                  height: 20,
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: cardData[index]
                                                        ["rating"],
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        margin: EdgeInsets.only(
                                                            left: 2),
                                                        child: Image.asset(
                                                          "assets/images/rating.png",
                                                          width: 23.w,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Text("Rs "+cardData[index]["price"].toString()+"/=",style: TextStyle(fontWeight: FontWeight.bold,color: drawerText,fontSize: 10),)
                                  ],
                                ),
                              );
                            },
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
    );
  }
}
