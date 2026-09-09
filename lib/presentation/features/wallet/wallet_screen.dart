import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/config.dart';
import '../../../config/routes.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../security_pin/security_pin.dart';
import '../voucher/voucher.dart';
import '../wrapper.dart';
import 'wallet.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorWhite,
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
        return WalletWrapper();
      }),
    );
  }
}

class WalletWrapper extends StatefulWidget {
  const WalletWrapper({super.key});

  @override
  AqualifeWrapperState<WalletWrapper> createState() => _WalletWrapperState();
}

class _WalletWrapperState extends AqualifeWrapperState<WalletWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WalletBloc>(
          create: (context) =>
              WalletBloc(userRepository: sl())..add(WalletLoad()),
        ),
        BlocProvider<SecurityBloc>(
          create: (context) => SecurityBloc(),
        ),
        BlocProvider<VoucherBloc>(
          create: (context) {
            ProfileBloc profileBloc = ProfileBloc(userRepository: sl());
            return VoucherBloc(profileBloc: profileBloc)
              ..add(VoucherCategoriesLoad(filterBy: 'all', filterValue: 'all'));
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<WalletBloc, WalletState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);
              if (state is WalletError) {
                showErrorToast(state.error, context);
              }
              if (state is WalletNetworkError) {
                showErrorToast(state.error, context);
              }
              if (state is WalletSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is WalletMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.maintenanceScreen,
                    (Route<dynamic> route) => false,
                    arguments: MaintenanceParameters(message: state.message));
              }
            },
          ),
          BlocListener<SecurityBloc, SecurityState>(
            listener: (context, securityState) {
              if (securityState is SecurityError) {
                showErrorToast(securityState.error, context);
              }
              if (securityState is SecuritySessionError) {
                sessionExpiredLogOut(securityState.error);
              }
            },
          ),
          BlocListener<VoucherBloc, VoucherState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is VoucherError) {
                showErrorToast(state.error, context);
              }
              if (state is VoucherSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is VoucherNetworkError) {
                showErrorToast('No internet connection', context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.home, (Route<dynamic> route) => false);
              }
              if (state is VoucherOutletLocationDisabled) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.home, (Route<dynamic> route) => false);
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          WalletView(changeView: changePage),
        ]),
      ),
    );
  }
}
