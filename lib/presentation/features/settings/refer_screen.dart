import 'package:flutter/services.dart';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/routes.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../refer/refer.dart';
import '../wrapper.dart';
import 'setting.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({super.key});

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
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
          title: Text(
            'Refer Friends',
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          body: ReferWrapper(),
          bottomMenuIndex: 4,
          systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorWhite,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
      },
    );
  }
}

class ReferWrapper extends StatefulWidget {
  const ReferWrapper({super.key});

  @override
  AqualifeWrapperState<ReferWrapper> createState() => _ReferWrapperState();
}

class _ReferWrapperState extends AqualifeWrapperState<ReferWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReferBloc>(
          create: (context) =>
              ReferBloc(userRepository: sl())..add(ReferLoad()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ReferBloc, ReferState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is ReferError) {
                showErrorToast(state.error, context);
                BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
              }
              if (state is ReferNetworkError) {
                showErrorToast(state.error, context);
                Navigator.pop(context);
              }
              if (state is ReferSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is ReferMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.maintenanceScreen,
                    (Route<dynamic> route) => false,
                    arguments: MaintenanceParameters(message: state.message));
              }
            },
          )
        ],
        child: getPageView(<Widget>[
          ReferView(changeView: changePage),
        ]),
        // ),
      ),
    );
  }
}
