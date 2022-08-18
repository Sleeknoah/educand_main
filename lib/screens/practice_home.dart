import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:educand/screens/bagde_award.dart';
import 'package:educand/screens/practiceresult.dart';
import 'package:educand/screens/testresult.dart';
import 'package:educand/utils/loading.dart';
import 'package:educand/values/colors.dart';
import 'package:educand/widgets/submitbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PHome extends StatefulWidget {
  final String mode;
  final String type;
  PHome({this.mode, this.type});
  @override
  _PHomeState createState() => _PHomeState();
}

class _PHomeState extends State<PHome> {
  TextEditingController fnController = TextEditingController();
  int wordcount = 0;
  int _correct = 0;
  int _wrong = 0;
  int buildcount = 0;
  int splitcount = 0;
  List _wordList;
  List _scrabbledWord;
  List _ommittedWord;
  Timer _timer;
  int _start = 125;
  int _start_secs;
  int _start_mins;
  Future<List> getWords;
  BuildContext _mContext;
  AudioPlayer audioPlayer = AudioPlayer();
  SharedPreferences prefs;
  String level = '';
  bool visible1 = true;
  bool visible2 = false;
  String base = 'https://educand.org/educand/get_words.php?';

  @override
  void initState() {
    super.initState();
    _read();
    getWords = _getWords();
    startTimer();
  }

