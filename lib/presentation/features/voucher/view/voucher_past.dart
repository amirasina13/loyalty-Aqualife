// import '../../../../config/config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../../../data/model/model.dart';
// import '../../../widgets/extensions/voucher_past_view.dart';
// import '../voucher.dart';

// class VoucherPastView extends StatefulWidget {
//   final Function? changeView;

//   const VoucherPastView({Key? key, this.changeView}) : super(key: key);

//   @override
//   State<VoucherPastView> createState() => _VoucherPastViewState();
// }

// class _VoucherPastViewState extends State<VoucherPastView> {
//   List<VoucherPast> vouchersPast = [];
//   final bool _enabled = true;

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;

//     return SingleChildScrollView(
//       child: Container(
//         height: height * 0.8,
//         color: colorBackground,
//         margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//         padding: EdgeInsets.only(bottom: 15),
//         child: BlocConsumer<VoucherBloc, VoucherState>(
//           listener: (context, state) {},
//           builder: (context, state) {
//             if (state is VoucherLoading) {
//               return Container(
//                 color: colorTransparent,
//                 child: Shimmer.fromColors(
//                   baseColor: colorLightGray,
//                   highlightColor: colorDisableGrey,
//                   enabled: _enabled,
//                   child: ListView.builder(
//                     itemBuilder: (_, __) => Padding(
//                       padding: const EdgeInsets.only(bottom: 8.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             width: height / 5.2,
//                             height: height / 5.2,
//                             color: colorWhite,
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 8.0),
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   width: double.infinity,
//                                   height: height * 0.03,
//                                   color: colorWhite,
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 2.0),
//                                 ),
//                                 Container(
//                                   width: double.infinity,
//                                   height: height * 0.062,
//                                   color: colorWhite,
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 2.0),
//                                 ),
//                                 Container(
//                                   // width: 40.0,
//                                   height: height / 30,
//                                   color: colorWhite,
//                                 ),
//                                 const Padding(
//                                   padding: EdgeInsets.symmetric(vertical: 2.0),
//                                 ),
//                                 Container(
//                                   height: height / 16,
//                                   color: colorWhite,
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     itemCount: 6,
//                   ),
//                 ),
//               );
//             }
//             if (state is VoucherEmpty) {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: height / 9,
//                     width: width * 0.3,
//                     padding: EdgeInsets.symmetric(
//                         vertical: height / 8, horizontal: width),
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         fit: BoxFit.contain,
//                         image: AssetImage('assets/icons/empty_my_voucher.png'),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: height * 0.03),
//                   Text(
//                     "No Available Voucher",
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w300,
//                       color: colorNoVoucherGrey,
//                     ),
//                     textAlign: TextAlign.center,
//                     textScaleFactor: scaleFactor,
//                   ),
//                 ],
//               );
//             }

//             return _buildVoucherPastListView(context, state);
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildVoucherPastListView(BuildContext context, VoucherState state) {
//     if (state is VoucherPastTransactionsLoaded) {
//       vouchersPast = state.vouchersPast;
//     }

//     var voucherPastTiles = vouchersPast
//         .map((voucher) => voucher.getVoucherPastTile(
//             context: context, past: true, onTap: () {}))
//         .toList(growable: false);

//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: vouchersPast.length,
//       itemBuilder: (context, index) {
//         return voucherPastTiles[index];
//       },
//     );
//   }
// }
