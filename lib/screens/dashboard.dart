import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_routing_app/components/layout.dart';
import 'package:web_routing_app/utils/mainColors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? filterValue;
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  List<String> filters = ["Custom", "All", "Day", "Week", "Month"];
  List<String> topTen = [
    "Mark",
    "John",
    "xxxxx",
    "xxxxx",
    "xxxxx",
    "xxxxx",
    "xxxxx",
    "xxxxx",
    "xxxxx",
    "xxxxx",
  ];

  String formatTopTen(List<String> list) {
    int index = 1;
    String result = "";
    list.forEach((element) {
      result += "$index:$element\n";
      index++;
    });
    return result.substring(0, 78);
  }

  @override
  void initState() {
    fromController.text = "";
    toController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavLayout(
      url: "/dashboard",
      filterWidget: Row(
        children: [
          Container(
            width: 150,
            child: DropdownButton<String>(
                focusColor: Colors.transparent,
                underline: Divider(height: 1, color: Colors.white),
                iconEnabledColor: Colors.white,
                dropdownColor: Colors.white,
                autofocus: false,
                itemHeight: 50,
                style: TextStyle(color: Colors.white),
                hint: Text(
                  filterValue ?? "Filters",
                  style: TextStyle(color: Colors.white),
                ),
                isExpanded: true,
                items: filters
                    .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(
                          value: e,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.black, width: 1))),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(Icons.arrow_right_outlined),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (val) => {
                      setState(() {
                        filterValue = val;
                      })
                    }),
          ),
          filterDateField(
              context, "From", fromController, filterValue == "Custom"),
          filterDateField(context, "To", toController, filterValue == "Custom"),
        ],
      ),
      child: Container(
          padding: EdgeInsets.all(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  detailsCard("USERS", NumberFormat.compact().format(1500000)),
                  detailsCard("TOTAL REDEMED COINS \nIN MONEY",
                      NumberFormat.compact().format(452000),
                      gap: 8),
                  detailsCard(
                      "ACTIVE EVENTS", NumberFormat.compact().format(10000)),
                  detailsCard(
                      "MAIN SPONSORS", NumberFormat.compact().format(10000)),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailsCard("ACTIVE CHALLANGES",
                        NumberFormat.compact().format(456000)),
                    detailsCard("TOTAL STORES REVENUE",
                        NumberFormat.compact().format(4500000)),
                    detailsCard("UPCOMMING EVENTS",
                        NumberFormat.compact().format(4000)),
                    detailsCard(
                        "SUB SPONSORS", NumberFormat.compact().format(4000)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailsCard("TOTAL COIN PURCHASE",
                        NumberFormat.compact().format(4500000)),
                    detailsCard("TOP TEN STEPS \nCHALLANGE(MORE WINS)",
                        formatTopTen(topTen),
                        gap: 10, height: 350, fontSize: 22),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget detailsCard(String title, String value,
      {double? height, double? gap, double? fontSize}) {
    return Container(
      height: height ?? 90,
      margin: EdgeInsets.only(top: 30),
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(color: borderColor, width: 5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: gap ?? 12),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: "Segoe UI",
                      color: borderColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                Visibility(
                  visible: title == "USERS",
                  child: Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      "57 countries",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize ?? 24,
                ),
              ),
              Visibility(
                visible: title == "USERS",
                child: Container(
                  height: 30,
                  margin: EdgeInsets.only(left: 20),
                  child: DropdownButton<String>(
                      items: [],
                      hint: Text("PAK",
                          style: TextStyle(color: Colors.black, fontSize: 12)),
                      underline: Divider(
                        color: Colors.black,
                        height: 1,
                      ),
                      onChanged: (val) {}),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget filterDateField(BuildContext context, String text,
      TextEditingController controller, bool condition) {
    return Visibility(
      visible: condition,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
        width: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            Expanded(
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: controller,
                decoration: InputDecoration(
                  hintText: "yyyy/mm/dd",
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.only(bottom: 20, left: 30),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now());

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      controller.text = formattedDate;
                      if (fromController.text.isNotEmpty &&
                          toController.text.isNotEmpty) {
                        print(fromController.text);
                        print(toController.text);
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
