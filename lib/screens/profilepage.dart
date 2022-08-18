import 'dart:convert';
import 'dart:io';

import 'package:educand/utils/savedata.dart';
import 'package:educand/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/submitbutton.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String photo = "";
  String fName = "";
  String lName = "";
  var username = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var name = TextEditingController();
  var school = TextEditingController();
  var state = TextEditingController();
  var rank = TextEditingController();
  var testTaken = TextEditingController();
  var score = TextEditingController();
  List<String> nigerianState = [
    "Select State",
    "Abia",
    "Adamawa",
    "Akwa Ibom",
    "Anambra",
    "Bauchi",
    "Bayelsa",
    "Benue",
    "Borno",
    "Cross River",
    "Delta",
    "Ebonyi",
    "Edo",
    "Ekiti",
    "Enugu",
    "FCT - Abuja",
    "Gombe",
    "Imo",
    "Jigawa",
    "Kaduna",
    "Kano",
    "Katsina",
    "Kebbi",
    "Kogi",
    "Kwara",
    "Lagos",
    "Nasarawa",
    "Niger",
    "Ogun",
    "Ondo",
    "Osun",
    "Oyo",
    "Plateau",
    "Rivers",
    "Sokoto",
    "Taraba",
    "Yobe",
    "Zamfara"
  ];
  List<String> school_class = [
    "Select Class",
    "Primary One",
    "Primary Two",
    "Primary Three",
    "Primary Four",
    "Primary Five",
    "Primary Six",
    "JSS 1",
    "JSS 2",
    "JSS 3",
    "SSS 1",
    "SSS 2",
  ];
  String dropdownValue = '';
  String dropdownValue2 = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      photo = preferences.getString("photo") ??
          'https://img.freepik.com/free-photo/pleasant-looking-serious-man-stands-profile-has-confident-expression-wears-casual-white-t-shirt_273609-16959.jpg';
      name.text = preferences.getString("full_name");
      username.text = preferences.getString("user_name");
      email.text = preferences.getString("email");
      phone.text = preferences.getString("phone");
      school.text = preferences.getString("class") ?? "";
      state.text = preferences.getString("class") ?? "";
      rank.text = preferences.getString("rank");
      testTaken.text = preferences.getString("test_taken") ?? "";
      score.text = preferences.getString("score") ?? "";
      dropdownValue =
          preferences.getString("state") ?? nigerianState[0]; // get the value
      dropdownValue2 = preferences.getString("school_class") ?? school_class[0];
      fName = preferences.getString("first_name").split("")[0];
      lName = preferences.getString("last_name").split("")[0];
    });
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        photo = "file";
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double height2 = height / 7;
    return Scaffold(
      backgroundColor: c8,
      appBar: AppBar(
        backgroundColor: c8,
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(
            width: width,
            height: height,
            color: c8,
          ),
          Column(
            children: <Widget>[
              Container(
                height: height2,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        20,
                      ),
                      topLeft: Radius.circular(
                        20,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: (width / 6) + 8,
                          bottom: 8.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: false,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFFFB100),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            labelText: 'Fullname',
                            labelStyle: TextStyle(
                              color: Color(0xFFFFB100),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 16.0,
                            ),
                          ),
                          controller: name,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 2.0,
                            color: Color(0xFF515151),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: false,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFFFB100),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: Color(0xFFFFB100),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 16.0,
                            ),
                          ),
                          enabled: false,
                          controller: username,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 2.0,
                            color: Color(0xFF515151),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: false,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFFFB100),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Color(0xFFFFB100),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 16.0,
                            ),
                          ),
                          enabled: false,
                          controller: email,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 2.0,
                            color: Color(0xFF515151),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF9B9B9B),
                              ),
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: DropdownButton<String>(
                              value: dropdownValue2 == ""
                                  ? school_class[0]
                                  : dropdownValue2,
                              isExpanded: true,
                              hint: Text(
                                "Choose Class",
                                style: TextStyle(color: Colors.black),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF9B9B9B),
                              ),
                              menuMaxHeight: height / 2,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Color(0x00000000),
                              ),
                              dropdownColor: Colors.white,
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue2 = newValue;
                                  print("done");
                                });
                              },
                              items: school_class.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            filled: false,
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFFFB100),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                              color: Color(0xFFFFB100),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 16.0,
                            ),
                          ),
                          controller: phone,
                          style: TextStyle(
                            fontSize: 14.0,
                            height: 2.0,
                            color: Color(0xFF515151),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF9B9B9B),
                              ),
                              borderRadius: BorderRadius.circular(4.0)),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: DropdownButton<String>(
                              value: dropdownValue == ""
                                  ? nigerianState[0]
                                  : dropdownValue,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF9B9B9B),
                              ),
                              menuMaxHeight: height / 2,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 2,
                                color: Color(0x00000000),
                              ),
                              dropdownColor: Colors.white,
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;

                                  print("done");
                                });
                              },
                              items: nigerianState
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SubmitButton(
                        act: () async {
                          _uploadImage();
                        },
                        title: "SAVE CHANGES",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: height / 20,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: width / 6,
                    backgroundColor: photo == "https://educand.org/educand/"
                        ? c2
                        : Colors.grey,
                    child: Text(
                      photo == "https://educand.org/educand/"
                          ? "${fName}${lName}"
                          : photo == "file"
                              ? "${fName}${lName}"
                              : "",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    backgroundImage: _image == null
                        ? NetworkImage(photo)
                        : FileImage(File(_image.path)),
                  ),
                ),
                Positioned(
                  top: width / 5,
                  left: width / 5,
                  child: InkWell(
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: EdgeInsets.all(16),
                      child: Icon(Icons.camera_alt_sharp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          40,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200],
                            offset: const Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],
                      ),
                    ),
                    onTap: () {
                      getImage();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _uploadImage() async {
    _showDialog();
    if (_image != null) {
      var uri =
          Uri.parse("https://educand.org/educand/upload_profile_image.php");
      var request = new http.MultipartRequest("POST", uri);
      request.fields['username'] = username.text;
      request.files.add(new http.MultipartFile.fromBytes(
        "image",
        await File.fromUri(_image.uri).readAsBytes(),
        filename: _image.path.split("/").last,
        contentType: new MediaType('image', 'jpg'),
      ));

      request.send().then((response) async {
        if (response.statusCode == 200) {
          print("Uploaded!");
          var respStr = await http.Response.fromStream(response);
          print(respStr.body);
          Map<String, dynamic> data = jsonDecode(respStr.body);
          setState(() {
            photo = "https://educand.org/educand/" + data["url"];
            SaveData.saveStringData('photo', photo);
            _image = null;
          });
          _upload();
        }
      });
    } else {
      _upload();
    }
  }

  _upload() async {
    if (name.text != null && username.text != null) {
      Map userProfile = await FlutterSession().get("userProfile");

      http.Response response =
          await http.post('https://educand.org/educand/set_profile.php', body: {
        'fullname': name.text,
        'username': username.text,
        'email': userProfile["email"],
        'phone': phone.text,
        'password': userProfile["password"],
        'score': userProfile["score"],
        'rank': userProfile["rank"],
        'total_tests': userProfile["total_tests"],
        'total_practice': userProfile['total_practice'],
        'state': dropdownValue,
        'school_class': dropdownValue2
      });
      if (response.statusCode == 200) {
        print(response.body);
        if (response.body == "success") {
          Navigator.of(context).pop();
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setString("phone", phone.text);
          _showSuccessDialog("Changes Saved Successfully!");
        }
        http.Response response2 = await http
            .post('https://educand.org/educand/get_profile.php', body: {
          'username': username.text,
        });

        await FlutterSession().set("userProfile", response2.body);
        Map<String, dynamic> data = jsonDecode(response2.body);
        _saveData(data);
      } else {
        print('Request failed with status: ${response.statusCode}.');
        Navigator.of(context).pop();
        _showErrorDialog("Connection Error!");
      }
    } else {
      _showErrorDialog("Incomplete Details!");
    }
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle_sharp,
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
                child: Row(children: <Widget>[
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
                ]),
              ),
            ));
  }

  Future<Map> userProfile() async {
    Map userProfile = await FlutterSession().get("userProfile");
    return userProfile;
  }

  void _saveData(Map<String, dynamic> data) {
    SaveData.saveStringData('full_name', data["fullname"]);
    SaveData.saveFirstData(data["fullname"]);
    SaveData.saveLastData(data["fullname"]);
    SaveData.saveStringData('email', data["email"]);
    SaveData.saveStringData('user_name', data["username"]);
    SaveData.saveStringData('phone', data["phone"]);
    SaveData.saveStringData('score', data["score"]);
    SaveData.saveStringData('rank', data["rank"]);
    SaveData.saveStringData('total_tests', data["total_tests"]);
    SaveData.saveStringData('state', data["state"]);
    SaveData.saveStringData('school_class', data["school_class"]);
  }
}
