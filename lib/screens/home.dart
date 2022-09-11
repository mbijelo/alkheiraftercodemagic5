import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/splash.dart';
import 'package:active_ecommerce_flutter/screens/devab.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/top_selling_products.dart';
import 'package:active_ecommerce_flutter/screens/brand_products.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:active_ecommerce_flutter/screens/brand_products.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:active_ecommerce_flutter/repositories/sliders_repository.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/repositories/shop_repository.dart';
import 'package:active_ecommerce_flutter/repositories/brand_repository.dart';
import 'package:active_ecommerce_flutter/repositories/pubs_repository.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/screens/main_cart.dart';



class Home extends StatefulWidget {
  Home({Key key, this.title, this.show_back_button = false, go_back = true})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  bool show_back_button;
  bool go_back;


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _current_slider = 0;
  int _counter = 0;
  int hour=0;
  int minute=0;
  int seconde=0;

  ScrollController _featuredProductScrollController;
  ScrollController _mainScrollController = ScrollController();

  var _carouselImageList = [];
  var _featuredCategoryList = [];
  var _featuredSellersList = [];
  var _featuredBrandsList = [];
  var _featuredProductList = [];
  bool _isProductInitial = true;
  bool _isCategoryInitial = true;
  bool _isSellersInitial = true;
  bool _isBrandsInitial = true;
  bool _isCarouselInitial = true;
  int _totalProductData = 0;
  int _productPage = 1;
  bool _showProductLoadingContainer = false;


  bool _isPubsInitial = true;
  var _pubsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // In initState()
    fetchAll();

