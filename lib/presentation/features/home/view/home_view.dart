// ignore_for_file: unused_field

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../config/config.dart';
import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../../data/model/model.dart';
import '../../../../util/custom_page_route.dart';
import '../../../widgets/independent/independent.dart';
import '../../../widgets/independent/webview.dart';
import '../../bulletin/bulletin.dart';
import '../../ordering/ordering.dart';
import '../../rewards/reward.dart';
import '../../voucher/voucher.dart';
import '../../webview/webview_deeplink.dart';
import '../home.dart';

class HomeViewNew extends StatefulWidget {
  final String? token;
  final Function changeView;

  const HomeViewNew({super.key, this.token, required this.changeView});

  @override
  State<HomeViewNew> createState() => _HomeViewNewState();
}

class _HomeViewNewState extends State<HomeViewNew> {
  List<String> slideshowImage = [];
  List<CategoryVoucher> categories = [];
  List<VouchersCat> catVouchers = [];
  List<Upcoming> upcoming = [];
  List<Merchant> merchants = [];
  List<Highlight> highlight = [];
  List<MiniProgram> miniProgram = [];
  int _current = 0;
  final bool _enabled = true;
  // final CarouselController _controller = CarouselController();
  CarouselSliderController carouselController = CarouselSliderController();

  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomeLoaded) {
          slideshowImage = state.homePage.slideshow!;
          categories = state.homePage.categories!;
          upcoming = state.homePage.upcoming!;
          merchants = state.homePage.merchants!;
          highlight = state.homePage.highlight!;
          miniProgram = state.homePage.mini!;

          return CustomScrollView(
            slivers: [
              // ----------------------------------------------------------------- Dynamic appbar
              SliverAppBar(
                expandedHeight: height * 0.27,
                collapsedHeight: height * 0.17,
                floating: true,
                pinned: true,
                snap: true,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor:
                        colorTransparent, // this one will make the statusbar transparent
                    statusBarIconBrightness:
                        Brightness.light //this will take care of the icon color
                    ),
                flexibleSpace: Stack(
                  children: <Widget>[
                    // ----------------------------------------------------------- Slideshow image
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: _buildslideshowImage(context, state),
                      ),
                    ),
                    // ----------------------------------------------------------- Search box
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: _searchBar(true),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Container(
                    //   height: height * 0.15,
                    //   width: height * 0.15,
                    //   color: colorBabyBlue,
                    //   child: SvgPicture.asset(
                    //     'assets/icons/image_svg.svg',
                    //     color: colorRed,
                    //   ),
                    // ),
                    // ----------------------------------------------------------- Category button (Top Brands/ trending Voucher)
                    _buildCategory(),
                    // ----------------------------------------------------------- Upcoming Event
                    _buildUpcomingEvent(state),
                    // ----------------------------------------------------------- Merchant/ Brand
                    _buildTopBrand(state),
                  ],
                ),
              ),
              // ----------------------------------------------------------------- Category voucher(Trending voucher/ hot deals voucher)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildCategoryVoucher(index);
                  },
                  childCount: categories.length,
                ),
              ),
              // ----------------------------------------------------------------- Highlight/ bulletin list
              SliverToBoxAdapter(
                child: _buildHighlight(),
              ),
            ],
          );
        }

        return _homeLoading();
      },
    );
  }

  Widget _homeLoading() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          height: height,
          color: colorTransparent,
          child: Shimmer.fromColors(
            baseColor: colorLightGray,
            highlightColor: colorWhiteQrLight,
            enabled: _enabled,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height * 0.31,
                    color: colorWhite,
                    padding: EdgeInsets.fromLTRB(
                        marginHorizontal, 50, marginHorizontal, 10),
                  ),
                  Container(
                    height: height * 0.1,
                    // color: colorWhite,
                    margin: EdgeInsets.fromLTRB(
                        marginHorizontal, 8, marginHorizontal, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < 5; i++)
                          Container(
                            height: height * 0.07,
                            width: height * 0.07,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorWhite,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Container(
                    height: height * 0.03,
                    width: width,
                    padding: EdgeInsets.symmetric(vertical: 23),
                    margin: EdgeInsets.symmetric(
                        vertical: 0, horizontal: marginHorizontal),
                    color: colorWhite,
                  ),
                  Container(
                    height: height * 0.15,
                    width: width,
                    margin: EdgeInsets.symmetric(
                        vertical: 10, horizontal: marginHorizontal),
                    color: colorWhite,
                  ),
                  SizedBox(height: height * 0.04),
                  Container(
                    height: height * 0.03,
                    width: width,
                    padding: EdgeInsets.symmetric(vertical: 23),
                    margin: EdgeInsets.symmetric(
                        vertical: 0, horizontal: marginHorizontal),
                    color: colorWhite,
                  ),
                  Container(
                    height: height * 0.15,
                    width: width,
                    margin: EdgeInsets.symmetric(
                        vertical: 10, horizontal: marginHorizontal),
                    color: colorWhite,
                  ),
                  SizedBox(height: height * 0.04),
                  Container(
                    height: height * 0.03,
                    width: width,
                    padding: EdgeInsets.symmetric(vertical: 23),
                    margin: EdgeInsets.symmetric(
                        vertical: 0, horizontal: marginHorizontal),
                    color: colorWhite,
                  ),
                  Container(
                    height: height * 0.15,
                    width: width,
                    margin: EdgeInsets.symmetric(
                        vertical: 10, horizontal: marginHorizontal),
                    color: colorWhite,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Slideshow image body
  Widget _buildslideshowImage(BuildContext context, HomeState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // If slideshow empty, return container
    if (slideshowImage.isEmpty) {
      return AspectRatio(
        aspectRatio: 2 / 1,
        child: Container(
          height: height * 0.23,
          color: colorBackground,
        ),
      );
    }

    // Else, return Carousel image
    return CarouselSlider(
      items: slideshowImage.map((item) {
        return CachedNetworkImage(
          imageUrl: item,
          imageBuilder: (context, imageProvider) {
            return Container(
              width: width,
              alignment: Alignment.center, // where to position the child
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(item),
                ),
              ),
            );
          },
        );
      }).toList(),
      carouselController: carouselController,
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        viewportFraction: 1.1,
        enableInfiniteScroll: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
    );
  }

  // search box body
  Widget _searchBar(bool? showSuffix) {
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AqualifeRoutes.searchResultsPage);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: colorWhite,
          border: Border.all(color: colorGreyBox),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0.0, 3.0),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: width * 0.05,
              child: Image(
                image: AssetImage(
                  'assets/icons/outlet/search.png',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Search',
                style: TextStyle(
                  color: colorSoftGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: fontFamilyMain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category button body
  Widget _buildCategory() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    double itemSpacing = Platform.isIOS ? width * 0.04 : width * 0.045;
    int totalLength = 4;
    int lengthBlnce = 0;

    lengthBlnce = totalLength - categories.length;

    return Container(
      height: height * 0.12,
      margin: EdgeInsets.fromLTRB(marginHorizontal, 20, marginHorizontal, 0),
      child: Row(
        mainAxisAlignment: categories.length < 3
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            splashColor: colorTransparent,
            highlightColor: colorTransparent,
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AqualifeRoutes.orderingMerchant,
                (Route<dynamic> route) => false,
                arguments: OrderingScreenParameters(selectedTab: 1),
              );
            },
            child: Column(
              children: [
                Container(
                  height: height * 0.07,
                  width: height * 0.07,
                  padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                  // margin: EdgeInsets.only(right: 7),
                  child: Image(
                    image: AssetImage('assets/icons/homePage/top.png'),
                  ),
                ),
                Container(
                  width: height * 0.07,
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Top Brands',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorBlack,
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0;
              i < (categories.length > 3 ? 3 : categories.length);
              i++)
            InkWell(
              splashColor: colorTransparent,
              highlightColor: colorTransparent,
              onTap: () {
                Storage().isTabChange = false;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.voucher,
                  (Route<dynamic> route) => false,
                  arguments: VoucherParameters(
                    selectedTab: 0,
                    filterBy: categories[i].filterBy!,
                    filterValue: categories[i].id!.toString(),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.07,
                    width: height * 0.07,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.only(left: itemSpacing),
                    child: Image(
                      image: NetworkImage(categories[i].image!),
                    ),
                  ),
                  Container(
                    width: height * 0.07,
                    padding: EdgeInsets.only(top: 5),
                    margin: EdgeInsets.only(left: itemSpacing),
                    child: Text(
                      categories[i].name!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colorBlack,
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          miniProgram.isNotEmpty
              ? totalLength == 1
                  ? InkWell(
                      splashColor: colorTransparent,
                      highlightColor: colorTransparent,
                      onTap: () {
                        modalBottomSheetMenu();
                      },
                      child: Column(
                        children: [
                          Container(
                            height: height * 0.07,
                            width: height * 0.07,
                            // color: colorBabyBlue,
                            margin: EdgeInsets.only(left: itemSpacing),
                            padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: secondaryColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image(
                                  image: AssetImage(
                                      'assets/icons/homePage/viewall.png'),
                                  // color: colorWhite,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: height * 0.07,
                            padding: EdgeInsets.only(top: 5),
                            margin: EdgeInsets.only(left: itemSpacing),
                            // margin: EdgeInsets.only(right: 5),
                            child: Text(
                              'View All',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colorBlack,
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  : miniProgram.length < lengthBlnce
                      ? Row(
                          children: [
                            for (int j = 0; j < miniProgram.length; j++)
                              InkWell(
                                splashColor: colorTransparent,
                                highlightColor: colorTransparent,
                                onTap: () {
                                  if (miniProgram[j].url != null) {
                                    Navigator.push(
                                      context,
                                      NoAnimationPageRoute(
                                        builder: (context) {
                                          return Scaffold(
                                            appBar: AppBar(
                                              systemOverlayStyle:
                                                  SystemUiOverlayStyle(
                                                statusBarColor: secondaryColor,
                                                systemNavigationBarColor:
                                                    colorWhite,
                                              ),
                                              title: Text(
                                                miniProgram[j].name!,
                                                style: TextStyle(
                                                  fontFamily: fontFamilyMain,
                                                  color: colorBlack,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                                textScaler: TextScaler.linear(
                                                    scaleFactor),
                                              ),
                                              leading: Container(
                                                child: IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              centerTitle: true,
                                              backgroundColor: secondaryColor,
                                              iconTheme: IconThemeData(
                                                  color: colorBlack),
                                              elevation: 0,
                                            ),
                                            body: WidgetWebView(
                                              widgetUrl: miniProgram[j].url!,
                                              // widgetUrl:
                                              //     'https://mini.Aqualife.com/event_checkin_demo?token=4ffacfc4eb46b5a7330e047435b2830512377f165053437cb5faa02cca93da81',
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    showErrorToast('Not available', context);
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height * 0.07,
                                      width: height * 0.07,
                                      padding: EdgeInsets.all(5),
                                      margin:
                                          EdgeInsets.only(left: itemSpacing),
                                      child: Image(
                                        image:
                                            NetworkImage(miniProgram[j].image!),
                                      ),
                                    ),
                                    Container(
                                      width: height * 0.07,
                                      padding: EdgeInsets.only(top: 5),
                                      margin:
                                          EdgeInsets.only(left: itemSpacing),
                                      child: Text(
                                        miniProgram[j].name!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: colorBlack,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        )
                      : Row(
                          children: [
                            for (int j = 0; j < lengthBlnce - 1; j++)
                              InkWell(
                                splashColor: colorTransparent,
                                highlightColor: colorTransparent,
                                onTap: () {
                                  if (miniProgram[j].url != null) {
                                    Navigator.push(
                                      context,
                                      NoAnimationPageRoute(
                                        builder: (context) {
                                          return Scaffold(
                                            appBar: AppBar(
                                              systemOverlayStyle:
                                                  SystemUiOverlayStyle(
                                                statusBarColor: secondaryColor,
                                                systemNavigationBarColor:
                                                    colorWhite,
                                              ),
                                              title: Text(
                                                miniProgram[j].name!,
                                                style: TextStyle(
                                                  fontFamily: fontFamilyMain,
                                                  color: colorBlack,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                                textScaler: TextScaler.linear(
                                                    scaleFactor),
                                              ),
                                              leading: Container(
                                                child: IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              centerTitle: true,
                                              backgroundColor: secondaryColor,
                                              iconTheme: IconThemeData(
                                                  color: colorBlack),
                                              elevation: 0,
                                            ),
                                            body: WidgetWebView(
                                              widgetUrl: miniProgram[j].url!,
                                              // widgetUrl:
                                              //     'https://mini.Aqualife.com/event_checkin_demo?token=4ffacfc4eb46b5a7330e047435b2830512377f165053437cb5faa02cca93da81',
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    showErrorToast('Not available', context);
                                  }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: height * 0.07,
                                      width: height * 0.07,
                                      padding: EdgeInsets.all(5),
                                      margin:
                                          EdgeInsets.only(left: itemSpacing),
                                      child: Image(
                                        image:
                                            NetworkImage(miniProgram[j].image!),
                                      ),
                                    ),
                                    Container(
                                      width: height * 0.07,
                                      padding: EdgeInsets.only(top: 5),
                                      margin:
                                          EdgeInsets.only(left: itemSpacing),
                                      child: Text(
                                        miniProgram[j].name!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: colorBlack,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            InkWell(
                              splashColor: colorTransparent,
                              highlightColor: colorTransparent,
                              onTap: () {
                                modalBottomSheetMenu();
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: height * 0.07,
                                    width: height * 0.07,
                                    // color: colorBabyBlue,
                                    margin: EdgeInsets.only(left: itemSpacing),
                                    padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: secondaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.2),
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image(
                                          image: AssetImage(
                                              'assets/icons/homePage/viewall.png'),
                                          // color: colorWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: height * 0.07,
                                    padding: EdgeInsets.only(top: 5),
                                    margin: EdgeInsets.only(left: itemSpacing),
                                    // margin: EdgeInsets.only(right: 5),
                                    child: Text(
                                      'View All',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: colorBlack,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
              : Container(),
        ],
      ),
    );
  }

  // Upcoming event body
  Widget _buildUpcomingEvent(HomeState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (upcoming.isEmpty) {
      return Container();
    }

    /* IF API call success and not empty, show listView If Perks section*/
    return Container(
      color: colorBackground,
      height: height * 0.25,
      padding: EdgeInsets.fromLTRB(marginHorizontal, 5, marginHorizontal, 0),
      child: Column(
        children: [
          Container(
            width: width,
            color: colorBackground,
            margin: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Image(
                        height: height * 0.035,
                        image: AssetImage('assets/icons/homePage/event.png'),
                      ),
                    ),
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorBlack,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AqualifeRoutes.upcoming,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorWhiteBlue,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: colorBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: upcoming.length,
              // physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AqualifeRoutes.bulletinDetails,
                      arguments: BulletinDetailsParameters(
                          bulletinId: upcoming[index].id!,
                          title: upcoming[index].name!),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        right: index == upcoming.length - 1 ? 0 : 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: width * 0.28,
                          color: colorBackground,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            // child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                // border: Border.all(
                                //   color: colorGreyBox,
                                // ),
                                // borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    // 'https://staging-loyalty.chup-la.com/storages/imgs/2024/03/150425_4_000_1.png'
                                    upcoming[index].image!,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // ),
                          ),
                        ),
                        // Container(
                        //   width: width * 0.25,
                        //   padding: EdgeInsets.only(top: 5),
                        //   child: Text(
                        //     upcoming[index].name!,
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w400,
                        //       fontFamily: fontFamilyMain,
                        //     ),
                        //     maxLines: 2,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Merchant body
  Widget _buildTopBrand(HomeState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (merchants.isEmpty) {
      return Container();
    }

    /* IF API call success and not empty, show listView If Perks section*/
    return Container(
      color: colorBackground,
      height: height * 0.27,
      padding: EdgeInsets.fromLTRB(marginHorizontal, 5, marginHorizontal, 0),
      //============================================== need cange to listview
      child: Column(
        children: [
          Container(
            width: width,
            color: colorBackground,
            margin: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Image(
                        height: height * 0.035,
                        image: AssetImage('assets/icons/homePage/top.png'),
                      ),
                    ),
                    Text(
                      'Top Brand',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorBlack,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AqualifeRoutes.orderingMerchant,
                        (Route<dynamic> route) => false,
                        arguments: OrderingScreenParameters(selectedTab: 1),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorWhiteBlue,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: colorBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: merchants.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Storage().brandName = merchants[index].name;
                    Navigator.of(context)
                        .pushNamed(AqualifeRoutes.orderingOutlet,
                            arguments: OrderingOutletParameters(
                                brandsId: merchants[index].id!))
                        .then((value) {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        right: index == merchants.length - 1 ? 0 : 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.28,
                          color: colorBackground,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            // child: InkWell(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorGreyBox,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        // 'https://staging-loyalty.chup-la.com/storages/imgs/2024/03/150425_4_000_1.png'
                                        merchants[index].image!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                merchants[index].isMuslim == true
                                    ? Positioned(
                                        right: 5,
                                        top: 5,
                                        child: HalalWidget(
                                            muslimCategory: merchants[index]
                                                .muslimCategory!,
                                            width: width * 0.08),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.25,
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            merchants[index].name!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: fontFamilyMain,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Categry voucher body
  Widget _buildCategoryVoucher(index) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    catVouchers = categories[index].vouchers!;

    if (catVouchers.isEmpty) {
      return Container();
    }

    /* IF API call success and not empty, show listView If Perks section*/
    return Container(
      height: height * 0.27,
      padding: EdgeInsets.fromLTRB(marginHorizontal, 5, marginHorizontal, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            color: colorBackground,
            margin: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Image(
                        height: height * 0.035,
                        image: NetworkImage(categories[index].image!),
                      ),
                    ),
                    Text(
                      categories[index].name!,
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorBlack,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      Storage().isTabChange = false;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AqualifeRoutes.voucher,
                        (Route<dynamic> route) => false,
                        arguments: VoucherParameters(
                          selectedTab: 0,
                          filterBy: categories[index].filterBy!,
                          filterValue: categories[index].id!.toString(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorWhiteBlue,
                        // border: Border.all(
                        //   color: secondaryColor,
                        //   width: 2,
                        // ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: colorBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildVoucher(context, categories[index].vouchers!),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucher(BuildContext context, List<VouchersCat> catVoucher) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeProcessing) {
          return Center(
            child: CircularProgressIndicator(
              color: colorDisableGrey,
            ),
          );
        }

        return Container(
          child: ListView.builder(
            itemCount: catVoucher.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, indexCat) {
              return InkWell(
                onTap: () {
                  TempData.voucherRefCode = '';
                  Navigator.of(context).pushNamed(AqualifeRoutes.rewardDetails,
                      arguments: RewardDetailsParameters(
                        rewardId: catVoucher[indexCat].id!,
                        title: catVoucher[indexCat].name!,
                        indexPage: 3,
                      ));
                },
                child: Container(
                  margin: EdgeInsets.only(
                      right: indexCat == catVoucher.length - 1 ? 0 : 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: width * 0.28,
                        color: colorBackground,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: colorGreyBox,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      // 'https://staging-loyalty.chup-la.com/storages/imgs/2024/03/150425_4_000_1.png'
                                      catVoucher[indexCat].image!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              catVoucher[indexCat].isMuslim == true
                                  ? Positioned(
                                      right: 3,
                                      top: 5,
                                      child: HalalWidget(
                                          muslimCategory: catVoucher[indexCat]
                                              .muslimCategory!,
                                          width: width * 0.08))
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: width * 0.25,
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          catVoucher[indexCat].name!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyMain,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Highlight/ bulletin body
  Widget _buildHighlight() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (highlight.isEmpty) {
      return Container();
    }

    /* IF API call success and not empty, show listView If Perks section*/
    return Container(
      height: height * 0.3,
      padding: EdgeInsets.fromLTRB(marginHorizontal, 5, marginHorizontal, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            color: colorBackground,
            margin: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Image(
                        height: height * 0.035,
                        image:
                            AssetImage('assets/icons/homePage/highlight.png'),
                      ),
                    ),
                    Text(
                      'Highlight',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorBlack,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
                Container(
                  // color: colorBabyBlue,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AqualifeRoutes.bulletin,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorWhiteBlue,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: colorBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              // shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: highlight.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AqualifeRoutes.bulletinDetails,
                      arguments: BulletinDetailsParameters(
                        bulletinId: highlight[index].id!,
                        title: highlight[index].name!,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                        right: index == upcoming.length - 1 ? 0 : 7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: width * 0.3,
                          color: colorBackground,
                          child: AspectRatio(
                            aspectRatio: 2 / 1,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colorGreyBox,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        // 'https://staging-loyalty.chup-la.com/storages/imgs/2024/03/150425_4_000_1.png'
                                        highlight[index].image!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: width * 0.25,
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            highlight[index].name!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: fontFamilyMain,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // // Category button body
  // Widget _buildMiniProgram(int? removepad) {
  //   var height = MediaQuery.of(context).size.height;
  //   var width = MediaQuery.of(context).size.width;

  //   return miniProgram.isNotEmpty
  //       ? Container(
  //           height: width * 0.27,
  //           color: colorBackground,
  //           margin: removepad == 0
  //               ? EdgeInsets.zero
  //               : EdgeInsets.fromLTRB(
  //                   marginHorizontal, 20, marginHorizontal, 0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               for (int i = 0; i < miniProgram.length; i++)
  //                 InkWell(
  //                   onTap: () {
  //                     if (miniProgram[i].url != null) {
  //                       Navigator.push(
  //                         context,
  //                         NoAnimationPageRoute(
  //                           builder: (context) {
  //                             return Scaffold(
  //                               appBar: AppBar(
  //                                 systemOverlayStyle: SystemUiOverlayStyle(
  //                                   statusBarColor: secondaryColor,
  //                                   systemNavigationBarColor: colorWhite,
  //                                 ),
  //                                 title: Text(
  //                                   miniProgram[i].name!,
  //                                   style: TextStyle(
  //                                     fontFamily: fontFamilyMain,
  //                                     color: colorBlack,
  //                                     fontWeight: FontWeight.w400,
  //                                     fontSize: 15,
  //                                   ),
  //                                   textScaler: TextScaler.linear(scaleFactor),
  //                                 ),
  //                                 leading: Container(
  //                                   child: IconButton(
  //                                     icon: Icon(Icons.close),
  //                                     onPressed: () {
  //                                       Navigator.pop(context);
  //                                     },
  //                                   ),
  //                                 ),
  //                                 centerTitle: true,
  //                                 backgroundColor: secondaryColor,
  //                                 iconTheme: IconThemeData(color: colorBlack),
  //                                 elevation: 0,
  //                               ),
  //                               body: WidgetWebView(
  //                                 widgetUrl: miniProgram[i].url!,
  //                                 // widgetUrl:
  //                                 //     'https://mini.Aqualife.com/event_checkin_demo?token=4ffacfc4eb46b5a7330e047435b2830512377f165053437cb5faa02cca93da81',
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       );
  //                     } else {
  //                       showErrorToast('Not available', context);
  //                     }
  //                   },
  //                   child: Column(
  //                     children: [
  //                       Container(
  //                         height: height * 0.07,
  //                         width: height * 0.07,
  //                         padding: EdgeInsets.all(5),
  //                         margin: EdgeInsets.only(right: 10),
  //                         child: Image(
  //                           image: NetworkImage(miniProgram[i].image!),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: height * 0.07,
  //                         padding: EdgeInsets.only(top: 5),
  //                         margin: EdgeInsets.only(right: 10),
  //                         child: Text(
  //                           miniProgram[i].name!,
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                             color: colorBlack,
  //                             fontSize: 10,
  //                             fontWeight: FontWeight.w300,
  //                           ),
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         )
  //       : Container();
  // }

  // View all bottom body
  void modalBottomSheetMenu() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        backgroundColor: colorBackground,
        builder: (builder) {
          return Container(
            height: 350.0,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: CustomScrollView(
              primary: false,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    // margin: EdgeInsets.all(20),
                    child: Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      marginHorizontal, 20, marginHorizontal, 0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      // crossAxisSpacing: 1.0,
                      mainAxisSpacing: height * 0.02,
                      mainAxisExtent: width * 0.23,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int i) {
                        if (i == 0) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                AqualifeRoutes.orderingMerchant,
                                (Route<dynamic> route) => false,
                                arguments:
                                    OrderingScreenParameters(selectedTab: 1),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: height * 0.07,
                                  width: height * 0.07,
                                  padding: EdgeInsets.all(5),
                                  // margin: EdgeInsets.only(right: 7),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/icons/homePage/top.png'),
                                  ),
                                ),
                                Container(
                                  width: height * 0.07,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Top Brands',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: colorBlack,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        int categoryIndex = i - 1;

                        return InkWell(
                          onTap: () {
                            Storage().isTabChange = false;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AqualifeRoutes.voucher,
                              (Route<dynamic> route) => false,
                              arguments: VoucherParameters(
                                selectedTab: 0,
                                filterBy: categories[categoryIndex].filterBy!,
                                filterValue:
                                    categories[categoryIndex].id!.toString(),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: height * 0.07,
                                width: height * 0.07,
                                padding: EdgeInsets.all(5),
                                child: Image(
                                  image: NetworkImage(
                                      categories[categoryIndex].image!),
                                ),
                              ),
                              Container(
                                width: height * 0.07,
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  categories[categoryIndex].name!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colorBlack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: categories.length + 1,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: miniProgram.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Service',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        )
                      : Container(),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      marginHorizontal, 20, marginHorizontal, 0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      // crossAxisSpacing: 1.0,
                      mainAxisSpacing: height * 0.02,
                      mainAxisExtent: width * 0.23,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int i) {
                        return Container(
                          child: InkWell(
                            onTap: () {
                              if (miniProgram[i].url != null) {
                                Navigator.push(
                                  context,
                                  NoAnimationPageRoute(
                                    builder: (context) {
                                      return Scaffold(
                                        appBar: AppBar(
                                          systemOverlayStyle:
                                              SystemUiOverlayStyle(
                                            statusBarColor: secondaryColor,
                                            systemNavigationBarColor:
                                                colorWhite,
                                          ),
                                          title: Text(
                                            miniProgram[i].name!,
                                            style: TextStyle(
                                              fontFamily: fontFamilyMain,
                                              color: colorBlack,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                            textScaler:
                                                TextScaler.linear(scaleFactor),
                                          ),
                                          leading: Container(
                                            child: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                          centerTitle: true,
                                          backgroundColor: secondaryColor,
                                          iconTheme:
                                              IconThemeData(color: colorBlack),
                                          elevation: 0,
                                        ),
                                        body: WidgetWebView(
                                          widgetUrl: miniProgram[i].url!,
                                          // widgetUrl:
                                          //     'https://mini.Aqualife.com/event_checkin_demo?token=4ffacfc4eb46b5a7330e047435b2830512377f165053437cb5faa02cca93da81',
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                showErrorToast('Not available', context);
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: height * 0.07,
                                  width: height * 0.07,
                                  padding: EdgeInsets.all(5),
                                  // margin: EdgeInsets.only(right: 10),
                                  child: Image(
                                    image: NetworkImage(miniProgram[i].image!),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: height * 0.07,
                                    padding: EdgeInsets.only(top: 5),
                                    // margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      miniProgram[i].name!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: colorBlack,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: miniProgram.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
