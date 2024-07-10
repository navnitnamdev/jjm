import 'package:flutter/material.dart';

class InternetAllow extends StatelessWidget {
  InternetAllow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Unable to Connect to the Internet. Please check your network settings.',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}

class InternetAllowwithimage extends StatelessWidget {
  InternetAllowwithimage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SizedBox(
              height: 150,
              width: 150,
              child: Image.asset("images/nointernetgifone.gif"),
            ),
          ),
        ),
      ),
    );
  }
}
