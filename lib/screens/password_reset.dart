import 'dart:convert';

import 'package:educand/values/colors.dart';
import 'package:educand/widgets/submitbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

class PasswordReset extends StatefulWidget {
  const PasswordReset({Key key}) : super(key: key);

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  var oldPassword = TextEditingController();
  var newPassword = TextEditingController();
  var newPasswordConfirm = TextEditingController();

  bool isObscure = true;
  bool isClicked = false;
  bool isObscure2 = true;
  bool isClicked2 = false;
  bool isObscure3 = true;
  bool isClicked3 = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Text(
                "Change your account password using the form below.",
                style: TextStyle(
                  color: c32,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                obscureText: isObscure3,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure3 = !isObscure3;
                        isClicked3 = !isClicked3;
                      });
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      child: isClicked3
                          ? Icon(
                              Icons.visibility_off,
                            )
                          : Icon(
                              Icons.remove_red_eye_sharp,
                            ),
                    ),
                  ),
                  filled: false,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFFB100),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  labelText: 'Old Password',
                  labelStyle: TextStyle(
                    color: c33,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0,
                  ),
                ),
                controller: oldPassword,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 2.0,
                  color: Color(0xFF515151),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                obscureText: isObscure2,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure2 = !isObscure2;
                        isClicked2 = !isClicked2;
                      });
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      child: isClicked2
                          ? Icon(Icons.visibility_off)
                          : Icon(
                              Icons.remove_red_eye_sharp,
                            ),
                    ),
                  ),
                  filled: false,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFFB100),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  labelText: 'New Password',
                  labelStyle: TextStyle(
                    color: c33,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0,
                  ),
                ),
                controller: newPassword,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 2.0,
                  color: Color(0xFF515151),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                obscureText: isObscure,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isObscure = !isObscure;
                        isClicked = !isClicked;
                      });
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      child: isClicked
                          ? Icon(Icons.visibility_off)
                          : Icon(
                              Icons.remove_red_eye_sharp,
                            ),
                    ),
                  ),
                  filled: false,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFFFB100),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  labelText: 'Confirm New Password',
                  labelStyle: TextStyle(
                    color: c33,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 16.0,
                  ),
                ),
                controller: newPasswordConfirm,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 2.0,
                  color: Color(0xFF515151),
                ),
              ),
            ),
            new Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 32.0,
              ),
              child: SubmitButton(
                act: () async {
                  _changePassword();
                },
                title: "Update Password",
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showSuccessDialog(String text) {
    showDialog(
      context: context,
      // ignore: deprecated_member_use
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: Container(
          height: MediaQuery.of(context).size.height / 3.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle,
                size: 66,
                color: Color(0xFF10CA88),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text("Successful!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: new Container(
                height: MediaQuery.of(context).size.height / 12.0,
                child: Row(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Image.asset(
                        'assets/images/loading.gif',
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20, left: 20),
                      child: Text(
                        "Processing ...",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ]),
              ),
            ));
  }

  _showErrorDialog(String text) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: new Container(
          height: MediaQuery.of(context).size.height / 12.0,
          child: Row(
            children: <Widget>[
              Center(
                child: Icon(
                  Icons.error,
                  size: 60,
                  color: Colors.redAccent,
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 15, left: 15),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _changePassword() async {
    if (newPassword.text == newPasswordConfirm.text && _checkInputs()) {
      _showDialog();
      Map userProfile = await FlutterSession().get("userProfile");

      http.Response response = await http
          .post('https://educand.org/educand/change_password.php', body: {
        'username': userProfile["username"],
        'oldpassword': oldPassword.text,
        'newpassword': newPassword.text
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        if (data["message"] == "Success") {
          Navigator.of(context).pop();
          _showSuccessDialog("Password changed successfully");
        } else {
          Navigator.of(context).pop();
          _showErrorDialog("Password Incorrect");
        }
      }
    }
  }

  bool _checkInputs() {
    if (oldPassword.text.isEmpty || oldPassword.text == " ") {
      return false;
    } else if (newPassword.text.isEmpty || newPassword.text == " ") {
      return false;
    } else if (newPasswordConfirm.text.isEmpty ||
        newPasswordConfirm.text == " ") {
      return false;
    } else {
      return true;
    }
  }
}
