import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OptionContainer extends StatelessWidget {
  final Function function;
  final bool isSvg;
  final String image;
  final String text;
  const OptionContainer(
      {Key key, this.function, this.isSvg = false, this.image, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFECECEC),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: isSvg == true
                    ? SvgPicture.asset(
                        image,
                        width: 16.0,
                        height: 16.0,
                      )
                    : Image.asset(
                        image,
                        width: 16.0,
                        height: 16.0,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0,
                    color: Color(0xFF575757),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              new Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
