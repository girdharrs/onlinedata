import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:onlinedata/viewpage.dart';

class edit extends StatefulWidget {
  List<dynamic> list;
  int index;
  edit(this.list,this.index);

  // const edit({Key? key}) : super(key: key);


  @override
  _editState createState() => _editState();
}

class _editState extends State<edit> {
  TextEditingController a1 = TextEditingController();
  TextEditingController a2 = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String path ="";
  String imgstr="";
  String id="";
  String newimagename="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();

  }
  get()
  {
    imgstr="https://sukhadiyadev.000webhostapp.com/APICalling/${widget.list[widget.index]['imagename']}";
    id=widget.list[widget.index]['id'];
    newimagename=widget.list[widget.index]['imagename'];
    a1.text=widget.list[widget.index]['name'];
    a2.text=widget.list[widget.index]['contact'];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( body: ListView(
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
                ? Image.network(imgstr,height: 120,width: 120)
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
              String newname = a1.text;
              String newcontact = a2.text;
              // String id = widget.list[widget.index]['id'];

              String newimagestr = "";
              if(path.isNotEmpty)
                {
                  File file=File(path);

                  List<int> list = file.readAsBytesSync();

                  newimagestr=base64Encode(list);

                }
              Map m ={'id': id,'name': newname, 'contact': newcontact,'imagestr':newimagestr,'imagename' : newimagename};


              var url = Uri.parse('https://sukhadiyadev.000webhostapp.com/APICalling/update.php');

              var response = await http.post(url,body: m);
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
                    msg: "Not Update.....",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );

              }

            },
            child: Text("Update"))
           ],
         )
    );
  }
}
