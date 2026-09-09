import '../../../data/repositories/repositories.dart';
import '../../../locator.dart';
import '../base_use_case.dart';

// Reward/ If Perks details useCase

abstract class RewardDetailsGetUseCase
    implements BaseUseCase<RewardDetailsGetResult, RewardDetailsGetParams> {}

class RewardDetailsGetUseCaseImpl extends RewardDetailsGetUseCase {
  @override
  Future<RewardDetailsGetResult> execute(RewardDetailsGetParams params) async {
    try {
      // Get reward details
      RewardRepository rewardRepository = sl();
      var details = await rewardRepository.getDetails(
        params.token,
        params.rewardId,
        params.latitude,
        params.longitude,
      );

      // If got data, pass to RewardDetailsGetResult
      return RewardDetailsGetResult(details: details, result: true);
    } catch (e) {
      rethrow;
    }
  }
}

// RewardDetailsGetResult is trigger when result != null
class RewardDetailsGetResult extends UseCaseResult {
  dynamic details;

  RewardDetailsGetResult(
      {required this.details, super.exception, super.result});
}

// RewardDetailsGetParams class is defined and wrapped around the parameters
class RewardDetailsGetParams {
  String token;
  int rewardId;
  String latitude;
  String longitude;

  RewardDetailsGetParams({
    required this.token,
    required this.rewardId,
    required this.latitude,
    required this.longitude,
  });
}

// Trigger Exception
class RewardDetailsGetException implements Exception {
  Exception exception;

  RewardDetailsGetException({required this.exception});
}
