import '../../model/model.dart';

// Abstract repository for global

abstract class GlobalRepository {
  Future<List<Country>> getCountries();

  Future<Map> getGlobalData();
}
