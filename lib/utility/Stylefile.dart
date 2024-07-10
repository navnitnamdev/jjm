import 'package:flutter/material.dart';
import 'package:jaljeevanmissiondynamic/utility/Appcolor.dart';

class Stylefile {
  static double CONTAINER_HEIGHTDROPDOWN = 45;
  static double CONTAINER_WIDTH = 0;
  static double TEXTFORMFIELD_HEIGHT = 45;
  static double BOXHEIGHT = 80;
  static double BOXWIDTH = 90;


  static const TextStyle Textcolorwhitesize16 = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600);




  static const TextStyle Textcolorblackboldsizesixteenunderline = TextStyle(
      fontFamily: 'Poppins',
      color: Appcolor.black,
      decoration: TextDecoration.underline,
      fontSize: 16,
      fontWeight: FontWeight.bold);

  static void showmessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static void showmessageforvalidationtrue(
      BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_double_arrow_down_outlined,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Appcolor.greenmessagecolor,
    ));
  }

  static void showmessageforvalidationfalse(
      BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Icon(
            Icons.keyboard_double_arrow_down_outlined,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: Appcolor.red,
    ));
  }
  static void showmessageapisuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Appcolor.greenmessagecolor,
    ));
  }

  static void showmessageapierrors(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Appcolor.errormesssagecolor,
    ));
  }

  static ButtonStyle elevatedbuttonStyle = ElevatedButton.styleFrom(
    onPrimary: Appcolor.white,
    primary: Appcolor.btncolor,
    textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    elevation: 5,
    minimumSize: Size(230, 40),
    padding: EdgeInsets.symmetric(horizontal: 5),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(width: 1, color: Appcolor.btncolor)),
  );


  static const TextStyle submainheadingstyle = TextStyle(
      color: Appcolor.black,
      fontSize: 11);
  static const TextStyle mainheadingstyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold);
}
