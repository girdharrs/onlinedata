import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlinedata/insertpage.dart';
import 'package:http/http.dart' as http;

import 'editpage.dart';

class view extends StatefulWidget {
  const view({Key? key}) : super(key: key);

  @override
  _viewState createState() => _viewState();
}

class _viewState extends State<view> {
  List list = [];
  bool ready= false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  get() async {
    PaintingBinding.instance!.imageCache!.clear();

    var url = Uri.parse('https://sukhadiyadev.000webhostapp.com/APICalling/view.php');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    Map map = jsonDecode(response.body);
    int Connected = map['Connected'];
    if (Connected == 1) {
      int result = map['result'];
      if (result == 1) {


        setState(() {
          list = map['userdata'];
          print(list);
          ready=true;
        });
      } else {
        Center(
          child: Text("No Data Found"),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ready?ListView.builder(itemCount: list.length,
        itemBuilder: (context, index) {
          String imgstr="https://sukhadiyadev.000webhostapp.com/APICalling/${list[index]['imagename']}";
          return Card(
            child: ListTile(
              leading: Image.network(imgstr),
              title: Text(list[index]['name']),
              subtitle: Text(list[index]['contact']),
              trailing: TextButton(onPressed: () {
                showDialog(context: context, builder: (context) {

                  return AlertDialog(title: Text("select your choice..."),content: Text("Delete or Update"),
                  actions: [
                    TextButton.icon(onPressed: () async {
                      String id = list[index]['id'];

                      // https://sukhadiyadev.000webhostapp.com/APICalling/delete.php?id=$id&name=raj
                      var url = Uri.parse('https://sukhadiyadev.000webhostapp.com/APICalling/delete.php?id=$id');
                      var response = await http.get(url);
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return view();
                      },));


                    }, icon: Icon(Icons.delete), label: Text("Delete")),
                    TextButton.icon(onPressed: () async {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return edit(list,index);
                      },));


                    }, icon: Icon(Icons.edit), label: Text("Update"))
                  ],);

                },);
              }, child: Icon(Icons.more_vert)),

            ),
          );
        },
      ):Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return insert();
            },
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
