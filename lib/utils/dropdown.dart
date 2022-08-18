import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropDownCustom extends StatefulWidget {
  final List<String> item;
  const DropDownCustom({Key key, this.item}) : super(key: key);

  @override
  State<DropDownCustom> createState() => _DropDownCustomState();
}

class _DropDownCustomState extends State<DropDownCustom> {
  String dropdownValue = '';
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    _read();
  }

  _read() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      dropdownValue =
          prefs.getString("level") ?? "Choose level"; // get the value
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
      ),
      elevation: 16,
      style: const TextStyle(color: Colors.white),
      underline: Container(
        height: 2,
        color: Color(0x00000000),
      ),
      dropdownColor: Colors.black,
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          prefs.setString("level", newValue);
          print("done");
        });
      },
      items: widget.item.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
