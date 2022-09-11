import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/screens/seller_details.dart';
import 'package:shimmer/shimmer.dart';

class ShopSquareCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String code_s;

  ShopSquareCard({Key key,this.id, this.image, this.name , this.code_s}) : super(key: key);

  @override
  _ShopSquareCardState createState() => _ShopSquareCardState();
}

class _ShopSquareCardState extends State<ShopSquareCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SellerDetails(id: widget.id,);
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: ((MediaQuery.of(context).size.width - 24) /2) * .72,
                  child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16), bottom: Radius.zero),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: AppConfig.BASE_PATH + widget.image,
                        fit: BoxFit.scaleDown,
                        imageErrorBuilder:
                            (BuildContext context, Object y, StackTrace z) {
                          return Image(
                            image: NetworkImage(
                                AppConfig.BASE_PATH + widget.image),
                            fit: BoxFit.cover,
                            height: ((MediaQuery.of(context).size.width - 24) /2) * .72,
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
                                      height: ((MediaQuery.of(context).size.width - 24) /2) * .72,
                                      width: double.infinity,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                            },
                          );
                        },
                      ))),
              Container(
                height: 40,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    widget.code_s+" : "+widget.name,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
