// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/config.dart';
import '../../../../config/global_setup.dart';
import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance.dart';
import '../../profile/profile.dart';
import '../../security_pin/security_pin.dart';
import '../../settings/setting.dart';
import '../../voucher/voucher.dart';
import '../wallet.dart';

class WalletView extends StatefulWidget {
  final Function changeView;

  const WalletView({super.key, required this.changeView});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  String passcodePin = '';
  bool isProcessing = false;
  bool? clickPasscode = false;
  int? totalMyVoucher = 0;
  var profileData, height, width;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          AqualifeRoutes.home,
          (Route<dynamic> route) => false,
        );
      },
      child: AqualifeScaffold(
        bottomMenuIndex: 2,
        isShow: true,
        showAppbar: false,
        extendBodyBehindAppBar: true,
        canClick: false,
        isCenterTitle: false,
        body: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is WalletLoaded) {
              profileData = state.userQrcode;

              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _topBody(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: Column(
                            children: [
                              _creditPointsBalanceBody(),
                              _topupBody(),
                              _settingBody(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return LoadingWidget();
          },
        ),
      ),
    );
  }

  Widget _topBody() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(top: height * 0.08),
      child: AspectRatio(
        aspectRatio: 2 / 1,
        child: Container(
          width: width,
          // height: height * 0.45,
          margin: EdgeInsets.symmetric(horizontal: marginHorizontal - 2),
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/image/aqua_card.png')),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            // color: Colors.redAccent,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  children: [
                    Container(
                      width: width * 0.2,
                      padding: EdgeInsets.only(bottom: 2),
                      child: AspectRatio(
                        aspectRatio: 2 / 2,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorTransparent,
                            border: Border.all(
                              color: colorWhite,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: CachedImage(
                              imageUrl: profileData.profile.image!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 3),
                      child: Text(
                        profileData!.profile!.name!,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: width * 0.035,
                top: width * 0.385,
                left: 20,
                child: Container(
                  margin: EdgeInsets.only(bottom: 3),
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    profileData!.profile!.code!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // height: height * 0.4,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10),
          // ),
          // padding: EdgeInsets.symmetric(horizontal: marginHorizontal - 2),
          // child: Card(
          //   color: colorBabyBlue,
          //   child: Image(
          //     image: AssetImage('assets/image/aqua_card.png'),
          //   ),
          // ),
          // child: AspectRatio(
          //   aspectRatio: 2 / 1,
          //   child: Container(
          //     //
          //     // decoration: BoxDecoration(
          //     //   image: DecorationImage(
          //     //     image: AssetImage('assets/image/aqua_card.png'),
          //     //     fit: BoxFit.contain,
          //     //   ),
          //     //   borderRadius: BorderRadius.circular(10),
          //     // ),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(10),
          //       child: Image(
          //         image: AssetImage('assets/image/aqua_card.png'),
          //       ),
          //     ),
          //   ),

          //   // child: Container(
          //   // height: height * 0.16,
          //   // decoration: BoxDecoration(
          //   //   image: DecorationImage(
          //   //     image: AssetImage('assets/image/aqua_card.png'),
          //   //     fit: BoxFit.cover,
          //   //   ),
          //   // ),
          //   // ),
          // ),
        ),
      ),
    );

    // return Container(
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(
    //       begin: Alignment.topCenter,
    //       end: Alignment.bottomCenter,
    //       colors: const [secondaryColor, colorWhite],
    //     ),
    //   ),
    //   child: Container(
    //     height: height * 0.16,
    //     margin: EdgeInsets.fromLTRB(marginHorizontal, 40, marginHorizontal, 10),
    //     child: Column(
    //       children: [
    //         Container(
    //           alignment: Alignment.centerRight,
    //           padding: EdgeInsets.symmetric(vertical: 7),
    //           child: InkWell(
    //             child: SizedBox(
    //               width: height * 0.04,
    //               height: height * 0.04,
    //               child: Image(
    //                 color: colorBlack,
    //                 image: AssetImage(
    //                   'assets/icons/bottom/settings.png',
    //                 ),
    //               ),
    //             ),
    //             onTap: () {
    //               Navigator.of(context).pushNamed(AqualifeRoutes.setting);
    //             },
    //           ),
    //         ),
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Container(
    //               width: width * 0.2,
    //               margin: EdgeInsets.only(right: 10),
    //               child: AspectRatio(
    //                 aspectRatio: 2 / 2,
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     color: colorTransparent,
    //                     border: Border.all(
    //                       color: colorWhite,
    //                       width: 2,
    //                     ),
    //                   ),
    //                   child: ClipOval(
    //                     child: CachedImage(
    //                       imageUrl: profileData.profile.image!,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Container(
    //                     margin: EdgeInsets.only(bottom: 3),
    //                     child: Text(
    //                       profileData!.profile!.name!,
    //                       style: TextStyle(
    //                         fontSize: 16,
    //                         color: colorBlack,
    //                         fontWeight: FontWeight.w700,
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                     margin: EdgeInsets.only(bottom: 3),
    //                     padding: EdgeInsets.only(top: 5, bottom: 5),
    //                     child: Text(
    //                       profileData!.profile!.code!,
    //                       style: TextStyle(
    //                         fontSize: 13,
    //                         fontWeight: FontWeight.w400,
    //                         color: colorBlack,
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _creditPointsBalanceBody() {
    return Container(
      height: height * 0.1,
      color: colorBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ------------------------------------------------------------------- My Voucher Sections
          BlocBuilder<VoucherBloc, VoucherState>(
            builder: (context, state) {
              if (state is VoucherCategoriesLoaded) {
                totalMyVoucher = state.vouchers.vouchers!.length;
              }
              return Expanded(
                child: InkWell(
                  onTap: () {
                    Storage().rewardReload = '';
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        AqualifeRoutes.voucher, (Route<dynamic> route) => false,
                        arguments: VoucherParameters(
                          selectedTab: 1,
                          filterBy: ' ',
                          filterValue: ' ',
                        ));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        totalMyVoucher.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'My Voucher',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: colorCountGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // ------------------------------------------------------------------- Credit Balance Sections
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AqualifeRoutes.history,
                    arguments: HistoryParameters(selectedTab: 0));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    profileData.profile!.credits!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    '$creditLabelTitle ($creditLabelText)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colorCountGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ------------------------------------------------------------------- Points Balance Sections
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AqualifeRoutes.history,
                    arguments: HistoryParameters(selectedTab: 1));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    profileData.profile!.points!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    pointLabelTitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colorCountGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topupBody() {
    return BlocConsumer<SecurityBloc, SecurityState>(
      listener: (context, securityState) {
        setProcessingStatus(false);

        if (securityState is SecurityCheckVerified) {
          if (securityState.verified == false) {
            Storage().page = 'wallet';

            Navigator.of(context)
                .pushNamed(AqualifeRoutes.securityCreate)
                .then((value) {
              setState(() {
                clickPasscode = false;
              });
            });
          } else {
            Storage().set = 'reset';
            Storage().page = 'wallet';

            Navigator.of(context)
                .pushNamed(AqualifeRoutes.securityChange)
                .then((value) {
              setState(() {
                clickPasscode = false;
              });
            });
          }
        }

        if (securityState is SecurityOtpSent) {
          showSuccessToast(securityState.data['message'], context);
          Navigator.of(context).pushNamed(AqualifeRoutes.securityOtp,
              arguments: SecurityOtpParameters(otpData: securityState.data));
        }

        if (securityState is SecurityError) {
          Navigator.pop(context);
          showErrorToast(securityState.error, context);
        }
        /* ----------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
        if (securityState is SecurityMaintenanceError) {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => MaintenanceScreen(
                    parameters:
                        MaintenanceParameters(message: securityState.message))),
            ModalRoute.withName('/'),
          );
        }
      },
      builder: (context, securityState) {
        return InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 20, horizontal: marginHorizontal),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: colorLightGray,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 2.0),
                ),
              ],
            ),
            child: AqualifeStyleButton(
              title: 'Top-up',
              onPressed: isProcessing ? () {} : _topupCredit,
              borderRadius: 10,
              backgroundColor: colorBackground,
              borderColor: colorLightGray,
              icon: Icons.add_circle_outline,
              iconSize: 25,
              iconColor: secondaryColor,
              textColor: mainColor,
            ),
          ),
        );
      },
    );
  }

  Widget _settingBody() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
      decoration: BoxDecoration(
        color: colorBackground,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: colorSoftGrey,
            blurRadius: 8.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            AqualifeMenuLine(
              title: 'My Account',
              icon: Image(
                image:
                    AssetImage('assets/icons/settings/account-circle-line.png'),
              ),
              onTap: (() {
                // Storage().page = 'card';
                Navigator.of(context).pushNamed(AqualifeRoutes.profile);
              }),
            ),
            SizedBox(height: height * 0.01),
            AqualifeMenuLine(
              title: 'Following Merchant',
              icon: Image(
                image: AssetImage('assets/icons/settings/fav-brand.png'),
              ),
              onTap: (() {
                Storage().page = '';
                Navigator.of(context).pushNamed(AqualifeRoutes.favMerchant);
              }),
            ),
            SizedBox(height: height * 0.01),
            AqualifeMenuLine(
              title: 'Favourite Deals',
              icon: Image(
                image: AssetImage('assets/icons/settings/fav-deal.png'),
              ),
              onTap: (() {
                Storage().page = '';
                Navigator.of(context).pushNamed(AqualifeRoutes.favDeal);
              }),
            ),
            SizedBox(height: height * 0.01),
            AqualifeMenuLine(
              title: 'Favourite Brands\' Outlets',
              icon: Image(
                image: AssetImage('assets/icons/settings/fav-deal.png'),
              ),
              onTap: (() {
                Storage().page = '';
                Navigator.of(context).pushNamed(AqualifeRoutes.favOutlet);
              }),
            ),
            SizedBox(height: height * 0.01),
            AqualifeMenuLine(
              title: 'Transaction History',
              icon: Image(
                image: AssetImage('assets/icons/settings/txn_icon.png'),
              ), //Icons.history,
              onTap: (() {
                Navigator.of(context)
                    .pushNamed(AqualifeRoutes.history,
                        arguments: HistoryParameters(selectedTab: 0))
                    .then((value) {
                  if (!mounted) return;
                  BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
                });
              }),
            ),
            SizedBox(height: height * 0.01),
            AqualifeMenuLine(
              title: 'Refer Friends',
              icon: Image(
                image: AssetImage('assets/icons/settings/hand-heart-line.png'),
              ),
              onTap: (() async {
                // var currentBrightness = await ScreenBrightness().current;
                // var newBrightness = 1 - currentBrightness;

                // BrightnessCheck()
                //     .setBrightness(currentBrightness + newBrightness);

                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamed(AqualifeRoutes.refer).then(
                  (value) {
                    // BrightnessCheck().resetBrightness();
                    if (!mounted) return;
                    BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
                  },
                );
              }),
            ),
            SizedBox(height: height * 0.01),
            BlocConsumer<SecurityBloc, SecurityState>(
              listener: (context, securityState) {
                fToast = FToast();
                fToast.init(context);

                if (securityState is SecurityCheckVerified) {
                  if (securityState.verified == false) {
                    Storage().page = 'wallet';
                    // Storage().email = email!;

                    // BlocProvider.of<SecurityBloc>(context)
                    //     .add(SecurityOtpSend());

                    Navigator.of(context)
                        .pushNamed(AqualifeRoutes.securityCreate)
                        .then((value) {
                      setState(() {
                        clickPasscode = false;
                      });
                    });
                  } else {
                    Storage().set = 'reset';
                    Storage().page = 'wallet';
                    Navigator.of(context)
                        .pushNamed(AqualifeRoutes.securityChange)
                        .then((value) {
                      setState(() {
                        clickPasscode = false;
                      });
                    });
                  }
                }
                if (securityState is SecurityOtpSent) {
                  showSuccessToast(securityState.data['message'], context);
                  Navigator.of(context)
                      .pushNamed(AqualifeRoutes.securityOtp,
                          arguments: SecurityOtpParameters(
                              otpData: securityState.data))
                      .then((value) {
                    setState(() {
                      clickPasscode = false;
                    });
                  });
                }
              },
              builder: (context, securityState) {
                return AqualifeMenuLine(
                  title: 'Passcode',
                  icon: Image(
                    image: AssetImage(
                        'assets/icons/settings/lock-password-line.png'),
                  ),
                  onTap: clickPasscode == false
                      ? (() {
                          setState(() {
                            clickPasscode = true;
                          });
                          // print('ALREADY CLICK !!!!!!');
                          BlocProvider.of<SecurityBloc>(context)
                              .add(SecurityStart());
                        })
                      : () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _topupCredit() {
    Navigator.of(context).pushNamed(AqualifeRoutes.creditOnline).then((value) {
      if (!mounted) return;
      BlocProvider.of<WalletBloc>(context).add(WalletLoad());
    });
  }
}
