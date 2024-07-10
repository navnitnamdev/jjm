import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jaljeevanmissiondynamic/controller/Logincontroller.dart';
import 'package:jaljeevanmissiondynamic/utility/Appcolor.dart';
import 'package:jaljeevanmissiondynamic/utility/Stylefile.dart';
import 'package:jaljeevanmissiondynamic/utility/Textfile.dart';
import 'package:jaljeevanmissiondynamic/utility/Utilityclass.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final logincontroller = Logincontroller();
  bool isShownPassword = false;
  var random;
  var random1;
  var hashedPassword;
  var HASHpassword;
  int RandomNumber = 0;
  int RandomNumber1 = 0;
  int addcaptcha = 0;
  int RandomNumbersalt = 0;

  @override
  void initState() {
    super.initState();
    random = generateRandomString(6);
  }

  _launchURL() async {
    final Uri url = Uri.parse(
        'https://ejalshakti.gov.in/JJM/JJM/DataEntry/user/ViewFlipBook.aspx?id=8');
    String encodedUrl = Uri.encodeFull(url.toString());
    try {
      if (await canLaunch(encodedUrl)) {
        await launch(encodedUrl);
      } else {
        throw 'Could not launch $encodedUrl';
      }
    } catch (e) {
      debugPrintStack();
    }
  }

  Future<void> downloadPDF(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory?.path}/Offline_Geotagging_User_manual.pdf';
      File file = File(filePath);
      await file.writeAsBytes(bytes);
    } else {
      throw Exception('Failed to download PDF: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    logincontroller.emailcontroller.dispose();
    logincontroller.passwordcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'Login ',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            backgroundColor: Appcolor.btncolor,
            elevation: 5,
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/header_bg.png'),
                fit: BoxFit.fill,
                scale: 3),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/header_bg.png'),
                        fit: BoxFit.fill,
                        scale: 3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Image.asset(
                          "images/bharat.png",
                          width: 60,
                          height: 60,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/header_bg.png'),
                              fit: BoxFit.fill,
                              scale: 3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(Textfile.headingjaljeevan,
                                      textAlign: TextAlign.justify,
                                      style: Stylefile.mainheadingstyle),
                                  SizedBox(
                                    child: Text(Textfile.subheadingjaljeevan,
                                        textAlign: TextAlign.justify,
                                        style: Stylefile.submainheadingstyle),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 0,
                  color: Colors.white.withOpacity(0.8),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign in to',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Your Account !',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'images/appjalicon.png',
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Login Id',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: logincontroller.emailcontroller,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                hintText: "Enter Login Id",
                                hintStyle: const TextStyle(fontSize: 16),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^[a-zA-Z0-9_]+$')
                                        .hasMatch(value)) {
                                  return "Enter correct phone number";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter password",
                                hintStyle: const TextStyle(fontSize: 16),
                                suffixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isShownPassword = !isShownPassword;
                                      });
                                    },
                                    child: Icon(
                                      isShownPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.next,
                              obscureText: !isShownPassword,
                              controller: logincontroller.passwordcontroller,
                              onChanged: (password) {
                                var bytes = utf8.encode(password);
                                var digest = sha512.convert(bytes);
                                hashedPassword =
                                    digest.toString().toUpperCase();
                                HASHpassword = hashedPassword +
                                    RandomNumbersalt.toString();
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 90,
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(left: 5),
                                  margin:
                                      const EdgeInsets.only(left: 0, right: 50),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(4)),
                                    margin: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Center(
                                      child: Text(
                                        '$RandomNumber' +
                                            " + " +
                                            '$RandomNumber1 =  ?',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 24,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                child: IconButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        random = generateRandomString(6);
                                      });
                                    },
                                    icon: Center(
                                        child: Image.asset(
                                      "images/ddd.png",
                                      scale: 4,
                                    ))),
                              )),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextFormField(
                              controller: logincontroller.entercaptcha,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter Captcha",
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty || value == random) {
                                  return "Enter correct Captcha code";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: Stylefile.elevatedbuttonStyle,
                                  onPressed: () async {
                                    if (logincontroller.emailcontroller.text
                                        .trim()
                                        .toString()
                                        .isEmpty) {
                                      Stylefile.showmessageforvalidationfalse(
                                          context, Textfile.usernamerequired);
                                    } else if (logincontroller
                                        .passwordcontroller.text
                                        .trim()
                                        .toString()
                                        .isEmpty) {
                                      Stylefile.showmessageforvalidationfalse(
                                          context, Textfile.passwordrequired);
                                    } else if (logincontroller
                                            .passwordcontroller.text
                                            .trim()
                                            .toString()
                                            .length <
                                        5) {
                                      Stylefile.showmessageforvalidationfalse(
                                          context,
                                          Textfile.passwordlengthshouldbefive);
                                    } else if (logincontroller.entercaptcha.text
                                        .trim()
                                        .toString()
                                        .isEmpty) {
                                      Stylefile.showmessageforvalidationfalse(
                                          context, Textfile.entercaptcha);
                                    } else if (!logincontroller
                                        .entercaptcha.text
                                        .trim()
                                        .toString()
                                        .contains(addcaptcha.toString())) {
                                      Stylefile.showmessageforvalidationfalse(
                                          context,
                                          Textfile.entercaptchacorrect);
                                    } else {
                                      try {
                                        final result =
                                            await InternetAddress.lookup(
                                                'example.com');
                                        if (result.isNotEmpty &&
                                            result[0].rawAddress.isNotEmpty) {
                                          logincontroller.LoginApi(
                                              context,
                                              HASHpassword,
                                              RandomNumbersalt.toString());
                                          FocusScope.of(context).unfocus();
                                        }
                                        random = generateRandomString(6);
                                      } on SocketException catch (_) {
                                        Utilityclass.showInternetDialog(
                                            context);
                                      }
                                    }
                                  },
                                  child: Text(
                                    Textfile.login,
                                    style: Stylefile.Textcolorwhitesize16,
                                  )),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                final result =
                                    await InternetAddress.lookup('example.com');
                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  _launchURL();
                                }
                              } on SocketException catch (_) {
                                Stylefile.showmessageforvalidationfalse(context,
                                    "Unable to Connect to the Internet. Please check your network settings.");
                              }
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Download user manual",
                                  style: TextStyle(
                                      color: Appcolor.btncolor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.download_rounded,
                                  color: Appcolor.btncolor,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                  height: 60,
                                  width: 100,
                                  child: Image.asset("images/nicone.png")),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateRandomString(int len) {
    int max = 15;
    RandomNumber = Random().nextInt(max);
    RandomNumber1 = Random().nextInt(max);
    addcaptcha = RandomNumber + RandomNumber1;
    RandomNumbersalt = Random().nextInt(max);

    return addcaptcha.toString();
  }
}