  _read() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      level = prefs.getString("level").toLowerCase();
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _timeupDialog();
          });
        } else {
          setState(() {
            _start--;
            _start_mins = (_start / 60).floor();
            _start_secs = _start - (_start_mins * 60);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: getWords,
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            List wordList = snapshot.data;
            _wordList = wordList;

            if (buildcount == 0) {
              // FlutterTts flutterTts = FlutterTts();
              // flutterTts.setLanguage("en-NG");
              // flutterTts.setSpeechRate(0.5);
              // flutterTts.setPitch(0.7);
              // flutterTts.speak(
              //   _wordList[wordcount]["word"],
              // );

              playSound(_wordList[wordcount]["audio_url"]);
              // VoiceController controller =
              //     FlutterTextToSpeech.instance.voiceController();
              // controller.init().then((_) {
              //   controller.speak(
              //     _wordList[wordcount]["word"],
              //   );
              // });
              buildcount++;
            }

            if (splitcount == 0) {
              split();
              ommit();
              splitcount++;
            }

            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text(
                  widget.mode == "test"
                      ? "Take Test"
                      : widget.mode == "scrabbled"
                          ? "Practice - Scrabbled Word Mode"
                          : widget.mode == "incomplete"
                              ? "Practice - Missing Word Mode"
                              : "Practice - Standard Mode",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                titleSpacing: 0.0,
                centerTitle: false,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: c7,
                // foregroundColor: c7,
              ),
              body: Center(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 0.0, left: 6.0, right: 6.0, bottom: 0.0),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 0,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 8,
                                    bottom: 8,
                                    left: 8,
                                    right: 8,
                                  ),
                                  child: Text(
                                    _start_mins.toString() +
                                        "m " +
                                        _start_secs.toString() +
                                        "s",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 20,
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Card(
                                  color: c10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    child: Center(
                                      child: Text(
                                        _correct.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 65,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  color: c11,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  )),
                                  child: Container(
                                    height: 110,
                                    width: 110,
                                    child: Center(
                                      child: Text(
                                        _wrong.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 65,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                      backgroundColor: Color(0x55CDEBF3),
                                    ),
                                    onPressed: () {
                                      // FlutterTts flutterTts = FlutterTts();
                                      // flutterTts.setLanguage("en-NG");
                                      // flutterTts.setSpeechRate(0.5);
                                      // flutterTts.setPitch(0.7);
                                      // flutterTts.speak(
                                      //   _wordList[wordcount]["word"],
                                      // );
                                      playSound(
                                          _wordList[wordcount]["audio_url"]);
                                      // VoiceController controller =
                                      //     FlutterTextToSpeech.instance
                                      //         .voiceController();
                                      // controller.init().then((_) {
                                      //   controller.speak(
                                      //     _wordList[wordcount]["word"],
                                      //   );
                                      // });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 1.0,
                                          horizontal: 0.0,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "LISTEN AGAIN",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: c8,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Icon(
                                              Icons.volume_up,
                                              size: 20,
                                              color: c8,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      ),
                                      backgroundColor: c8,
                                    ),
                                    onPressed: () {
                                      //skip
                                      wordcount = wordcount + 1;
                                      // FlutterTts flutterTts = FlutterTts();
                                      // flutterTts.setLanguage("en-NG");
                                      // flutterTts.setSpeechRate(0.5);
                                      // flutterTts.setPitch(0.7);
                                      // flutterTts.speak(
                                      //   _wordList[wordcount]["word"],
                                      // );
                                      playSound(
                                          _wordList[wordcount]["audio_url"]);
                                      // VoiceController controller =
                                      //     FlutterTextToSpeech.instance
                                      //         .voiceController();
                                      // controller.init().then((_) {
                                      //   controller.speak(
                                      //     _wordList[wordcount]["word"],
                                      //   );
                                      // });
                                      if (widget.mode == "scrabbled" ||
                                          widget.mode == "incomplete") {
                                        splitcount = 0;
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 1.0,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 1.0,
                                          horizontal: 0.0,
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Text(
                                                "SKIP",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_right_sharp,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 40,
                            bottom: 20,
                          ),
                          child: TextField(
                            controller: fnController,
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.visiblePassword,
                            autocorrect: false,
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).dividerColor,
                              hintText: 'Enter the pronounced Word',
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey[500],
                                  style: BorderStyle.solid,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey[500],
                                  style: BorderStyle.solid,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: c1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              filled: false,
                              contentPadding: EdgeInsets.only(left: 16),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            child: Text(
                              'Hint:',
                              style: TextStyle(
                                color: Color(0xFF9B9B9B),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: widget.mode == "scrabbled"
                                ? Wrap(
                                    alignment: WrapAlignment.center,
                                    children: <Widget>[
                                      for (var item in _scrabbledWord)
                                        Card(
                                          color: Color(0xFFFBAE30),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 3, left: 3, right: 3),
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              child: Text(
                                                item,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  )
                                : widget.mode == "incomplete"
                                    ? Wrap(
                                        alignment: WrapAlignment.center,
                                        children: <Widget>[
                                            for (var item in _ommittedWord)
                                              Card(
                                                color: Color(0xFFFBAE30),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 3,
                                                      left: 3,
                                                      right: 3),
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    child: Text(
                                                      item,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ])
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: c34,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 16.0,
                                          ),
                                          child: Text(
                                            _wordList[wordcount]["definitions"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[500],
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 16.0,
                            ),
                            child: Text(
                              _wordList[wordcount]["part_of_speech"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        new Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: SubmitButton(
                              title: "SUBMIT",
                              removePadding: true,
                              act: () {
                                if (equalsIgnoreCase(fnController.text,
                                    _wordList[wordcount]["title"])) {
                                  FocusScope.of(context).unfocus();
                                  fnController.clear();
                                  _correct++;
                                  _correctDialog(_wordList[wordcount]["title"]);
                                  Future.delayed(Duration(milliseconds: 1800),
                                      () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  });
                                  wordcount = wordcount + 1;
                                  splitcount = 0;
                                } else {
                                  _wrong++;
                                  FocusScope.of(context).unfocus();
                                  fnController.clear();
                                  _wrongDialog(_wordList[wordcount]["title"]);
                                  Future.delayed(Duration(milliseconds: 1500),
                                      () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  });
                                  wordcount = wordcount + 1;
                                  splitcount = 0;
                                }
                              }),
                        ),
                        //   Padding(
                        //     padding: EdgeInsets.only(
                        //         top: 30, bottom: 10, right: 10, left: 10),
                        //     child: FlatButton(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(4.0),
                        //       ),
                        //       color: Theme.of(context).primaryColor,
                        //       onPressed: () {
                        //         if (equalsIgnoreCase(fnController.text,
                        //             _wordList[wordcount]["word"])) {
                        //           if (wordcount > 8) {
                        //             _correct++;
                        //             _sessionDialog(_correct.toString());
                        //           } else {
                        //             FocusScope.of(context).unfocus();
                        //             fnController.clear();
                        //             _correct++;
                        //             _correctDialog("You answered correctly!");
                        //             wordcount = wordcount + 1;
                        //             splitcount = 0;
                        //           }
                        //         } else {
                        //           if (wordcount > 8) {
                        //             _wrong++;
                        //             _sessionDialog(_correct.toString());
                        //           } else {
                        //             _wrong++;
                        //             FocusScope.of(context).unfocus();
                        //             fnController.clear();
                        //             _wrongDialog(_wordList[wordcount]["word"]);
                        //             wordcount = wordcount + 1;
                        //             splitcount = 0;
                        //           }
                        //         }
                        //       },
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(
                        //           vertical: 15.0,
                        //           horizontal: 10.0,
                        //         ),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: <Widget>[
                        //             Expanded(
                        //               child: Text(
                        //                 "SUBMIT",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: 15.0,
                        //                     fontWeight: FontWeight.bold),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Future.delayed(
            //   Duration.zero,
            //   () => _showLoadingIndicator(widget.mode == "test"
            //       ? "Test mode loading"
            //       : "Practice mode loading"),
            // );
            return Container(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(
                    widget.mode == "test"
                        ? "Take Test"
                        : widget.mode == "scrabbled"
                            ? "Practice - Scrabbled Word Mode"
                            : widget.mode == "incomplete"
                                ? "Practice - Missing Word Mode"
                                : "Practice - Standard Mode",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  titleSpacing: 0.0,
                  centerTitle: false,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: c7,
                  // foregroundColor: c7,
                ),
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: Colors.black,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 24.0,
                            ),
                            child: Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: c2,
                                ),
                                width: 32,
                                height: 32),
                          ),
                          Text(
                            "Please wait …",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  void _showLoadingIndicator([String text]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          backgroundColor: Colors.white,
          content: LoadingIndicator(
            text: text,
          ),
        );
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  _timeupDialog() async {
    playAssetSound("assets/sounds/time_up.wav");
    showDialog(
      context: context,
      barrierDismissible: true,
      // ignore: deprecated_member_use
      // change this to child
      // i'm on 2.x
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    new Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/gif/Time-Up.gif',
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 16.0,
                ),
                child: Text(
                  "Time up!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      _sessionDialog(_correct, _wrong);
    });
  }

  _correctDialog(String text) async {
    playAssetSound("assets/sounds/correct.wav");
    showDialog(
      context: context,
      barrierDismissible: false,
      // ignore: deprecated_member_use
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 8.0),
              //   child: Row(
              //     children: <Widget>[
              //       new Spacer(),
              //       InkWell(
              //         onTap: () {
              //           Navigator.of(context, rootNavigator: true).pop();
              //         },
              //         child: Icon(
              //           Icons.close,
              //           size: 20,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Image.asset(
                'assets/gif/Correct.gif',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "Correct!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "The Correct word is:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.grey[500],
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                        ),
                        child: Text(
                          capitalize(text),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: c1,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      print("correct closed");
      // FlutterTts flutterTts = FlutterTts();
      // flutterTts.setLanguage("en-NG");
      // flutterTts.setSpeechRate(0.5);
      // flutterTts.setPitch(0.7);
      // flutterTts.speak(
      //   _wordList[wordcount]["word"],
      // );
      playSound(_wordList[wordcount]["audio_url"]);
      // VoiceController controller =
      //     FlutterTextToSpeech.instance.voiceController();
      // controller.init().then((_) {
      //   controller.speak(
      //     _wordList[wordcount]["word"],
      //   );
      // });
    });
  }

  _wrongDialog(String text) async {
    playAssetSound("assets/sounds/wrong.wav");
    await showDialog(
      context: context,
      barrierDismissible: false,
      // ignore: deprecated_member_use
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.only(
              //     bottom: 8.0,
              //   ),
              //   child: Row(
              //     children: <Widget>[
              //       new Spacer(),
              //       InkWell(
              //         onTap: () {
              //           Navigator.of(context, rootNavigator: true).pop();
              //         },
              //         child: Icon(
              //           Icons.close,
              //           size: 20,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Image.asset(
                'assets/gif/Wrong.gif',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                ),
                child: Text(
                  "Wrong!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      "The correct word is: ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: Text(
                        capitalize(text),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: c1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      print("wrong closed");
      // FlutterTts flutterTts = FlutterTts();
      // flutterTts.setLanguage("en-NG");
      // flutterTts.setSpeechRate(0.5);
      // flutterTts.setPitch(0.7);
      // flutterTts.speak(
      //   _wordList[wordcount]["word"],
      // );
      playSound(_wordList[wordcount]["audio_url"]);
      // VoiceController controller =
      //     FlutterTextToSpeech.instance.voiceController();
      // controller.init().then((_) {
      //   controller.speak(
      //     _wordList[wordcount]["word"],
      //   );
      // });
    });
  }

  _sessionDialog(int correct, int wrong) async {
    playAssetSound("assets/sounds/game_completed.wav");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int total = correct + wrong;
    preferences.setString("questions", total.toString());
    preferences.setString("correct", correct.toString());
    preferences.setString("incorrect", wrong.toString());
    // _timer.cancel();
    await showDialog(
      context: context,
      barrierDismissible: false,
      // ignore: deprecated_member_use
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Visibility(
                    visible: visible1,
                    child: Image.asset(
                      'assets/gif/Correct.gif',
                      width: 130,
                      height: 130,
                    ),
                  ),
                  Visibility(
                    visible: visible2,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Complete!",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: widget.mode == "test"
                      ? Text(
                          "Spelling Test Complete.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : Text(
                          "Practice Session Complete.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  backgroundColor: Colors.orange[700],
                ),
                onPressed: () {
                  widget.mode == "test"
                      ? saveCred()
                      : widget.mode == "scrabbled"
                          ? Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PracticeResults(
                                  mode: "scrabbled",
                                ),
                              ),
                              ModalRoute.withName("/Home"))
                          : widget.mode == "incomplete"
                              ? Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PracticeResults(
                                      mode: "incomplete",
                                    ),
                                  ),
                                  ModalRoute.withName("/Home"),
                                )
                              : saveCred();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 1.0,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 1.0,
                      horizontal: 0.0,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(
                              4.0,
                            ),
                            child: Text(
                              "See Results",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> _getWords() async {
    if (widget.mode == "test") {
      String url = 'https://educand.org/educand/get_words_test.php';
      http.Response response = await http.post(url);
      Map<String, dynamic> data = jsonDecode(response.body);
      return data["payload"];
    } else {
      String url = 'https://educand.org/educand/get_words.php?' + widget.type;
      http.Response response = await http.post(url);
      Map<String, dynamic> data = jsonDecode(response.body);
      return data["payload"];
    }

    // if (widget.mode == "test") {
    //
    //   // return jsonDecode(response.body);
    // } else {
    //   http.Response response = await http.post(url);
    //   Map<String, dynamic> data = jsonDecode(response.body);
    //   return data["payload"];
    //   // return jsonDecode(response.body);
    // }
  }

  bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  List shuffle(List items) {
    var random = new Random();
// Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  split() {
    List itemsList = _wordList[wordcount]["title"].toUpperCase().split('');
    _scrabbledWord = shuffle(itemsList);
  }

  ommit() {
    String str = _wordList[wordcount]["title"];
    double halflength = str.length / 2;
    _ommittedWord = str
        .toUpperCase()
        .substring(0, str.length - halflength.floor())
        .split("");
    String _ommittedStr = _ommittedWord.join();
    for (var i = 1; i <= halflength.floor(); i++)
      _ommittedStr = _ommittedStr + "-";
    _ommittedWord = _ommittedStr.split("");
  }

  String capitalize(String string) {
    return "${string[0].toUpperCase()}${string.substring(1)}";
  }

  saveCred() async {
    // Navigator.pop(context);
    loadResults();

    Map userProfile = await FlutterSession().get("userProfile");
    _correct = _correct * 10;

    if (widget.mode == "test") {
      int score = int.parse(userProfile['score']) + _correct;

      userProfile['score'] = score.toString();

      var totaltests = int.parse(userProfile['total_tests']) + 1;
      userProfile['total_tests'] = totaltests.toString();
      print(totaltests);
      print(userProfile['total_tests']);

      http.Response response =
          await http.post('https://educand.org/educand/set_profile.php', body: {
        'username': userProfile['username'],
        'fullname': userProfile['fullname'],
        'email': userProfile['email'],
        'phone': userProfile['phone'],
        'password': userProfile['password'],
        'rank': userProfile['rank'],
        'total_tests': userProfile['total_tests'],
        'total_practice': userProfile['total_practice'],
        'state': userProfile['state'],
        'school_class': userProfile['school_class'],
        'score': userProfile['score']
      });

      if (response.statusCode == 200) {
        http.Response profileResponse = await http
            .post('https://educand.org/educand/get_profile.php', body: {
          'username': userProfile['username'],
        });

        await FlutterSession().set("userProfile", profileResponse.body);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("score", userProfile['score']);
        preferences.setString("total_tests", userProfile['total_tests']);

        if (mounted) {
          if (userProfile['total_tests'] == "1" ||
              userProfile['total_tests'] == "5" ||
              userProfile['total_tests'] == "10" ||
              userProfile['total_tests'] == "25" ||
              userProfile['total_tests'] == "50" ||
              userProfile['total_tests'] == "100") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BatchNotifyScreen(
                  mode: "test",
                  test: userProfile['total_tests'],
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TestResults(),
              ),
            );
          }
        }
      }
    } else if (widget.mode == "standard") {
      var totalPractice = int.parse(userProfile['total_practice']) + 1;
      userProfile['total_practice'] = totalPractice.toString();
      print(totalPractice);
      print(userProfile['total_practice']);

      http.Response response =
          await http.post('https://educand.org/educand/set_profile.php', body: {
        'username': userProfile['username'],
        'fullname': userProfile['fullname'],
        'email': userProfile['email'],
        'phone': userProfile['phone'],
        'password': userProfile['password'],
        'rank': userProfile['rank'],
        'total_tests': userProfile['total_tests'],
        'total_practice': userProfile['total_practice'],
        'state': userProfile['state'],
        'school_class': userProfile['school_class'],
        'score': userProfile['score']
      });

      if (response.statusCode == 200) {
        http.Response profileResponse = await http
            .post('https://educand.org/educand/get_profile.php', body: {
          'username': userProfile['username'],
        });

        await FlutterSession().set("userProfile", profileResponse.body);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("total_practice", userProfile['total_practice']);
        if (mounted) {
          if (userProfile['total_practice'] == "1" ||
              userProfile['total_practice'] == "10" ||
              userProfile['total_practice'] == "50" ||
              userProfile['total_practice'] == "100" ||
              userProfile['total_practice'] == "150" ||
              userProfile['total_practice'] == "250") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BatchNotifyScreen(
                  mode: "practice",
                  practice: userProfile['total_practice'],
                ),
              ),
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => PracticeResults(
                  mode: "standard",
                ),
              ),
              ModalRoute.withName("Practice"),
            );
          }
        }
      }
    }
  }

  playSound(String url) async {
    int result = await audioPlayer.play(url);

    if (result == 1) {
      print("Playing...");
    }
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

  void loadResults() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      // ignore: deprecated_member_use
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Loading results...",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
