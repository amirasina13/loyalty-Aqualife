import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/routes.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../rewards/reward.dart';
import '../wrapper.dart';
import 'ordering.dart';

class OrderingOutletParameters {
  final int brandsId;

  const OrderingOutletParameters({required this.brandsId});
}

class OrderingOutletScreen extends StatefulWidget {
  final OrderingOutletParameters parameters;

  const OrderingOutletScreen({super.key, required this.parameters});

  @override
  State<OrderingOutletScreen> createState() => _OrderingOutletScreenState();
}

class _OrderingOutletScreenState extends State<OrderingOutletScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileProcessing) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: colorWhite,
              child: LoadingWidget(),
            );
          }
          return AqualifeScaffold(
            // systemUiOverlayStyle: SystemUiOverlayStyle(
            //   statusBarColor: colorBackground,
            //   statusBarIconBrightness: Brightness.dark,
            // ),
            showAppbar: false,
            body: OrderingOutletWrapper(
              brandsId: widget.parameters.brandsId,
            ),
            bottomMenuIndex: 1,
            isShow: true,
            canClick: true,
          );
        },
      ),
    );
  }
}

class OrderingOutletWrapper extends StatefulWidget {
  final int brandsId;

  const OrderingOutletWrapper({super.key, required this.brandsId});

  @override
  AqualifeWrapperState<OrderingOutletWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _OrderingOutletWrapperState(brandsId);
}

class _OrderingOutletWrapperState
    extends AqualifeWrapperState<OrderingOutletWrapper> {
  final int brandsId;
  _OrderingOutletWrapperState(this.brandsId);

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderingBloc>(create: (context) {
          // Storage().orderingCheck = 1;
          return OrderingBloc(orderingRepository: sl())..add(OrderingCheck());
        }),
        BlocProvider<RewardBloc>(create: (context) {
          return RewardBloc(context: context, rewardRepository: sl());
        }),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<OrderingBloc, OrderingState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is OrderingError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.home,
                  (Route<dynamic> route) => false,
                );
                showErrorToast(state.error, context);
                // ErrorDialog.showErrorDialog(context, state.error);
              }
              if (state is OrderingSessionError) {
                sessionExpiredLogOut(state.error);
              }
              /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
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
          )
        ],
        child: getPageView(<Widget>[
          OrderingOutletView(
            changeView: changePage,
            brandsId: brandsId,
          ),
        ]),
      ),
    );
  }
}