    _mainScrollController.addListener(() {
      //print("position: " + _xcrollController.position.pixels.toString());
      //print("max: " + _xcrollController.position.maxScrollExtent.toString());

      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        setState(() {
          _productPage++;
        });
        _showProductLoadingContainer = true;
        fetchFeaturedProducts();
      }
    });
  }

  fetchAll() {
    fetchCarouselImages();
    fetchFeaturedCategories();
    fetchFeaturedSellers();
    fetchFeaturedBrands();
    fetchFeaturedProducts();
    fetchPubs();
  }

  ontaptitle(){
    DateTime now = DateTime.now();
    int h = now.hour;
    int m = now.minute;
    int s = now.second;
    if(hour == h && minute == m){
      if(s-seconde < 10){
        print(h.toString() + "=" + hour.toString());
        print(m.toString() + "=" + minute.toString());
        print(s.toString() + "=" + seconde.toString());
        setState(() {
          hour=h;
          minute=m;
          seconde=s;
          _counter++;
        });
        print("counter" + _counter.toString() + "valider");
      }else{
        print(h.toString() + "=" + hour.toString());
        print(m.toString() + "=" + minute.toString());
        print(s.toString() + "=" + seconde.toString());
        setState(() {
          hour=h;
          minute=m;
          seconde=s;
          _counter=0;
        });
        print("counter" + _counter.toString() + "initialisé à 1 first");
      }
    }else{
      print(h.toString() + "=" + hour.toString());
      print(m.toString() + "=" + minute.toString());
      print(s.toString() + "=" + seconde.toString());
      setState(() {
        hour=h;
        minute=m;
        seconde=s;
        _counter=0;
      });
      print("counter" + _counter.toString() + "initialisé à 1");
    }
    if(_counter > 10){
      _counter=0;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return Devab(show_back_button: true);
          }));
    }
  }


  fetchPubs() async {
    var pubsResponse = await PubsRepository().getAllPubs();
    _pubsList.addAll(pubsResponse.pubs);
    _isPubsInitial = false;
    setState(() {});
  }



  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    carouselResponse.sliders.forEach((slider) {
      _carouselImageList.add(slider.photo);
    });
    _isCarouselInitial = true;
    setState(() {});
  }

  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    _featuredCategoryList.addAll(categoryResponse.categories);
    _isCategoryInitial = false;
    setState(() {});
  }
  fetchFeaturedSellers() async {
    var sellersResponse = await ShopRepository().getAll();
    _featuredSellersList.addAll(sellersResponse.shops);
    _isSellersInitial = false;
    setState(() {});
  }

  fetchFeaturedBrands() async {
    var brandsResponse = await BrandRepository().getAllBrands();
    _featuredBrandsList.addAll(brandsResponse.brands);
    _isBrandsInitial = false;
    setState(() {});
  }


  fetchFeaturedProducts() async {
    var productResponse = await ProductRepository().getFeaturedProducts(
      page: _productPage,
    );

    _featuredProductList.addAll(productResponse.products);
    _isProductInitial = false;
    _totalProductData = productResponse.meta.total;
    _showProductLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _carouselImageList.clear();
    _featuredCategoryList.clear();
    _isCarouselInitial = true;
    _isCategoryInitial = true;

    setState(() {});

    resetProductList();
  }

  Future<void> _onRefresh() async {
    reset();
    fetchAll();
  }

  resetProductList() {
    _featuredProductList.clear();
    _isProductInitial = true;
    _totalProductData = 0;
    _productPage = 1;
    _showProductLoadingContainer = false;
    setState(() {});
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    //print(MediaQuery.of(context).viewPadding.top);

    return WillPopScope(
      onWillPop: () async {
        return widget.go_back;
      },
      child: Directionality(
        textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: buildAppBar(statusBarHeight, context),
            drawer: MainDrawer(),
            body: Stack(
              children: [
                RefreshIndicator(
                  color: Colors.black,
                  backgroundColor: Colors.white,
                  onRefresh: _onRefresh,
                  displacement: 0,
                  child: CustomScrollView(
                    controller: _mainScrollController,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*
                                Text(
                                  AppLocalizations.of(context).home_screen_featured_categories,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ]),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: SizedBox(
                            height: 117,
                            child: buildHomeFeaturedCategories(context),
                          ),
                        ),
                      ),










                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(

                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            child: buildHomeCarouselSlider(context),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            // child: buildHomeMenuRow(context),
                          ),
                        ]),
                      ),



















                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            /*
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context).filter_screen_sellers.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            */

                            child:
                            !_isSellersInitial && _featuredSellersList.length == 0 ? Container() :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).filter_screen_sellers.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),


                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return Filter(
                                        selected_filter: "sellers",
                                      );
                                    }));
                                  },
                                  child: Container(
                                      child: Text(
                                        "[" + AppLocalizations.of(context).common_view_more + "]",
                                        textDirection: TextDirection.ltr,
                                        textAlign: TextAlign.left,

                                        style: TextStyle(
                                            color: Colors.brown,
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 14
                                        ),
                                      )

                                  ),
                                ),






                              ],
                            ),
                          ),
                        ]),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: SizedBox(
                            height: !_isSellersInitial && _featuredSellersList.length == 0 ? 0 : 117,
                            child: !_isSellersInitial && _featuredSellersList.length == 0 ? Container() : buildHomeFeaturedSellers1(context),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: SizedBox(
                            height: !_isSellersInitial && _featuredSellersList.length == 0 ? 0 : 117,
                            child: !_isSellersInitial && _featuredSellersList.length == 0 ? Container() : buildHomeFeaturedSellers2(context),
                          ),
                        ),
                      ),






















                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            /*
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context).filter_screen_sellers.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            */

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).selected_for_you.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return Filter(
                                        selected_filter: "sellers",
                                      );
                                    }));
                                  },
                                  child: Container(
                                    /*
                                      child: Text(
                                        "[" + AppLocalizations.of(context).common_view_more + "]",
                                        textDirection: TextDirection.ltr,
                                        textAlign: TextAlign.left,

                                        style: TextStyle(
                                            color: Colors.brown,
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 14
                                        ),
                                      )
                                     */
                                  ),
                                ),






                              ],
                            ),
                          ),
                        ]),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: SizedBox(
                            height: 310,
                            child: buildHomeFeaturedPub(context),
                          ),
                        ),
                      ),


































