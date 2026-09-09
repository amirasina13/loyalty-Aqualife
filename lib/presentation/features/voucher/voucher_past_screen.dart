// import '../../../../config/config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import '../../../config/routes.dart';

// import '../../../locator.dart';
// import '../../widgets/independent/independent.dart';
// import '../maintenance/maintenance_screen.dart';
// import '../profile/profile.dart';
// import '../settings/setting.dart';
// import '../wrapper.dart';
// import 'voucher.dart';

// class VoucherPastScreen extends StatefulWidget {
//   const VoucherPastScreen({Key? key}) : super(key: key);

//   @override
//   State<VoucherPastScreen> createState() => _VoucherPastScreenState();
// }

// class _VoucherPastScreenState extends State<VoucherPastScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileBloc, ProfileState>(
//       builder: (context, state) {
//         if (state is ProfileProcessing) {
//           return Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             color: colorWhite,
//             child: LoadingWidget(),
//           );
//         }

//         return AqualifeScaffold(
//           title: Text(
//             'Past',
//             style: TextStyle(
//               fontFamily: fontFamilyMain,
//               color: colorBlack,
//               fontWeight: FontWeight.w400,
//               fontSize: 15,
//             ),
//             textScaleFactor: scaleFactor,
//           ),
//           body: BlocProvider<VoucherBloc>(
//             create: (context) {
//               ProfileBloc profileBloc = ProfileBloc(userRepository: sl());
//               return VoucherBloc(profileBloc: profileBloc)
//                 ..add(VoucherPastTransactionsLoad());
//             },
//             child: VoucherPastWrapper(),
//           ),
//           appbarAction: [
//             IconButton(
//               icon: Icon(Icons.history),
//               onPressed: () {
//                 Navigator.of(context).pushNamed(AqualifeRoutes.history,
//                     arguments: HistoryParameters(selectedTab: 1));
//               },
//             ),
//           ],
//           bottomMenuIndex: 1,
//         );
//       },
//     );
//   }
// }

// class VoucherPastWrapper extends StatefulWidget {
//   const VoucherPastWrapper({Key? key}) : super(key: key);

//   @override
//   AqualifeWrapperState<VoucherPastWrapper> createState() =>
//       _VoucherPastWrapperState();
// }

// class _VoucherPastWrapperState
//     extends AqualifeWrapperState<VoucherPastWrapper> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<VoucherBloc, VoucherState>(
//       listener: (context, state) {
//         fToast = FToast();
//         fToast.init(context);

//         if (state is VoucherError) {
//           showErrorToast(state.error, context);
//         }
//         if (state is VoucherSessionError) {
//           sessionExpiredLogOut(state.error);
//         }
//         /* --------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
//         if (state is VoucherMaintenanceError) {
//           Navigator.pushAndRemoveUntil<void>(
//             context,
//             MaterialPageRoute<void>(
//                 builder: (BuildContext context) => MaintenanceScreen(
//                     parameters: MaintenanceParameters(message: state.message))),
//             ModalRoute.withName('/'),
//           );
//         }
//       },
//       builder: (context, state) {
//         return getPageView(<Widget>[
//           VoucherPastView(
//             changeView: changePage,
//           ),
//         ]);
//       },
//     );
//   }
// }
