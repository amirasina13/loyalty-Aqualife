// import '../../../data/model/model.dart';
// import '../../../data/repositories/repositories.dart';
// import '../../../locator.dart';
// import '../base_use_case.dart';

// // Voucher list useCase

// abstract class VoucherTransactionsGetUseCase
//     implements
//         BaseUseCase<VoucherTransactionsGetResult,
//             VoucherTransactionsGetParams> {}

// class VoucherTransactionsGetUseCaseImpl extends VoucherTransactionsGetUseCase {
//   @override
//   Future<VoucherTransactionsGetResult> execute(
//       VoucherTransactionsGetParams params) async {
//     try {
//       // Get voucher list
//       VoucherRepository voucherRepository = sl();
//       var vouchers =
//           await voucherRepository.listVouchers(params.filter, params.token);

//       // If got data, pass to VoucherTransactionsGetResult
//       if (vouchers.isNotEmpty) {
//         return VoucherTransactionsGetResult(vouchers: vouchers, result: true);
//       }
//     } catch (e) {
//       rethrow;
//     }

//     // If no data, pass to VoucherTransactionsGetException
//     return VoucherTransactionsGetResult(
//         vouchers: [],
//         result: false,
//         exception: VoucherTransactionsGetException(
//             exception: Exception('No Vouchers Found')));
//   }
// }

// // VoucherTransactionsGetResult is trigger when result != null
// class VoucherTransactionsGetResult extends UseCaseResult {
//   List<Voucher> vouchers;

//   VoucherTransactionsGetResult(
//       {required this.vouchers, Exception? exception, bool? result})
//       : super(exception: exception, result: result);
// }

// // VoucherTransactionsGetParams class is defined and wrapped around the parameters
// class VoucherTransactionsGetParams {
//   String filter;
//   String token;

//   VoucherTransactionsGetParams({
//     required this.filter,
//     required this.token,
//   });
// }

// // Trigger Exception
// class VoucherTransactionsGetException implements Exception {
//   Exception exception;

//   VoucherTransactionsGetException({required this.exception});
// }
