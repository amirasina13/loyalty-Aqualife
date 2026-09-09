import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../otp/otp.dart';
import '../wrapper.dart';
import 'forgot_pass.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorWhite,
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: colorBackground,
          body: ForgotPassWrapper(),
        ),
      ),
    );
  }
}

class ForgotPassWrapper extends StatefulWidget {
  const ForgotPassWrapper({super.key});

  @override
  AqualifeWrapperState<ForgotPassWrapper> createState() =>
      _ForgotPassWrapperState();
}

class _ForgotPassWrapperState extends AqualifeWrapperState<ForgotPassWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ForgotPassBloc>(
          create: (context) => ForgotPassBloc(userRepository: sl()),
        ),
        BlocProvider<OtpBloc>(
          create: (context) => OtpBloc(userRepository: sl()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ForgotPassBloc, ForgotPassState>(
              listener: (context, state) {
            /* ----------------------------------------------------------------- Listen to Credit error, popup error dialog */
            // if (state is ForgotPassError) {
            //   showErrorToast(state.error, context);
            // }
            // if (state is CreditNetworkError) {
            //   showErrorToast(state.error, context);
            // }
            // if (state is CreditSessionError) {
            //   sessionExpiredLogOut(state.error);
            // }
          }),
          BlocListener<OtpBloc, OtpState>(listener: (context, state) {
            /* ----------------------------------------------------------------- Listen to Security error, popup error dialog */
            if (state is OtpError) {
              showErrorToast(state.error, context);
            }
          }),
        ],
        child: getPageView(<Widget>[
          ForgetView(changeView: changePage),
          // ResetView(changeView: changePage),
        ]),
      ),
    );
  }
}
