import 'dart:convert';
import 'package:api_integration/imageUpload.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' ;
import 'package:fluttertoast/fluttertoast.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController _emailController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();


  void login(String email, String password)async{
    try{
      Response response=await post(
        Uri.parse('https://reqres.in/api/login'),
        body: {
          'email':email,
          'password':password
        }
      );
      if(response.statusCode==200){
        var data=jsonDecode(response.body.toString());
        Fluttertoast.showToast(
            msg: data['token'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Fluttertoast.showToast(
            msg: "Account created successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }else{
        Fluttertoast.showToast(
            msg: "email or password is wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }

    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SIGN UP"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>uploadImage()));
          },
              child: Text("Upload Image"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email"
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  hintText: "Password"
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){
                login(_emailController.toString(), _passwordController.toString());
              },
                child:Text("Sign Up"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: StadiumBorder()
              ),
            )
          ],
        ),
      ),
    );
  }
}
