import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../../config/storage.dart';

import '../../../../data/model/model.dart';
import '../../../widgets/independent/independent.dart';
import '../../../widgets/extensions/outlet_operation_view.dart';
import '../reward.dart';

class RewardOutletDetailsView extends StatefulWidget {
  final Function? changeView;
  final int outletId;

  const RewardOutletDetailsView(
      {super.key, this.changeView, required this.outletId});

  @override
  State<RewardOutletDetailsView> createState() =>
      _RewardOutletDetailsViewState();
}

class _RewardOutletDetailsViewState extends State<RewardOutletDetailsView>
    with TickerProviderStateMixin {
  bool isProcessing = false;
  List<Operation> operations = [];
  List<VoucherOutlet> outletVoucher = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late TabController _tabController;
  late ScrollController _scrollController;

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
    BlocProvider.of<RewardBloc>(context)
        .add(RewardOutletDetailsLoad(outletId: widget.outletId));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // double circleRadius = 120.0;

    return Container(
      color: colorBackground,
      // margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
      child: BlocConsumer<RewardBloc, RewardState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is RewardOutletDetailsLoading) {
            return LoadingWidget();
          }
          if (state is RewardOutletDetailsLoaded) {
            var detail = state.details;
            var outletId = detail.id;
            var operation = state.details.operations!.length;
            var distance = Storage().distance;
            var dist = double.parse(distance!);

            if (outletId != null) {
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refreshData,
                child: SingleChildScrollView(
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
                              padding: EdgeInsets.only(bottom: 25, top: 20),
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
                                      height: height * 0.07,
                                      width: height * 0.07,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: secondaryColor,
                                        border: Border.all(
                                            color: colorWhite, width: 2),
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
                                      launchMapDirection(detail, height, width);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: marginHorizontal),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10, bottom: 5),
                                    child: Text(
                                      detail.merchantName!,
                                      style: TextStyle(
                                        color: colorBlack,
                                        fontFamily: fontFamilyInter,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                      textScaler:
                                          TextScaler.linear(scaleFactor),
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
                                      textScaler:
                                          TextScaler.linear(scaleFactor),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                child: Text(
                                  '${dist.toStringAsFixed(2)} km',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: colorTextGrey,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: fontFamilyInter),
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              marginHorizontal, 20, marginHorizontal, 20),
                          child: HtmlWidget(
                            detail.merchantDesc!,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              marginHorizontal, 20, marginHorizontal, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    textScaler: TextScaler.linear(scaleFactor),
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
                              marginHorizontal, 10, marginHorizontal, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                  textScaler: TextScaler.linear(scaleFactor),
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              marginHorizontal, 10, marginHorizontal, 20),
                          // height: height * 0.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                        child: _buildOperationListView(
                                            context, state),
                                      ),
                                    )
                                  : Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                    ),
                            ],
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
          return Container();
        },
      ),
    );
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

  Widget _buildOperationListView(BuildContext context, RewardState state) {
    if (state is RewardOutletDetailsLoaded) {
      operations = state.details.operations!;
      // return Container(child: Text('${state.details.operations!.length}'));

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
}
