import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes.dart';
import '../../../../data/model/model.dart';
import '../../../widgets/independent/independent.dart';
import '../bulletin.dart';

class UpcomingView extends StatefulWidget {
  final Function changeView;
  const UpcomingView({super.key, required this.changeView});

  @override
  State<UpcomingView> createState() => _UpcomingViewState();
}

class _UpcomingViewState extends State<UpcomingView> {
  /* --------------------------------------------------------------------------- Declare the parameter */
  List<Bulletin> upcoming = [];

  @override
  void initState() {
    super.initState();
  }

  /* --------------------------------------------------------------------------- Main user interface */
  @override
  Widget build(BuildContext context) {
    /* ------------------------------------------------------------------------- Declare the height and width based on mobile screen view */
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    /* ------------------------------------------------------------------------- Visual Scaffold */
    return Scaffold(
      backgroundColor: colorWhite,
      /* ----------------------------------------------------------------------- Scaffold body */
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
        child: SingleChildScrollView(
          child: Container(
            color: colorWhite,
            /* ----------------------------------------------------------------- Bulletin bloc. Lisen to bulletin state */
            child: BlocBuilder<BulletinBloc, BulletinState>(
              builder: (context, state) {
                /* ------------------------------------------------------------- if state is BulletinLoading, will show loading progress indicator */
                if (state is BulletinLoading) {
                  return SizedBox(
                    height: height * 0.8,
                    child: LoadingWidget(),
                  );
                }
                /* ------------------------------------------------------------- If no bulletin in list, will show "No available news" text and icon */
                if (state is BulletinEmpty) {
                  return Center(
                    child: SizedBox(
                      height: height * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /* Empty news icon */
                          Container(
                            height: width * 0.2,
                            width: width * 0.2,
                            // padding: EdgeInsets.symmetric(
                            //     vertical: height / 8, horizontal: width),
                            // child: noBulletins,
                            decoration: const BoxDecoration(
                              // shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image:
                                    AssetImage('assets/icons/empty_news.png'),
                              ),
                            ),
                          ),
                          /* Set the space between icons and text vertically */
                          SizedBox(height: height * 0.03),
                          /* Empty news text */
                          Text(
                            "No Upcoming Events",
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
                /* ------------------------------------------------------------- else will show the bulletin list widget */
                return _buildBulletinListView(context, state);
              },
            ),
          ),
        ),
      ),
    );
  }

  /* --------------------------------------------------------------------------- Widget for showing bulletin list */
  Widget _buildBulletinListView(BuildContext context, BulletinState state) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    /* IF API call success and not empty, set List variable */
    if (state is BulletinListLoaded) {
      upcoming = state.bulletins;
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      itemCount: upcoming.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        mainAxisSpacing: height * 0.02,
        // crossAxisSpacing: 5,
      ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: colorBackground,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    // child: InkWell(
                    child: Container(
                      // height: height * 0.05,
                      margin: EdgeInsets.only(
                          right: index == upcoming.length - 1 ? 0 : 3),
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
              ),
              // Container(
              //   width: width * 0.25,
              //   // height: height * 0.05,
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
        );
      },
    );
  }
}
