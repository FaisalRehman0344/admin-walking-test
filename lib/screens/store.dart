import 'package:cloud_firestore/cloud_firestore.dart';
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
  DocumentSnapshot<Object?>? firstDocument;
  DocumentSnapshot<Object?>? lastDocument;
  int currentPage = 0;
  int pageLimit = 10;
  bool isUpdate = false;
  String updateId = "";
  bool isLoading = false;
  bool showView = false;
  var emailKey = GlobalKey<FormState>();
  var passwordKey = GlobalKey<FormState>();
  bool showForm = false;
  String? email, password;

  List data = [];
  List products = [];

  void addEmail() {
    if (email == null || password == null) {
      showToast("Please enter email and password");
    } else {
      setState(() {
        isLoading = true;
      });
      CollectionReference store =
          FirebaseFirestore.instance.collection("Store");
      if (isUpdate) {
        store.doc(updateId).update({"email": email, "password": password});
        isUpdate = false;
        updateId = "";
      } else {
        store.add({"email": email, "password": password, "product": null});
      }
      setState(() {
        isLoading = false;
        showForm = false;
      });
    }
  }

  void fetchData() {
    CollectionReference store = FirebaseFirestore.instance.collection("Store");
    List _userData = [];
    var val;
    setState(() {
      isLoading = true;
    });
    store.limit(pageLimit).snapshots().listen((event) {
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
    CollectionReference store = FirebaseFirestore.instance.collection("Store");
    store
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
    CollectionReference store = FirebaseFirestore.instance.collection("Store");
    store
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

  void setProducts(String id) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance.collection("Store").doc(id).get();
    if (doc.get("product") != null) products = doc.get("product");
    setState(() {
      showView = true;
    });
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
      url: "/store",
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
              width: size.width * .8,
              padding:
                  EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
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
                            style: ButtonStyle(
                                backgroundColor: materialBorderColor),
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
                                        textAlignVertical:
                                            TextAlignVertical.top,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        isUpdate = false;
                                        updateId = "";
                                        showForm = false;
                                      });
                                    },
                                    child: Text(
                                      "Cancel",
                                      style:
                                          TextStyle(color: deleteButtonColor),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              width: size.width * .8,
                              padding: EdgeInsets.only(
                                  left: 15, top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          style:
                                              TextStyle(color: cardTextColor),
                                        ),
                                        IconButton(
                                            onPressed: () =>
                                                setProducts(data[index]["id"]),
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
                                            onPressed: () {
                                              isUpdate = true;
                                              updateId = data[index]["id"];
                                              setState(() {
                                                showForm = true;
                                              });
                                            },
                                            child: Text(
                                              "Update",
                                              style: TextStyle(
                                                  color: updateButtonColor),
                                            )),
                                        TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("Store")
                                                .doc(data[index]["id"])
                                                .delete();
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: deleteButtonColor),
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
                                CollectionReference store = FirebaseFirestore
                                    .instance
                                    .collection("Store");
                                store
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
                              style: TextStyle(
                                  color: secondaryColor, fontSize: 30.sp),
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              iconSize: 30.sp,
                              onPressed: () async {
                                CollectionReference store = FirebaseFirestore
                                    .instance
                                    .collection("Store");
                                store
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
                              itemCount: products.length,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              child: Image.asset(
                                                  "assets/images/walking_logo.png"),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              height: 52,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    products[index]["name"],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: drawerText),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 15.h),
                                                    height: 30.h,
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: products[index]
                                                          ["rating"],
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
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
                                      Text(
                                        "Rs " +
                                            products[index]["price"]
                                                .toString() +
                                            "/=",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: drawerText,
                                            fontSize: 10),
                                      )
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
      ),
    );
  }
}
