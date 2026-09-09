import 'dart:convert';

import 'package:flutter/services.dart';
import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../widgets/independent/independent.dart';
import '../../../widgets/extensions/outlet_favourite_view.dart';
import '../../ordering/ordering.dart';
import '../../outlet/outlet.dart';

class FavOutletView extends StatefulWidget {
  final Function changeView;
  const FavOutletView({super.key, required this.changeView});

  @override
  State<FavOutletView> createState() => _FavOutletViewState();
}

class _FavOutletViewState extends State<FavOutletView>
    with SingleTickerProviderStateMixin {
  List<OutletFav> outletFav = [];
  // int totalFav = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AqualifeScaffold(
      bottomMenuIndex: 2,
      isShow: true,
      showAppbar: true,
      systemUiOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: colorWhite,
        statusBarIconBrightness: Brightness.dark,
      ),
      title: Text(
        'Favourite Brands\' Outlets',
        style: TextStyle(
          fontFamily: fontFamilyMain,
          color: colorBlack,
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        textScaler: TextScaler.linear(scaleFactor),
      ),
      canClick: true,
      isCenterTitle: true,
      body: BlocConsumer<OrderingBloc, OrderingState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is OrderingInitial || state is OrderingLoading) {
            return LoadingWidget();
          }

          if (state is OutletMerchantLoaded) {
            outletFav = state.outletFavourite;
          }

          // return LoadingWidget();
          return Column(
            children: [
              Container(
                width: width,
                padding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: marginHorizontal),
                decoration: BoxDecoration(
                    border: Border.symmetric(
                  horizontal: BorderSide(
                    color: colorCountGrey,
                  ),
                )),
                child: Text(
                  '${outletFav.length} items found',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildFavOutletView(context, state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /* --------------------------------------------------------------------------- All Voucher ListView section */
  Widget _buildFavOutletView(BuildContext context, OrderingState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    /* IF API call success and not empty, set List variable */
    if (state is OutletMerchantLoaded) {
      outletFav = state.outletFavourite;
    }

    /* the extension for gridview voucher */
    var outletFavListTiles = outletFav
        .map((favOutlet) => favOutlet.getOutletFavListTile(
              context: context,
              onTap: () {
                Storage().distance = favOutlet.distance;
                Navigator.of(context)
                    .pushNamed(AqualifeRoutes.outletDetails,
                        arguments: OutletDetailsParameters(
                            outletId: favOutlet.id, outlet: favOutlet.place))
                    .then((value) {
                  setState(() {
                    BlocProvider.of<OrderingBloc>(context)
                        .add(OutletMerchantLoad());
                  });
                });
              },
              onTapFav: () {
                if (outletFav.any((fav) => fav.id == favOutlet.id)) {
                  // print('ISCONTAIN: TRUE');

                  outletFav
                      .removeWhere((outletFav) => outletFav.id == favOutlet.id);

                  String encodedFavList = jsonEncode(outletFav);

                  setState(() {
                    _saveList(encodedFavList);
                  });
                }
              },
            ))
        .toList(growable: false);

    /* My Voucher design */
    return outletFav.isNotEmpty
        ? Container(
            padding: EdgeInsets.only(bottom: 30, top: 10),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10),
              physics: NeverScrollableScrollPhysics(),
              itemCount: outletFav.length,
              itemBuilder: (context, index) {
                return outletFavListTiles[index];
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: colorPermissionGrey,
                  thickness: 1,
                  indent: marginHorizontal,
                  endIndent: marginHorizontal,
                );
              },
            ),
          )
        : Center(
            child: SizedBox(
              height: height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top -
                  kBottomNavigationBarHeight -
                  85,
              // color: colorBabyBlue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: width * 0.2,
                    width: width * 0.2,
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
                    "No Available Brands' Outlet",
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

  Future<void> _saveList(favList) async {
    await Storage().secureStorage.write(key: 'favList', value: favList);
  }
}
