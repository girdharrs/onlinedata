import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:onlinedata/viewpage.dart';

class insert extends StatefulWidget {
  const insert({Key? key}) : super(key: key);

  @override
  _insertState createState() => _insertState();
}

class _insertState extends State<insert> {
  TextEditingController a1 = TextEditingController();
  TextEditingController a2 = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String path = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("select picture"),
                      children: [
                        ListTile(
                          title: Text("gallery"),
                          onTap: () async {
                            Navigator.pop(context);
                            final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                            path = image!.path;
                            setState(() {});
                          },
                        ),
                        ListTile(
                          title: Text("camera"),
                          onTap: () async {
                            Navigator.pop(context);
                            final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                            path = photo!.path;
                            setState(() {});
                          },
                        )
                      ],
                    );
                  },
                );
              } ,
              child: path == ""
                  ? Image.asset("images/profile.png",height: 120,width: 120,)
                  : Image.file(File(path), height: 120, width: 120)),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: a1,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: a2,
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                String name = a1.text;
                String contact = a2.text;

        File file=File(path);

        List<int> list = file.readAsBytesSync();

        String imagestr=base64Encode(list);

              Map m ={'name': name, 'contact': contact,'imagestr':imagestr};

                var url = Uri.parse('https://sukhadiyadev.000webhostapp.com/APICalling/insert.php');
                var response = await http.post(url, body: m);
                print('Response status: ${response.statusCode}');
                print('Response body: ${response.body}');
               Map map = jsonDecode(response.body);
               int Connected=map['Connected'];
               if(Connected==1)
                 {
                   int result=map['result'];
                   if(result==1)
                     {
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                         return view();
                       },));

                     }

                 }
               else
                 {
                   Fluttertoast.showToast(
                       msg: "Not Connected.....",
                       toastLength: Toast.LENGTH_SHORT,
                       gravity: ToastGravity.CENTER,
                       timeInSecForIosWeb: 1,
                       backgroundColor: Colors.red,
                       textColor: Colors.white,
                       fontSize: 16.0
                   );

                 }


              },
              child: Text("save"))
        ],
      ),
    );
  }
}
