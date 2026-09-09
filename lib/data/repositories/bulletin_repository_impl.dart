import '../api/repositories/api_repositories.dart';
import 'repositories.dart';

// Repository for bulletin

class BulletinRepositoryImpl extends BulletinRepository {
  final RemoteBulletinRepository remoteBulletinRepository;

  BulletinRepositoryImpl({required this.remoteBulletinRepository});

  @override
  Future<dynamic> listBulletin(String token, String type) async {
    return remoteBulletinRepository.listBulletin(token, type);
  }

  @override
  Future<dynamic> getDetails(String token, int bulletinId) async {
    return remoteBulletinRepository.getDetails(token, bulletinId);
  }
}
