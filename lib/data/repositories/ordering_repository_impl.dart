import '../api/repositories/api_repositories.dart';
import 'repositories.dart';

// Repository for ordering

class OrderingRepositoryImpl extends OrderingRepository {
  final RemoteOrderingRepository remoteOrderingRepository;

  OrderingRepositoryImpl({required this.remoteOrderingRepository});

  // @override
  // Future<dynamic> listMerchants(
  //     String token, String latitude, String longitude) async {
  //   return remoteOrderingRepository.listMerchants(token, latitude, longitude);
  // }

  @override
  Future<dynamic> listNearbyOutlet(
      String token, String latitude, String longitude, int offset) async {
    return remoteOrderingRepository.listNearbyOutlet(
        token, latitude, longitude, offset);
  }

  @override
  Future<dynamic> listBrands(
      String token, String latitude, String longitude, int categoryId) async {
    return remoteOrderingRepository.listBrands(
        token, latitude, longitude, categoryId);
  }

  @override
  Future<dynamic> listOutlets(
      int brandId, String latitude, String longitude, String token) async {
    return remoteOrderingRepository.listOutlets(
        brandId, latitude, longitude, token);
  }

  @override
  Future<dynamic> getDetails(int outletId, String token) async {
    return remoteOrderingRepository.getDetails(outletId, token);
  }

  @override
  Future<dynamic> addRemoveBookmark(
      {required String token, required String merchantId}) async {
    return remoteOrderingRepository.addRemoveBookmark(
        token: token, merchantId: merchantId);
  }

  @override
  Future<dynamic> getBookmark({
    required String token,
    required String latitude,
    required String longitude,
  }) async {
    return remoteOrderingRepository.getBookmark(
      token: token,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
