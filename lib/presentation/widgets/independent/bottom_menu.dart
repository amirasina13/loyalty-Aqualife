import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../config/routes.dart';
import '../../../config/storage.dart';
import '../../features/ordering/ordering.dart';
import '../../features/voucher/voucher.dart';
import '../../features/webview/webview_deeplink.dart';

/* Widget class for bottom menu. Will use mostly in independent/scaffold.dart (custom scaffold) */
class AqualifeBottomMenu extends StatelessWidget {
  final int menuIndex;
  final bool isShow;
  final bool canClick;

  // ignore: use_key_in_widget_constructors
  const AqualifeBottomMenu(
    this.menuIndex,
    this.isShow,
    this.canClick,
  );

  BottomNavigationBarItem getItem(BuildContext context, String imageSelected,
      String image, String title, ThemeData theme, int index, bool isShow) {
    var height = MediaQuery.of(context).size.height;

    return BottomNavigationBarItem(
      icon: Container(
        // color: colorLightYellow,
        // decoration: BoxDecoration(border: Border.all(color: colorLightYellow)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: height * 0.035,
              width: height * 0.035,
              // margin: EdgeInsets.only(bottom: 2),
              padding: EdgeInsets.only(right: 2),
              child: Image(
                image: index == menuIndex && isShow == true
                    ? AssetImage(imageSelected)
                    : AssetImage(image),
                // color: index == menuIndex && isShow == true
                //     ? secondaryColor
                //     : colorCountGrey,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      label: title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Pass image icon, title, theme, index no and isShow
    List<BottomNavigationBarItem> menuItems = [
      getItem(
          context, imageSelected1, imageUnselected1, title1, theme, 0, isShow),
      getItem(
          context, imageSelected2, imageUnselected2, title2, theme, 1, isShow),
      getItem(
          context, imageSelected3, imageUnselected3, title3, theme, 2, isShow),
      getItem(
          context, imageSelected4, imageUnselected4, title4, theme, 3, isShow),
      getItem(
          context, imageSelected5, imageUnselected5, title5, theme, 4, isShow),
    ];

    // Custom design for bottom menu
    return Container(
      decoration: BoxDecoration(
        color: colorBackground,
        // border: Border(
        //   top: BorderSide(
        //     color: Color(0xFFC4C4C4),
        //     width: 1.0,
        //   ),
        // ),
        boxShadow: const [
          BoxShadow(color: colorWhite, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorBackground,
        unselectedLabelStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamilyMain,
        ),
        selectedLabelStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamilyMain,
        ),
        selectedItemColor: isShow == true
            ? colorBlack
            : colorDarkGray.withValues(alpha: 1.0), //colorBlack,
        currentIndex: menuIndex,
        onTap: (value) async {
          TempData.voucherId = '';
          TempData.voucherRefCode = '';
          TempData.affiliateCode = '';
          TempData.currentPage = '';
          if (value != menuIndex) {
            switch (value) {
              case 0:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.home,
                  (Route<dynamic> route) => false,
                );

                break;
              case 1:
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.orderingMerchant,
                    (Route<dynamic> route) => true,
                    arguments: OrderingScreenParameters(selectedTab: 0));

                break;
              case 2:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.wallet,
                  (Route<dynamic> route) => true,
                );

                break;
              case 3:
                Storage().rewardReload = '';
                Storage().isTabChange = false;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.voucher, (Route<dynamic> route) => true,
                    arguments: VoucherParameters(
                      selectedTab: 0,
                      filterBy: 'all',
                      filterValue: 'all',
                    ));

                break;
              case 4:
                // BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.setting,
                  (Route<dynamic> route) => true,
                );

                break;
            }
          } else if (value == menuIndex && canClick == true) {
            switch (value) {
              case 0:
                // await Storage().secureStorage.delete(key: 'vId');
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.home,
                  (Route<dynamic> route) => false,
                );

                break;
              case 1:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.orderingMerchant,
                  (Route<dynamic> route) => true,
                  arguments: OrderingScreenParameters(selectedTab: 0),
                );
                break;
              case 2:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.wallet,
                  (Route<dynamic> route) => true,
                );
                break;
              case 3:
                Storage().rewardReload = '';
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.voucher, (Route<dynamic> route) => true,
                    arguments: VoucherParameters(
                      selectedTab: 0,
                      filterBy: 'all',
                      filterValue: '1',
                    ));

                // Navigator.of(context).pushNamedAndRemoveUntil(
                //    AqualifeRoutes.brandsChecking,
                //   (Route<dynamic> route) => true,
                // );
                break;
              case 4:
                // BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.setting,
                  (Route<dynamic> route) => true,
                );
                break;
            }
          }
        },
        items: menuItems,
      ),
    );
  }
}