/*

                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            5.0,
                            0.0,
                            0.0,
                          ),
                          child: SizedBox(
                            height: 300,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: AppConfig.BASE_PATH +"uploads/all/pub1.png",
                                fit: BoxFit.cover,
                                height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub1.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                              height: 300,
                                              width: double.infinity,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                    },
                                  );
                                },
                              ),
                          ),
                        ),
                      ),
                      ),

*/







                      /* SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 300,
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +"uploads/all/pub2.png",
                                  fit: BoxFit.cover,
                                  height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub2.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                                  height: 300,
                                                  width: double.infinity,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

*/







                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            /*
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context).filter_screen_sellers.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            */

                            child:
                            !_isBrandsInitial && _featuredBrandsList.length == 0 ? Container() :
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context).filter_screen_brands.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return Filter(
                                        selected_filter: "brands",
                                      );
                                    }));
                                  },
                                  child: Container(
                                      child: Text(
                                        "[" + AppLocalizations.of(context).common_view_more + "]",
                                        textDirection: TextDirection.ltr,
                                        textAlign: TextAlign.left,

                                        style: TextStyle(
                                            color: Colors.brown,
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 14
                                        ),
                                      )

                                  ),
                                ),






                              ],
                            ),
                          ),
                        ]),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                          ),
                          child: SizedBox(
                            height: !_isBrandsInitial && _featuredBrandsList.length == 0 ? 0 : 117,
                            child: !_isBrandsInitial && _featuredBrandsList.length == 0 ? Container() : buildHomeFeaturedBrands1(context),
                          ),
                        ),
                      ),














                      /* SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 300,
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +"uploads/all/pub3.png",
                                  fit: BoxFit.cover,
                                  height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub3.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                                  height: 300,
                                                  width: double.infinity,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
*/

                      /*                    SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 300,
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +"uploads/all/pub4.png",
                                  fit: BoxFit.cover,
                                  height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub4.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                                  height: 300,
                                                  width: double.infinity,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
*/

                    /*  SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 150,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: AppConfig.BASE_PATH +"uploads/all/pub5.png",
                                fit: BoxFit.cover,
                                height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub5.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                              height: 300,
                                              width: double.infinity,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),


                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 150,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: AppConfig.BASE_PATH +"uploads/all/pub6.png",
                                fit: BoxFit.cover,
                                height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub6.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                              height: 300,
                                              width: double.infinity,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),


                      /*          SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 300,
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +"uploads/all/pub7.png",
                                  fit: BoxFit.cover,
                                  height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub7.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                                  height: 300,
                                                  width: double.infinity,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
*/

                      /*                    SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 300,
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +"uploads/all/pub8.png",
                                  fit: BoxFit.cover,
                                  height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub8.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                                  height: 300,
                                                  width: double.infinity,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

*/
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 150,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: AppConfig.BASE_PATH +"uploads/all/pub9.png",
                                fit: BoxFit.cover,
                                height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub9.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                              height: 300,
                                              width: double.infinity,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 150,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: AppConfig.BASE_PATH +"uploads/all/pub10.png",
                                fit: BoxFit.cover,
                                height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub10.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                              height: 300,
                                              width: double.infinity,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),


                      /*                    SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return BrandProducts(
                                id: 100,
                                brand_name: "LOUIS VUITTON",
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              5.0,
                              0.0,
                              0.0,
                            ),
                            child: SizedBox(
                              height: 300,
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +"uploads/all/pub11.png",
                                  fit: BoxFit.cover,
                                  height:0,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +"uploads/all/pub11.png"),
                                    fit: BoxFit.cover,
                                    height: 300,
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
                                                  height: 300,
                                                  width: double.infinity,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),


*/
*/








                      SliverList(
                        delegate: SliverChildListDelegate([
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).home_screen_featured_products.toUpperCase(),
                                  style:
                                  TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    0.0,
                                    0.0,
                                    0.0,
                                    0.0,
                                  ),
                                  child: buildHomeFeaturedProducts(context),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 80,
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: buildProductLoadingContainer())
              ],
            )),
      ),
    );
  }

  buildHomeFeaturedProducts(context) {
    if (_isProductInitial && _featuredProductList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper().buildProductGridShimmer(
              scontroller: _featuredProductScrollController));
    } else if (_featuredProductList.length > 0) {
      //snapshot.hasData

      return GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: _featuredProductList.length,
        controller: _featuredProductScrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            mainAxisExtent: (( MediaQuery.of(context).size.width - 28 ) / 2) + 160,
            childAspectRatio: 0.618),
        padding: EdgeInsets.all(0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
              id: _featuredProductList[index].id,
              image: _featuredProductList[index].thumbnail_image,
              name: _featuredProductList[index].name,
              main_price: _featuredProductList[index].main_price,
              stroked_price: _featuredProductList[index].stroked_price,
              has_discount: _featuredProductList[index].has_discount,
              code_p: _featuredProductList[index].code_p);
        },
      );
    } else if (_totalProductData == 0) {
      return Center(child: Text(AppLocalizations.of(context).common_no_product_is_available));
    } else {
      return Container(); // should never be happening
    }
  }



  buildHomeFeaturedCategories(context) {
    if (_isCategoryInitial && _featuredCategoryList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_featuredCategoryList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _featuredCategoryList.length,
          itemExtent: 85,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CategoryProducts(
                      category_id: _featuredCategoryList[index].id,
                      category_name: _featuredCategoryList[index].name,
                    );
                  }));
                },
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    //side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0.0,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        //width: 100,
                          height: 67,
                          child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(0),
                                  bottom: Radius.zero),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder.png',
                                image: AppConfig.BASE_PATH +
                                    _featuredCategoryList[index].banner,
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return Image(
                                    image: NetworkImage(
                                        AppConfig.BASE_PATH +
                                            _featuredCategoryList[index].banner),
                                    fit: BoxFit.cover,
                                    height: 67,
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
                                              height: 67,
                                              width: double.infinity,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                    },
                                  );
                                },
                              ))),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Container(
                          height: 25,
                          child: Text(
                            _featuredCategoryList[index].name,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 11, color: MyTheme.font_grey
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    } else if (!_isCategoryInitial && _featuredCategoryList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).home_screen_no_category_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }





  buildHomeFeaturedBrands1(context) {
    if (_isBrandsInitial && _featuredBrandsList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_featuredBrandsList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          //itemCount: _featuredSellersList.length,
          itemCount: 10,
          itemExtent: 160,
          itemBuilder: (context, index) {

            return Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BrandProducts(
                      id: _featuredBrandsList[index].id,
                      brand_name: _featuredBrandsList[index].name,
                    );
                  }));
                },
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0.0,
                  child: Container(

                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          //width: 100,
                            height: 67,
                            child: ClipRRect(
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +
                                      _featuredBrandsList[index].logo,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (BuildContext context, Object y, StackTrace z) {
                                    return Image(
                                      image: NetworkImage(
                                          AppConfig.BASE_PATH +
                                              _featuredBrandsList[index].logo),
                                      fit: BoxFit.cover,
                                      height: 67,
                                      errorBuilder:
                                          (BuildContext context, Object y, StackTrace z) {
                                        return
                                          /*
                                        Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 180,
                                            color: Colors.grey,
                                          ));
                                      */
                                          Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                                            child: Shimmer.fromColors(
                                              baseColor: MyTheme.shimmer_base,
                                              highlightColor: MyTheme.shimmer_highlighted,
                                              child: Container(
                                                height: 67,
                                                width: double.infinity,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                      },
                                    );
                                  },
                                ))),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Container(
                            height: 25,
                            child: Text(
                              _featuredBrandsList[index].name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 11, color: MyTheme.font_grey
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else if (!_isBrandsInitial && _featuredBrandsList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).home_screen_no_seller_found,
                //AppLocalizations.of(context).home_screen_no_brand_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }





  buildHomeFeaturedPub(context) {

    if (_isPubsInitial && _pubsList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_pubsList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          //itemCount: _featuredSellersList.length,
          itemCount: _pubsList.length,
          // itemExtent: 300,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BrandProducts(
                      id: _pubsList[index].id_shop,
                      brand_name: _pubsList[index].lb_shop,
                    );
                  }));
                },
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    //side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0.0,
                  child: Container(
                    /*
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bgsellers.jpg"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  */
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          //width: 360,
                            height: 300,
                            child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(0),
                                    bottom: Radius.circular(0)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +
                                      _pubsList[index].img,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (BuildContext context, Object y,
                                      StackTrace z) {
                                    return Image(
                                      image: NetworkImage(
                                          AppConfig.BASE_PATH +
                                              _pubsList[index].img),
                                      fit: BoxFit.cover,
                                      height: 300,
                                      errorBuilder:
                                          (BuildContext context, Object y,
                                          StackTrace z) {
                                        return
                                          /*
                                        Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 180,
                                            color: Colors.grey,
                                          ));
                                      */
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 0.0),
                                            child: Shimmer.fromColors(
                                              baseColor: MyTheme.shimmer_base,
                                              highlightColor: MyTheme
                                                  .shimmer_highlighted,
                                              child: Container(
                                                height: 300,
                                                width: double.infinity,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                      },
                                    );
                                  },
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else if (!_isPubsInitial && _pubsList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).home_screen_no_seller_found,
                //AppLocalizations.of(context).home_screen_no_brand_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }





  buildHomeFeaturedSellers1(context) {
    if (_isSellersInitial && _featuredSellersList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_featuredSellersList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          //itemCount: _featuredSellersList.length,
          itemCount: 5,
          itemExtent: 120,
          itemBuilder: (context, index) {

            return Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SellerDetails(
                      id: _featuredSellersList[index].id,
                    );
                  }));
                },
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    //side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bgsellers.jpg"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          //width: 100,
                            height: 67,
                            child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(0),
                                    bottom: Radius.circular(50)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +
                                      _featuredSellersList[index].logo,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (BuildContext context, Object y, StackTrace z) {
                                    return Image(
                                      image: NetworkImage(
                                          AppConfig.BASE_PATH +
                                              _featuredSellersList[index].logo),
                                      fit: BoxFit.cover,
                                      height: 67,
                                      errorBuilder:
                                          (BuildContext context, Object y, StackTrace z) {
                                        return
                                          /*
                                        Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 180,
                                            color: Colors.grey,
                                          ));
                                      */
                                          Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                                            child: Shimmer.fromColors(
                                              baseColor: MyTheme.shimmer_base,
                                              highlightColor: MyTheme.shimmer_highlighted,
                                              child: Container(
                                                height: 67,
                                                width: double.infinity,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                      },
                                    );
                                  },
                                ))),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Container(
                            height: 25,
                            child: Text(
                              _featuredSellersList[index].code_s +" : "+ _featuredSellersList[index].name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 11, color: MyTheme.font_grey
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else if (!_isSellersInitial && _featuredSellersList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).home_screen_no_seller_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  buildHomeFeaturedSellers2(context) {
    if (_isSellersInitial && _featuredSellersList.length == 0) {
      return Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
          Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 32) / 3)),
        ],
      );
    } else if (_featuredSellersList.length > 0) {
      //snapshot.hasData
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          //itemCount: _featuredSellersList.length,
          itemCount: 5,
          itemExtent: 120,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                index = 5;
                break;
              case 1:
                index = 6;
                break;
              case 2:
                index = 7;
                break;
              case 3:
                index = 8;
                break;
              case 4:
                index = 9;
                break;
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SellerDetails(
                      id: _featuredSellersList[index].id,
                    );
                  }));
                },
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    //side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/bgsellers.jpg"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          //width: 100,
                            height: 67,
                            child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(0),
                                    bottom: Radius.circular(50)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: AppConfig.BASE_PATH +
                                      _featuredSellersList[index].logo,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (BuildContext context, Object y, StackTrace z) {
                                    return Image(
                                      image: NetworkImage(
                                          AppConfig.BASE_PATH +
                                              _featuredSellersList[index].logo),
                                      fit: BoxFit.cover,
                                      height: 67,
                                      errorBuilder:
                                          (BuildContext context, Object y, StackTrace z) {
                                        return
                                          /*
                                        Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 180,
                                            color: Colors.grey,
                                          ));
                                      */
                                          Padding(
                                            padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                                            child: Shimmer.fromColors(
                                              baseColor: MyTheme.shimmer_base,
                                              highlightColor: MyTheme.shimmer_highlighted,
                                              child: Container(
                                                height: 67,
                                                width: double.infinity,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                      },
                                    );
                                  },
                                ))),
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Container(
                            height: 25,
                            child: Text(
                              _featuredSellersList[index].code_s +" : "+_featuredSellersList[index].name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 11, color: MyTheme.font_grey
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else if (!_isSellersInitial && _featuredSellersList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).home_screen_no_seller_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }
  buildHomeMenuRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CategoryList(
                is_top_category: true,
              );
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: MyTheme.light_grey, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("assets/top_categories.png"),
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    AppLocalizations.of(context).home_screen_top_categories,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromRGBO(132, 132, 132, 1),
                        fontWeight: FontWeight.w300),
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Filter(
                selected_filter: "brands",
              );
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: MyTheme.light_grey, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("assets/brands.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(AppLocalizations.of(context).home_screen_brands,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TopSellingProducts();
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: MyTheme.light_grey, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("assets/top_sellers.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(AppLocalizations.of(context).home_screen_top_sellers,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TodaysDealProducts();
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: MyTheme.light_grey, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("assets/todays_deal.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(AppLocalizations.of(context).home_screen_todays_deal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FlashDealList();
            }));
          },
          child: Container(
            height: 100,
            width: MediaQuery.of(context).size.width / 5 - 4,
            child: Column(
              children: [
                Container(
                    height: 57,
                    width: 57,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                        Border.all(color: MyTheme.light_grey, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("assets/flash_deal.png"),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(AppLocalizations.of(context).home_screen_flash_deal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(132, 132, 132, 1),
                            fontWeight: FontWeight.w300))),
              ],
            ),
          ),
        )
      ],
    );
  }

  buildHomeCarouselSlider(context) {
    if (_isCarouselInitial && _carouselImageList.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: Shimmer.fromColors(
          baseColor: MyTheme.shimmer_base,
          highlightColor: MyTheme.shimmer_highlighted,
          child: Container(
            height: 120,
            width: double.infinity,
            color: Colors.white,
          ),
        ),
      );
    } else if (_carouselImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 1.95,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInCubic,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current_slider = index;
              });
            }),
        items: _carouselImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(
                children: <Widget>[
                  Container(
                      width: double.infinity,
                      height:180,
                      margin: EdgeInsets.symmetric(horizontal: 0.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: AppConfig.BASE_PATH + i,
                            fit: BoxFit.fill,
                            imageErrorBuilder:
                                (BuildContext context, Object y, StackTrace z) {
                              return Image(
                                image: NetworkImage(
                                    AppConfig.BASE_PATH + i),
                                fit: BoxFit.cover,
                                height: 180,
                                errorBuilder:
                                    (BuildContext context, Object y, StackTrace z) {
                                  return
                                    /*
                                        Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 180,
                                            color: Colors.grey,
                                          ));
                                      */
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                                      child: Shimmer.fromColors(
                                        baseColor: MyTheme.shimmer_base,
                                        highlightColor: MyTheme.shimmer_highlighted,
                                        child: Container(
                                          height: 180,
                                          width: double.infinity,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                },
                              );
                            },
                          ))),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _carouselImageList.map((url) {
                        int index = _carouselImageList.indexOf(url);
                        return Container(
                          width: 7.0,
                          height: 7.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current_slider == index
                                ? MyTheme.white
                                : Color.fromRGBO(112, 112, 112, .3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          );
        }).toList(),
      );
    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context).home_screen_no_carousel_image_found,
                style: TextStyle(color: MyTheme.font_grey),
              )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
          child: widget.show_back_button
              ? Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                onPressed: () {
                  if(!widget.go_back){
                    return;
                  }
                  return Navigator.of(context).pop();
                }),
          )
              : Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 18.0, horizontal: 0.0),
              child: Container(
                child: Image.asset(
                  'assets/hamburger.png',
                  height: 16,
                  //color: MyTheme.dark_grey,
                  color: MyTheme.black,
                ),
              ),
            ),
          )
      ),






      titleSpacing: 35,
      title:  InkWell(
        onTap: () {
          ontaptitle();
        },
        child: Image.asset('assets/app_logo-of-top-bar.png', height:45),

      ),

      actions:<Widget>[

        Row(children: [
          IconButton(
            icon: Icon(Icons.local_grocery_store_outlined),
            iconSize: 30,
            color:Colors.black,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Main_cart())),
            //onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Splash())),

          )
        ]),


        Row(children: [
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 35,
            color:Colors.black,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => Filter())),

          )
        ]),



      ],

