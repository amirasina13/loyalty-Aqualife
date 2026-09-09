import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes.dart';
import '../../../../data/model/model.dart';
import '../../../widgets/extensions/bulletin_list_view.dart';
import '../../../widgets/independent/independent.dart';
import '../bulletin.dart';

class BulletinView extends StatefulWidget {
  final Function changeView;
  const BulletinView({super.key, required this.changeView});

  @override
  State<BulletinView> createState() => _BulletinViewState();
}

class _BulletinViewState extends State<BulletinView> {
  /* --------------------------------------------------------------------------- Declare the parameter */
  List<Bulletin> bulletins = [];
  bool isProcessing = false;
  // Image? noBulletins;

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
                            "No Highlight Yet",
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
    // var height = MediaQuery.of(context).size.height;

    /* IF API call success and not empty, set List variable */
    if (state is BulletinListLoaded) {
      bulletins = state.bulletins;
    }

    /* the extension for listview bulletin. if want to change the design can go
     to getBulletinTile() in widgets/extension/bulletin_list_view.dart */
    var bulletinTiles = bulletins
        .map((bulletin) => bulletin.getBulletinTile(
            context: context,
            onTap: isProcessing
                ? () {}
                : () {
                    Navigator.of(context).pushNamed(
                        AqualifeRoutes.bulletinDetails,
                        arguments: BulletinDetailsParameters(
                            bulletinId: bulletin.id!, title: bulletin.name!));
                  }))
        .toList(growable: false);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: bulletins.length,
      itemBuilder: (context, index) {
        return bulletinTiles[index];
      },
    );
  }
}
