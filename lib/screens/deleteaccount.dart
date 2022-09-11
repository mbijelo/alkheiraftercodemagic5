import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/screens/profile_edit.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/club_point.dart';
import 'package:active_ecommerce_flutter/screens/refund_request.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/addon_config.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/repositories/language_repository.dart';

import '../helpers/auth_helper.dart';
import 'login.dart';


class deleteaccount extends StatefulWidget {
  deleteaccount({Key key, this.show_back_button = false}) : super(key: key);

  bool show_back_button;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<deleteaccount> {
  ScrollController _mainScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _cartCounter = 0;
  String _cartCounterString = "...";
  int _wishlistCounter = 0;
  String _wishlistCounterString = "...";
  int _orderCounter = 0;
  String _orderCounterString = "...";
  var _list = [];
  bool showLoading = false;


  String _image1 =	"";
  String _description	= "";
  String _phone1	= "";
  String _phone2	= "";
  String _phone3	= "";
  String _email1	= "";
  String _email2	= "";
  String _email3	= "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchAll();

  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }


  fetchLanguage() async {
    var languageListResponse1 = await LanguageRepository().getLanguageList1();
    _list.addAll(languageListResponse1.languages);


    if (_list.length > 0) {
      /*
      _list.forEach((lang) {
        setState(() {
          _image1 =	lang.image1;
          _description	= lang.description;
          _phone1	= lang.phone1;
          _phone2	= lang.phone2;
          _phone3	= lang.phone3;
          _email1	= lang.email1;
          _email2	= lang.email2;
          _email3	= lang.email3;
        });
        // print("jean louis"+ AppConfig.BASE_PATH + _image1);
      });

      */
    }
    else{
      print("jean louis");
    }

  }

  fetchAll() {
    fetchCounters();
    fetchLanguage();
  }

  fetchCounters() async {
    var profileCountersResponse =
    await ProfileRepository().getProfileCountersResponse();

    _cartCounter = profileCountersResponse.cart_item_count;
    _wishlistCounter = profileCountersResponse.wishlist_item_count;
    _orderCounter = profileCountersResponse.order_count;

    _cartCounterString =
        counterText(_cartCounter.toString(), default_length: 2);
    _wishlistCounterString =
        counterText(_wishlistCounter.toString(), default_length: 2);
    _orderCounterString =
        counterText(_orderCounter.toString(), default_length: 2);

    setState(() {});
  }

  String counterText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;

    // print(txt + " " + default_length.toString());
    // print(newtxt);

    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }
    //print(newtxt);

    return newtxt;
  }

  reset() {
    _cartCounter = 0;
    _cartCounterString = "...";
    _wishlistCounter = 0;
    _wishlistCounterString = "...";
    _orderCounter = 0;
    _orderCounterString = "...";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(context),
      ),
    );
  }

  buildBody(context) {
    return RefreshIndicator(
      color: MyTheme.accent_color,
      backgroundColor: Colors.white,
      onRefresh: _onPageRefresh,
      displacement: 10,
      child: CustomScrollView(
        controller: _mainScrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              showLoading ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 0),
                    child: Container(
                      // width:10,
                      height: (MediaQuery.of(context).size.height) / 5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                    child: Container(
                      width: 75,
                      height: 75,
                      child:
                      CircularProgressIndicator(),
                    ),
                  ),
                ],

              )
                  :

              buildTopSection(),
              //buildCountersRow(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  height: 24,
                ),
              ),
              //buildHorizontalMenu(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  height: 24,
                ),
              ),
              //buildVerticalMenu()
            ]),
          )
        ],
      ),
    );

  }

  buildHorizontalMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderList();
            }));
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: Colors.green,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppLocalizations.of(context).profile_screen_orders,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfileEdit();
            })).then((value) {
              onPopped(value);
            });
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.blueAccent,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppLocalizations.of(context).profile_screen_profile,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Address();
            }));
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.amber,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppLocalizations.of(context).profile_screen_address,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
        /*InkWell(
          onTap: () {
            ToastComponent.showDialog("Coming soon", context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          },
          child: Column(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: MyTheme.light_grey,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Icon(Icons.message_outlined, color: Colors.redAccent),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Message",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.font_grey, fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),*/
      ],
    );
  }

  buildVerticalMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              ToastComponent.showDialog(AppLocalizations.of(context).common_coming_soon, context,
                  gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
            },
            child: Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  children: [
                    Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        AppLocalizations.of(context).profile_screen_notification,
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(color: MyTheme.font_grey, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OrderList();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.credit_card_rounded,
                          color: Colors.white,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context).profile_screen_purchase_history,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
          AddonConfig.club_point_addon_installed
              ? InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return Clubpoint();
                  }));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.white,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context).profile_screen_earning_points,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.font_grey, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          )
              : Container(),
          AddonConfig.refund_addon_installed
              ? InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return RefundRequest();
                  }));
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.double_arrow,
                          color: Colors.white,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      AppLocalizations.of(context).profile_screen_refund_requests,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: MyTheme.font_grey, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }

  buildCountersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _cartCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context).profile_screen_in_your_cart,
                  style: TextStyle(
                    color: MyTheme.medium_grey,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _wishlistCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context).profile_screen_in_wishlist,
                  style: TextStyle(
                    color: MyTheme.medium_grey,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _orderCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.font_grey,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context).profile_screen_in_ordered,
                  style: TextStyle(
                    color: MyTheme.medium_grey,
                  ),
                )),
          ],
        )
      ],
    );
  }

  buildTopSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            _description +
                " Cette action n'est pas inversible si vous choisissez de supprimer votre compte, vos données seront complètement supprimées. "+
                " This action is not reversible if you choose to delete your account, your data will be completely deleted. "+
                " لا يمكن التراجع عن هذا الإجراء إذا اخترت حذف حسابك ، فسيتم حذف بياناتك بالكامل."
            ,
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.font_grey,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
             _phone1 +
                 " ",
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.font_grey,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
             _phone2,
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.font_grey,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            _phone3,
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.font_grey,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            _email1 +
            "  ",
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.font_grey,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            _email2,
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.font_grey,
                fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Text(
            _email3,
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.font_grey,
                fontWeight: FontWeight.w600),
          ),
        ),



        GestureDetector(
    onTap: () async {
      setState(() {showLoading = true;});

      var languageListResponse1 = await LanguageRepository().getLanguageList2("${user_id.$}");



      Future.delayed(Duration(seconds: 15), (){
       // print("Executed after 5 seconds");
        setState(() {showLoading = false;});
        AuthHelper().clearUserData();

        /*
    var logoutResponse = await AuthRepository()
            .getLogoutResponse();


    if(logoutResponse.result == true){
         ToastComponent.showDialog(logoutResponse.message, context,
                   gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
         }
         */
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Login();
        }));

      });


    },

            child : Text(
              "OK delete | OK supprimer | موافق حذف",
              style: TextStyle(
                color: Colors.red,
              ),
            )
        ),

      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: GestureDetector(
        child: widget.show_back_button
            ? Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: MyTheme.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        )
            : Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 18.0, horizontal: 0.0),
              child: Container(
                child: Image.asset(
                  'assets/hamburger.png',
                  height: 16,
                  color: MyTheme.dark_grey,
                ),
              ),
            ),
          ),
        ),
      ),
      title: Text(
       '',
        style: TextStyle(fontSize: 12, color: MyTheme.black),
      ),
      //elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