/*
      title: Container(
        height: kToolbarHeight +
            statusBarHeight -
            (MediaQuery.of(context).viewPadding.top > 40 ? 16.0 : 16.0),
            //width:60,
        //MediaQuery.of(context).viewPadding.top is the statusbar height, with a notch phone it results almost 50, without a notch it shows 24.0.For safety we have checked if its greater than thirty
        child: Container(
          child: Padding(
              padding: app_language_rtl.$ ? const EdgeInsets.only(top: 14.0, bottom: 14, left: 12) : const EdgeInsets.only(top: 14.0, bottom: 14, right: 12),
              // when notification bell will be shown , the right padding will cease to exist.
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Filter();
                    }));
                  },
                  child: buildHomeSearchBox(context))),
        ),
      ),
      //elevation: 0.0,
      titleSpacing: 0,
*/


/*
      actions: <Widget>[
        InkWell(
          onTap: () {
            ToastComponent.showDialog(AppLocalizations.of(context).common_coming_soon, context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          },
          child: Visibility(
            visible: true,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                 //const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Image.asset(
                'assets/app_logo-of-top-bar.png',
                height: 16,
                color: MyTheme.black,
              ),
            ),
          ),
        ),
      ],


*/




    );
  }

  buildHomeSearchBox(BuildContext context) {
    return TextField(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Filter();
        }));
      },
      autofocus: false,
      decoration: InputDecoration(
          hintText: AppLocalizations.of(context).home_screen_search,
          hintStyle: TextStyle(fontSize: 12.0, color: MyTheme.textfield_grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.textfield_grey, width: 0.5),
            borderRadius: const BorderRadius.all(
              const Radius.circular(16.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.textfield_grey, width: 1.0),
            borderRadius: const BorderRadius.all(
              const Radius.circular(16.0),
            ),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.search,
              color: MyTheme.textfield_grey,
              size: 20,
            ),
          ),
          contentPadding: EdgeInsets.all(0.0)),
    );
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showProductLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalProductData == _featuredProductList.length
            ? AppLocalizations.of(context).common_no_more_products
            : AppLocalizations.of(context).common_loading_more_products),
      ),
    );
  }
}
