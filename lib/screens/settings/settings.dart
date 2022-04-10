import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:web_routing_app/components/layout.dart';
import 'package:web_routing_app/screens/settings/faq.dart';
import 'package:web_routing_app/screens/settings/gifts.dart';
import 'package:web_routing_app/screens/settings/levels.dart';
import 'package:web_routing_app/utils/mainColors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget currentScreen = LevelsScreen();
  List navButtons = [
    {"title": "Levels", "color": borderColor, "screen": LevelsScreen()},
    {"title": "FAQ", "color": secondaryTextColor, "screen": FaqScreen()},
    {"title": "Gifts", "color": secondaryTextColor, "screen": GiftsScreen()}
  ];

  void onMenuChange(String title) {
    navButtons.forEach((element) {
      setState(() {
        if (title == element["title"]) {
          element["color"] = borderColor;
          currentScreen = element["screen"];
        } else {
          element["color"] = secondaryTextColor;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavLayout(
      url: "/settings",
      child: Container(
        margin: EdgeInsets.only(left: 25.w, top: 25.h),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Container(
              width: 300,
              height: 30,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: navButtons.length,
                itemBuilder: ((context, index) {
                  return navButton(
                      navButtons[index]["title"], navButtons[index]["color"]);
                }),
              ),
            ),
            currentScreen
          ],
        ),
      ),
    );
  }

  Widget navButton(String title, Color color) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onMenuChange(title),
        child: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.only(left: 20.w),
          width: 105.w,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: color, width: 2.w),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
