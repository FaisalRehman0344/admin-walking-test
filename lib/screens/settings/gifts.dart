import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:web_routing_app/utils/mainColors.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as path;
import 'package:web_routing_app/utils/toast.dart';

class GiftsScreen extends StatefulWidget {
  const GiftsScreen({Key? key}) : super(key: key);

  @override
  State<GiftsScreen> createState() => _GiftsScreenState();
}

class _GiftsScreenState extends State<GiftsScreen> {
  DocumentSnapshot<Object?>? firstDocument;
  DocumentSnapshot<Object?>? lastDocument;
  int currentPage = 0;
  int pageLimit = 10;
  bool isLoading = false;
  bool showForm = false;
  bool isUpdate = false;
  String updateIndex = "";
  String? name, coins;
  Uint8List? _photo;
  MediaInfo? _photoInfo;

  List data = [];

  void pickImage() async {
    final pickedFile = await ImagePickerWeb.getImageInfo;
    if (mounted) {
      setState(() {
        if (pickedFile != null) {
          _photoInfo = pickedFile;
          _photo = pickedFile.data;
        }
      });
    }
  }

  void addGift() async {
    if (name == null || coins == null) {
      showToast("Please enter Question and Description");
    } else {
      setState(() {
        isLoading = true;
        showForm = false;
      });
      CollectionReference gifts =
          FirebaseFirestore.instance.collection("Gifts");
      var gift = {"image": "", "name": name!, "coins": int.parse(coins!)};
      if (isUpdate) {
        String? url;
        if (_photo != null && _photoInfo != null) {
          url = (await uploadImage(_photoInfo!, updateIndex)).toString();
        }
        if (url != null) {
          gift["image"] = url;
        }
        gifts.doc(updateIndex).update(gift);
        isUpdate = false;
        updateIndex = "";
        _photo = null;
        _photoInfo = null;
      } else {
        if (_photo == null) {
          setState(() {
            isLoading = false;
            showForm = false;
          });
          showToast("Please select an image");
        } else {
          String docId = (await gifts.add(gift)).id;
          String url = (await uploadImage(_photoInfo!, docId)).toString();
          gift["image"] = url;
          gifts.doc(docId).update(gift);
        }
      }
      setState(() {
        isLoading = false;
        showForm = false;
      });
    }
  }

  Future<String> uploadImage(MediaInfo info, String docId) async {
    String? mimeType = mime(path.basename(info.fileName!));
    final extension = extensionFromMime(mimeType!);
    var metadata = SettableMetadata(
      contentType: mimeType,
    );

    Reference r =
        FirebaseStorage.instance.ref().child("gifts/images/$docId.$extension");
    TaskSnapshot sn = r.putData(info.data!, metadata).snapshot;
    return sn.ref.getDownloadURL();
    // fb.StorageReference ref = fb
    //     .app()
    //     .storage()
    //     .refFromURL('gs://admin-walking-challange.appspot.com')
    //     .child("gifts/images/$docId.$extension");
    // fb.UploadTask uploadTask = ref.put(info.data, metadata);
    // fb.UploadTaskSnapshot taskSnapshot = await uploadTask.future;
    // return taskSnapshot.ref.getDownloadURL();
  }

  void fetchData() {
    CollectionReference gift = FirebaseFirestore.instance.collection("Gifts");
    List _giftData = [];
    var val;
    setState(() {
      isLoading = true;
    });
    gift.limit(pageLimit).snapshots().listen((event) {
      event.docs.forEach((element) {
        val = element.data();
        val!["id"] = element.id;
        _giftData.add(val);
      });
      setState(() {
        data = _giftData.reversed.toList();
        firstDocument = event.docChanges.first.doc;
        lastDocument = event.docChanges.last.doc;
        _giftData = [];
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
    CollectionReference gift = FirebaseFirestore.instance.collection("Gifts");
    gift
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
    CollectionReference gift = FirebaseFirestore.instance.collection("Gifts");
    gift
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
        ),
      ),
      child: Container(
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
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        margin: EdgeInsets.only(right: 104.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1.w, color: primaryColor),
                            borderRadius: BorderRadius.circular(10)),
                        width: 110.w,
                        height: 91.h,
                        child: Center(
                          child: _photo == null
                              ? Text(
                                  "Add Image",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.sp,
                                      color: primaryColor),
                                )
                              : Container(
                                  color: primaryColor,
                                  padding: EdgeInsets.all(20.sp),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Center(
                                      child: Image.memory(
                                    _photo!,
                                    fit: BoxFit.fill,
                                  )),
                                ),
                        ),
                      ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ListView.builder(
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
                                border:
                                    Border.all(width: 1.w, color: primaryColor),
                                borderRadius: BorderRadius.circular(10)),
                            width: 110.w,
                            height: 91.h,
                            child: Container(
                              color: primaryColor,
                              padding: EdgeInsets.all(20.sp),
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Center(
                                  child: Image.network(data[index]["image"])),
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
                                        isUpdate = true;
                                        updateIndex = data[index]["id"];
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
                                    setState(() {
                                      FirebaseFirestore.instance
                                          .collection("Gifts")
                                          .doc(data[index]["id"])
                                          .delete();
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
                          CollectionReference gifts =
                              FirebaseFirestore.instance.collection("Gifts");
                          gifts
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
                          CollectionReference gifts =
                              FirebaseFirestore.instance.collection("Gifts");
                          gifts
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
