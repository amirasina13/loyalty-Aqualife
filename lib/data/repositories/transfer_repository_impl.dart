import '../api/repositories/api_repositories.dart';
import 'repositories.dart';

// Repository for transfer

class TransferRepositoryImpl extends TransferRepository {
  final RemoteTransferRepository remoteTransferRepository;

  TransferRepositoryImpl({required this.remoteTransferRepository});

  @override
  Future<dynamic> verifyTransfer({
    required String token,
    required String qrCode,
  }) async {
    return remoteTransferRepository.verifyTransfer(
      token: token,
      qrCode: qrCode,
    );
  }

  @override
  Future<dynamic> transferCredit({
    required String token,
    required String qrCode,
    required String amount,
    required String pin,
  }) async {
    return remoteTransferRepository.transferCredit(
      token: token,
      qrCode: qrCode,
      amount: amount,
      pin: pin,
    );
  }
}
