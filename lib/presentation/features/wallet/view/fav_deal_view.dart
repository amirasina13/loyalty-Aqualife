import 'package:flutter/services.dart';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../../data/model/model.dart';
import '../../../widgets/extensions/reward_favourite.dart';
import '../../../widgets/independent/independent.dart';
import '../../rewards/reward.dart';

class FavDealView extends StatefulWidget {
  final Function changeView;
  const FavDealView({super.key, required this.changeView});

  @override
  State<FavDealView> createState() => _FavDealViewState();
}

class _FavDealViewState extends State<FavDealView> {
  List<RewardFavourite> rewardFavouriteList = <RewardFavourite>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        'Favourite Deals',
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
      body: BlocConsumer<RewardBloc, RewardState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is RewardOutletStarted) {
            BlocProvider.of<RewardBloc>(context).add(RewardFavouriteLoad());
          }

          if (state is RewardFavouriteLoaded) {
            // var profileData = state.userQrcode;
            int totalLength = state.rewardFavourite.length;

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
                    '$totalLength items found',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildRewardWishlistView(context, state),
                  ),
                ),
              ],
            );
          }

          return LoadingWidget();
        },
      ),
    );
  }

  /* --------------------------------------------------------------------------- All Voucher ListView section */
  Widget _buildRewardWishlistView(BuildContext context, RewardState state) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    /* IF API call success and not empty, set List variable */
    if (state is RewardFavouriteLoaded) {
      rewardFavouriteList = state.rewardFavourite;
    }

    /* the extension for gridview voucher */
    var rewardFavouriteListTiles = rewardFavouriteList
        .map((favouriteList) => favouriteList.getRewardFavouriteListTile(
              context: context,
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AqualifeRoutes.rewardDetails,
                        arguments: RewardDetailsParameters(
                          rewardId: favouriteList.id!,
                          title: favouriteList.name!,
                          indexPage: 3,
                        ))
                    .then((value) {
                  if (context.mounted) {
                    BlocProvider.of<RewardBloc>(context)
                        .add(RewardOutletCheck());
                  }
                });
              },
              onTapFavourite: () {
                setState(() {
                  Storage().page = 'wallet_wishlist';
                  BlocProvider.of<RewardBloc>(context)
                      .add(RewardAddRemoveFavouriteLoad(
                    voucherId: favouriteList.id.toString(),
                  ));
                });
              },
            ))
        .toList(growable: false);

    /* My Voucher design */
    return rewardFavouriteList.isNotEmpty
        ? Container(
            padding: EdgeInsets.only(bottom: 30, top: 10),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10),
              physics: NeverScrollableScrollPhysics(),
              itemCount: rewardFavouriteList.length,
              itemBuilder: (context, index) {
                return rewardFavouriteListTiles[index];
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
            child: Container(
              color: colorBackground,
              height: height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top -
                  kBottomNavigationBarHeight -
                  85,
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
          );
  }
}
