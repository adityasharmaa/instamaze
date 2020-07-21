import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta/widgets/bottom_navigation_bar_with_sliding_bar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class PickImagesScreen extends StatefulWidget {
  static const route = "/add_post_screen_selector";
  @override
  _PickImagesScreenState createState() => _PickImagesScreenState();
}

class _PickImagesScreenState extends State<PickImagesScreen> {
  final key = GlobalKey<ScaffoldState>();
  List<File> _pickedImages = [];
  int _mode = 0;
  int _noOfImages = 1;

  final _modes = [
    "Gallery",
    "Photo",
  ];

  void _pickImage() async {
    if (_mode == 1) {
      final file = await ImagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (file != null) {
        if (_noOfImages == 1) _pickedImages.clear();
        if (_pickedImages.length < _noOfImages)
          setState(() {
            _pickedImages.add(file);
          });
        else
          key.currentState.showSnackBar(SnackBar(
            content: Text(
                "Sorry, no more than $_noOfImages pictures can be selected"),
            duration: Duration(seconds: 3),
          ));
      }
    } else {
      List<Asset> resultList = [];

      try {
        resultList = await MultiImagePicker.pickImages(
          maxImages: _noOfImages,
          cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
          materialOptions: MaterialOptions(
            actionBarColor: "#000000",
            actionBarTitle: "Select Images",
            allViewTitle: "All Photos",
            useDetailsView: false,
            selectCircleStrokeColor: "#ffffff",
            statusBarColor: "#000000",
            actionBarTitleColor: "#ffffff",
            lightStatusBar: true,
          ),
        );
      } on Exception catch (e) {
        print(e.toString());
      }

      if (resultList.isEmpty) return;

      if (_noOfImages == 1) _pickedImages.clear();

      _pickedImages = await _fileImagesFromMemory(resultList);

      setState(() {});
    }
  }

  Future<List<File>> _fileImagesFromMemory(List<Asset> memoryImages) async {
    List<File> images = [];
    Directory extDir = await path_provider.getExternalStorageDirectory();
    for (int i = 0; i < memoryImages.length; i++) {
      images.add(
        await File(extDir.path + "_$i").writeAsBytes(
          (await memoryImages[i].getByteData()).buffer.asUint8List(),
        ),
      );
    }
    return images;
  }

  void _finish() {
    Navigator.of(context).pop(_pickedImages);
  }

  void _setNoOfImages(int n) {
    Future.delayed(Duration(milliseconds: 0), () {
      setState(() {
        _noOfImages = n;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final int noOfImages = ModalRoute.of(context).settings.arguments;
    _setNoOfImages(noOfImages);

    return Scaffold(
      key: key,
      appBar: AppBar(
        elevation: 1.5,
        leading: InkWell(
          child: Icon(Icons.clear),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(_modes[_mode]),
        actions: <Widget>[
          Center(
            child: InkWell(
              child: Text(
                "Next",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color:
                      _pickedImages.isNotEmpty ? Colors.blue : Colors.blue[200],
                  fontSize: 18,
                ),
              ),
              onTap: _finish,
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              width: width,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: CarouselSlider(
                height: double.maxFinite,
                items: _pickedImages
                    .map((file) => Image.file(
                          file,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ))
                    .toList(),
                enableInfiniteScroll: false,
                viewportFraction: 1.0,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              width: width,
              child: Center(
                child: GestureDetector(
                  child: _GreyAnnulus(),
                  onTap: _pickImage,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWithSlidingBar(
          items: [
            "Gallery",
            "Photo",
          ],
          onTap: (index) {
            setState(() {
              _mode = index;
            });
          }),
    );
  }
}

class _GreyAnnulus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.grey[300],
      child: Center(
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
