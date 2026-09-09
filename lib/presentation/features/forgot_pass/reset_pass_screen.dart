import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../otp/otp.dart';
import '../wrapper.dart';
import 'forgot_pass.dart';

class ResetPassParameters {
  final String email;
  final String vToken;

  const ResetPassParameters({
    required this.email,
    required this.vToken,
  });
}

class ResetPassScreen extends StatefulWidget {
  final ResetPassParameters? parameters;

  const ResetPassScreen({super.key, this.parameters});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
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
          body: ResetPassWrapper(
            email: widget.parameters!.email,
            vToken: widget.parameters!.vToken,
          ),
        ),
      ),
    );
  }
}

class ResetPassWrapper extends StatefulWidget {
  final String email;
  final String vToken;

  const ResetPassWrapper({
    super.key,
    required this.email,
    required this.vToken,
  });

  @override
  AqualifeWrapperState<ResetPassWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _ResetPassWrapperState(email, vToken);
}

class _ResetPassWrapperState extends AqualifeWrapperState<ResetPassWrapper> {
  final String email;
  final String vToken;

  _ResetPassWrapperState(this.email, this.vToken);

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
          ForcePassView(
            changeView: changePage,
            email: email,
            vToken: vToken,
          ),
        ]),
      ),
    );
  }
}
