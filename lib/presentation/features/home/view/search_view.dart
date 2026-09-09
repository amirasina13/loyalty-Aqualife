import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/routes.dart';
import '../../../../data/api/models/models.dart';
import '../../../widgets/extensions/search_results_view.dart';
import '../../../widgets/independent/independent.dart';
import '../../authentication/authentication.dart';
import '../../ordering/ordering_outlet_screen.dart';
import '../../rewards/reward_detail.dart';
import '../home.dart';
import '../../../../config/config.dart';

class SearchView extends StatefulWidget {
  final Function? changeView;

  const SearchView({super.key, this.changeView});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  List<dynamic> searchResults = [];
  List<SearchListsModel> allMerchantList = [];
  List<SearchListsModel> allVouchersList = [];
  TextEditingController searchController = TextEditingController();
  final ScrollController _merchantController = ScrollController();
  final ScrollController _voucherController = ScrollController();
  bool isLoading = true;
  bool showVouchers = true;
  bool showMerchants = true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(VoucherBrandLoad());
    fToast = FToast();
    fToast.init(context);
  }

  /* --------------------------------------------------------------------------- dispose - Called when this object is removed from the tree permanently. */
  @override
  void dispose() {
    super.dispose();

    _merchantController.dispose();
    _voucherController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    // Check if Merchant or Voucher lists are visible
    bool hasMerchants =
        searchResults.any((element) => element['title'] == "Merchants");
    bool hasVouchers =
        searchResults.any((element) => element['title'] == "Vouchers");

    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeNetworkError) {
          showErrorToast(state.error, context);
        }

        if (state is VoucherBrandLoaded) {
          setState(() {
            isLoading = false;
            searchResults = state.searchData!;
          });
        }
      },
      builder: (context, state) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: colorWhite,
          ),
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: SizedBox(
                width: width * 0.3,
                child: Image(
                  image: AssetImage('assets/icons/aqua_words.png'),
                ),
              ),
            ),
            backgroundColor: colorBackground,
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 20),
                    _searchBar(true),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: hasMerchants,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: _merchantLists(context),
                              ),
                            ),
                            Visibility(
                              visible: hasVouchers,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                margin: EdgeInsets.only(
                                    top: hasMerchants
                                        ? 0
                                        : 20), // Adjust top margin if merchants are not shown
                                child: _voucherLists(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoading)
                  Center(
                    child: LoadingWidget(),
                  ),
                if (searchResults.isEmpty && !isLoading)
                  Center(child: _emptyListWidget()),
              ],
            ),
          ),
        );
      },
    );
  }

  // vouchers widget
  Widget _voucherLists(BuildContext context) {
    String title = '';
    var allVouchers = searchResults
        .where((element) => element['title'] == "Vouchers")
        .toList();

    if (allVouchers.isNotEmpty) {
      title = allVouchers[0]['title'];
      var vouchersList = allVouchers[0]['lists'] as List<dynamic>;

      allVouchersList =
          vouchersList.map((item) => SearchListsModel.fromJson(item)).toList();
    }

    var allVouchersWidgets = allVouchersList
        .map((voucher) => voucher.getSearchList(
              context: context,
              onTap: () {
                navigateToRewardDetails(voucher);
              },
              isSelected: false,
            ))
        .toList(growable: false);

    // Limit the number of widgets to 6
    var vouchersWidget = allVouchersWidgets.take(6).toList();

    if (title.isEmpty) {
      return SizedBox();
    }

    return Scrollbar(
        controller: _voucherController,
        trackVisibility: true,
        thickness: 5,
        interactive: true,
        radius: const Radius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 15, // Horizontal spacing between widgets
              runSpacing: 20, // Vertical spacing between lines
              children: vouchersWidget,
            ),
          ],
        ));
  }

  // Merchants list
  Widget _merchantLists(BuildContext context) {
    String title = '';
    var allMerchants = searchResults
        .where((element) => element['title'] == "Merchants")
        .toList();

    if (allMerchants.isNotEmpty) {
      title = allMerchants[0]['title'];
      var merchantsList = allMerchants[0]['lists'] as List<dynamic>;

      allMerchantList =
          merchantsList.map((item) => SearchListsModel.fromJson(item)).toList();
    }

    var allMerchantWidget = allMerchantList
        .map((merchant) => merchant.getSearchList(
              context: context,
              onTap: () {
                navigateToBrandDetails(merchant);
              },
              isSelected: false,
            ))
        .toList(growable: false);

    // Limit the number of widgets to 6
    var merchantsWidget = allMerchantWidget.take(6).toList();

    if (title.isEmpty) {
      return SizedBox();
    }

    return Scrollbar(
        controller: _merchantController,
        trackVisibility: true,
        thickness: 5,
        interactive: true,
        radius: const Radius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 15, // Horizontal spacing between widgets
                runSpacing: 20, // Vertical spacing between lines
                children: merchantsWidget),
          ],
        ));
  }

  // Search bar
  Widget _searchBar(bool? showSuffix) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: colorWhite,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: colorWhite,
          border: Border.all(color: colorGreyBox),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) {
            _onSearchTextChanged(searchController.text);
          },
          style: TextStyle(
            color: colorBlack,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(
              color: colorSoftGrey,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamilyMain,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            icon: SizedBox(
              width: width * 0.05,
              child: Image(
                image: AssetImage('assets/icons/outlet/search.png'),
              ),
            ),
            // suffixIcon: showSuffix == true
            //     ? InkWell(
            //         onTap: () {
            //           _onSearchTextChanged(searchController.text);
            //         },
            //         child: Container(
            //           width: width * 0.03,
            //           height: width * 0.08,
            //           padding: EdgeInsets.all(12),
            //           child: Image(
            //             image: AssetImage('assets/icons/filter.png'),
            //           ),
            //         ))
            //     : SizedBox(),
            border: InputBorder.none,
          ),
          onChanged: null,
        ),
      ),
    );
  }

  Widget _emptyListWidget() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      color: colorBackground,
      // height: height * 0.5,
      // margin: EdgeInsets.symmetric(vertical: 10),
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
                image: AssetImage('assets/icons/outlet/no_merchant_outlet.png'),
              ),
            ),
          ),
          SizedBox(height: height * 0.03),
          Text(
            "No Available Brands or Vouchers",
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

  void _onSearchTextChanged(String? text) {
    BlocProvider.of<HomeBloc>(context)
        .add(VoucherBrandLoad(keywords: text ?? ""));
  }

  void navigateToRewardDetails(SearchListsModel voucher) {
    Navigator.of(context).pushNamed(AqualifeRoutes.rewardDetails,
        arguments: RewardDetailsParameters(
          rewardId: voucher.id,
          title: voucher.name!,
          indexPage: 3,
        ));
  }

  void navigateToBrandDetails(SearchListsModel merchant) {
    Navigator.of(context)
        .pushNamed(AqualifeRoutes.orderingOutlet,
            arguments: OrderingOutletParameters(brandsId: merchant.id))
        .then((value) {});
  }

  void sessionExpiredLogOut(String error) {
    showErrorToast('$error\nYou will be logged out.', context);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
    Navigator.of(context).pushNamedAndRemoveUntil(
        AqualifeRoutes.login, (Route<dynamic> route) => false);
  }
}
