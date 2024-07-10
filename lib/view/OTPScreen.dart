import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jaljeevanmissiondynamic/apiservice/Apiservice.dart';
import 'package:jaljeevanmissiondynamic/view/Dashboard.dart';
import 'package:jaljeevanmissiondynamic/view/LoginScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../utility/Appcolor.dart';
import '../utility/Stylefile.dart';
import '../utility/Textfile.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  GetStorage box = GetStorage();

  //int _remainingSeconds;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  bool _showImage = false;
  void _onCodeSubmitted(String code) {
    print('Code submitted: $code');
    setState(() {
      _showImage = true;
    });
    Apiservice.OTPVerificationapi(context).then((value) {});

    Stylefile.showmessageforvalidationtrue(
        context, "Vefied otp");
    /*Get.offAll(Dashboard(
        stateid: box.read("StateId").toString(),
        userid: box.read("Userid").toString(),
        usertoken: box.read("Token").toString(),
       ));*/
  }

  Timer? _periodicTimer;
  int secondsRemaining = 10;
  bool enableResend = false;
  Timer? timer;

  void _resendCode() {
    //other code here
    setState(() {
      secondsRemaining = 10;
      enableResend = false;
    });
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(

        body:
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/header_bg.png'),
                fit: BoxFit.fill,
                scale: 3),
          ),
          child: SingleChildScrollView(
            child:
            Column(
              children: [
                SizedBox(height: 20,),
                _showImage?  Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:Text("")
                  ),
                ):  GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Icon(Icons.arrow_back , color: Appcolor.black ,size: 30,)
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _showImage? Text(" Verified",
                      style: TextStyle(
                          fontSize: 25,
                          color: Appcolor.black,
                          fontWeight: FontWeight.bold),):Text(" Verification",
                      style: TextStyle(
                          fontSize: 25,
                          color: Appcolor.black,
                          fontWeight: FontWeight.bold),),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
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
                const SizedBox(
                  height: 20,
                ),

                _showImage
                    ?
                Container(
                  child: Column(
                    children: [
                     SizedBox(
                         height: 200 , width: 200,
                        // child: Image.asset("images/succc.gif")),
                         child: Image.asset("images/successth.gif")),
                      SizedBox(height: 20,),
                      Text("You are verified ",  style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 20,
                          color:
                          Appcolor.black),),
                      SizedBox(height: 20,),
                      SizedBox(
                          width: 180,
                        child: /*ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Appcolor.btncolor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: (){}, child: Text("OKEY", style: TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 16,
                            color:
                            Appcolor.white),)),*/
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                  style: Stylefile.elevatedbuttonStyle,
                                onPressed: () {
                                    print("ggggg");
                              /*    Get.offAll(Dashboard(
                                      stateid: box.read("stateid"),
                                      userid: box.read("userid"),
                                      usertoken: box.read("UserToken")));*/


                                    Get.offAll(Dashboard(
                                        stateid:"ddd",
                                        userid: "dds",
                                        usertoken: "sss"));

                                },
                                icon: Icon(
                                  Icons.arrow_back,color: Appcolor.white,
                                ),
                                label: Text("OKEY", style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                    Appcolor.white),)))
                        )
                      )
                    ],
                  ),
                )  :     Container(
                  child:Column(
                    children: [
                      Card(
                        elevation: 5,
                        surfaceTintColor: Colors.white,
                        color: Colors.white,
                        child: Container(
                          //color: Appcolor.white,
                          margin: const EdgeInsets.all(5),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'images/appjalicon.png',
                              width: 150,
                              height: 135,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Enter Verification Code',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding:
                        const EdgeInsets.all(5.0),
                        child: RichText(
                          text: const TextSpan(
                            text: 'We are automatically detection a SMS\nSent to your number : ',
                            style: TextStyle(
                                fontWeight:
                                FontWeight.w400,
                                fontSize: 16,
                                color:
                                Appcolor.black),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                  '91252522552.',
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      fontSize: 16,
                                      color: Appcolor
                                          .black)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),


                      Container(
                        margin: EdgeInsets.only(left: 80, right: 80),
                        child: Center(
                            child: PinCodeTextField(
                              appContext: context,
                              length: 4,
                              obscureText: false,
                              blinkWhenObscuring: true,
                              animationType: AnimationType.scale,
                              pinTheme:PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(4),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.white,
                                  inactiveColor: Appcolor.btncolor,

                                  inactiveFillColor: Appcolor.light,
                                  selectedFillColor: Colors.white,
                                  selectedColor: Colors.greenAccent,
                                  activeColor: Appcolor.greenmessagecolor


                              ),
                              animationDuration: Duration(milliseconds: 300),

                              enableActiveFill: true,
                              errorAnimationController: errorController,
                              controller: textEditingController,
                              onCompleted: (v) {


                                _onCodeSubmitted(v);


                              },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                              beforeTextPaste: (text) {
                                print("Allowing to paste $text");
                                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                return true;
                              },
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Time Remaining : $secondsRemaining',
                        style: TextStyle(fontSize: 14, color: Appcolor.red),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Apiservice.OTPResendapi(context).then((value) {
                            secondsRemaining = 10;
                            enableResend ? _resendCode : null;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: RichText(
                            text: const TextSpan(
                              text: "Don't Receive the OTP?",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Appcolor.grey),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " RESEND OTP",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Appcolor.COLOR_PRIMARY)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ) ,
                ),



                const SizedBox(
                  height: 20,
                ),

              ],
            ),
          ),
        ),
      ),
    );

  }


}

