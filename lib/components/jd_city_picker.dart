import 'package:flutter/material.dart';

import 'package:city_pickers/city_pickers.dart';

class JdCityPicker {
  static Future<Result> showCities(BuildContext ctx) async {
    return await CityPickers.showCityPicker(
        context: ctx, locationCode: "320611");
  }
}
