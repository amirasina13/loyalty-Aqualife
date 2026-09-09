import '../../../data/repositories/repositories.dart';
import '../../../locator.dart';
import '../base_use_case.dart';

// Voucher past list useCase

abstract class VoucherPastDetailsGetUseCase
    implements
        BaseUseCase<VoucherPastDetailsGetResult, VoucherPastDetailsGetParams> {}

class VoucherPastDetailsGetUseCaseImpl extends VoucherPastDetailsGetUseCase {
  @override
  Future<VoucherPastDetailsGetResult> execute(
      VoucherPastDetailsGetParams params) async {
    try {
      // Get voucher past list
      VoucherRepository voucherPastDetailsRepository = sl();
      var pastDetails = await voucherPastDetailsRepository
          .getPastVoucherDetails(params.token, params.voucherId);

      // If got data, pass to VoucherPastDetailsGetResult
      // if (vouchersPast != null) {
      return VoucherPastDetailsGetResult(
        pastDetails: pastDetails,
        result: true,
      );
      // }
    } catch (e) {
      rethrow;
    }
  }
}

// VoucherPastDetailsGetResult is trigger when result != null
class VoucherPastDetailsGetResult extends UseCaseResult {
  dynamic pastDetails;

  VoucherPastDetailsGetResult(
      {required this.pastDetails, super.exception, super.result});
}

// VoucherPastDetailsGetParams class is defined and wrapped around the parameters
class VoucherPastDetailsGetParams {
  String token;
  int voucherId;

  VoucherPastDetailsGetParams({
    required this.token,
    required this.voucherId,
  });
}

// Trigger Exception
class VoucherPastDetailsGetException implements Exception {
  Exception exception;

  VoucherPastDetailsGetException({required this.exception});
}
