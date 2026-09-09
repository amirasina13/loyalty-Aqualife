import '../../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../config/routes.dart';
import '../../../../../config/storage.dart';
import '../../../../../data/model/model.dart';
import '../../../../../locator.dart';
import '../../../../widgets/independent/independent.dart';
import '../../../../widgets/extensions/reward_list_view.dart';
import '../../../authentication/authentication.dart';
import '../../../maintenance/maintenance.dart';
import '../../../rewards/reward.dart';
import '../../../webview/webview_deeplink.dart';

class VoucherRewardsTab extends StatefulWidget {
  final String? filterBy;
  final String? filterValue;
  // final bool? isTabChanging;

  const VoucherRewardsTab({
    super.key,
    required this.filterBy,
    required this.filterValue,
    // required this.isTabChanging,
  });

  @override
  State<VoucherRewardsTab> createState() => VoucherRewardsTabState();
}

class VoucherRewardsTabState extends State<VoucherRewardsTab>
    with TickerProviderStateMixin {
  FilterData? filterData;
  String updatedFilterBy = '', updatedFilterValue = '';

  late TabController _voucherRewardTabController;
  List<VoucherReward> voucherReward = <VoucherReward>[];
  var rewardListTiles = [];

  /* --------------------------------------------------------------------------- initState - Called when this object is inserted into the tree */
  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    if (Storage().isTabChange == false) {
      updatedFilterBy = widget.filterBy!;
      updatedFilterValue = widget.filterValue!;
    } else {
      updatedFilterBy = 'all';
      updatedFilterValue = 'all';
    }
  }

  @override
  void dispose() {
    super.dispose();

    _voucherRewardTabController.dispose();
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

            _voucherRewardTabController = TabController(
                length: filterData!.options!.length + 1,
                vsync: this,
                initialIndex: updatedFilterBy == 'all'
                    ? 0
                    : int.parse(widget.filterValue!));
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
                      controller: _voucherRewardTabController,
                      unselectedLabelColor: colorDarkGray,
                      padding: EdgeInsets.zero,
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
                        controller: _voucherRewardTabController,
                        children: [
                          BlocProvider<RewardBloc>(
                            create: (context) {
                              voucherReward.clear();
                              updatedFilterBy = 'all';
                              updatedFilterValue = 'all';

                              return RewardBloc(
                                  context: context, rewardRepository: sl())
                                ..add(RewardListLoad(
                                    filterBy: updatedFilterBy,
                                    filterValue: updatedFilterValue));
                            },
                            child: BlocBuilder<RewardBloc, RewardState>(
                              builder: (context, state) {
                                return _buildReward(context, updatedFilterBy,
                                    updatedFilterValue);
                              },
                            ),
                          ),
                          for (int i = 0; i < filterData!.options!.length; i++)
                            BlocProvider<RewardBloc>(
                              create: (context) {
                                voucherReward.clear();
                                updatedFilterBy = 'category';
                                updatedFilterValue =
                                    filterData!.options![i].id.toString();

                                return RewardBloc(
                                    context: context, rewardRepository: sl())
                                  ..add(RewardListLoad(
                                      filterBy: updatedFilterBy,
                                      filterValue: updatedFilterValue));
                                //'${filterData!.options![i].id}'));
                              },
                              child: BlocBuilder<RewardBloc, RewardState>(
                                builder: (context, state) {
                                  return _buildReward(context, updatedFilterBy,
                                      updatedFilterValue);
                                  // '${filterData!.options![i].id}');
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

  Widget _buildReward(
      BuildContext context, String filterBy, String filterValue) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      child: BlocConsumer<RewardBloc, RewardState>(
        listener: (context, state) {
          fToast = FToast();
          fToast.init(context);
          if (state is RewardListStop) {
            showPaginationToast('No more transaction', context);
          }
        },
        builder: (context, state) {
          if (state is RewardLoading) {
            return SizedBox(
              child: LoadingWidget(),
            );
          }

          if (state is RewardListLoaded) {
            // first check if api returns any historical records,
            if (state.voucherRewards.vouchers != null &&
                state.voucherRewards.vouchers!.isNotEmpty) {
              // if history.records is neither null or empty
              // append to the global records variable (List<CreditRecords>)
              voucherReward.addAll(state.voucherRewards.vouchers!);
              BlocProvider.of<RewardBloc>(context).isRewardFetching = false;
              // BlocProvider.of<RewardBloc>(context).isRewardFirstShow = false;
            }

            // comment: instead of working with the records from api,
            // records.add(state.history.records);
            // comment: work with the global variable that has the records from API added above
            rewardListTiles = voucherReward;
            BlocProvider.of<RewardBloc>(context).isRewardFetching = false;
          }

          if (state is RewardEmpty) {
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
                  child: _buildRewardListView(
                      context, state, filterBy, filterValue),
                ),
              ),
              state is RewardNextLoading
                  ? SizedBox(
                      child: LoadingWidget(),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  /* -------------------------------------------0-------------------------------- All Voucher ListView section */
  Widget _buildRewardListView(BuildContext context, RewardState state,
      String filterBy, String filterValue) {
    /* IF API call success and not empty, set List variable */
    if (state is RewardListLoaded) {
      voucherReward = state.voucherRewards.vouchers!
          .where((voucher) => voucher.purchaseMethod != 'redeemable')
          .toList();
    }

    /* the extension for gridview voucher */
    rewardListTiles = voucherReward
        .map((allList) => allList.getRewardListTile(
            context: context,
            onTap: () {
              TempData.voucherRefCode = '';
              Navigator.of(context)
                  .pushNamed(AqualifeRoutes.rewardDetails,
                      arguments: RewardDetailsParameters(
                        rewardId: allList.id!,
                        title: allList.name!,
                        indexPage: 3,
                      ))
                  .then((value) {
                if (!context.mounted) return;
                BlocProvider.of<RewardBloc>(context)
                  ..rewardPage = 0
                  ..add(
                    RewardListLoad(
                        filterBy: filterBy, filterValue: filterValue),
                  );
              });
            },
            onFavouriteTap: () {
              setState(() {
                Storage().page = 'reward_wishlist';
                BlocProvider.of<RewardBloc>(context)
                    .add(RewardAddRemoveFavouriteLoad(
                  voucherId: allList.id!.toString(),
                ));
              });
            }))
        .toList(growable: false);

    ScrollController scrollControllerReward = ScrollController();
    scrollControllerReward.addListener(() async {
      if (scrollControllerReward.position.maxScrollExtent ==
          scrollControllerReward.position.pixels) {
        if (!BlocProvider.of<RewardBloc>(context).isRewardFetching) {
          BlocProvider.of<RewardBloc>(context)
            ..isRewardFetching = true
            ..add(
              RewardListLoad(filterBy: filterBy, filterValue: filterValue),
            );
        }
      }
    });

    /* Reward design */
    return Container(
      margin: EdgeInsets.fromLTRB(marginHorizontal, 10, marginHorizontal, 0),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.only(bottom: 30),
        controller: scrollControllerReward,
        itemCount: voucherReward.length,
        itemBuilder: (context, index) {
          return rewardListTiles[index];
        },
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
