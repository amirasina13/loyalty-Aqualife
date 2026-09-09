import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/config.dart';
import '../../../../config/routes.dart';
import '../../../../data/model/model.dart';
import '../../../widgets/independent/independent.dart';
import '../voucher.dart';

class VoucherPastDetailsView extends StatefulWidget {
  final Function? changeView;
  final int voucherId;

  const VoucherPastDetailsView(
      {super.key, this.changeView, required this.voucherId});

  @override
  State<VoucherPastDetailsView> createState() => _VoucherPastDetailsViewState();
}

class _VoucherPastDetailsViewState extends State<VoucherPastDetailsView> {
  bool isProcessing = false;
  int initialRating = 0, finalRating = 0;
  String initialValue = '';
  late Timer durationLoading;
  late VoucherPastDetails pastDetail;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final TextEditingController ratingTextController = TextEditingController();
  final GlobalKey<AqualifeInputFieldState> ratingTextKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    if (!mounted) return;
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    BlocProvider.of<VoucherBloc>(context)
        .add(VoucherPastDetailsLoad(voucherId: widget.voucherId));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AqualifeScaffold(
      title: Text(
        'Feedback',
        style: TextStyle(
          fontFamily: fontFamilyMain,
          color: colorBlack,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          // overflow: TextOverflow.ellipsis,
        ),
        textScaler: TextScaler.linear(scaleFactor),
        textAlign: TextAlign.center,
      ),
      bottomMenuIndex: 3,
      // showBottomNavigator: false,
      body: BlocConsumer<VoucherBloc, VoucherState>(
        listener: (context, state) {
          if (state is VoucherRatingSuccess) {
            showSuccessToast(state.ratingResponse['message'], context);

            Navigator.of(context).pushNamedAndRemoveUntil(
                AqualifeRoutes.voucher, (route) => false,
                arguments: VoucherParameters(
                  selectedTab: 2,
                  filterBy: ' ',
                  filterValue: ' ',
                ));
          }

          if (state is VoucherRatingFailed) {
            setProcessingStatus(false);
            showErrorToast(state.ratingResponse['message'], context);
          }

          if (state is VoucherError) {
            // BlocProvider.of<VoucherBloc>(context).add(VoucherOutletCheck());
            showErrorToast(state.error, context);

            // Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is VoucherInitial || state is VoucherPastDetailsLoading) {
            return LoadingWidget();
          }

          if (state is VoucherPastDetailsLoaded) {
            pastDetail = state.pastDetails;
            initialValue = pastDetail.comment!;
            initialRating = pastDetail.rating!;
          }

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: marginHorizontal),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.2,
                          width: height * 0.2,
                          decoration: BoxDecoration(
                            // color: colorBabyBlue,
                            borderRadius: BorderRadius.circular(15),
                            // color: colorDisableGrey,
                            // boxShadow: const [
                            //   BoxShadow(
                            //     color: colorGreyBox,
                            //     blurRadius: 5.0,
                            //     offset: Offset(0.0, 5.0),
                            //   ),
                            // ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedImage(
                              imageUrl: pastDetail.image!,
                              // colorFilter: ColorFilter.mode(
                              //   colorWhite.withOpacity(0.35),
                              //   BlendMode.dstATop,
                              // ),
                            ),
                          ),
                        ),
                        // ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            pastDetail.name!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                            pastDetail.rating != 0 &&
                                    pastDetail.comment!.isNotEmpty
                                ? 'Thank you for your feedback!'
                                : 'Rate Your Experience',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        pastDetail.rating != 0 && pastDetail.comment!.isNotEmpty
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Are you satisfied with the service?',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: RatingBar.builder(
                            itemSize: width * 0.15,
                            initialRating:
                                double.parse(initialRating.toString()),
                            minRating: 0,
                            direction: Axis.horizontal,
                            ignoreGestures: pastDetail.rating != 0 &&
                                    pastDetail.comment!.isNotEmpty
                                ? true
                                : false,
                            // allowHalfRating: false,
                            unratedColor: colorGreyRating,
                            // glowColor: colorBackground,
                            glow: false,
                            itemCount: 5,
                            // itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: colorYellowLogo,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {
                                finalRating = rating.toInt();
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 20),
                          child: TextFormField(
                            key: ratingTextKey,
                            controller: pastDetail.rating != 0 &&
                                    pastDetail.comment!.isNotEmpty
                                ? null
                                : ratingTextController,
                            initialValue: pastDetail.rating != 0 &&
                                    pastDetail.comment!.isNotEmpty
                                ? initialValue
                                : null,
                            minLines: 8,
                            maxLines: null,
                            readOnly: pastDetail.rating != 0 &&
                                    pastDetail.comment!.isNotEmpty
                                ? true
                                : false,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: fontFamilyMain,
                            ),
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              contentPadding: EdgeInsets.all(10),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorGreyRating)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorGreyRating)),
                              hintText: 'Tell us about your experience',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: colorCountGrey,
                                fontFamily: fontFamilyMain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: pastDetail.rating != 0 &&
                            pastDetail.comment!.isNotEmpty
                        ? Container()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Spacer(),
                              AqualifeStyleButton(
                                title: 'Submit',
                                height: height / 14,
                                // iconLeading: false,
                                // icon: Icons.arrow_forward,
                                backgroundColor:
                                    isProcessing ? processing : secondaryColor,
                                textColor:
                                    isProcessing ? processingText : colorWhite,
                                onPressed:
                                    isProcessing ? () {} : _validateAndSend,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  FocusScope.of(context).unfocus();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 5, top: 10),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: colorBlack,
                                      decoration: TextDecoration.underline,
                                    ),
                                    textScaler: TextScaler.linear(scaleFactor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // void _getReviewData() {

  //   _fullNameController.text = profile['name'] ?? '';
  //   _firstNameController.text = profile['forename'] ?? '';
  //   _lastNameController.text = profile['surname'] ?? '';
  //   _dobController.text =
  //       profile['dob'].toString() != '' && profile['dob'].toString().isNotEmpty
  //           ? formatter.format(DateTime.parse(profile['dob']))
  //           : formatter.format(
  //               DateTime(dateNow.year - minAgeDOB, dateNow.month, dateNow.day));
  //   // _emailController.text = profile['email'] ?? '';
  //   _contactController.text =
  //       profile['contact'].substring(profile['contact'].indexOf("-") + 1) ?? '';
  //   _genderController.text = profile['gender'] ?? '';
  //   _muslimController.text = profile['isMuslim'] == null
  //       ? ''
  //       : profile['isMuslim'] == true
  //           ? 'Muslim-Friendly Content Only'
  //           : 'Include Non-Halal Content';

  //   selectedCode = profile['contact'] != ''
  //       ? profile['contact'].substring(0, profile['contact'].indexOf("-"))
  //       : '60';
  // }

  void _validateAndSend() {
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (finalRating == 0) {
      // errorfield = '';
      showErrorToast(
          "Kindly rate your experience with at least 1 star.", context);
    } else if (ratingTextController.text.isEmpty) {
      showErrorToast("Please tell us about your experience.", context);
    } else {
      setProcessingStatus(true);
      BlocProvider.of<VoucherBloc>(context).add(
        VoucherRating(
          id: widget.voucherId.toString(),
          rating: finalRating,
          comment: ratingTextController.text.trim(),
        ),
      );
    }
  }
}
