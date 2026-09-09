import 'dart:convert';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../../data/model/model.dart';
import '../../../../locator.dart';
import '../../../widgets/independent/independent.dart';
import '../../outlet/outlet_details_screen.dart';
import '../../../widgets/extensions/reward_merchant_view.dart';
import '../../rewards/reward.dart';
import '../ordering.dart';

class OrderingOutletView extends StatefulWidget {
  final Function? changeView;
  final int brandsId;

  const OrderingOutletView(
      {super.key, this.changeView, required this.brandsId});

  @override
  State<OrderingOutletView> createState() => _OrderingOutletViewState();
}

class _OrderingOutletViewState extends State<OrderingOutletView>
    with TickerProviderStateMixin {
  bool isProcessing = false;
  bool isBookmark = false;
  String fullAddress = '';
  OutletInfo? outletInfo;
  List<OutletList> outlets = [];
  List<OutletList> outletDisplay = [];
  List<RewardMerchant> listVoucher = [];
  List<RewardMerchant> listVoucherDisplay = [];
  // List<dynamic> favoriteOutlet = [];
  List<OutletList> favOutlet = [];
  List<Map<String, dynamic>> newFavList = [];
  List<OutletFav> outletFav = [];
  TextEditingController editingController = TextEditingController();
  bool isClickFollow = false;

  late TabController _tabController;

  List<String> cityState = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Kuala Lumpur',
    'Labuan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Pulau Pinang',
    'Putrajaya',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
  ];

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);

    _tabController.addListener(() {
      setState(() {
        // _selectedIndex = _tabController.index;
        _tabController.index;
      });
    });

    _getList();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocConsumer<OrderingBloc, OrderingState>(
      listener: (context, state) {
        // If location is not enable, popup dialog
        if (state is OrderingLocationRequested) {
          YesNoDialog.showYesNoDialog(
            context,
            'Enable Location Service',
            Platform.isAndroid ? androidLocText : iosLocText,
            colorBlack,
            TextAlign.justify,
            _buildEnableButton(context),
          );
        }

        if (state is OutletsLoaded) {
          isClickFollow = false;
        }
      },
      builder: (context, state) {
        if (state is OrderingStarted) {
          BlocProvider.of<OrderingBloc>(context)
              .add(OutletLoad(brandId: widget.brandsId));
          // BlocProvider.of<OrderingBloc>(context).add(BrandsLoad());
        }

        if (state is OrderingInitial ||
            state is OrderingLoading ||
            state is OrderingStarted) {
          // return Container(
          return LoadingWidget();
        }

        if (state is OutletsLoaded) {
          outletInfo = state.outlets;
          isBookmark = outletInfo!.merchant!.isFavourite!;

          // Main body
          return SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              color: colorBackground,
              height: MediaQuery.of(context).size.height - // total height
                  kToolbarHeight - // top AppBar height
                  MediaQuery.of(context).padding.top,
              //  - // top padding
              // kBottomNavigationBarHeight, // BottomNavigationBar height
              margin: EdgeInsets.only(top: kToolbarHeight - 20),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                    child: Row(
                      children: [
                        Container(
                          width: width * 0.17,
                          height: width * 0.17,
                          margin: EdgeInsets.symmetric(
                              horizontal: marginHorizontal, vertical: 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorBackground,
                            boxShadow: const [
                              BoxShadow(
                                color: colorGreyBox,
                                blurRadius: 8.0,
                                offset: Offset(0.0, 2.0),
                              ),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(outletInfo!.merchant!.image!),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: Text(
                                      outletInfo!.merchant!.name!,
                                      style: TextStyle(
                                        // fontFamily: fontFamilyRoboto,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    height: height * 0.03,
                                    padding: EdgeInsets.only(left: 5),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/icons/outlet/verify_merchant.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          child: Container(
                            width: width * 0.23,
                            height: height * 0.05,
                            margin: EdgeInsets.only(right: marginHorizontal),
                            decoration: BoxDecoration(
                              color: isBookmark ? mainColor : secondaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: isBookmark
                                  ? Text(
                                      isClickFollow == false
                                          ? ' Following'
                                          : 'Loading...',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: colorWhite,
                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  : isClickFollow == false
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.add,
                                              size: 15,
                                              color: colorWhite,
                                            ),
                                            Text(
                                              ' Follow',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                                color: colorWhite,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )
                                      : Text(
                                          ' Loading...',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: colorWhite,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                            ),
                            // : Center(
                            //     child: Text(
                            //     'Loading...',
                            //     style: TextStyle(
                            //       fontSize: 11,
                            //       fontWeight: FontWeight.w400,
                            //       color: colorWhite,
                            //     ),
                            //     textAlign: TextAlign.center,
                            //   )),
                          ),
                          onTap: () {
                            setState(() {
                              isClickFollow = true;

                              Storage().page = 'merchant_bookmark';
                              BlocProvider.of<OrderingBloc>(context)
                                  .add(OutletAddRemoveFavouriteLoad(
                                merchantId:
                                    outletInfo!.merchant!.id!.toString(),
                              ));
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.8,
                          color: colorWhiteQrLight,
                        ),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: secondaryColor,
                      tabs: [
                        Tab(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage(
                                  'assets/icons/outlet/merchant_info.png'),
                              color:
                                  _tabController.index == 0 ? colorBlack : null,
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage(
                                  'assets/icons/outlet/merchant_outlet.png'),
                              color:
                                  _tabController.index == 1 ? colorBlack : null,
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage(
                                  'assets/icons/outlet/merchant_voucher.png'),
                              color:
                                  _tabController.index == 2 ? colorBlack : null,
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage(
                                  'assets/icons/outlet/merchant_gallery.png'),
                              color:
                                  _tabController.index == 3 ? colorBlack : null,
                            ),
                          ),
                        ),
                        // Tab(
                        //   child: Container(
                        //     padding: EdgeInsets.all(8),
                        //     child: Image(
                        //       image: AssetImage(
                        //           'assets/icons/outlet/merchant_review.png'),
                        //       color:
                        //           _tabController.index == 4 ? colorBlack : null,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        BlocBuilder<OrderingBloc, OrderingState>(
                          // listener: (context, state) {},
                          builder: (context, state) {
                            return SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context)
                                        .size
                                        .height - // total height
                                    kToolbarHeight - // top AppBar height
                                    kToolbarHeight -
                                    // MediaQuery.of(context)
                                    //     .padding
                                    //     .top - // top padding
                                    kBottomNavigationBarHeight -
                                    kBottomNavigationBarHeight,
                                margin: EdgeInsets.only(top: 10),
                                color: colorBackground,
                                child: _buildAboutUs(context, state),
                              ),
                            );
                          },
                        ),
                        BlocBuilder<OrderingBloc, OrderingState>(
                          // listener: (context, state) {},
                          builder: (context, state) {
                            return SingleChildScrollView(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                // height: height * 0.12,
                                color: colorBackground,
                                child: _buildOutletList(context, state),
                              ),
                            );
                          },
                        ),
                        BlocProvider<RewardBloc>(
                          create: (context) {
                            return RewardBloc(
                                context: context, rewardRepository: sl())
                              ..add(RewardMerchantLoad(
                                  merchantId: widget.brandsId));
                          },
                          child: BlocConsumer<RewardBloc, RewardState>(
                            listener: (context, state) {},
                            builder: (context, state) {
                              return SingleChildScrollView(
                                child: Container(
                                  color: colorBackground,
                                  margin: EdgeInsets.only(top: 10),
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: marginHorizontal,
                                  //     vertical: 10),
                                  child: _buildVoucherListView(context, state),
                                ),
                              );
                            },
                          ),
                        ),
                        BlocBuilder<OrderingBloc, OrderingState>(
                          // listener: (context, state) {},
                          builder: (context, state) {
                            return SingleChildScrollView(
                              child: Container(
                                height: MediaQuery.of(context)
                                        .size
                                        .height - // total height
                                    kToolbarHeight - // top AppBar height
                                    kToolbarHeight -
                                    // MediaQuery.of(context)
                                    //     .padding
                                    //     .top - // top padding
                                    kBottomNavigationBarHeight -
                                    kBottomNavigationBarHeight,
                                margin: EdgeInsets.only(top: 10),
                                color: colorBackground,
                                child: _buildGallery(context, state),
                              ),
                            );
                          },
                        ),
                        // BlocBuilder<OrderingBloc, OrderingState>(
                        //   // listener: (context, state) {},
                        //   builder: (context, state) {
                        //     return SingleChildScrollView(
                        //       child: Container(
                        //         height: MediaQuery.of(context)
                        //                 .size
                        //                 .height - // total height
                        //             kToolbarHeight - // top AppBar height
                        //             kToolbarHeight -
                        //             // MediaQuery.of(context)
                        //             //     .padding
                        //             //     .top - // top padding
                        //             kBottomNavigationBarHeight -
                        //             kBottomNavigationBarHeight,
                        //         margin: EdgeInsets.only(top: 10),
                        //         color: colorBackground,
                        //         child: _buildReview(context, state),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ),
            // ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildAboutUs(BuildContext context, OrderingState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    double itemSpacing = width * 0.08;

    if (state is OutletsLoaded) {
      outletInfo = state.outlets;
    }

    return Container(
      margin: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                EdgeInsets.fromLTRB(marginHorizontal, 10, marginHorizontal, 10),
            child: Text(
              outletInfo!.merchant!.name!,
              style: TextStyle(
                fontFamily: fontFamilyInter,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding:
                EdgeInsets.fromLTRB(marginHorizontal, 20, marginHorizontal, 20),
            child: HtmlWidget(
              outletInfo!.merchant!.merchantDesc!,
            ),
          ),
          outletInfo!.merchant!.socials!.isNotEmpty
              ? Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        marginHorizontal, 20, marginHorizontal, 20),
                    // color: colorBabyBlue,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: outletInfo!.merchant!.socials!
                          .map(
                            (item) => InkWell(
                              child: Container(
                                // height: height * 0.05,
                                // width: height * 0.05,
                                height: height * 0.055,
                                width: height * 0.055,
                                padding: EdgeInsets.all(
                                    item.type! == 'Website' ? 0 : 5),
                                margin: EdgeInsets.only(
                                    right:
                                        outletInfo!.merchant!.socials!.last ==
                                                item
                                            ? 0
                                            : itemSpacing),
                                // color: colorBabyBlue,
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                    item.type! == 'Website'
                                        ? 'assets/icons/social/m_website.png'
                                        : item.type! == 'Instagram'
                                            ? 'assets/icons/social/m_insta.png'
                                            : item.type! == 'Facebook'
                                                ? 'assets/icons/social/m_facebook.png'
                                                : item.type! == 'TikTok'
                                                    ? 'assets/icons/social/m_tiktok.png'
                                                    : 'assets/icons/social/m_xhs.png',
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (!await launchUrl(
                                  Uri.parse(
                                    item.url!,
                                  ),
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  throw 'Could not launch this link';
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      // ),
    );
  }

  Widget _buildOutletList(BuildContext context, OrderingState state) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        // height: height * 0.62,
        color: colorTransparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                  marginHorizontal, 10, marginHorizontal, 10),
              child: Text(
                'Outlets',
                style: TextStyle(
                  fontFamily: fontFamilyInter,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildOutletListView(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildOutletListView(BuildContext context, OrderingState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List<String> newState = [];
    List<String> combineList = [];
    // Create a Map to group filtered items
    Map<String, List<OutletList>> groupedList = {};
    // Create a new list to store the grouped items
    List<GroupedItem> newOutletList = [];

    if (state is OutletsLoaded) {
      outlets = state.outlets.outlets!;
      // _loadList();
    }

    // var outletsAllTiles = outlets
    //     .map((outlet) => outlet.getListOutletTile(
    //         context: context,
    //         onTap: () {
    //           Storage().distance = outlet.distance;
    //           Navigator.of(context)
    //               .pushNamed(AqualifeRoutes.outletDetails,
    //                   arguments: OutletDetailsParameters(
    //                       outletId: outlet.id!, outlet: outlet.place!))
    //               .then((value) {});
    //         }))
    //     .toList(growable: false);

    // var searchOutletTiles = outletDisplay
    //     .map((outlet) => outlet.getListOutletTile(
    //         context: context,
    //         onTap: () {
    //           Storage().distance = outlet.distance;
    //           Navigator.of(context)
    //               .pushNamed(AqualifeRoutes.outletDetails,
    //                   arguments: OutletDetailsParameters(
    //                       outletId: outlet.id!, outlet: outlet.place!))
    //               .then((value) {});
    //         }))
    //     .toList(growable: false);

    for (int a = 0; a < outlets.length; a++) {
      for (int i = 0; i < cityState.length; i++) {
        var gotit = outlets[a].address!.contains(cityState[i]);
        if (gotit == true) {
          newState.add(cityState[i]);
          Set<String> uniqueSet = newState.toSet();

          combineList = uniqueSet.toList();
        }
      }
    }

    // Iterate over listA, filter based on listB, and group
    for (var item in outlets) {
      for (var keyword in combineList) {
        if (item.address!.toLowerCase().contains(keyword.toLowerCase())) {
          groupedList.putIfAbsent(keyword, () => []).add(item);
        }
      }
    }

    // Iterate over the groupedList Map and add GroupedItem objects to the new list
    groupedList.forEach((keyword, outlet) {
      newOutletList.add(GroupedItem(keyword, outlet));
    });

    // return Container(
    //   padding: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 30),
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     physics: NeverScrollableScrollPhysics(),
    //     itemCount: combineList.length,
    //     itemBuilder: (context, index) {
    //       return Column(
    //         children: [
    //           Container(
    //             height: height * 0.03,
    //             color: colorBabyBlue,
    //             alignment: Alignment.centerLeft,
    //             padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
    //             margin: EdgeInsets.only(bottom: 5),
    //             child: Text(
    //               combineList[index],
    //               style: TextStyle(
    //                 fontSize: 8,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //             ),
    //           ),

    //         ],
    //       );
    //     },
    //   ),
    // );

    return outlets.isEmpty
        ? Center(
            child: Container(
              color: colorBackground,
              height: height * 0.5,
              // margin: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: width * 0.2,
                    width: width * 0.2,
                    // margin: EdgeInsets.only(top: height / 4),
                    padding: EdgeInsets.symmetric(
                        vertical: height / 8, horizontal: width),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                            'assets/icons/outlet/no_merchant_outlet.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Text(
                    "No Outlet Yet",
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
          )
        : Container(
            // height: height * 0.8,
            padding: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 30),

            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: newOutletList.length,
              itemBuilder: (context, index) {
                final group = newOutletList[index];
                return Container(
                  // height: height * 0.2,
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.03,
                        color: colorWhiteQrLight,
                        alignment: Alignment.centerLeft,
                        padding:
                            EdgeInsets.symmetric(horizontal: marginHorizontal),
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          group.cityState,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: group.outletList
                              .map(
                                (outlet) => Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Storage().distance = outlet.distance;
                                        Navigator.of(context)
                                            .pushNamed(
                                                AqualifeRoutes.outletDetails,
                                                arguments:
                                                    OutletDetailsParameters(
                                                        outletId: outlet.id!,
                                                        outlet: outlet.place!))
                                            .then((value) {});
                                      },
                                      child: Container(
                                        padding: Platform.isIOS
                                            ? EdgeInsets.symmetric(
                                                vertical: 16,
                                                horizontal: marginHorizontal)
                                            : EdgeInsets.symmetric(
                                                vertical: 18,
                                                horizontal: marginHorizontal),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              // width: height * 0.025, //width * 0.09,
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              height: height * 0.02,
                                              color: colorTransparent,
                                              child: Image(
                                                image: AssetImage(
                                                    'assets/icons/outlet/outlet_black.png'),
                                                color: colorCountGrey,
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.7,
                                              color: colorBackground,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    // margin: EdgeInsets.only(bottom: 10, top: 10),
                                                    child: Text(
                                                      outlet.place!,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: colorBlackTab,
                                                        fontFamily:
                                                            fontFamilyInter,
                                                      ),
                                                      textScaler:
                                                          TextScaler.linear(
                                                              scaleFactor),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.only(top: 8),
                                                    child: Text(
                                                      outlet.address!,
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: colorTextGrey,
                                                        fontFamily:
                                                            fontFamilyInter,
                                                      ),
                                                      textScaler:
                                                          TextScaler.linear(
                                                              scaleFactor),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 6),
                                                          child:
                                                              outlet.isOpen ==
                                                                      true
                                                                  ? Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              3,
                                                                          horizontal:
                                                                              7),
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              colorLightGreen,
                                                                          borderRadius:
                                                                              BorderRadius.circular(3)),
                                                                      child:
                                                                          Text(
                                                                        'Open Now',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              9,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              fontFamilyMain,
                                                                          color:
                                                                              colorTextGreen,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              3,
                                                                          horizontal:
                                                                              7),
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              colorLightRed,
                                                                          borderRadius:
                                                                              BorderRadius.circular(3)),
                                                                      child:
                                                                          Text(
                                                                        'Closed',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              9,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              fontFamilyMain,
                                                                          color:
                                                                              colorTextRed,
                                                                        ),
                                                                      ),
                                                                    ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 6,
                                                                  left: 5),
                                                          child:
                                                              outlet.isOpen ==
                                                                      true
                                                                  ? Container(
                                                                      child:
                                                                          Text(
                                                                        outlet.end!.isEmpty
                                                                            ? ''
                                                                            : 'Closing at ${outlet.end}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              9,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              fontFamilyMain,
                                                                          color:
                                                                              colorDarkGray,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      child:
                                                                          Text(
                                                                        outlet.start!.isEmpty
                                                                            ? ''
                                                                            : 'Open at ${outlet.start}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              9,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              fontFamilyMain,
                                                                          color:
                                                                              colorDarkGray,
                                                                        ),
                                                                      ),
                                                                    ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                child: Container(
                                                  child: outletFav.any((e) =>
                                                          e.id == outlet.id)
                                                      ? Icon(
                                                          Icons.favorite,
                                                          size: 28,
                                                          color: colorRed,
                                                        )
                                                      : Icon(
                                                          Icons.favorite_border,
                                                          size: 28,
                                                          color: colorCountGrey,
                                                        ),
                                                  //   child: favoriteOutlet
                                                  //           .contains(outlet.id)
                                                  //       ? Icon(
                                                  //           Icons.favorite,
                                                  //           size: 28,
                                                  //           color: colorRed,
                                                  //         )
                                                  //       : Icon(
                                                  //           Icons.favorite_border,
                                                  //           size: 28,
                                                  //           color: colorCountGrey,
                                                  //         ),
                                                ),
                                                onTap: () {
                                                  if (outletFav.any((fav) =>
                                                      fav.id == outlet.id)) {
                                                    // print('ISCONTAIN: TRUE');

                                                    outletFav.removeWhere(
                                                        (outletFav) =>
                                                            outletFav.id ==
                                                            outlet.id);

                                                    String encodedFavList =
                                                        jsonEncode(outletFav);

                                                    setState(() {
                                                      _saveList(encodedFavList);
                                                    });
                                                  } else {
                                                    // print('ISCONTAIN: FALSE');

                                                    outletFav.add(OutletFav(
                                                      id: outlet.id!,
                                                      merchantName:
                                                          outlet.merchantName!,
                                                      image: outlet.image!,
                                                      place: outlet.place!,
                                                      distance:
                                                          outlet.distance!,
                                                    ));

                                                    String encodedFavList =
                                                        jsonEncode(outletFav);

                                                    setState(() {
                                                      _saveList(encodedFavList);
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    group.outletList.last == outlet
                                        ? Container()
                                        : Divider(
                                            thickness: 1,
                                            color: colorLightGray,
                                          )
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  Widget _buildVoucherListView(BuildContext context, RewardState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    dynamic voucherTiles;

    if (state is RewardMerchantLoaded) {
      listVoucher = state.rewards;
    }

    listVoucher = listVoucher
        .where((voucher) => voucher.purchaseMethod != 'redeemable')
        .toList();

    voucherTiles = listVoucher
        .map(
          (listVoucher) => listVoucher.getRewardMerchantTile(
            context: context,
            onTap: () {
              setProcessingStatus(true);

              Navigator.of(context)
                  .pushNamed(AqualifeRoutes.rewardDetails,
                      arguments: RewardDetailsParameters(
                        rewardId: listVoucher.id!,
                        title: Storage().brandName!,
                        indexPage: 3,
                      ))
                  .then((value) {
                setProcessingStatus(false);
              }).then(
                (value) {
                  if (!context.mounted) return;
                  BlocProvider.of<RewardBloc>(context).add(
                    RewardMerchantLoad(merchantId: widget.brandsId),
                  );
                },
              );
            },
            onFavouriteTap: () {
              setState(() {
                Storage().page = 'merchant_wishlist';
                Storage().merchantId = widget.brandsId;

                BlocProvider.of<RewardBloc>(context)
                    .add(RewardAddRemoveFavouriteLoad(
                  voucherId: listVoucher.id!.toString(),
                ));
              });
            },
          ),
        )
        .toList(growable: false);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                EdgeInsets.fromLTRB(marginHorizontal, 10, marginHorizontal, 10),
            child: Text(
              'Deals',
              style: TextStyle(
                fontFamily: fontFamilyInter,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          state is RewardEmpty || listVoucher.isEmpty
              ? Center(
                  child: Container(
                    color: colorBackground,
                    height: height * 0.5,
                    // margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: width * 0.2,
                          width: width * 0.2,
                          // margin: EdgeInsets.only(top: height / 4),
                          padding: EdgeInsets.symmetric(
                              vertical: height / 8, horizontal: width),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(
                                  'assets/icons/outlet/no_merchant_voucher.png'),
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
                )
              : Container(
                  margin: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 30),
                  padding: EdgeInsets.fromLTRB(
                      marginHorizontal, 10, marginHorizontal, 0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: listVoucher.length,
                    itemBuilder: (context, index) {
                      return voucherTiles[index];
                    },
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildGallery(BuildContext context, OrderingState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // double itemSpacing = width * 0.085;
    // List<String> images = <String>[
    //   'https://photo.tuchong.com/14649482/f/601672690.jpg',
    //   'https://photo.tuchong.com/17325605/f/641585173.jpg',
    //   'https://photo.tuchong.com/3541468/f/256561232.jpg',
    //   'https://photo.tuchong.com/16709139/f/278778447.jpg',
    //   'This is an video',
    //   'https://photo.tuchong.com/5040418/f/43305517.jpg',
    //   'https://photo.tuchong.com/3019649/f/302699092.jpg'
    // ];

    if (state is OutletsLoaded) {
      outletInfo = state.outlets;
    }

    return Container(
      // margin: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                EdgeInsets.fromLTRB(marginHorizontal, 10, marginHorizontal, 10),
            child: Text(
              'Menu / Gallery',
              style: TextStyle(
                fontFamily: fontFamilyInter,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          outletInfo!.merchant!.menus!.isNotEmpty
              ? Expanded(
                  child: Container(
                    // height: height,
                    // color: colorBabyBlue,
                    margin: EdgeInsets.fromLTRB(
                        marginHorizontal, 20, marginHorizontal, 20),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // number of items in each row
                        mainAxisSpacing: 10.0, // spacing between rows
                        crossAxisSpacing: 10.0, // spacing between columns
                        // childAspectRatio: 0.6,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final String url = outletInfo!.merchant!.menus![index];
                        return GestureDetector(
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Hero(
                              tag: url,
                              child: url == 'This is an video'
                                  ? Container(
                                      alignment: Alignment.center,
                                      child: const Text('This is an video'),
                                    )
                                  : ExtendedImage.network(
                                      url,
                                      fit: BoxFit.cover,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SimplePicsWiper(
                                  url: url,
                                  images: outletInfo!.merchant!.menus!,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      itemCount: outletInfo!.merchant!.menus!.length,
                    ),
                    // child: ListView.builder(
                    //   padding: EdgeInsets.zero,
                    //   itemCount: outletInfo!.merchant!.menus!.length,
                    //   scrollDirection: Axis.horizontal,
                    //   itemBuilder: (context, index) {
                    //     return GestureDetector(
                    //       child: Container(
                    //         // height: width * 0.27,
                    //         // width: width * 0.28,
                    //         color: colorBackground,
                    //         child: AspectRatio(
                    //           aspectRatio: 1 / 1,
                    //           // child: InkWell(
                    //           child: Stack(
                    //             children: [
                    //               Container(
                    //                 margin: EdgeInsets.only(right: 7),
                    //                 decoration: BoxDecoration(
                    //                   border: Border.all(
                    //                     color: colorGreyBox,
                    //                   ),
                    //                   borderRadius: BorderRadius.circular(10),
                    //                   image: DecorationImage(
                    //                     image: NetworkImage(
                    //                       // 'https://staging-loyalty.chup-la.com/storages/imgs/2024/03/150425_4_000_1.png'
                    //                       outletInfo!.merchant!.menus![index],
                    //                     ),
                    //                     fit: BoxFit.cover,
                    //                   ),
                    //                 ),
                    //               ),
                    //               // merchants[index].isMuslim == true
                    //               //     ? Positioned(
                    //               //         right: 15,
                    //               //         top: 5,
                    //               //         child: HalalWidget(
                    //               //             muslimCategory: merchants[index]
                    //               //                 .muslimCategory!,
                    //               //             width: width * 0.08))
                    //               //     : SizedBox(),
                    //             ],
                    //             // child:
                    //           ),
                    //           // ),
                    //         ),
                    //       ),
                    //       onTap: () => showDialog(
                    //         context: context,
                    //         useSafeArea: false,
                    //         builder: (context) {
                    //           return AlertDialog(
                    //             contentPadding: EdgeInsets.all(20.0),
                    //             insetPadding: EdgeInsets.zero,
                    //             backgroundColor: colorBackground,
                    //             content: GestureDetector(
                    //               onDoubleTapDown: (d) => _doubleTapDetails = d,
                    //               onDoubleTap: _handleDoubleTap,
                    //               child: Stack(
                    //                 alignment: Alignment.bottomCenter,
                    //                 children: [
                    //                   Center(
                    //                     child: InteractiveViewer(
                    //                       transformationController:
                    //                           _transformationController,
                    //                       panEnabled: false,
                    //                       child: Container(
                    //                         height: height * 0.9,
                    //                         color: colorBackground,
                    //                         child: CachedNetworkImage(
                    //                           imageUrl: outletInfo!
                    //                               .merchant!.menus![index],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   Positioned(
                    //                     top: height * 0.03,
                    //                     right: 0,
                    //                     // bottom: -46,
                    //                     child: InkWell(
                    //                       child: Container(
                    //                         padding: EdgeInsets.zero,
                    //                         child: Icon(
                    //                           Icons.close_rounded,
                    //                           color: colorBlack,
                    //                           size: 30,
                    //                         ),
                    //                       ),
                    //                       onTap: () {
                    //                         Navigator.pop(context);
                    //                       },
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //               // onTap: () {
                    //               //   Navigator.pop(context);
                    //               // },
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     );
                    //   },
                    // ),
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
                          height: width * 0.2,
                          width: width * 0.2,
                          // margin: EdgeInsets.only(top: height / 4),
                          padding: EdgeInsets.symmetric(
                              vertical: height / 8, horizontal: width),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(
                                  'assets/icons/outlet/no_merchant_gallery.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Text(
                          "No Gallery Yet",
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
                ),
        ],
      ),
    );
  }

  // Widget _buildReview(BuildContext context, OrderingState state) {
  //   // var height = MediaQuery.of(context).size.height;
  //   // var width = MediaQuery.of(context).size.width;
  //   // double itemSpacing = width * 0.085;

  //   if (state is OutletsLoaded) {
  //     outletInfo = state.outlets;
  //   }

  //   return Container(
  //     margin: EdgeInsets.only(bottom: Platform.isIOS ? 80 : 50),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           padding:
  //               EdgeInsets.fromLTRB(marginHorizontal, 10, marginHorizontal, 10),
  //           child: Text(
  //             'Customer Reviews',
  //             style: TextStyle(
  //               fontFamily: fontFamilyInter,
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600,
  //             ),
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //         Container(
  //           padding:
  //               EdgeInsets.fromLTRB(marginHorizontal, 20, marginHorizontal, 20),
  //           child: HtmlWidget(
  //             outletInfo!.merchant!.merchantDesc!,
  //           ),
  //         ),
  //         // outletInfo!.merchant!.socials!.isNotEmpty
  //         //     ? Expanded(
  //         //         child: Container(
  //         //           padding: EdgeInsets.fromLTRB(
  //         //               marginHorizontal, 20, marginHorizontal, 20),
  //         //           // color: colorBabyBlue,
  //         //           child: Row(
  //         //             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //             crossAxisAlignment: CrossAxisAlignment.start,
  //         //             children: outletInfo!.merchant!.socials!
  //         //                 .map(
  //         //                   (item) => InkWell(
  //         //                     child: Container(
  //         //                       // height: height * 0.05,
  //         //                       // width: height * 0.05,
  //         //                       height: height * 0.055,
  //         //                       width: height * 0.055,
  //         //                       padding: EdgeInsets.all(
  //         //                           item.type! == 'Website' ? 0 : 5),
  //         //                       margin: EdgeInsets.only(
  //         //                           right:
  //         //                               outletInfo!.merchant!.socials!.last ==
  //         //                                       item
  //         //                                   ? 0
  //         //                                   : itemSpacing),
  //         //                       // color: colorBabyBlue,
  //         //                       alignment: Alignment.center,
  //         //                       child: Image(
  //         //                         image: AssetImage(
  //         //                           item.type! == 'Website'
  //         //                               ? 'assets/icons/social/m_website.png'
  //         //                               : item.type! == 'Instagram'
  //         //                                   ? 'assets/icons/social/m_insta.png'
  //         //                                   : item.type! == 'Facebook'
  //         //                                       ? 'assets/icons/social/m_facebook.png'
  //         //                                       : item.type! == 'TikTok'
  //         //                                           ? 'assets/icons/social/m_tiktok.png'
  //         //                                           : 'assets/icons/social/m_xhs.png',
  //         //                         ),
  //         //                       ),
  //         //                     ),
  //         //                     onTap: () async {
  //         //                       if (!await launchUrl(
  //         //                         Uri.parse(
  //         //                           item.url!,
  //         //                         ),
  //         //                         mode: LaunchMode.externalApplication,
  //         //                       )) {
  //         //                         throw 'Could not launch this link';
  //         //                       }
  //         //                     },
  //         //                   ),
  //         //                 )
  //         //                 .toList(),
  //         //           ),
  //         //         ),
  //         //       )
  //         //     : Container(),
  //       ],
  //     ),
  //     // ),
  //   );
  // }

  // This function is called whenever the text field changes
  searchFilter(String text) {
    text = text.toLowerCase();

    if (_tabController.index == 0) {
      setState(() {
        outletDisplay = outlets.where((outlet) {
          var outletPlace = outlet.place!.toLowerCase();
          var outletAddress = outlet.address!.toLowerCase();
          return outletPlace.contains(text) || outletAddress.contains(text);
        }).toList();
      });
      // if (text.isNotEmpty) {
      //   nearbyOutletDisplay = nearbyOutletList.where((brands) {
      //     var outletPlace = brands.merchantName!.toLowerCase();
      //     return outletPlace.contains(text);
      //   }).toList();

      //   setState(() {
      //     nearbyOutletDisplay;

      //     // print('NEARBY? : $isNearbyFetching ');

      //     // loading = false;
      //   });
      // } else {
      //   setState(() {
      //     nearbyOutletDisplay = [];
      //   });
      // }
    } else {
      setState(() {
        listVoucherDisplay = listVoucher.where((voucher) {
          var voucherName = voucher.name!.toLowerCase();
          return voucherName.contains(text);
        }).toList();
      });
      // }
    }
  }

  // For enable buton in location dialog
  Widget _buildEnableButton(BuildContext context) {
    return AqualifeStyleButton(
      title: 'Continue',
      backgroundColor: mainColor,
      onPressed: () async {
        BlocProvider.of<OrderingBloc>(context).add(OrderingLocationEnable());
        Navigator.pop(context);
      },
    );
  }

  Future<void> _saveList(favList) async {
    await Storage().secureStorage.write(key: 'favList', value: favList);
  }

  Future<void> _getList() async {
    final String? favList = await Storage().secureStorage.read(key: 'favList');
    if (favList != null) {
      final List<dynamic> fav = jsonDecode(favList);

      // setState(() {
      outletFav = fav.map((item) {
        final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
        return OutletFav.fromJson(itemMap);
      }).toList();
      // });
    }
  }
}

class GroupedItem {
  final String cityState;
  final List<OutletList> outletList;

  GroupedItem(this.cityState, this.outletList);
}

class OutletFav {
  final int id;
  final String merchantName;
  final String image;
  final String place;
  final String distance;

  OutletFav({
    required this.id,
    required this.merchantName,
    required this.image,
    required this.place,
    required this.distance,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "merchantName": merchantName,
      "image": image,
      "place": place,
      "distance": distance,
    };
  }

  factory OutletFav.fromJson(Map<String, dynamic> json) => OutletFav(
        id: json['id'] as int,
        merchantName: json['merchantName'] as String,
        image: json['image'] as String,
        place: json['place'] as String,
        distance: json['distance'] as String,
      );
}
