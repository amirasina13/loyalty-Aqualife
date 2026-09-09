import '../../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../config/routes.dart';
import '../../../../../data/model/model.dart';
import '../../../../../locator.dart';
import '../../../../widgets/extensions/voucher_list_view.dart';
import '../../../../widgets/independent/independent.dart';
import '../../../authentication/authentication.dart';
import '../../../maintenance/maintenance.dart';
import '../../../profile/profile.dart';
import '../../../rewards/reward.dart';
import '../../voucher.dart';

class MyVoucherTab extends StatefulWidget {
  const MyVoucherTab({super.key});

  @override
  State<MyVoucherTab> createState() => _MyVoucherTabState();
}

class _MyVoucherTabState extends State<MyVoucherTab>
    with TickerProviderStateMixin {
  FilterData? filterData;
  late TabController _myVoucherTabController;
  List<Voucher> allMyVouchers = <Voucher>[];

  /* --------------------------------------------------------------------------- initState - Called when this object is inserted into the tree */
  @override
  void initState() {
    super.initState();
    _myVoucherTabController = TabController(length: 0, vsync: this);
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    super.dispose();

    _myVoucherTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return BlocProvider<RewardBloc>(
      create: (context) {
        return RewardBloc(context: context, rewardRepository: sl())
          ..add(FilterCategoryLoad());
      },
      child: BlocConsumer<RewardBloc, RewardState>(
        listener: (context, state) {
          if (state is RewardError) {
            showErrorToast(state.error, context);
          }
          if (state is RewardSessionError) {
            sessionExpiredLogOut(state.error);
          }
          if (state is RewardNetworkError) {
            showErrorToast('No internet connection', context);
            Navigator.of(context).pushNamedAndRemoveUntil(
                AqualifeRoutes.home, (Route<dynamic> route) => false);
          }
          if (state is RewardMaintenanceError) {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => MaintenanceScreen(
                      parameters:
                          MaintenanceParameters(message: state.message))),
              ModalRoute.withName('/'),
            );
          }
        },
        builder: (context, state) {
          if (state is RewardInitial || state is RewardLoading) {
            return Column(
              children: [
                Container(
                  height: height * 0.04,
                ),
                Expanded(
                  child: LoadingWidget(),
                ),
              ],
            );
          }

          if (state is FilterCategoryLoaded) {
            filterData = state.filterData;

            _myVoucherTabController = TabController(
                length: filterData!.options!.length + 1, vsync: this);
          }

          return Container(
            child: DefaultTabController(
              length: filterData!.options!.length + 1,
              child: Column(
                children: [
                  Container(
                    // color: colorBabyBlue,
                    height: height * 0.04,
                    padding: EdgeInsets.only(
                        top: 3,
                        left: marginHorizontal,
                        right: marginHorizontal),
                    child: TabBar(
                      isScrollable: true,
                      controller: _myVoucherTabController,
                      unselectedLabelColor: colorDarkGray,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: fontFamilyInter,
                        fontWeight: FontWeight.w500,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: secondaryColor,
                      indicatorPadding: EdgeInsets.only(right: 10),
                      labelColor: mainColor,
                      labelPadding: EdgeInsets.only(right: 10),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        fontFamily: fontFamilyInter,
                        fontWeight: FontWeight.w700,
                      ),
                      onTap: (value) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      tabs: [
                        Tab(
                          child: Container(
                            child: Text(
                              'For You',
                              style: TextStyle(
                                color: colorBlack,
                              ),
                            ),
                          ),
                        ),
                        for (int i = 0; i < filterData!.options!.length; i++)
                          Container(
                            // color: colorBabyBlue,
                            // height: height * 0.03,
                            child: Text(
                              filterData!.options![i].name!,
                              style: TextStyle(
                                color: colorBlack,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(
                        controller: _myVoucherTabController,
                        children: [
                          BlocProvider<VoucherBloc>(
                            create: (context) {
                              return VoucherBloc(
                                  profileBloc:
                                      ProfileBloc(userRepository: sl()))
                                ..add(VoucherCategoriesLoad(
                                    filterBy: 'all', filterValue: 'all'));
                            },
                            child: BlocBuilder<VoucherBloc, VoucherState>(
                              builder: (context, state) {
                                // return _buildReward(context, 'all', 'all');
                                return _buildMyVoucher(context);
                                // return SingleChildScrollView(
                                //   child: Container(
                                //     child: _buildMyVouchersView(context, state),
                                //   ),
                                // );
                              },
                            ),
                          ),
                          for (int i = 0; i < filterData!.options!.length; i++)
                            BlocProvider<VoucherBloc>(
                              create: (context) {
                                return VoucherBloc(
                                    profileBloc:
                                        ProfileBloc(userRepository: sl()))
                                  ..add(VoucherCategoriesLoad(
                                      filterBy: 'category',
                                      filterValue:
                                          '${filterData!.options![i].id}'));
                              },
                              child: BlocBuilder<VoucherBloc, VoucherState>(
                                builder: (context, state) {
                                  // return _buildReward(context, 'category',
                                  //     '${filterData!.options![i].id}');

                                  return _buildMyVoucher(context);
                                  // return SingleChildScrollView(
                                  //   child: Container(
                                  //     child:
                                  //         _buildMyVouchersView(context, state),
                                  //   ),
                                  // );
                                },
                              ),
                            ),
                        ],
                      ),
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

  Widget _buildMyVoucher(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      child: BlocConsumer<VoucherBloc, VoucherState>(
        listener: (context, state) {
          // if (state is VoucherListStop) {
          //   showPaginationToast('No more transaction', context);
          // }
        },
        builder: (context, state) {
          if (state is VoucherLoading) {
            return SizedBox(
              child: LoadingWidget(),
            );
          }

          if (state is VoucherEmpty) {
            return Center(
              child: Container(
                color: colorBackground,
                height: height * 0.5,
                // margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: width * 0.18,
                      width: width * 0.18,
                      // margin: EdgeInsets.only(top: height / 4),
                      padding: EdgeInsets.symmetric(
                          vertical: height / 8, horizontal: width),
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/icons/no_deals.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    Text(
                      "No Deals Yet",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: colorNoVoucherGrey,
                      ),
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: Container(
                  child: _buildMyVouchersView(context, state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /* --------------------------------------------------------------------------- All Voucher ListView section */
  Widget _buildMyVouchersView(BuildContext context, VoucherState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (state is VoucherCategoriesLoaded) {
      allMyVouchers = state.vouchers.vouchers!;
    }
    /* the extension for gridview voucher */
    var allListTiles = allMyVouchers
        .map((allList) => allList.getVoucherListTile(
              context: context,
              onTap: () {
                Navigator.of(context).pushNamed(AqualifeRoutes.voucherDesc,
                    arguments: VoucherDescParameters(
                        voucherId: allList.voucherId!, title: allList.name!));
              },
            ))
        .toList(growable: false);

    /* My Voucher design */
    return allMyVouchers.isNotEmpty
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 30),
              // physics: NeverScrollableScrollPhysics(),
              itemCount: allMyVouchers.length,
              itemBuilder: (context, index) {
                return allListTiles[index];
              },
            ),
          )
        : Center(
            child: Container(
              color: colorBackground,
              height: height * 0.5,
              // margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: width * 0.18,
                    width: width * 0.18,
                    // margin: EdgeInsets.only(top: height / 4),
                    padding: EdgeInsets.symmetric(
                        vertical: height / 8, horizontal: width),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/icons/no_deals.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    "No Deals Yet",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: colorNoVoucherGrey,
                    ),
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(scaleFactor),
                  ),
                ],
              ),
            ),
          );
  }

  /* --------------------------------------------------------------------------- Session expired function */
  void sessionExpiredLogOut(String error) {
    /* Show error toast */
    showErrorToast('$error\nYou will be logged out.', context);

    /* Call Authentication logout bloc */
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());

    /* Navigate to login page directly */
    Navigator.of(context).pushNamedAndRemoveUntil(
        AqualifeRoutes.login, (Route<dynamic> route) => false);
  }
}
