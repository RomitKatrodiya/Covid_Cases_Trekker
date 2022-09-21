import 'dart:convert';
import 'package:corona_cases_app/modals/modals.dart';
import 'package:http/http.dart' as http;

class CovidApi {
  CovidApi._();

  static final CovidApi covidAPI = CovidApi._();

  Future<List<CovidData>?> fetchCovidDataAPI() async {
    String url = "https://corona-api.com//countries?include";

    http.Response res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      Map<String, dynamic> decodedData = jsonDecode(res.body);

      List decodedDataList = decodedData["data"];

      List<CovidData> covidData = decodedDataList.map((e) {
        return CovidData.fromJSON(json: e);
      }).toList();
      return covidData;
    }
    return null;
  }
}
