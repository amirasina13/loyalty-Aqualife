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
import '../security_pin/security_pin.dart';
import '../wrapper.dart';
import 'setting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorWhite,
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
          extendBodyBehindAppBar: true,
          showAppbar: false,
          body: SettingWrapper(),
          bottomMenuIndex: 4,
          isShow: true,
          canClick: false,
          isCenterTitle: false,
        );
      }),
    );
  }
}

class SettingWrapper extends StatefulWidget {
  const SettingWrapper({super.key});

  @override
  AqualifeWrapperState<SettingWrapper> createState() => _SettingWrapperState();
}

class _SettingWrapperState extends AqualifeWrapperState<SettingWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) =>
              ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        ),
        BlocProvider<SecurityBloc>(
          create: (context) => SecurityBloc(),
        )
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is ProfileError) {
                showErrorToast(state.error, context);
                BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
              }
              if (state is ProfileSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is ProfileMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.maintenanceScreen,
                    (Route<dynamic> route) => false,
                    arguments: MaintenanceParameters(message: state.message));
              }
            },
          ),
          BlocListener<SecurityBloc, SecurityState>(
            listener: (context, state) {
              if (state is SecuritySessionError) {
                sessionExpiredLogOut(state.error);
              }
            },
          )
        ],
        child: getPageView(<Widget>[
          SettingView(changeView: changePage),
        ]),
      ),
    );
  }
}
