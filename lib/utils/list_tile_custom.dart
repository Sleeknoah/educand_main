import 'package:flutter/material.dart';

class ListTileCustom extends StatelessWidget {
  final ImageProvider<Object> leading;
  final Widget title;
  final Widget subtitle;
  const ListTileCustom({Key key, this.leading, this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            width: width / 4,
            height: width / 4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: leading,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                title,
                subtitle,
              ],
            ),
          ),
        )
      ],
    );
  }
}
