import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:educand/screens/practiceresult.dart';
import 'package:educand/screens/testresult.dart';
import 'package:educand/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class BatchNotifyScreen extends StatefulWidget {
  final String practice;
  final String test;
  final String mode;
  const BatchNotifyScreen({Key key, this.practice, this.test, this.mode})
      : super(key: key);

  @override
  State<BatchNotifyScreen> createState() => _BatchNotifyScreenState();
}

class _BatchNotifyScreenState extends State<BatchNotifyScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playAssetSound("assets/sounds/congratulations.wav");
  }

  playAssetSound(String asset) async {
    ByteData bytes = await rootBundle.load(asset); //load sound from assets
    Uint8List soundBytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    int result = await audioPlayer.playBytes(soundBytes);
    if (result == 1) {
      //play success
      print("Sound playing successful.");
    } else {
      print("Error while playing sound.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: widget.mode == "test" ? c5 : c8,
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/images/bagde_bg.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: c35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 4.5,
                    child: widget.mode == "practice"
                        ? imageAssetPractice()
                        : imageAssetTest(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                    ),
                    child: Text(
                      "Congratulations",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      "You have a received a badge",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Text(
                      widget.mode == "practice" ? practiceText() : testText(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      widget.mode == "practice"
                          ? "Completed ${widget.practice} Practice"
                          : "Completed ${widget.test} test",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  new Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: GestureDetector(
                      onTap: () => _onShareData(context),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                          left: 20,
                          bottom: 20,
                        ),
                        child: Container(
                          // padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment(-1.0, 0.0),
                                end: Alignment(2.0, -2.0),
                                colors: [
                                  Color(0xFFFF7600),
                                  Color(0xFFFF7600),
                                  Color(0xFFFFB206),
                                  Color(0xFFFFB206),
                                  Color(0xFFFFB206),
                                ],
                                stops: [
                                  0.28,
                                  0.38,
                                  0.58,
                                  0.85,
                                  .98,
                                ]),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 23.0,
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  'Share with your friends',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 48.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            widget.mode == "practice"
                                ? Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PracticeResults(
                                        mode: "standard",
                                      ),
                                    ),
                                    ModalRoute.withName("Practice"))
                                : Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TestResults(),
                                    ),
                                    ModalRoute.withName("Test"));
                          },
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageAssetTest() {
    if (widget.test == "1") {
      return Image.asset("assets/images/bright_beginner.png",
          fit: BoxFit.cover);
    } else if (widget.test == "5") {
      return Image.asset("assets/images/beaming_champ.png", fit: BoxFit.cover);
    } else if (widget.test == "10") {
      return Image.asset("assets/images/avid_reader.png", fit: BoxFit.cover);
    } else if (widget.test == "25") {
      return Image.asset("assets/images/grammarian.png", fit: BoxFit.cover);
    } else if (widget.test == "50") {
      return Image.asset("assets/images/rising_author.png", fit: BoxFit.cover);
    } else if (widget.test == "100") {
      return Image.asset("assets/images/young_scholar.png", fit: BoxFit.cover);
    }
    return Container();
  }

  Widget imageAssetPractice() {
    if (widget.practice == "1") {
      return Image.asset("assets/images/good_start.png", fit: BoxFit.cover);
    } else if (widget.practice == "10") {
      return Image.asset("assets/images/practice_10.png", fit: BoxFit.cover);
    } else if (widget.practice == "50") {
      return Image.asset("assets/images/practice_50.png", fit: BoxFit.cover);
    } else if (widget.practice == "100") {
      return Image.asset("assets/images/practice_100.png", fit: BoxFit.cover);
    } else if (widget.practice == "150") {
      return Image.asset("assets/images/practice_150.png", fit: BoxFit.cover);
    } else if (widget.practice == "250") {
      return Image.asset("assets/images/practice_250.png", fit: BoxFit.cover);
    }
    return Container();
  }

  _onShareData(BuildContext context) async {
    Share.share(
        'Hi check out my score on the Educand SPELL&THRILL test. Just click the link to see https://educand.org/my-educand-app/');
  }

  String practiceText() {
    if (widget.practice == "1") {
      return "Good Start";
    } else if (widget.practice == "10") {
      return "Practice 10";
    } else if (widget.practice == "50") {
      return "Practice 50";
    } else if (widget.practice == "100") {
      return "Practice 100";
    } else if (widget.practice == "150") {
      return "Practice 150";
    } else if (widget.practice == "250") {
      return "Practice 250";
    }
    return "";
  }

  String testText() {
    if (widget.test == "1") {
      return "Bright Beginner";
    } else if (widget.test == "5") {
      return "Beaming Champ";
    } else if (widget.test == "10") {
      return "Avid Reader";
    } else if (widget.test == "25") {
      return "Grammarian";
    } else if (widget.test == "50") {
      return "Rising Author";
    } else if (widget.test == "100") {
      return "Young Scholar";
    }
    return "";
  }

  Future<bool> _onBackPressed() {
    if (widget.mode == "practice") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PracticeResults(
              mode: "standard",
            ),
          ),
          ModalRoute.withName("Practice"));
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => TestResults(),
          ),
          ModalRoute.withName("Test"));
    }
  }
}
