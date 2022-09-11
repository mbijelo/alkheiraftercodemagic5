import 'package:active_ecommerce_flutter/screens/checkout.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/address_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/data_model/city_response.dart';
import 'package:active_ecommerce_flutter/data_model/country_response.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/address.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/l10n/app_localizations.dart';
class ShippingInfo extends StatefulWidget {
  int owner_id;
  int nbreShop;

  ShippingInfo({Key key, this.owner_id, this.nbreShop}) : super(key: key);

  @override
  _ShippingInfoState createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  ScrollController _mainScrollController = ScrollController();

  int _seleted_shipping_address = 0;

  bool _isInitial = true;
  List<dynamic> _shippingAddressList = [];
  List<City> _cityList = [];
  List<Country> _countryList = [];

  String _shipping_cost_string = ". . .";
  int _shipping_cost =0;

  bool showLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shipping_cost = widget.nbreShop * 100;
    /*print("user data");
    print(is_logged_in.$);
    print(access_token.value);
    print(user_id.$);
    print(user_name.$);*/

    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  fetchAll() {
    if (is_logged_in.$ == true) {
      fetchShippingAddressList();
    }
    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList.addAll(addressResponse.addresses);
    if (_shippingAddressList.length > 0) {
      _seleted_shipping_address = _shippingAddressList[0].id;

      _shippingAddressList.forEach((address) {
        if (address.set_default == 1) {
          _seleted_shipping_address = address.id;
        }
      });
    }
    _isInitial = false;
    setState(() {});

    getSetShippingCost();
  }

  getSetShippingCost() async {
    var shippingCostResponse = await AddressRepository()
        .getShippingCostResponse(widget.nbreShop,
            widget.owner_id, user_id.$, _seleted_shipping_address);

    if (shippingCostResponse.result == true) {
      _shipping_cost_string = shippingCostResponse.value_string;
      setState(() {});
    }
  }



  reset() {
    _shippingAddressList.clear();
    _cityList.clear();
    _countryList.clear();
    _shipping_cost_string = ". . .";
    _shipping_cost_string = ". . .";
    _isInitial = true;
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
     reset();
     fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }

  onAddressSwitch() async {
    _shipping_cost_string = ". . .";
    setState(() {});
    getSetShippingCost();
  }


  onPressProceed(context) async {
    if (_seleted_shipping_address == 0) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).shipping_info_screen_address_choice_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }

    setState(() {showLoading=true;});
    var addressUpdateInCartResponse = await AddressRepository()
        .getAddressUpdateInCartResponse(_seleted_shipping_address);

    if (addressUpdateInCartResponse.result == false) {
      ToastComponent.showDialog(addressUpdateInCartResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      setState(() {showLoading=false;});
      return;
    }

    ToastComponent.showDialog(addressUpdateInCartResponse.message, context,
        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    setState(() {showLoading=false;});
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Checkout(
        shipping_coast : _shipping_cost
      );
    })).then((value) {
      onPopped(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          bottomNavigationBar: buildBottomAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onRefresh,
            displacement: 0,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:

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


                    buildShippingInfoList(),
                  ),



                      showLoading ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0, bottom: 0),
                            child: Container(
                              // width:10,
                              height: 0,
                            ),
                          ),
                        ],
                      )

                  :
                  Container(
                      height: 40,
                      child: Center(
                          child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Address(from_shipping_info: true,);
                          })).then((value) {
                            onPopped(value);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .shipping_info_screen_go_to_address.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14,
                                decoration: TextDecoration.underline,
                                color: Colors.blueAccent),
                          ),
                        ),
                      ))),
                  SizedBox(
                    height: 100,
                  )
                ]))
              ],
            ),
          )),
    );
  }



  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "${AppLocalizations.of(context).shipping_info_screen_shipping_cost} ${_shipping_cost_string}",
        //"${AppLocalizations.of(context).shipping_info_screen_shipping_cost} ${_shipping_cost}",
        style: TextStyle(fontSize: 20, color: Colors.blueAccent),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildShippingInfoList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_login_warning,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildShippingInfoItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).common_no_address_added,
            style: TextStyle(color: MyTheme.black, fontSize: 16),
          )));
    }
  }

  GestureDetector buildShippingInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        if (_seleted_shipping_address != _shippingAddressList[index].id) {
          setState(() {
            _seleted_shipping_address = _shippingAddressList[index].id;
          });
          onAddressSwitch();
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_address == _shippingAddressList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .shipping_info_screen_address,
                        style: TextStyle(
                          color: MyTheme.black, fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      width: 175,
                      child: Text(
                        _shippingAddressList[index].address,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600
                            , fontSize: 16),
                      ),
                    ),
                    Spacer(),
                    buildShippingOptionsCheckContainer(
                        _seleted_shipping_address ==
                            _shippingAddressList[index].id)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context).order_details_screen_field,
                        style: TextStyle(
                          color: MyTheme.black, fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].city_name,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .shipping_info_screen_city,
                        style: TextStyle(
                          color: MyTheme.black , fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].state_name,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600 , fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .shipping_info_screen_country,
                        style: TextStyle(
                          color: MyTheme.black, fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].country_name,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context)
                            .order_details_screen_sedini,
                        style: TextStyle(
                          color: MyTheme.black, fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].postal_code,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        AppLocalizations.of(context).shipping_info_screen_phone,
                        style: TextStyle(
                          color: MyTheme.black, fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].phone,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildShippingOptionsCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(FontAwesome.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child:
      Container(
        color: Colors.transparent,
        height: 50,
        child:

        showLoading ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0, bottom: 0),
              child: Container(
                // width:10,
                height: 0,
              ),
            ),
          ],
        )

            :

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: MyTheme.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                AppLocalizations.of(context)
                    .shipping_info_screen_btn_proceed_to_checkout,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressProceed(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
