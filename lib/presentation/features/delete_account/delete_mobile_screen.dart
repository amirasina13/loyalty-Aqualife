import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'delete_acc.dart';

class DeleteAccMobileScreen extends StatefulWidget {
  const DeleteAccMobileScreen({super.key});

  @override
  State<DeleteAccMobileScreen> createState() => _DeleteAccMobileScreenState();
}

class _DeleteAccMobileScreenState extends State<DeleteAccMobileScreen> {
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
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: AqualifeScaffold(
            showAppbar: false,
            body: DeleteAccMobileWrapper(),
            bottomMenuIndex: 4,
            showBottomNavigator: false,
          ),
        );
      },
    );
  }
}

class DeleteAccMobileWrapper extends StatefulWidget {
  const DeleteAccMobileWrapper({super.key});

  @override
  AqualifeWrapperState<DeleteAccMobileWrapper> createState() =>
      _DeleteAccMobileWrapperState();
}

class _DeleteAccMobileWrapperState
    extends AqualifeWrapperState<DeleteAccMobileWrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeleteAccBloc>(
      create: (context) {
        return DeleteAccBloc(userRepository: sl());
        // return DeleteAccBloc(userRepository: sl())..add(DeleteAccLoad());
      },
      child: BlocConsumer<DeleteAccBloc, DeleteAccState>(
        listener: (context, state) {},
        builder: (context, state) {
          return getPageView(<Widget>[
            DeleteMobileView(changeView: changePage),
          ]);
        },
      ),
    );
  }
}
