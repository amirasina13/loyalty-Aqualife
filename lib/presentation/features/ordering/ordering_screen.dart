import 'dart:io';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../locator.dart';
import '../../features/profile/profile.dart';
import '../../features/wrapper.dart';
import '../../widgets/independent/independent.dart';
import 'ordering.dart';

class OrderingScreenParameters {
  final int selectedTab;

  const OrderingScreenParameters({required this.selectedTab});
}

class OrderingScreen extends StatefulWidget {
  final OrderingScreenParameters parameters;

  const OrderingScreen(
      {super.key, required this.parameters}); //, required this.parameters

  @override
  State<OrderingScreen> createState() => _OrderingScreenState();
}

class _OrderingScreenState extends State<OrderingScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
        if (profileState is ProfileProcessing) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: colorWhite,
            child: LoadingWidget(),
          );
        }

        return AqualifeScaffold(
          body: OrderingWrapper(
            selectedTab: widget.parameters.selectedTab,
          ),
          extendBodyBehindAppBar: true,
          // appBarColor: colorTransparent,

          // title: Container(
          //   height: MediaQuery.of(context).size.height * 0.15,
          //   padding: EdgeInsets.symmetric(vertical: 10),
          //   child: Image(
          //     image: AssetImage('assets/logo/Aqualife_text_black.png'),
          //     fit: BoxFit.contain,
          //   ),
          // ),
          showAppbar: false,
          bottomMenuIndex: 1,
          isShow: true,
          canClick: false,
        );
      }),
    );
  }
}

class OrderingWrapper extends StatefulWidget {
  final int selectedTab;

  const OrderingWrapper({super.key, required this.selectedTab});

  @override
  AqualifeWrapperState<OrderingWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _OrderingWrapperState(
          selectedTab: selectedTab); //merchantList: merchantList
}

class _OrderingWrapperState extends AqualifeWrapperState<OrderingWrapper> {
  final int selectedTab;
  _OrderingWrapperState({required this.selectedTab});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderingBloc>(create: (context) {
          // return OrderingBloc()..add(OrderingCheck());
          return OrderingBloc(orderingRepository: sl());
        }),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<OrderingBloc, OrderingState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is OrderingError) {
                showErrorToast(state.error, context);
              }
              if (state is OrderingSessionError) {
                sessionExpiredLogOut(state.error);
              }

              // If location is not enable, popup dialog
              if (state is OrderingLocationRequested) {
                YesNoDialog.showYesNoDialog(
                  context,
                  'Enable Location Service',
                  Platform.isAndroid ? androidLocText : iosLocText,
                  colorBlack,
                  TextAlign.justify,
                  _buildEnableButton(context),
                );
              }

              // if (state is OrderingStarted) {
              //   print('READ HERE!');
              //   // BlocProvider.of<OrderingBloc>(context).add(NearbyLoad());
              // }
            },
          )
        ],
        child: getPageView(<Widget>[
          OrderingView(
            changeView: changePage,
            selectedTab: selectedTab,
          ),
        ]),
      ),
    );
    // return BlocProvider<OrderingBloc>(
    //   create: (context) {
    //     return OrderingBloc()..add(event); //..add(BrandsLoad());
    //   },
    //   child: BlocConsumer<OrderingBloc, OrderingState>(
    //     listener: (context, state) {
    //       fToast = FToast();
    //       fToast.init(context);

    //       if (state is OrderingError) {
    //         showErrorToast(state.error, context);
    //         // ErrorDialog.showErrorDialog(context, state.error);
    //       }
    //       if (state is OrderingSessionError) {
    //         sessionExpiredLogOut(state.error);
    //       }
    //       if (state is OrderingNetworkError) {
    //         showErrorToast('No internet connection', context);
    //         // ErrorIconDialog.showErrorDialog(context, 'No internet connection');
    //         Navigator.of(context).pushNamedAndRemoveUntil(
    //              AqualifeRoutes.home, (Route<dynamic> route) => false);
    //       }
    //     },
    //     builder: (context, state) {
    //       return getPageView(<Widget>[
    //         OrderingView(
    //           changeView: changePage,
    //           // merchantList: merchantList,
    //         ),
    //       ]);
    //     },
    //   ),
    // );
  }

  // For enable buton in location dialog
  Widget _buildEnableButton(BuildContext context) {
    return AqualifeStyleButton(
      title: 'Continue',
      backgroundColor: mainColor,
      onPressed: () async {
        BlocProvider.of<OrderingBloc>(context).add(OrderingLocationEnable());
        Navigator.pop(context);
      },
    );
  }
}
