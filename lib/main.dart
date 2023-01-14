import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const Home(title: 'Flutter Demo Home Page'),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? lctn;
  final ImagePicker _picker = ImagePicker();
  Location location = Location();
  TextEditingController txt1controller = TextEditingController();
  File? photo;

  cam(String s) async {
    final XFile? image = await _picker.pickImage(
        source: s == 'Gallery' ? ImageSource.gallery : ImageSource.camera);
    setState(() {
      photo = File(image!.path);
    });
  }

  loc() async {
    LocationData locationData = await location.getLocation();
    lctn = '${locationData.latitude} ${locationData.longitude}';
    txt1controller.text = lctn ?? 'location';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 180,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  height: 500,
                  width: 360,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.blueAccent, blurRadius: 5)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 8, 0, 0),
                        child: TextField(
                            controller: txt1controller,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                            decoration: const InputDecoration(
                                labelText: 'Location',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black26,
                                        width: 2,
                                        style: BorderStyle.solid)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              loc();
                            },
                            icon: const Icon(Icons.location_on_outlined)),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 60,
                child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Center(child: const Text('ALERT!!!')),
                              actions: [
                                Row(
                                  children: [
                                    SizedBox.fromSize(size: Size(30, 10)),
                                    ElevatedButton(
                                        onPressed: () {
                                          cam('Gallery');
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Gallery')),
                                    SizedBox.fromSize(size: Size(40, 10)),
                                    ElevatedButton(
                                        onPressed: () {
                                          cam('Camera');
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Camera')),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: photo == null
                          ? const AssetImage('assets/images/R1.jpg')
                              as ImageProvider
                          : FileImage(photo!),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
