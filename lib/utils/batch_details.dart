import 'package:flutter/material.dart';

class BatchDetails extends StatelessWidget {
  final String image;
  final String title;
  final bool testTaken;
  final String number;
  const BatchDetails(
      {Key key, this.image, this.title, this.testTaken = false, this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 0.0,
          ),
          child: Image.asset(
            image,
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 4,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
          ),
          child: Visibility(
            visible: testTaken == true ? true : false,
            child: CircleAvatar(
              backgroundColor: Color(0xFF0087C5),
              radius: 13,
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              // child: Container(
              //   decoration: BoxDecoration(
              //     color: Color(0xFF0087C5),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(4.0),
              //     child: Text(
              //       number,
              //       style: TextStyle(
              //         fontSize: 12,
              //         fontWeight: FontWeight.w600,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
