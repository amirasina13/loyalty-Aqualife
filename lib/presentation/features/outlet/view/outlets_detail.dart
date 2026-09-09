import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../../config/routes.dart';
import '../../../../config/storage.dart';

import '../../../../data/model/model.dart';
import '../../../widgets/extensions/outlet_operation_view.dart';
import '../../../widgets/extensions/outlet_voucher_view.dart';
import '../../../widgets/independent/cache_network_image.dart';
import '../../ordering/ordering.dart';
import '../../rewards/reward.dart';
import '../../voucher/voucher.dart';
import '../outlet.dart';

class OutletDetailsView extends StatefulWidget {
  final Function? changeView;
  final int? outletId;

  const OutletDetailsView({super.key, this.changeView, this.outletId});

  @override
  State<OutletDetailsView> createState() => _OutletDetailsViewState();
}

class _OutletDetailsViewState extends State<OutletDetailsView>
    with TickerProviderStateMixin {
  bool isProcessing = false;
  List<Operation> operations = [];
  List<VoucherOutlet> outletVoucher = [];
  List<OutletFav> outletFav = [];
  // int _current = 0;
  late TabController _tabController;
  late ScrollController _scrollController;
  // final CarouselController _controller = CarouselController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    _tabController.addListener(() {
      setState(() {
        // _selectedIndex = _tabController.index;
        _tabController.index;
      });
    });
  }

  /* --------------------------------------------------------------------------- dispose - Called when this object is removed from the tree permanently. */
  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    BlocProvider.of<OutletBloc>(context)
        .add(OutletDetailsLoad(outletId: widget.outletId!));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colorBackground,
      body: Container(
        color: colorBackground,
        // margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
        child: BlocConsumer<OutletBloc, OutletState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is OutletDetailsLoaded) {
              var detail = state.details;
              var outletId = detail.id;
              var distance =
                  Storage().distance!.isNotEmpty ? Storage().distance : '0';
              var dist = double.parse(distance!);
              var operation = state.details.operations!.length;
              var availableVoucher = state.details.vouchers!.length;

              if (outletId != null) {
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshData,
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        /* ----------------------------------------------------------------- Tabbar section */
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: SliverAppBarDelegate(
                            minHeight: height * 0.06,
                            maxHeight: height * 0.06,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: colorBackground,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: colorGreyBox,
                                    ),
                                  )),
                              child: TabBar(
                                // isScrollable: true,
                                controller: _tabController,
                                unselectedLabelColor: Color(0xFF929292),
                                unselectedLabelStyle: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: fontFamilyInter,
                                  fontWeight: FontWeight.w600,
                                ),
                                labelColor: colorBlack,
                                labelStyle: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: fontFamilyInter,
                                  fontWeight: FontWeight.w600,
                                ),
                                indicatorColor: secondaryColor,
                                indicatorWeight: 5,
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 0.0),
                                tabs: [
                                  Tab(
                                    // text: 'My Vo/ucher',
                                    child: Container(
                                      alignment: Alignment.center,
                                      color: colorTransparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.05,
                                            margin: EdgeInsets.only(right: 3),
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/icons/outlet/about_tab.png'),
                                              color: _tabController.index == 0
                                                  ? colorBlack
                                                  : null,
                                            ),
                                          ),
                                          Text(
                                            'About',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    // text: 'Subscription Plan',
                                    child: Container(
                                      color: colorTransparent,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: width * 0.05,
                                            margin: EdgeInsets.only(right: 3),
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/icons/outlet/voucher_tab.png'),
                                              color: _tabController.index == 1
                                                  ? colorBlack
                                                  : null,
                                            ),
                                          ),
                                          Text(
                                            'Voucher',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    /* ------------------------------------------------------------------- Body Sliver */
                    body: Container(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              // height: height * 0.12,
                              color: colorBackground,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 25, top: 20),
                                        child: Container(
                                          // color: colorBabyBlue,
                                          margin: EdgeInsets.only(bottom: 5),
                                          height: width * 0.46,
                                          child: CachedImage(
                                            imageUrl: detail.image!,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -5,
                                        right: 10,
                                        child: Column(
                                          children: [
                                            InkWell(
                                              child: Container(
                                                height: height * 0.06,
                                                width: height * 0.06,
                                                padding: EdgeInsets.zero,
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  // color: secondaryColor,
                                                  // border: Border.all(
                                                  //     color: colorWhite,
                                                  //     width: 2),
                                                ),
                                                child: Container(
                                                  // margin: EdgeInsets.all(5),
                                                  child: Image(
                                                    image: AssetImage(
                                                        'assets/icons/location/map.png'),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                launchMapDirection(
                                                    detail, height, width);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Positioned(
                                      //   top: 27,
                                      //   right: 18,
                                      //   // bottom: -5,
                                      //   // right: 10,
                                      //   child: InkWell(
                                      //     child: Container(
                                      //       padding: EdgeInsets.all(6),
                                      //       decoration: BoxDecoration(
                                      //         color: colorBackground,
                                      //         shape: BoxShape.circle,
                                      //       ),
                                      //       child: outletFav.any(
                                      //               (e) => e.id == outletId)
                                      //           ? Icon(
                                      //               Icons.favorite,
                                      //               size: 28,
                                      //               color: colorRed,
                                      //             )
                                      //           : Icon(
                                      //               Icons.favorite_border,
                                      //               size: 28,
                                      //               color: colorCountGrey,
                                      //             ),
                                      //     ),
                                      //     onTap: () {
                                      //       if (outletFav.any(
                                      //           (fav) => fav.id == outletId)) {
                                      //         // print('ISCONTAIN: TRUE');

                                      //         outletFav.removeWhere(
                                      //             (outletFav) =>
                                      //                 outletFav.id == outletId);

                                      //         String encodedFavList =
                                      //             jsonEncode(outletFav);

                                      //         setState(() {
                                      //           _saveList(encodedFavList);
                                      //         });
                                      //       } else {
                                      //         // print('ISCONTAIN: FALSE');

                                      //         outletFav.add(OutletFav(
                                      //           id: outletId,
                                      //           merchantName:
                                      //               detail.merchantName!,
                                      //           image: detail.image!,
                                      //           place: detail.place!,
                                      //           distance: Storage().distance!,
                                      //         ));

                                      //         String encodedFavList =
                                      //             jsonEncode(outletFav);

                                      //         setState(() {
                                      //           _saveList(encodedFavList);
                                      //         });
                                      //       }
                                      //     },
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: marginHorizontal),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, bottom: 5),
                                                child: Text(
                                                  detail.merchantName!,
                                                  style: TextStyle(
                                                    color: colorBlack,
                                                    fontFamily: fontFamilyInter,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  textScaler: TextScaler.linear(
                                                      scaleFactor),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  detail.place!,
                                                  style: TextStyle(
                                                    color: colorBlack,
                                                    fontFamily: fontFamilyInter,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  // textAlign: TextAlign.center,
                                                  textScaler: TextScaler.linear(
                                                      scaleFactor),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        dist == 0
                                            ? SizedBox()
                                            : Container(
                                                child: Text(
                                                  '${dist.toStringAsFixed(2)} km',
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: colorTextGrey,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily:
                                                          fontFamilyInter),
                                                  textScaler: TextScaler.linear(
                                                      scaleFactor),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        marginHorizontal,
                                        20,
                                        marginHorizontal,
                                        20),
                                    child: HtmlWidget(
                                      detail.merchantDesc!,
                                      // textStyle: TextStyle(
                                      //   fontSize: 12,
                                      //   fontFamily: fontFamilyInter,
                                      //   // color: colorSoftGrey,
                                      //   fontWeight: FontWeight.w400,
                                      // ),
                                      // customWidgetBuilder: (element) {
                                      //   if (element.localName == 'span') {
                                      //     return Text(
                                      //       element.text,
                                      //       style: TextStyle(
                                      //         fontFamily: fontFamilyMain,
                                      //         fontSize: 14,
                                      //         color: colorSoftGrey,
                                      //       ),
                                      //     );
                                      //   }
                                      //   return null;
                                      // },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        marginHorizontal,
                                        20,
                                        marginHorizontal,
                                        10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: height * 0.02,
                                          margin: EdgeInsets.only(right: 20),
                                          color: colorTransparent,
                                          child: Image(
                                            image: AssetImage(
                                                'assets/icons/outlet/location.png'),
                                            color: colorBlackTab,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              detail.address!,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: colorBlackTab,
                                                fontFamily: fontFamilyInter,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.start,
                                              textScaler: TextScaler.linear(
                                                  scaleFactor),
                                              maxLines: 3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // margin: EdgeInsets.only(top: 10),
                                    padding: EdgeInsets.fromLTRB(
                                        marginHorizontal,
                                        10,
                                        marginHorizontal,
                                        10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: height * 0.02,
                                          margin: EdgeInsets.only(right: 20),
                                          color: colorTransparent,
                                          child: Image(
                                            image: AssetImage(
                                                'assets/icons/outlet/contact.png'),
                                            color: colorBlackTab,
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            detail.contact!,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: colorBlackTab,
                                              fontFamily: fontFamilyInter,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.start,
                                            textScaler:
                                                TextScaler.linear(scaleFactor),
                                            maxLines: 3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        marginHorizontal,
                                        10,
                                        marginHorizontal,
                                        20),
                                    // height: height * 0.2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: height * 0.02,
                                          margin: EdgeInsets.only(right: 20),
                                          color: colorTransparent,
                                          child: Image(
                                            image: AssetImage(
                                                'assets/icons/outlet/time.png'),
                                            color: colorBlackTab,
                                          ),
                                        ),
                                        operation != 0
                                            ? Expanded(
                                                child: Container(
                                                  // height: height * 0.5,
                                                  // color: colorBabyBlue,
                                                  // alignment: Alignment.center,
                                                  // margin: EdgeInsets.only(
                                                  //     top: 10,
                                                  //     bottom: 20,
                                                  //     left: 5,
                                                  //     right: 5),
                                                  // padding: EdgeInsets.all(18),
                                                  // padding: EdgeInsets.symmetric(
                                                  // vertical: 10),
                                                  child:
                                                      _buildOperationListView(
                                                          context, state),
                                                ),
                                              )
                                            : Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10),
                                              ),
                                      ],
                                    ),
                                  ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: availableVoucher != 0
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: marginHorizontal),
                                    child: _buildOutletVoucherListView(
                                        context, state),
                                  )
                                : SizedBox(
                                    height: height * 0.7,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: width * 0.2,
                                          width: width * 0.2,
                                          // margin: EdgeInsets.only(top: height / 4),
                                          padding: EdgeInsets.symmetric(
                                              vertical: height / 8,
                                              horizontal: width),
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
                                          "No Voucher Yet",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            color: colorNoVoucherGrey,
                                          ),
                                          textAlign: TextAlign.center,
                                          textScaler:
                                              TextScaler.linear(scaleFactor),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Container();
            }
            return Container(
              height: height * 0.8,
              width: MediaQuery.of(context).size.width,
              color: colorWhite,
              child: Center(
                child: CircularProgressIndicator(
                  color: colorDisableGrey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOperationListView(BuildContext context, OutletState state) {
    if (state is OutletDetailsLoaded) {
      operations = state.details.operations!;

      var operationTiles = operations
          .map((operation) => operation.getOutletOperationTile(
                context: context,
              ))
          .toList(growable: false);

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: operations.length,
        itemBuilder: (context, index) {
          return operationTiles[index];
        },
        // ),
      );
    }
    return Container();
  }

  Widget _buildOutletVoucherListView(BuildContext context, OutletState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (state is OutletDetailsLoaded) {
      // outletVoucher = state.details.vouchers!;

      outletVoucher = state.details.vouchers!
          .where((voucher) => voucher.purchaseMethod != 'redeemable')
          .toList();

      var voucherTiles = outletVoucher
          .map((outletVoucher) => outletVoucher.getOutletVoucherTile(
              context: context,
              onTap: () {
                setProcessingStatus(true);

                Navigator.of(context)
                    .pushNamed(AqualifeRoutes.rewardDetails,
                        arguments: RewardDetailsParameters(
                          rewardId: outletVoucher.id!,
                          title: state.details.merchantName!,
                          indexPage: 3,
                        ))
                    .then((value) {
                  setProcessingStatus(false);
                });
              }))
          .toList(growable: false);

      return outletVoucher.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: outletVoucher.length,
              itemBuilder: (context, index) {
                return voucherTiles[index];
              },
              // ),
            )
          : SizedBox(
              height: height * 0.7,
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
                    "No Voucher Yet",
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
            );
    }
    return Container();
  }

  launchMapDirection(OutletDetails detail, double height, double width) async {
    final availableMaps = await MapLauncher.installedMaps;

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              Container(
                width: width,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                color: colorBackground,
                child: Text('Open with: '),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20),
                color: colorBackground,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Wrap(
                        children: <Widget>[
                          for (var map in availableMaps)
                            ListTile(
                              onTap: () => map.showDirections(
                                destination: Coords(
                                  double.parse(detail.latitude!),
                                  double.parse(detail.longitude!),
                                ),
                                destinationTitle: detail.address,
                                // origin: Coords(),
                                // waypoints:
                                directionsMode: DirectionsMode.driving,
                              ),
                              title: Text(map.mapName),
                              leading: SvgPicture.asset(
                                map.icon,
                                height: 30.0,
                                width: 30.0,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Future<void> _saveList(favList) async {
  //   await Storage().secureStorage.write(key: 'favList', value: favList);
  // }
}
