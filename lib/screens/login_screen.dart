import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/registration.dart';
//import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/l10n/app_localizations.dart';


enum  MobileVerificationState{
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}


class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState  currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId ;
  bool  showLoading = false;


  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {
     setState(() {
       showLoading = true;
     });
    try {
      final authCredential = await _auth.signInWithCredential(
          phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if(authCredential?.user != null){
        //Navigator.push(context, MaterialPageRoute(builder: (context)=> Registration()));
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Registration(
            phoneN: "+222"+phoneController.text,
          );
        }));


      }
    } on FirebaseAuthException catch (e){
      setState(() {
        showLoading = false;
      });
      _ScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.message)));
    }
    }


  getMobileFormWidget(context){
     return Column(
       children: [
         Padding(
           padding: const EdgeInsets.only(top: 0, bottom: 0),
           child: Container(
             // width:10,
             height: (MediaQuery.of(context).size.height) / 3.5,
           ),
         ),
         TextField(
           controller:phoneController,
           decoration: InputDecoration(
             hintText: AppLocalizations.of(context).password_forget_screen_phone_warning,
           ),
         ),
         SizedBox(height: 16,
         ),
         FlatButton(
            onPressed: () async {

              setState(() {
                showLoading = true;
              });

             await  _auth.verifyPhoneNumber(
                  phoneNumber: "+222"+phoneController.text,

                  verificationCompleted: (phoneAuthCredential) async{
                    setState(() {
                      showLoading = false;
                    });
                    //signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                  verificationFailed: (verificationFailed) async{
                    setState(() {
                      showLoading = true;
                    });
                    _ScaffoldKey.currentState.showSnackBar(SnackBar(content: Text(verificationFailed.message)));
                  },
                  codeSent: (verificationId, resendingToken) async{
                    setState(() {
                      showLoading = false;
                      currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                      this.verificationId = verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationId) async{

                  },
             );

            },
            child: Text(AppLocalizations.of(context).otp_screen_btn_send_code),
             color: Colors.blue,
           textColor: Colors.white,
         )
       ],
     );
  }

  getOptFormWidget(context){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 0),
          child: Container(
            // width:10,
            height: (MediaQuery.of(context).size.height) / 3.5,
          ),
        ),
        TextField(
          controller:otpController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).otp_screen_verification_code_warning,
          ),
        ),
        SizedBox(height: 16,
        ),
        FlatButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text(AppLocalizations.of(context).otp_screen_verify_your + " " + AppLocalizations.of(context).otp_screen_phone_number),
          color: Colors.blue,
          textColor: Colors.white,
        )
      ],
    );
  }

  final GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _ScaffoldKey,
      body: Container(
        child: showLoading ? Center(child: CircularProgressIndicator(),) : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
        ? getMobileFormWidget(context)
        : getOptFormWidget(context),
        padding: const EdgeInsets.all(16),
      )
    );
  }
}