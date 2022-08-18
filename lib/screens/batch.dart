import 'package:educand/utils/batch_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BatchScreen extends StatefulWidget {
  const BatchScreen({Key key}) : super(key: key);

  @override
  State<BatchScreen> createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> {
  String testTaken = '';
  String practiceTaken = '';
  int test = 0;
  int practice = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      testTaken = preferences.getString("total_tests") ?? '0';
      practiceTaken = preferences.getString("total_practice") ?? '0';
      test = int.parse(testTaken);
      practice = int.parse(practiceTaken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 8.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Batch",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 32.0,
                ),
                child: Text(
                  "Spelling Test",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              _practiceBatch(),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 32.0,
                  top: 16.0,
                ),
                child: Text(
                  "SPELL&THRILL! Practice",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: _testBatch(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _practiceBatch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            BatchDetails(
              image: practice > 0
                  ? "assets/images/good_start.png"
                  : "assets/images/good_start_2.png",
              title: "Good Start",
              number: "1",
            ),
            BatchDetails(
              image: practice > 99
                  ? "assets/images/practice_100.png"
                  : "assets/images/practice_100_2.png",
              title: "Practice 100",
              number: "1",
            ),
          ],
        ),
        Column(
          children: <Widget>[
            BatchDetails(
              image: practice > 9
                  ? "assets/images/practice_10.png"
                  : "assets/images/practice_10_2.png",
              title: "Practice 10",
              number: "1",
            ),
            BatchDetails(
              image: practice > 149
                  ? "assets/images/practice_150.png"
                  : "assets/images/practice_150_2.png",
              title: "Practice 150",
              number: "1",
            ),
          ],
        ),
        Column(
          children: <Widget>[
            BatchDetails(
              image: practice > 49
                  ? "assets/images/practice_50.png"
                  : "assets/images/practice_50_2.png",
              title: "Practice 50",
              number: "1",
            ),
            BatchDetails(
              image: practice > 249
                  ? "assets/images/practice_250.png"
                  : "assets/images/practice_250_2.png",
              title: "Practice 250",
              number: "1",
            ),
          ],
        ),
      ],
    );
  }

  Widget _testBatch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            BatchDetails(
              image: test > 0
                  ? "assets/images/bright_beginner.png"
                  : "assets/images/bright_beginner_2.png",
              title: "Bright Beginner",
              testTaken: true,
              number: "1",
            ),
            BatchDetails(
              image: test > 24
                  ? "assets/images/grammarian.png"
                  : "assets/images/grammarian_2.png",
              title: "Grammarian",
              testTaken: true,
              number: "25",
            ),
          ],
        ),
        Column(
          children: <Widget>[
            BatchDetails(
              image: test > 4
                  ? "assets/images/beaming_champ.png"
                  : "assets/images/beaming_champ_2.png",
              title: "Beaming Champ",
              testTaken: true,
              number: "5",
            ),
            BatchDetails(
              image: test > 49
                  ? "assets/images/rising_author.png"
                  : "assets/images/rising_author_2.png",
              title: "Rising Author",
              testTaken: true,
              number: "50",
            ),
          ],
        ),
        Column(
          children: <Widget>[
            BatchDetails(
              image: test > 9
                  ? "assets/images/avid_reader.png"
                  : "assets/images/avid_reader_2.png",
              title: "Avid Reader",
              testTaken: true,
              number: "10",
            ),
            BatchDetails(
              image: test > 99
                  ? "assets/images/young_scholar.png"
                  : "assets/images/young_scholar_2.png",
              title: "Young Scholar",
              testTaken: true,
              number: "100",
            ),
          ],
        ),
      ],
    );
  }
}
