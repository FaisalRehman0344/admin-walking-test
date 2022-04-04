import 'package:flutter/material.dart';
import 'package:web_routing_app/routing/fluro_router.dart';
import 'package:web_routing_app/utils/auth.dart';
import 'package:web_routing_app/utils/mainColors.dart';
import 'package:web_routing_app/utils/toast.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List menus = [
    {"title": "Dashboard", "width": 5},
    {"title": "Users", "width": 0},
    {"title": "Challenges", "width": 0},
    {"title": "Settings", "width": 0},
    {"title": "Store", "width": 0}
  ];

  void onMenuChange(String title) {
    menus.forEach((element) {
      if (title == element["title"]) {
        setState(() {
          element["width"] = 5;
        });
      } else {
        setState(() {
          element["width"] = 0;
        });
      }
    });
  }

  @override
  void initState() {
    // AuthService.checkLogin(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: 60,
            color: primaryColor,
          ),
          Container(
            height: size.height,
            width: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: secondaryColor),
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/walking_logo.png",
                              width: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "WALKING CHALLANGE ADMIN",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: menus.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => onMenuChange(
                                    menus.elementAt(index)["title"]),
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  padding: EdgeInsets.only(
                                      left: 10, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                          color: menus.elementAt(index)["width"] != 0 ? Colors.white : secondaryColor,
                                          width:
                                              menus.elementAt(index)["width"]),
                                    ),
                                  ),
                                  child: Text(
                                    menus.elementAt(index)["title"],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(10),
                          fixedSize: MaterialStateProperty.all(
                              Size(double.infinity, 20))),
                      onPressed: () {
                        AuthService auth = new AuthService();
                        auth.signOut(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/Logout.png",
                            width: 20,
                          ),
                          SizedBox(width: 2),
                          Text(
                            "LOGOUT",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
