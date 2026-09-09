import 'dart:io';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../../data/model/model.dart';
import '../../../../locator.dart';
import '../../../widgets/independent/independent.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance.dart';
import '../../outlet/outlet_details_screen.dart';
import '../../../widgets/extensions/nearby_list_view.dart';
import '../../voucher/voucher.dart';
import '../ordering.dart';

class OrderingNearbyView extends StatefulWidget {
  final Function? changeView;

  const OrderingNearbyView({super.key, this.changeView});

  @override
  State<OrderingNearbyView> createState() => _OrderingNearbyViewState();
}

class _OrderingNearbyViewState extends State<OrderingNearbyView>
    with TickerProviderStateMixin {
  String gotChangeValue = '';
  NearbyOutlet? nearbyOutlet;
  List<NearbyOutletList> nearbyOutletList = <NearbyOutletList>[];
  List<NearbyOutletList> nearbyOutletDisplay = <NearbyOutletList>[];
  var nearbyListTiles = [];
  var searchOutletTiles = [];
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, value) {
        return [
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: SliverAppBarDelegate(
              minHeight: height * 0.1,
              maxHeight: height * 0.1,
              child: Container(
                color: colorWhiteGrey,
                // height: height * 0.2,
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: marginHorizontal),
                      child: _searchBar(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: Container(
        // padding: EdgeInsets.only(bottom: 20),
        //Add this to give height
        // height: MediaQuery.of(context).size.height * 0.2,
        color: colorBackground,
        child: BlocProvider<OrderingBloc>(
          create: (context) {
            return OrderingBloc(orderingRepository: sl())..add(NearbyLoad());
          },
          child: BlocConsumer<OrderingBloc, OrderingState>(
            listener: (context, state) {
              if (state is OrderingError) {
                showErrorToast(state.error, context);
                // ErrorDialog.showErrorDialog(
                //     context, state.error);
              }
              if (state is OrderingSessionError) {
                sessionExpiredLogOut(state.error);
              }
              /* --------------------------------------------- Listen to maintenance error, navigate to maintenance page */
              if (state is OrderingMaintenanceError) {
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
              return Container(
                // height: height * 0.3,
                margin: EdgeInsets.only(bottom: Platform.isAndroid ? 30 : 70),
                child: _buildTabNearby(context),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabNearby(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      child: BlocConsumer<OrderingBloc, OrderingState>(
        listener: ((context, state) {
          fToast = FToast();
          fToast.init(context);

          if (state is NearbyListStop) {
            showPaginationToast('No more outlets', context);
          }

          if (state is NearbyLoaded) {
            // first check if api returns any historical records,
            if (state.outlets.outlets != null &&
                state.outlets.outlets!.isNotEmpty) {
              // if history.records is neither null or empty
              // append to the global records variable (List<nearbyOutlets>)
              nearbyOutletList.addAll(state.outlets.outlets!);
              BlocProvider.of<OrderingBloc>(context).isNearbyFetching = false;
            }

            // comment: instead of working with the records from api,
            // records.add(state.history.records);
            // comment: work with the global variable that has the records from API added above
            nearbyListTiles = nearbyOutletList;
            BlocProvider.of<OrderingBloc>(context).isNearbyFetching = false;
          }

          // if (state is NearbySearchStop) {
          //   nearbyOutletDisplay = nearbyOutletList.where((brands) {
          //     var outletPlace = brands.merchantName!.toLowerCase();
          //     return outletPlace.contains(editingController.text.toLowerCase());
          //   }).toList();

          //   if (editingController.text.isEmpty) {
          //     nearbyOutletList = nearbyOutletList;
          //   }
          //   // else{
          //   //   nearbyOutletList
          //   // }
          // }
        }),
        builder: (context, state) {
          if (state is OrderingLoading) {
            return LoadingWidget();
          }

          // if (state is NearbyLoaded) {
          //   // first check if api returns any historical records,
          //   if (state.outlets.outlets != null &&
          //       state.outlets.outlets!.isNotEmpty) {
          //     // if history.records is neither null or empty
          //     // append to the global records variable (List<nearbyOutlets>)
          //     nearbyOutletList.addAll(state.outlets.outlets!);
          //     BlocProvider.of<OrderingBloc>(context).isNearbyFetching = false;
          //   }

          //   // comment: instead of working with the records from api,
          //   // records.add(state.history.records);
          //   // comment: work with the global variable that has the records from API added above
          //   nearbyListTiles = nearbyOutletList;
          //   BlocProvider.of<OrderingBloc>(context).isNearbyFetching = false;
          // }

          if (state is NearbyEmpty) {
            return Center(
              child: Container(
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

          // print('CURRENT STATE: $state');

          return Column(
            children: [
              Expanded(
                child: Container(
                  child: _buildNearbyList(context, state),
                ),
              ),
              state is NearbyNextLoading
                  ? Container(
                      // height: height * 0.05,
                      // margin: EdgeInsets.only(bottom: 10),
                      // color: colorTransparent,
                      child: LoadingWidget(),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNearbyList(BuildContext context, OrderingState state) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    if (state is NearbyLoaded) {
      nearbyOutlet = state.outlets;
    }

    // if (nearbyOutlet != null) {
    var nearbyListTiles = nearbyOutletList
        .map((nearbyList) => nearbyList.getNearbyListTile(
              context: context,
              state: state,
              onTap: () {
                Storage().distance = nearbyList.distance;
                Navigator.of(context)
                    .pushNamed(AqualifeRoutes.outletDetails,
                        arguments: OutletDetailsParameters(
                            outletId: nearbyList.id!,
                            outlet: nearbyList.place!))
                    .then((value) {});
              },
            ))
        .toList(growable: false);

    var searchOutletTiles = nearbyOutletDisplay
        .map((nearbyList) => nearbyList.getNearbyListTile(
            context: context,
            state: state,
            onTap: () {
              Storage().distance = nearbyList.distance;
              Navigator.of(context)
                  .pushNamed(AqualifeRoutes.outletDetails,
                      arguments: OutletDetailsParameters(
                          outletId: nearbyList.id!, outlet: nearbyList.place!))
                  .then((value) {});
            }))
        .toList(growable: false);

    ScrollController scrollControllerNearby = ScrollController();
    scrollControllerNearby.addListener(() async {
      if (scrollControllerNearby.position.maxScrollExtent ==
          scrollControllerNearby.position.pixels) {
        if (!BlocProvider.of<OrderingBloc>(context).isNearbyFetching) {
          BlocProvider.of<OrderingBloc>(context)
            ..isFirstLoad = false
            ..isNearbyFetching = true
            ..add(
              NearbyLoad(),
            );
        }
      }
    });

    return Container(
      // padding: EdgeInsets.only(bottom: 40),
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 40),
        // padding: EdgeInsets.zero,
        shrinkWrap: true,
        controller: scrollControllerNearby,
        itemCount: searchController.text.isEmpty
            ? nearbyOutletList.length
            : nearbyOutletDisplay.length,
        itemBuilder: (BuildContext context, int index) {
          return nearbyOutletDisplay.isEmpty
              ? nearbyListTiles[index]
              : searchOutletTiles[index];
        },
      ),
    );
  }

  // Widget for search function
  Widget _searchBar() {
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: colorGreyBox),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: searchController,

        style: TextStyle(
          color: colorBlack,
          fontSize: 15,
          fontWeight: FontWeight.w300,
          // height: 0.5,
        ),
        decoration: InputDecoration(
            hintText: "Search",
            hintStyle: TextStyle(
              color: colorSoftGrey,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontFamily: fontFamilyMain,
            ),
            icon: SizedBox(
              width: width * 0.05,
              child: Image(
                image: AssetImage(
                  'assets/icons/outlet/search.png',
                ),
              ),
            ),
            // suffixIcon: gotChangeValue.isNotEmpty
            //     ? InkWell(
            //         child: Container(
            //           color: colorBackground,
            //           margin: EdgeInsets.all(10),
            //           // width: width * 0.03,
            //           // height: height * 0.002,
            //           child: Icon(
            //             Icons.close,
            //             color: colorSoftGrey,
            //           ),
            //         ),
            //         onTap: () {
            //           searchController.clear();
            //         },
            //       )
            //     : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 15)),
        textInputAction: TextInputAction.search,
        onChanged: searchBrands,
        // onChanged: (value) {
        //   gotChangeValue = value;
        //   searchBrands(value);
        // },

        // onSubmitted: searchBrands,
      ),
    );
  }

  // This function is called whenever the text field changes
  searchBrands(String text) {
    text = text.toLowerCase();

    if (text.isNotEmpty) {
      nearbyOutletDisplay = nearbyOutletList.where((brands) {
        var outletPlace = brands.merchantName!.toLowerCase();
        var outleAddress = brands.address!.toLowerCase();
        return outletPlace.contains(text) || outleAddress.contains(text);
      }).toList();

      setState(() {
        nearbyOutletDisplay;
      });
    } else {
      setState(() {
        nearbyOutletDisplay = [];
      });
    }
  }

  void sessionExpiredLogOut(String error) {
    showErrorToast('$error\nYou will be logged out.', context);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
    Navigator.of(context).pushNamedAndRemoveUntil(
        AqualifeRoutes.login, (Route<dynamic> route) => false);
  }
}
