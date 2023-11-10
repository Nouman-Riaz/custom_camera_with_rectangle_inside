import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/rectangle_painter.dart';


class HomeScreen extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image

  @override
  void initState() {
    loadCamera();
    super.initState();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if(cameras != null){
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }else{
      print("NO any camera found");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Capture Image from Camera"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding:EdgeInsetsDirectional.only(start: 40),
                height: 500,
                width: 1000,
                child: Stack(
                  children: [
                    controller == null
                        ? Center(child: Text("Loading Camera..."))
                        : !controller!.value.isInitialized
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : CameraPreview(controller!),
                    CustomPaint(
                      painter: RectanglePainter(),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    if (controller != null) {
                      if (controller!.value.isInitialized) {
                        image = await controller!.takePicture();
                        setState(() {
                          // update UI
                        });
                      }
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                icon: Icon(Icons.camera),
                label: Text("Capture"),
              ),
              Container(
                padding: EdgeInsets.all(30),
                child: image == null
                    ? Text("No image captured")
                    : Image.file(
                  File(image!.path),
                  height: 300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}