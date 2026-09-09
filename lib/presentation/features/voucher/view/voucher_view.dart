import 'dart:async';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../../../../config/routes.dart';
import '../../../../config/storage.dart';

import '../../../../data/model/model.dart';
import '../../../widgets/independent/independent.dart';
import '../../authentication/authentication.dart';
import '../../rewards/reward.dart';
import '../voucher.dart';

class VoucherView extends StatefulWidget {
  final Function changeView;
  final int selectedTab;
  final String filterBy;
  final String filterValue;

  VoucherView({
    Key? key,
    required this.changeView,
    required this.selectedTab,
    required this.filterBy,
    required this.filterValue,
  }) : super(key: GlobalKey<_VoucherViewState>());

  @override
  State<VoucherView> createState() => _VoucherViewState();
}

class _VoucherViewState extends State<VoucherView>
    with SingleTickerProviderStateMixin {
  /* --------------------------------------------------------------------------- set variable */

  // final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<VoucherRewardsTabState> genarateWidgetKey =
      GlobalKey<VoucherRewardsTabState>();

  late TabController _tabController;
  late ScrollController _scrollController;
  String barcodeScanRes = '';
  late Timer durationLoading;
  bool isProcessing = false;
  String? categoryName;
  var formatter = DateFormat(appDateFormat);
  FilterData? filterData;
  bool isSelected = false;
  // int? selectedCategory;
  String updatedFilterBy = '', updatedFilterValue = '';
  bool tabChange = false;

  /* ------------------------------------------------------------------------ */

  MerchantCategory? merchantCategory;
  bool isRefresh = false;
  // late String filterState;
  FilterData? filterState;
  RewardState? updatedState;
  Color buttonColor = colorBlack;
  RewardState? updateEmptyReward;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  void onSelectionChange(String filterBy, String filterValue) {
    setState(() {
      updatedFilterBy = filterBy;
      updatedFilterValue = filterValue;
    });
  }

  /* --------------------------------------------------------------------------- initState - Called when this object is inserted into the tree */
  @override
  void initState() {
    super.initState();

    // tabLength = 4;

    _scrollController = ScrollController();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.selectedTab);

    categoryName = 'All';

    fToast = FToast();
    fToast.init(context);

    // _tabController.addListener(_listenToTabChanges);
    // selectedCategory = widget.filterIndex;

    updatedFilterBy = widget.filterBy;
    updatedFilterValue = widget.filterValue;
  }

  /* --------------------------------------------------------------------------- dispose - Called when this object is removed from the tree permanently. */
  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
    _tabController.dispose();
    // _tabController.removeListener(_listenToTabChanges);
  }

  /* --------------------------------------------------------------------------- Full body */
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    /* ------------------------------------------------------------------------- Scaffold */
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          AqualifeRoutes.home,
          (Route<dynamic> route) => false,
        );
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocConsumer<RewardBloc, RewardState>(
          listener: (context, state) {
            // if (state is FilterCategoryLoaded) {
            //   setState(() {
            //     filterState = state.filterData;
            //     print('FILTER DATA: $filterState');
            //   });
            // }

            // if (state is RewardListLoaded) {
            //   updatedState = state;
            // }

            // // if (state is RewardFilterListLoaded) {
            // //   updatedState = state;
            // // }

            // if (state is RewardEmpty) {
            //   // print('UPDATE HERE LISTENER: $state');
            //   updatedState = state;
            // }
          },
          builder: (context, state) {
            return AqualifeScaffold(
              scaffoldKey: _scaffoldKey,
              showAppbar: false,
              bottomMenuIndex: 3,
              isShow: true,
              canClick: false,
              /* ----------------------------------------------------------------------- Main body */
              body: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      // margin: EdgeInsets.only(top: 0, bottom: 0),
                      padding: EdgeInsets.fromLTRB(
                          marginHorizontal, 40, marginHorizontal, 10),
                      color: colorBackground,
                      child: Container(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Image(
                                      image: AssetImage(
                                          'assets/icons/aqua_words.png'),
                                      width: width * 0.37,
                                    ),
                                    Text(
                                      '  Rewards  ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: fontFamilySuez,
                                        color: mainColor,
                                        fontWeight: FontWeight.w400,
                                        // height: configApp == 'ifApp' ? null : 1.3,
                                      ),
                                      textScaler:
                                          TextScaler.linear(scaleFactor),
                                    ),
                                  ],
                                ),
                              ),
                              /* -------------------------------------------------- Scan Voucher section */
                              Container(
                                // width: width * 0.2,
                                color: colorTransparent,
                                child: Container(
                                  width: width * 0.13,
                                  height: width * 0.13,
                                  // margin: EdgeInsets.only(right: 5),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorTransparent,
                                    border: Border.all(
                                      color: colorGreyBox,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Storage().page = 'voucher';
                                      scanBarcodeNormal();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/icons/scanner.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.05,
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: marginHorizontal),
                      margin: EdgeInsets.fromLTRB(
                          marginHorizontal, 0, marginHorizontal, 20),
                      decoration: BoxDecoration(
                        color: colorBackground,
                        // border: Border(
                        //   top: BorderSide(color: colorTabBorderGrey),
                        //   bottom: BorderSide(color: colorTabBorderGrey),
                        // ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TabBar(
                              controller: _tabController,
                              unselectedLabelColor: colorDarkGray,
                              unselectedLabelStyle: TextStyle(
                                fontSize: 11,
                                fontFamily: fontFamilyInter,
                                fontWeight: FontWeight.w500,
                              ),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorWeight: 0,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: secondaryColor,
                              ),
                              labelColor: colorWhite,
                              labelPadding: EdgeInsets.symmetric(horizontal: 4),
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontFamily: fontFamilyInter,
                                fontWeight: FontWeight.w700,
                              ),
                              onTap: (value) {
                                FocusManager.instance.primaryFocus?.unfocus();

                                tabChange = true;
                                Storage().isTabChange = tabChange;
                              },
                              tabs: [
                                Tab(
                                  child: AnimatedBuilder(
                                    animation: _tabController,
                                    builder: (context, chiild) {
                                      return Container(
                                        width: width,
                                        height: height,
                                        decoration: BoxDecoration(
                                          color: _tabController.index == 0
                                              ? secondaryColor
                                              : colorWhite,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: _tabController.index == 0
                                                  ? secondaryColor
                                                  : colorWhiteLight,
                                              width: 1),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Deals',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Tab(
                                  child: AnimatedBuilder(
                                    animation: _tabController,
                                    builder: (context, chiild) {
                                      return Container(
                                        width: width,
                                        height: height,
                                        decoration: BoxDecoration(
                                          color: _tabController.index == 1
                                              ? secondaryColor
                                              : colorWhite,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: _tabController.index == 1
                                                  ? secondaryColor
                                                  : colorWhiteLight,
                                              width: 1),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'My Vouchers',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Tab(
                                  child: AnimatedBuilder(
                                    animation: _tabController,
                                    builder: (context, chiild) {
                                      return Container(
                                        width: width,
                                        height: height,
                                        decoration: BoxDecoration(
                                          color: _tabController.index == 2
                                              ? secondaryColor
                                              : colorWhite,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: _tabController.index == 2
                                                  ? secondaryColor
                                                  : colorWhiteLight,
                                              width: 1),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'History',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            child: Container(
                              // color: colorBabyBlue,
                              padding: EdgeInsets.all(8),
                              child: Image(
                                image: AssetImage(
                                  'assets/icons/outlet/search.png',
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AqualifeRoutes.searchResultsPage);
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: height * 0.72,
                          color: colorBackground,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              VoucherRewardsTab(
                                filterBy: updatedFilterBy,
                                filterValue: updatedFilterValue,
                                // isTabChanging: tabChange,
                              ),
                              MyVoucherTab(),
                              MyVoucherPastTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /* --------------------------------------------------------------------------- Scan barcode function */
  Future<void> scanBarcodeNormal() async {
    /* Navigate to scan view page */
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              AppBarcodeScannerWidget.defaultStyle(),
        ));
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

/* ----------------------------------------------------------------------------- MyTabs class */
class MyTabs {
  final String title;
  MyTabs({
    required this.title,
  });
}

/* ----------------------------------------------------------------------------- SliverAppbarDelegate class */
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
