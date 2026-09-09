import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'setup.dart';

class VMuslimParameters {
  final Map profile;

  const VMuslimParameters({required this.profile});
}

class VMuslimScreen extends StatefulWidget {
  final VMuslimParameters parameters;

  const VMuslimScreen({super.key, required this.parameters});

  @override
  State<VMuslimScreen> createState() => _VMuslimScreenState();
}

class _VMuslimScreenState extends State<VMuslimScreen> {
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

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: colorWhite,
            statusBarColor: colorWhite,
          ),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: colorWhite,
              body: VMuslimWrapper(
                profile: widget.parameters.profile,
              ),
            ),
          ),
        );
      },
    );
  }
}

class VMuslimWrapper extends StatefulWidget {
  final Map profile;

  const VMuslimWrapper({super.key, required this.profile});

  @override
  AqualifeWrapperState<VMuslimWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _VMuslimWrapperState(profile);
}

class _VMuslimWrapperState extends AqualifeWrapperState<VMuslimWrapper> {
  final Map profile;
  _VMuslimWrapperState(this.profile);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SetupBloc>(
          create: (context) => SetupBloc(userRepository: sl()),
        ),
        // BlocProvider<ProfileBloc>(
        //   create: (context) =>
        //       ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        // ),
        // BlocProvider<CountryBloc>(
        //   create: (context) => CountryBloc()..add(CountryLoad()),
        // ),
      ],
      child: getPageView(
        <Widget>[
          VMuslimView(
            changeView: changePage,
            profile: profile,
          ),
        ],
      ),
    );
    // return getPageView(<Widget>[
    //   ProfileRegisterView(
    //     changeView: changePage,
    //     profile: profile,
    //   ),
    // ]);
  }
}
