import 'package:active_ecommerce_flutter/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/repositories/wishlist_repository.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';


class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  ScrollController _mainScrollController = ScrollController();

  //init
  bool _wishlistInit = true;
  List<dynamic> _wishlistItems = [];

  @override
  void initState() {
    if (is_logged_in.$ == true) {
      fetchWishlistItems();
    }

    super.initState();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  fetchWishlistItems() async {
    var wishlistResponse = await WishListRepository().getUserWishlist();
    _wishlistItems.addAll(wishlistResponse.wishlist_items);
    _wishlistInit = false;
    setState(() {});
  }

  reset() {
    _wishlistInit = true;
    _wishlistItems.clear();
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchWishlistItems();
  }

  Future<void> _onPressRemove(index) async {
    var wishlist_id = _wishlistItems[index].id;
    _wishlistItems.removeAt(index);
    setState(() {});

    var wishlistDeleteResponse =
        await WishListRepository().delete(wishlist_id: wishlist_id);

    if (wishlistDeleteResponse.result == true) {
      ToastComponent.showDialog(wishlistDeleteResponse.message, context,
          gravity: Toast.TOP, duration: Toast.LENGTH_SHORT);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  buildWishlist(),
                ])),
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
        AppLocalizations.of(context).wishlist_screen_my_wishlist,
        style: TextStyle(fontSize: 20, color: MyTheme.black),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildWishlist() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).wishlist_screen_login_warning,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_wishlistInit == true && _wishlistItems.length == 0) {
      return SingleChildScrollView(
        child: ShimmerHelper().buildListShimmer(item_count: 10),
      );
    } else if (_wishlistItems.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _wishlistItems.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 3.0),
              child: buildWishListItem(index),
            );
          },
        ),
      );
    } else {
      return Container(
          height: 100,
          child: Center(
              child: Text(AppLocalizations.of(context).common_no_item_is_available,
                  style: TextStyle(color: MyTheme.font_grey))));
    }
  }

  buildWishListItem(index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: _wishlistItems[index].product.id,
          );
        }));
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Card(
              shape: RoundedRectangleBorder(
                side: new BorderSide(color: MyTheme.black, width: 1.0),
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16), right: Radius.zero),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image: AppConfig.BASE_PATH +
                                  _wishlistItems[index].product.thumbnail_image,
                              fit: BoxFit.cover,
                              imageErrorBuilder:
                                  (BuildContext context, Object y, StackTrace z) {
                                return Image(
                                  image: NetworkImage(
                                      AppConfig.BASE_PATH +
                                          _wishlistItems[index].product.thumbnail_image),
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                  errorBuilder:
                                      (BuildContext context, Object y, StackTrace z) {
                                    return
                                      /*
                                        Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 300,
                                            color: Colors.grey,
                                          ));
                                      */
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                                        child: Shimmer.fromColors(
                                          baseColor: MyTheme.shimmer_base,
                                          highlightColor: MyTheme.shimmer_highlighted,
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                  },
                                );
                              },
                            ))),
                    Container(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(
                              _wishlistItems[index].product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: MyTheme.black,
                                  fontSize: 16,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 4, 8, 8),
                            child: Text(
                              _wishlistItems[index].product.base_price,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
          app_language_rtl.$
              ? Positioned(
                  bottom: 8,
                  left: 12,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever_outlined,
                        color: MyTheme.medium_grey),
                    onPressed: () {
                      _onPressRemove(index);
                    },
                  ),
                )
              : Positioned(
                  bottom: 8,
                  right: 12,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever_outlined,
                        color: MyTheme.medium_grey),
                    onPressed: () {
                      _onPressRemove(index);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
