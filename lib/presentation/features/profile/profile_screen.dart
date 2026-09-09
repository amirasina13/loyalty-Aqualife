import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';
import '../../widgets/independent/independent.dart';
import '../country/country.dart';
import '../profile/profile.dart';
import '../wrapper.dart';

class ProfileRegParameters {
  final Map profile;

  const ProfileRegParameters({required this.profile});
}

class RegisterProfileScreen extends StatefulWidget {
  final ProfileRegParameters parameters;

  const RegisterProfileScreen({super.key, required this.parameters});

  @override
  State<RegisterProfileScreen> createState() => _RegisterProfileScreenState();
}

class _RegisterProfileScreenState extends State<RegisterProfileScreen> {
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
          ),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: colorWhite,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: colorBackground,
                  statusBarIconBrightness: Brightness.dark,
                ),
                title: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'User Profile',
                    style: TextStyle(
                      fontFamily: fontFamilyMain,
                      color: colorBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    textScaler: TextScaler.linear(scaleFactor),
                  ),
                ),
                elevation: 0,
              ),
              body: ProfileWrapper(
                profile: widget.parameters.profile,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileWrapper extends StatefulWidget {
  final Map profile;

  const ProfileWrapper({super.key, required this.profile});

  @override
  AqualifeWrapperState<ProfileWrapper> createState() =>
      // ignore: no_logic_in_create_state
      _ProfileWrapperState(profile);
}

class _ProfileWrapperState extends AqualifeWrapperState<ProfileWrapper> {
  final Map profile;
  _ProfileWrapperState(this.profile);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) =>
              ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        ),
        BlocProvider<CountryBloc>(
          create: (context) => CountryBloc()..add(CountryLoad()),
        ),
      ],
      child: getPageView(
        <Widget>[
          ProfileRegisterView(
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
