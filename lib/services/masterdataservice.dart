part of 'services.dart';

class MasterDataService {

  static Future<List<Province>> getProvince() async {
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/province"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        });

    var job = json.decode(response.body);
    List<Province> result = [];

    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((element) => Province.fromMap(element)).toList();

    }
    return result;
  }


  static Future<List<City>> getCity(var provId) async{
    var response = await http.get(Uri.https(Const.baseUrl, "/starter/city"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        });

    var job = json.decode(response.body);
    List<City> result = [];
    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'] as List)
          .map((e) => City.fromMap(e))
          .toList();
    }


    List<City> selectedCities = [];
    for(var c in result){
      if(c.provinceId == provId){
        selectedCities.add(c);
      }
    }
    return selectedCities;

  }

  static Future<List<Costs>> getCost(var origin, var destination, var weight, var courier) async{
    var response = await http.post(Uri.https(Const.baseUrl, "/starter/cost"),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
          'key': Const.apiKey,
        },
        body:<String,dynamic> {
        'origin': origin.toString(),
        'destination': destination.toString(),
        'weight': weight.toString(),
        'courier': courier.toString(),
        },);

    var job = json.decode(response.body);

    List<Costs> result = [];
    print(job['rajaongkir']['results'][0]['costs'] as List);
    if (response.statusCode == 200) {
      result = (job['rajaongkir']['results'][0]['costs']  as List)
          .map((e) => Costs.fromMap(e))
          .toList();
    }

    return result;
  }


}
