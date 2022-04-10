import 'package:flutter/material.dart';
import 'package:web_routing_app/routing/fluro_router.dart';
import 'package:web_routing_app/utils/auth.dart';
import 'package:web_routing_app/utils/mainColors.dart';

class NavLayout extends StatefulWidget {
  final Widget child;
  final Widget? filterWidget;
  final String url;
  const NavLayout(
      {Key? key, required this.child, this.filterWidget, required this.url})
      : super(key: key);

  @override
  State<NavLayout> createState() => _NavLayoutState();
}

class _NavLayoutState extends State<NavLayout> {
  List menus = [
    {"title": "Dashboard", "width": 5, "url": "/dashboard"},
    {"title": "Users", "width": 0, "url":"/users"},
    {"title": "Challenges", "width": 0 ,"url":"/challenges"},
    {"title": "Settings", "width": 0, "url":"/settings"},
    {"title": "Store", "width": 0, "url": "/store"}
  ];

  void onMenuChange(String title) {
    menus.forEach((element) {
      setState(() {
        if (title == element["title"])
          Flurorouter.router.navigateTo(context, element["url"]);
      });
    });
  }

  @override
  void initState() {
    AuthService.checkLogin(context);
    menus.forEach((element) {
      setState(() {
        if (widget.url == element["url"]) {
          element["width"] = 4;
        } else
          element["width"] = 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 270, right: 20),
            width: double.infinity,
            height: 60,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.filterWidget ??
                    Container(
                      width: 100,
                    ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      width: 180,
                      child: TextFormField(
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                          contentPadding: EdgeInsets.only(top: 20),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.search, color: Colors.white)),
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () => onMenuChange(
                                          menus.elementAt(index)["title"]),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        padding: EdgeInsets.only(
                                            left: 10, top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                                color: menus.elementAt(
                                                            index)["width"] !=
                                                        0
                                                    ? Colors.white
                                                    : secondaryColor,
                                                width: menus
                                                    .elementAt(index)["width"]),
                                          ),
                                        ),
                                        child: Text(
                                          menus.elementAt(index)["title"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
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
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                child: widget.child,
              ),
            ],
          )
        ],
      ),
    );
  }
}
