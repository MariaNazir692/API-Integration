import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:api_integration/models/UserModel.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  
  List<UserModel> userList=[];
  
  
  Future<List<UserModel>> getUser()async{
    final response=await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data=jsonDecode(response.body.toString());
    if(response.statusCode==200){
      for(Map<String, dynamic> i in data){
        userList.add(UserModel.fromJson(i));
      }
      return userList;
    }else{
      return userList;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                future: getUser(),
                builder: (context, AsyncSnapshot<List<UserModel>>snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator(),);
                  }else{
                    return ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context,index){
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  ReUseableRow(title: 'Name', value: snapshot.data![index].name.toString()),
                                  ReUseableRow(title: 'Email', value: snapshot.data![index].email.toString()),
                                  ReUseableRow(title: 'Phone', value: snapshot.data![index].phone.toString()),
                                  ReUseableRow(title: 'Website', value: snapshot.data![index].website.toString()),
                                  ReUseableRow(title: 'City', value: snapshot.data![index].address!.city.toString())

                                ],
                              ),
                            ),
                          );
                        });
                  }
                  

                },
              )
          )
        ],
      ),
    );
  }
}


class ReUseableRow extends StatelessWidget {
  String title, value;
  ReUseableRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(value)
        ],
      ),
    );
  }
}
