import '../../../data/repositories/repositories.dart';
import '../../../locator.dart';
import '../base_use_case.dart';

// Transfer credit useCase

abstract class TransferCreditGetUseCase
    implements BaseUseCase<TransferCreditGetResult, TransferCreditGetParams> {}

class TransferCreditGetUseCaseImpl extends TransferCreditGetUseCase {
  @override
  Future<TransferCreditGetResult> execute(
      TransferCreditGetParams params) async {
    try {
      // Transfer credit
      TransferRepository transferRepository = sl();
      var startTransfer = await transferRepository.transferCredit(
        token: params.token,
        qrCode: params.qrCode,
        amount: params.amount,
        pin: params.pin,
      );

      // If got data, pass to TransferCreditGetResult
      if (startTransfer.isNotEmpty) {
        return TransferCreditGetResult(
            transferSuccess: startTransfer, result: true);
      }
    } catch (e) {
      rethrow;
    }

    // If no data, pass to TransferCreditGetException
    return TransferCreditGetResult(
      transferSuccess: null,
      result: false,
      exception: TransferCreditGetException(
        exception: Exception('No security otp code Found'),
      ),
    );
  }
}

// TransferCreditGetResult is trigger when result != null
class TransferCreditGetResult extends UseCaseResult {
  dynamic transferSuccess;

  TransferCreditGetResult(
      {required this.transferSuccess, super.exception, super.result});
}

// TransferCreditGetParams class is defined and wrapped around the parameters
class TransferCreditGetParams {
  String token;
  String qrCode;
  String amount;
  String pin;

  TransferCreditGetParams({
    required this.token,
    required this.qrCode,
    required this.amount,
    required this.pin,
  });
}

// Trigger Exception
class TransferCreditGetException implements Exception {
  Exception exception;

  TransferCreditGetException({required this.exception});
}
