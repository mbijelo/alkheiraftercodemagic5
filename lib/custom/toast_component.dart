import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/screens/main_cart.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class ToastComponent {

  static showDialog(String msg, context, {duration = 0, gravity = 0}) {

    /*
    Toast.show(
      msg,
      context,
      duration: duration != 0 ? duration : Toast.LENGTH_SHORT,
      gravity: gravity != 0 ? gravity : Toast.BOTTOM,
        backgroundColor:
        MyTheme.accent_color,
        textColor: MyTheme.black,
        border: Border(
            top: BorderSide(
              color: MyTheme.black,
            ),bottom:BorderSide(
          color: MyTheme.black,
        ),right: BorderSide(
          color: MyTheme.black,
        ),left: BorderSide(
          color: MyTheme.black,
        )),
        backgroundRadius: 6
    );
  }
*/


    Alert(
      context: context,
      //type: AlertType.error,
      //title: "RFLUTTER ALERT",
      desc: msg,
    ).show();


  }//end function

}// end class
