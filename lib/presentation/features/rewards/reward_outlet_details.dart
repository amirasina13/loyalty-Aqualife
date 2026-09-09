import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'reward.dart';

class RewardOutletDetailsParameters {
  final int outletId;
  final String outletName;

  const RewardOutletDetailsParameters(
      {required this.outletId, required this.outletName});
}

class RewardOutletDetailsScreen extends StatefulWidget {
  final RewardOutletDetailsParameters parameters;

  const RewardOutletDetailsScreen({super.key, required this.parameters});

  @override
  State<RewardOutletDetailsScreen> createState() =>
      _RewardOutletDetailsScreenState();
}

class _RewardOutletDetailsScreenState extends State<RewardOutletDetailsScreen> {
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
          systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorBackground,
            statusBarIconBrightness: Brightness.dark,
          ),
          title: Text(
            widget.parameters.outletName,
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          body: BlocProvider<RewardBloc>(
              create: (context) {
                return RewardBloc(context: context, rewardRepository: sl())
                  ..add(RewardOutletDetailsLoad(
                    outletId: (widget.parameters.outletId),
                  ));
              },
              child: RewardOutletDetailsWrapper(
                  outletId: widget.parameters.outletId)),
          bottomMenuIndex: 0,
        );
      },
    );
  }
}

class RewardOutletDetailsWrapper extends StatefulWidget {
  final int outletId;

  const RewardOutletDetailsWrapper({super.key, required this.outletId});

  @override
  AqualifeWrapperState<RewardOutletDetailsWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _RewardOutletDetailsWrapperState(outletId);
}

class _RewardOutletDetailsWrapperState
    extends AqualifeWrapperState<RewardOutletDetailsWrapper> {
  final int outletId;

  _RewardOutletDetailsWrapperState(this.outletId);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RewardBloc, RewardState>(
      listener: (context, state) {
        fToast = FToast();
        fToast.init(context);

        if (state is RewardError) {
          Navigator.pop(context);

          showErrorToast(state.error, context);
        }
        if (state is RewardSessionError) {
          sessionExpiredLogOut(state.error);
        }
      },
      builder: (context, state) {
        return getPageView(<Widget>[
          RewardOutletDetailsView(
            changeView: changePage,
            outletId: outletId,
          ),
        ]);
      },
    );
  }
}
