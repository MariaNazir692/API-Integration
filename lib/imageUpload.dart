import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class uploadImage extends StatefulWidget {
  const uploadImage({Key? key}) : super(key: key);

  @override
  State<uploadImage> createState() => _uploadImageState();
}

class _uploadImageState extends State<uploadImage> {
  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  Future getImage() async {
    final _pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (_pickedFile != null) {
      image = File(_pickedFile.path);
      setState(() {});
    } else {
      print("No image selected");
    }
  }

  Future<void> uploadImage() async {
    setState(() {
      showSpinner = true;
    });
    var stream = new http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();
    var uri = Uri.parse('https://fakestoreapi.com/products');
    var request = new http.MultipartRequest('POST', uri);
    request.fields['title'] = 'Static';
    var multipost = new http.MultipartFile('image', stream, length);
    request.files.add(multipost);
    var response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'image uploaded',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        showSpinner = false;
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Something went wrong',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload Image"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image == null
                ? ElevatedButton(
                    onPressed: () {
                      getImage();
                    },
                    child: Text("Pick Image"))
                : Container(
                    child: Center(
                      child: Image.file(
                        File(image!.path).absolute,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                uploadImage();
              },
              child: Text(
                "Upload Image",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, shape: StadiumBorder()),
            )
          ],
        ),
      ),
    );
  }
}
