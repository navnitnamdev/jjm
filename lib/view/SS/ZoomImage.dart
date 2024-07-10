import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:jaljeevanmissiondynamic/utility/Appcolor.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class ZoomImage extends StatefulWidget {
  String imgurl;
  String lat;
  String long;

  ZoomImage(
      {required this.imgurl, required this.lat, required this.long, super.key});

  @override
  State<ZoomImage> createState() => _practisesecState(lat: lat, long: long);
}

class _practisesecState extends State<ZoomImage> {
  String lat;
  String long;

  _practisesecState({required this.lat, required this.long});

  String geturl = "";

  var fullimg;

  Uint8List convertBase64Image(String base64String) {
    return Base64Decoder().convert(base64String.split(',').last);
  }

  @override
  void initState() {
    geturl = widget.imgurl;
    super.initState();
    fullimg = convertBase64Image(geturl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolor.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        iconTheme: const IconThemeData(color: Appcolor.white),
      ),
      body: Stack(
        children: [
          geturl ==  null || geturl.isEmpty
              ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text(
                "No Image available",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
              : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 10,
              child: Image.memory(
                convertBase64Image(geturl),
                gaplessPlayback: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
