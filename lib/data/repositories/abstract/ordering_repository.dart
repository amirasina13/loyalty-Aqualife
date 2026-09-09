// Abstract repository for ordering

abstract class OrderingRepository {
  // Future<dynamic> listMerchants(
  //     String token, String latitude, String longitude);

  Future<dynamic> listNearbyOutlet(
      String token, String latitude, String longitude, int offset);

  Future<dynamic> listBrands(
      String token, String latitude, String longitude, int categoryId);

  Future<dynamic> listOutlets(
      int brandId, String latitude, String longitude, String token);

  Future<dynamic> getDetails(int outletId, String token);

  Future<dynamic> addRemoveBookmark(
      {required String token, required String merchantId});

  Future<dynamic> getBookmark(
      {required String token,
      required String latitude,
      required String longitude});
}
