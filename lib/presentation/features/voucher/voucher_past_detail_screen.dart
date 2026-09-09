import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/routes.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'voucher.dart';

class VoucherPastDetailsParameters {
  final int voucherId;
  // final String title;

  const VoucherPastDetailsParameters({required this.voucherId});
}

class VoucherPastDetailsScreen extends StatefulWidget {
  final VoucherPastDetailsParameters parameters;

  const VoucherPastDetailsScreen({super.key, required this.parameters});

  @override
  State<VoucherPastDetailsScreen> createState() =>
      _VoucherPastDetailsScreenState();
}

class _VoucherPastDetailsScreenState extends State<VoucherPastDetailsScreen> {
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
        // Storage().voucherId = widget.parameters.voucherId;
        // Storage().titlePasscodeRoute = widget.parameters.title;

        return VoucherPastDetailsWrapper(
            voucherId: widget.parameters.voucherId);
      },
    );
  }
}

class VoucherPastDetailsWrapper extends StatefulWidget {
  final int voucherId;

  const VoucherPastDetailsWrapper({super.key, required this.voucherId});

  @override
  AqualifeWrapperState<VoucherPastDetailsWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _VoucherPastDetailsWrapperState(voucherId);
}

class _VoucherPastDetailsWrapperState
    extends AqualifeWrapperState<VoucherPastDetailsWrapper> {
  int voucherId;

  _VoucherPastDetailsWrapperState(this.voucherId);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VoucherBloc>(
          create: (context) {
            ProfileBloc profileBloc = ProfileBloc(userRepository: sl());
            return VoucherBloc(profileBloc: profileBloc)
              ..add(VoucherPastDetailsLoad(voucherId: voucherId));
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<VoucherBloc, VoucherState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              // if (state is VoucherError) {
              //   // BlocProvider.of<VoucherBloc>(context).add(VoucherOutletCheck());
              //   showErrorToast(state.error, context);

              //   Navigator.pop(context);
              // }
              if (state is VoucherSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is VoucherNetworkError) {
                showErrorToast('No internet connection', context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.home, (Route<dynamic> route) => false);
              }
              /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
              if (state is VoucherMaintenanceError) {
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
          ),
        ],
        child: getPageView(
          <Widget>[
            VoucherPastDetailsView(
              changeView: changePage,
              voucherId: voucherId,
            ),
          ],
        ),
      ),
    );
  }

  // }
}
