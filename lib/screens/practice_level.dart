import 'package:educand/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'practice_home.dart';

class PLevel extends StatefulWidget {
  @override
  _PLevelState createState() => _PLevelState();
}

class _PLevelState extends State<PLevel> {
  List<String> listItem = ["Basic", "Intermediate", "Advanced"];

  String dropdownValue = '';
  SharedPreferences prefs;

  _read() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      dropdownValue = prefs.getString("level"); // get the value
    });
  }

  @override
  void initState() {
    super.initState();
    _read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Practice Mode",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        elevation: 0.0,
        // foregroundColor: c7,
        centerTitle: false,
        titleSpacing: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: c7,
      ),
      backgroundColor: c7,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Container(
            decoration: BoxDecoration(color: c7),
            padding: EdgeInsets.only(
              top: 12.0,
              left: 12.0,
              right: 12.0,
              bottom: 12.0,
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
                // Card(
                //   elevation: 6.0,
                //   child: Padding(
                //     padding: EdgeInsets.all(16.0),
                //     child:
                SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xFF3A336A),
                    ),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      hint: Text(
                        "Choose level",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Container(
                          width: 20,
                          height: 20,
                          child: Image.asset("assets/images/icons-close.png"),
                        ),
                      ),
                      elevation: 16,
                      style: const TextStyle(color: Colors.white),
                      underline: Container(
                        height: 0,
                        color: Color(0x00000000),
                      ),
                      dropdownColor: Color(0xFF3A336A),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                          prefs.setString("level", newValue);
                          print("done");
                        });
                      },
                      items: listItem
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  // Container(
                  //   child:
                  //       Image.asset('assets/images/plevel_illustration.png'),
                  // ),

                  Container(
                    padding: EdgeInsets.only(
                      top: 15,
                      bottom: 10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Choose a Practice Mode',
                        style: TextStyle(
                          fontSize: 19,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),

                  listTile(c1, "Standard\nMode", "standard",
                      "assets/images/chat.png", "assets/images/arrow.png"),
                  listTile(c3, "Scrabbled\nWord Mode", "scrabbled",
                      "assets/images/puzzles.png", "assets/images/arrow.png"),
                  listTile(c4, "Missing\nWord Mode", "incomplete",
                      "assets/images/columns.png", "assets/images/arrow.png"),
                  SizedBox(height: 60.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listTile(Color c, String text, String goto, String imagePath,
          String trailing) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: GestureDetector(
          onTap: () {
            _newScreen(context, goto, dropdownValue.toLowerCase());
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
            decoration: BoxDecoration(
              color: c,
              // padding: EdgeInsets.symmetric(),

              borderRadius: BorderRadius.all(
                Radius.circular(
                  10,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 8.0,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        imagePath,
                        width: 30,
                        height: 30,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        new Spacer(),
                        Container(
                          child: Image.asset(
                            trailing,
                            width: 20,
                            height: 20,
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

void _newScreen(BuildContext context, String goto, String level) {
  if (level == "choose level") {
  } else {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: PHome(
          mode: goto,
          type: level,
        ),
      ),
    );
  }
}
