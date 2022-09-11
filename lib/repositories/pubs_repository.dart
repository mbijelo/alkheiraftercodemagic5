import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/pubs_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class PubsRepository {

  Future<PubsResponse> getFilterPagePubs() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/pubs");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    return pubsResponseFromJson(response.body);
  }

  Future<PubsResponse> getAllPubs() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/pubs");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    return pubsResponseFromJson(response.body);
  }

  Future<PubsResponse> getBrands({name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/pubs"+
        "?page=${page}&name=${name}");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    return pubsResponseFromJson(response.body);
  }



}
