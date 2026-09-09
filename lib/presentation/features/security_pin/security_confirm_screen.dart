import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/independent/independent.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'security_pin.dart';

class SecurityConfirmScreen extends StatefulWidget {
  const SecurityConfirmScreen({super.key});

  @override
  State<SecurityConfirmScreen> createState() => _SecurityConfirmScreenState();
}

class _SecurityConfirmScreenState extends State<SecurityConfirmScreen> {
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
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
          ),
          body: SecurityConfirmWrapper(),
          backgroundColor: colorBackground,
        );
      }),
    );
  }
}

class SecurityConfirmWrapper extends StatefulWidget {
  const SecurityConfirmWrapper({super.key});

  @override
  AqualifeWrapperState<SecurityConfirmWrapper> createState() =>
      _SecurityConfirmWrapperState();
}

class _SecurityConfirmWrapperState
    extends AqualifeWrapperState<SecurityConfirmWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SecurityBloc>(
          create: (context) => SecurityBloc(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          // BlocListener<ProfileBloc, ProfileState>(
          //   listener: (context, state) {
          //     fToast = FToast();
          //     fToast.init(context);

          //     if (state is ProfileError) {
          //       showErrorToast(state.error, context);
          //       BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
          //     }
          //     if (state is ProfileSessionError) {
          //       sessionExpiredLogOut(state.error);
          //     }
          //   },
          // ),
          BlocListener<SecurityBloc, SecurityState>(
            listener: (context, state) {
              if (state is SecuritySessionError) {
                sessionExpiredLogOut(state.error);
              }
            },
          )
        ],
        child: getPageView(
          <Widget>[
            SecurityConfirmView(changeView: changePage),
          ],
        ),
      ),
    );
  }
}
