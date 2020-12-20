import 'package:api_to_sqlite_flutter/src/models/programmer_model.dart';
import 'package:api_to_sqlite_flutter/src/providers/db_provider.dart';
import 'package:dio/dio.dart';

class ProgrammerApiProvider {
  Future<List<Programmer>> getAllProgrammers() async {
    var url = "https://demo2479287.mockable.io/programmer";
    Response response = await Dio().get(url);

    return (response.data as List).map((programmer) {
      print('Inserting $programmer');
      DBProvider.db.createProgrammer(Programmer.fromJson(programmer));
    }).toList();
  }
}
