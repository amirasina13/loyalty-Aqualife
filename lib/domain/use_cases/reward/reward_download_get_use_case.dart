import '../../../data/repositories/repositories.dart';
import '../../../locator.dart';
import '../base_use_case.dart';

// Reward/ IF Perks purchase voucher useCase

abstract class RewardDownloadGetUseCase
    implements BaseUseCase<RewardDownloadGetResult, RewardDownloadGetParams> {}

class RewardDownloadGetUseCaseImpl extends RewardDownloadGetUseCase {
  @override
  Future<RewardDownloadGetResult> execute(
      RewardDownloadGetParams params) async {
    try {
      // Purchase reward/ IF Perks voucher
      RewardRepository purchaseRepository = sl();
      var success = await purchaseRepository.downloadVoucher(
          params.voucherId, params.pin, params.referral, params.token);

      // If got data, pass to RewardDownloadGetResult
      // if (success != null) {
      return RewardDownloadGetResult(success: success, result: true);
      // }
    } catch (e) {
      rethrow;
    }

    // // If no data, pass to RewardDownloadGetException
    // return RewardDownloadGetResult(
    //     success: null,
    //     result: false,
    //     exception: RewardDownloadGetException(
    //         exception: Exception('No Reward Found')));
  }
}

// RewardDownloadGetResult is trigger when result != null
class RewardDownloadGetResult extends UseCaseResult {
  dynamic success;

  RewardDownloadGetResult(
      {required this.success, super.exception, super.result});
}

// RewardDownloadGetParams class is defined and wrapped around the parameters
class RewardDownloadGetParams {
  int voucherId;
  String pin;
  String token;
  String referral;

  RewardDownloadGetParams({
    required this.voucherId,
    required this.pin,
    required this.token,
    required this.referral,
  });
}

// Trigger Exception
class RewardDownloadGetException implements Exception {
  Exception exception;

  RewardDownloadGetException({required this.exception});
}
