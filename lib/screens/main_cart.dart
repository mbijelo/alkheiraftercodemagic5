import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/l10n/app_localizations.dart';




class Main_cart extends StatefulWidget {

  Main_cart({Key key, go_back = true})
      : super(key: key);

  bool go_back;


  @override
  _Main_cartState createState() => _Main_cartState();
  

}

class _Main_cartState extends State<Main_cart> {


  int _currentIndex = 3;
  var _children = [
    Home(),
    CategoryList(
      is_base_category: true,
    ),
    Home(),
    Cart(has_bottomnav: true),
    Profile()
  ];


  void onTapped(int i) {
    setState(() {
      _currentIndex = i;
    });
  }

  void initState() {
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.go_back;
      },
      child: Directionality(
        textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          extendBody: true,
          body: _currentIndex == 3
          ? _children[_currentIndex]
          :  _children[_currentIndex],
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          //specify the location of the FAB
          floatingActionButton: Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom ==
                0.0, // if the kyeboard is open then hide, else show
            child: FloatingActionButton(
              backgroundColor: MyTheme.accent_color,
              onPressed: () {},
              tooltip: "start FAB",
              child: Container(
                  margin: EdgeInsets.all(0.0),
                  child: IconButton(
                      icon: new Image.asset('assets/square_logo.png'),
                      tooltip: 'Action',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Filter(
                            selected_filter: "sellers",
                          );
                        }));
                      })),
              elevation: 0.0,
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                onTap: (index){
                  switch(index){
                    case 0:
                      onTapped(0);
                      break;
                    case 1:
                      onTapped(1);
                      break;
                    case 2:
                      onTapped(2);
                      break;
                    case 3:
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Filter(
                          selected_filter: "brands",
                        );
                      }));
                      break;
                    case 4:
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Filter(
                          selected_filter: "sellers",
                        );
                      }));
                      break;
                }
                },
                currentIndex: _currentIndex,
                //backgroundColor: Colors.white.withOpacity(0.8),
                backgroundColor: Colors.black.withOpacity(1),
                fixedColor: Theme.of(context).accentColor,
                unselectedItemColor: Color.fromRGBO(153, 153, 153, 1),
                //unselectedItemColor: Colors.white,
                items: [
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        "assets/home.png",
                        color: _currentIndex == 0
                            ? Theme.of(context).accentColor
                            : Colors.white,
                        height: 20,
                      ),

                      label: AppLocalizations.of(context).main_screen_bottom_navigation_home,
                        ),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        "assets/categories.png",
                        color: _currentIndex == 1
                            ? Theme.of(context).accentColor
                            : Colors.white,
                        height: 20,
                      ),
                      label: AppLocalizations.of(context).main_screen_bottom_navigation_categories,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.circle,
                      color: Colors.transparent,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        "assets/brands.png",
                        color: _currentIndex == 3
                            ? Colors.white //Theme.of(context).accentColor
                            : Colors.white,
                        height: 20,
                      ),

                      label: AppLocalizations.of(context).home_screen_brands,

                  ),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        "assets/top_sellers.png",
                        color: _currentIndex == 4
                            ? Theme.of(context).accentColor
                            : Colors.white,
                        height: 20,
                      ),

                      label: AppLocalizations.of(context).home_screen_top_sellers,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
