// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/config.dart';
import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../../data/model/model.dart';
import '../../../../locator.dart';
import '../../../widgets/extensions/ordering_brands_view.dart';
import '../../../widgets/independent/independent.dart';
import '../ordering.dart';

class OrderingView extends StatefulWidget {
  final Function changeView;
  final int selectedTab;

  const OrderingView(
      {super.key, required this.changeView, required this.selectedTab});

  @override
  State<OrderingView> createState() => _OrderingViewState();
}

class _OrderingViewState extends State<OrderingView>
    with TickerProviderStateMixin {
  var height, width, heightAppbar;
  int idCategory = 0;
  late TabController _tabController;
  ScrollController scrollControllerBrands = ScrollController();
  List<dynamic> categoryList = [];
  List<MerchantList> brandsList = [];
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -10.0;
  ValueNotifier<int> selectedCategoryIndex = ValueNotifier<int>(0);
  ValueNotifier<int> selectedCategoryId = ValueNotifier<int>(0);
  ValueNotifier<int> selectedTabIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    _tabController.addListener(() {
      setState(() {
        // _selectedIndex = _tabController.index;
        _tabController.index;
      });
    });

    categoryList = Storage().globalValue!['brands'];
    // print('CATEGORY LIST: $categoryList');
    idCategory = categoryList.first['id'];
    selectedCategoryId.value = categoryList.first['id'];
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    heightAppbar = AppBar().preferredSize.height;

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          Navigator.of(context).pushNamedAndRemoveUntil(
            AqualifeRoutes.home,
            (Route<dynamic> route) => false,
          );
        },
        child: BlocProvider<OrderingBloc>(
          create: (context) {
            return OrderingBloc(orderingRepository: sl())
              ..add(BrandsLoad(categoryId: idCategory, loadingFirst: false));
          },
          child: BlocConsumer<OrderingBloc, OrderingState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is BrandsLoaded) {
                brandsList = state.merchants;
              }
              return CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    forceElevated: true,
                    centerTitle: true,
                    pinned: true,
                    floating: false,
                    title: Container(
                      width: width * 0.4,
                      color: colorWhite,
                      child: Theme(
                        data: ThemeData().copyWith(splashColor: colorWhite),
                        child: TabBar(
                          controller: _tabController,
                          unselectedLabelColor: colorCountGrey,
                          unselectedLabelStyle: TextStyle(
                            fontSize: 13.0,
                            fontFamily: fontFamilyInter,
                            fontWeight: FontWeight.w400,
                          ),
                          labelColor: colorBlack,
                          labelStyle: TextStyle(
                            fontSize: 13.0,
                            fontFamily: fontFamilyInter,
                            fontWeight: FontWeight.w600,
                          ),
                          labelPadding: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          indicatorColor: colorTransparent,
                          dividerColor: colorTransparent,
                          tabs: const [
                            Tab(
                              child: Text("Brand"),
                            ),
                            Tab(
                              child: Text("Nearby"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      InkWell(
                        child: Container(
                          width: width * 0.12,
                          // color: colorBabyBlue,
                          margin: EdgeInsets.only(right: marginHorizontal),
                          padding: EdgeInsets.all(12),
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
                  SliverToBoxAdapter(
                    // child: Expanded(
                    child: Container(
                      height: height - heightAppbar,
                      color: colorBackground,
                      child: TabBarView(
                        controller: _tabController,
                        // physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            // padding: EdgeInsets.only(top: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Left side: Drawer for Categories
                                Container(
                                  margin: EdgeInsets.only(right: 5, bottom: 0),
                                  padding: EdgeInsets.only(
                                      bottom: Platform.isIOS ? 30 : 50),
                                  width: width * 0.25,
                                  height: height,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: colorLightGray,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Drawer(
                                    backgroundColor: colorBackground,
                                    elevation: 0,
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          top: 10,
                                          bottom: Platform.isIOS
                                              ? height * 0.13
                                              : height * 0.06),
                                      itemCount: categoryList.length,
                                      // physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var category = categoryList[index];
                                        return Stack(
                                          children: [
                                            ValueListenableBuilder<int>(
                                              valueListenable:
                                                  selectedCategoryId,
                                              builder:
                                                  (context, selectedId, child) {
                                                return ListTile(
                                                  title: Column(
                                                    children: [
                                                      ColorFiltered(
                                                          colorFilter: ColorFilter.mode(
                                                              selectedCategoryId
                                                                          .value ==
                                                                      categoryList[
                                                                              index]
                                                                          ['id']
                                                                  ? colorBlack
                                                                  : colorCountGrey,
                                                              BlendMode
                                                                  .srcATop),
                                                          child: child),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        category['name'],
                                                        style: TextStyle(
                                                          fontSize: 9,
                                                          color: selectedCategoryId
                                                                      .value ==
                                                                  categoryList[
                                                                          index]
                                                                      ['id']
                                                              ? colorBlack
                                                              : colorTextGrey,
                                                        ),
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Divider(), // Optional: Add a divider between categories
                                                    ],
                                                  ),
                                                  onTap: selectedCategoryId
                                                              .value ==
                                                          categoryList[index]
                                                              ['id']
                                                      ? () {}
                                                      : () {
                                                          selectedCategoryIndex
                                                              .value = index;
                                                          selectedCategoryId
                                                                  .value =
                                                              categoryList[
                                                                  index]['id'];
                                                          context
                                                              .read<
                                                                  OrderingBloc>()
                                                              .add(
                                                                BrandsLoad(
                                                                  categoryId:
                                                                      categoryList[
                                                                              index]
                                                                          [
                                                                          'id'],
                                                                  loadingFirst:
                                                                      false,
                                                                ),
                                                              );
                                                        },
                                                );
                                              },
                                              // Define the child that doesn't change (image without color)
                                              child: Image(
                                                height: height * 0.05,
                                                fit: BoxFit.contain,
                                                image: Image.memory(
                                                  base64.decode(
                                                    category['image']
                                                        .replaceAll(
                                                      RegExp(
                                                          r'^data:image\/[a-z]+;base64,'),
                                                      '',
                                                    ),
                                                  ),
                                                ).image,
                                              ),
                                            ),

                                            // Animated position indicator
                                            ValueListenableBuilder<int>(
                                              valueListenable:
                                                  selectedCategoryIndex,
                                              builder: (context, selectedIndex,
                                                  child) {
                                                return Visibility(
                                                  visible: selectedCategoryId
                                                          .value ==
                                                      categoryList[index]['id'],
                                                  child: AnimatedPositioned(
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    top:
                                                        0, // Keep it at the top of the ListTile
                                                    right: 0,
                                                    child: Container(
                                                      height: height * 0.09,
                                                      width: 4,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: secondaryColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // Right side: Brands View
                                Expanded(
                                  child: Container(
                                    height: height * 0.8,
                                    margin: EdgeInsets.only(bottom: 20),
                                    padding: EdgeInsets.only(
                                        bottom: Platform.isIOS ? 30 : 0),
                                    color: colorBackground,
                                    child: ValueListenableBuilder(
                                      valueListenable: selectedCategoryId,
                                      builder: (context, value, child) {
                                        return _buildBrandList(context, state);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          OrderingNearbyScreen(),
                        ],
                      ),
                    ),
                    // ),
                  ),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildBrandList(BuildContext context, OrderingState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (state is OrderingEmpty) {
      return Center(
        child: Container(
          color: colorBackground,
          margin: EdgeInsets.only(
            bottom: height * 0.15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: width * 0.2,
                width: width * 0.2,
                // margin: EdgeInsets.only(top: height / 4),
                // padding:
                //     EdgeInsets.symmetric(vertical: height / 8, horizontal: width),
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
                "No Available Nearby Outlet",
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

    if (state is BrandsLoading) {
      return Container(
        margin: EdgeInsets.only(
          bottom: height * 0.15,
        ),
        color: colorBackground,
        child: LoadingWidget(),
      );
    }

    if (state is BrandsLoaded) {
      brandsList = state.merchants;
    }

    if (brandsList.isEmpty) {
      return Container(
        margin: EdgeInsets.only(
          bottom: height * 0.15,
        ),
        color: colorBackground,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: width * 0.2,
              width: width * 0.2,
              // margin: EdgeInsets.only(top: height / 4),
              // padding:
              //     EdgeInsets.symmetric(vertical: height / 8, horizontal: width),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image:
                      AssetImage('assets/icons/outlet/no_merchant_outlet.png'),
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
            Text(
              "No Available Brands",
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

    // // if (nearbyOutlet != null) {
    var brandsListTiles = brandsList
        .map((brandsList) => brandsList.getListBrandTile(
              context: context,
              // state: state,
              onTap: () {
                // Storage().brandId = brandsList.id!;
                Storage().brandName = brandsList.name;
                Navigator.of(context)
                    .pushNamed(AqualifeRoutes.orderingOutlet,
                        arguments:
                            OrderingOutletParameters(brandsId: brandsList.id!))
                    .then((value) {});
              },
            ))
        .toList(growable: false);

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: brandsList.length,
      // physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        // crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return brandsListTiles[index];
      },
    );
  }
}
