import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/routes.dart';
import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../profile/profile.dart';
import '../rewards/reward.dart';
import '../wrapper.dart';
import 'voucher.dart';

class VoucherManualScreen extends StatefulWidget {
  const VoucherManualScreen({super.key});

  @override
  State<VoucherManualScreen> createState() => _VoucherManualScreenState();
}

class _VoucherManualScreenState extends State<VoucherManualScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileProcessing) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: colorWhite,
            child: LoadingWidget(),
          );
        }
        return VoucherManualWrapper();
      },
    );
  }
}

class VoucherManualWrapper extends StatefulWidget {
  const VoucherManualWrapper({super.key});

  @override
  AqualifeWrapperState<VoucherManualWrapper> createState() =>
      _VoucherManualWrapperState();
}

class _VoucherManualWrapperState
    extends AqualifeWrapperState<VoucherManualWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RewardBloc>(
          create: (context) =>
              RewardBloc(context: context, rewardRepository: sl()),
        ),
        BlocProvider<VoucherBloc>(
          create: (context) =>
              VoucherBloc(profileBloc: ProfileBloc(userRepository: sl())),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RewardBloc, RewardState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is RewardError) {
                showErrorToast(state.error, context);
              }
              if (state is RewardSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is RewardNetworkError) {
                showErrorToast('No internet connection', context);

                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.home, (Route<dynamic> route) => false);
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          VoucherManualView(
            changeView: changePage,
          ),
        ]),
      ),
    );
  }
}
