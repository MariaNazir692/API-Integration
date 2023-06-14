import 'dart:convert';

import 'package:api_integration/Complex_Json_Screen.dart';
import 'package:api_integration/UserScreen.dart';
import 'package:api_integration/models/PostModel.dart';
import 'package:api_integration/photos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //if json response don't and array name then we have to make a custom List to store that array in list
  List<PostModel> postList = [];

  Future<List<PostModel>> getPostApi() async {
    //this is the way to hit the target api in this we give the url of target api which we are integrating
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    //after hiting target api we get som response which we hae to decode into stding to store it in dart object
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      postList.clear();
      for (Map<String, dynamic> i in data) {
        //putting all the returned data of api in list
        postList.add(PostModel.fromJson(i));
      }
      return postList;
    } else {
      return postList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("API Integration"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PhotosScreen()));
            },
            child: Text(
              "Photos",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserScreen()));
            },
            child: Text(
              "Users",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Product_Screen()));
            },
            child: Text(
              "Products",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: getPostApi(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    itemCount: postList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Accessing data of api
                            Text(postList[index].title.toString()),
                            Text(postList[index].body.toString())
                          ],
                        ),
                      );
                    });
              }
            },
          ))
        ],
      ),
    );
  }
}
