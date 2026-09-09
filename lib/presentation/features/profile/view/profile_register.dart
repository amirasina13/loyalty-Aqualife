import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../../config/config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../../../config/global_setup.dart';
import '../../../../config/routes.dart';
import '../../../../config/storage.dart';

import '../../../../data/model/model.dart';
import '../../../../domain/entities/validator.dart';
import '../../../widgets/data_driven/datadriven.dart';
import '../../../widgets/independent/independent.dart';
import '../../authentication/authentication.dart';
import '../../country/country.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../photo/photo.dart';
import '../../verify_email/verify_email.dart';
import '../profile.dart';

class ProfileRegisterView extends StatefulWidget {
  final Function? changeView;
  final Map profile;

  const ProfileRegisterView(
      {super.key, this.changeView, required this.profile});

  @override
  State<ProfileRegisterView> createState() => _ProfileRegisterViewState();
}

class _ProfileRegisterViewState extends State<ProfileRegisterView> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _muslimController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final GlobalKey<AqualifeInputFieldState> _fullNameKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> _firstNameKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> _lastNameKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> _dobKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> _genderKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> _muslimKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> _contactKey = GlobalKey();
  final GlobalKey<AqualifeSelectValueState> codeKey = GlobalKey();

  String errorfield = '';
  String? path, imageBytes;

  bool isProcessing = false;
  bool error = false;
  bool isMuslim = false;
  String newDate = '';
  String errorFullName = '',
      errorFirstName = '',
      errorLastName = '',
      errorEmail = '',
      errorDob = '',
      errorGender = '',
      errorMuslim = '',
      errorContact = '';
  late FocusNode _fullNameFocus,
      _firstNameFocus,
      _lastNameFocus,
      _emailFocus,
      _dobFocus,
      _genderFocus,
      _muslimFocus,
      _contactFocus;
  String selectedCode = '60';
  DateTime? dateSelect;

  List<String> getGender = ["Male", "Female"];
  List<String> getMuslim = [
    "Muslim-Friendly Content Only",
    "Include Non-Halal Content"
  ];
  List<String> getCode = [];

  Image? image;
  String? profileImage;
  late File _image;
  var photoBloc = PhotoBloc();
  final ImagePicker _picker = ImagePicker();
  final MyConnectivity _connectivity = MyConnectivity.instance;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    _setProfileData();

    _fullNameFocus = FocusNode();
    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode();
    _dobFocus = FocusNode();
    _genderFocus = FocusNode();
    _muslimFocus = FocusNode();
    _contactFocus = FocusNode();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _lastNameController.dispose();
    _firstNameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _muslimController.dispose();
    _contactController.dispose();

    // Clean up the focus node when the Form is disposed.
    _fullNameFocus.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _dobFocus.dispose();
    _genderFocus.dispose();
    _muslimFocus.dispose();
    _contactFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // var sizeBetween = height / 20;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        /* --------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
        if (state is ProfileMaintenanceError) {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => MaintenanceScreen(
                    parameters: MaintenanceParameters(message: state.message))),
            ModalRoute.withName('/'),
          );
        }
        /* --------------------------------------------------------------------- IF Profile got error, show error message */
        if (state is ProfileError) {
          setProcessingStatus(false);
          // ignore: unnecessary_null_comparison
          state.error != null ? error = true : error = false;
          showErrorToast(state.error, context);
          // ErrorDialog.showErrorDialog(context, state.error);
        }
        // if (state is ProfileLoaded) {
        if (state is ProfileRegUpdated) {
          setProcessingStatus(false);
          // showSuccessToast('${state.dataUpdated['message']}', context);

          // print('Data Update: ${state.dataUpdated}');

          if (state.dataUpdated['status'] == true) {
            if (state.dataUpdated['data']['verifyContact'] == true) {
              Storage().page = 'profileReg';
              Storage().otpToken = state.dataUpdated['data']['token'];
              Storage().contact =
                  '$selectedCode-${_contactController.text.trim()}';
              // Navigator.of(context).pushNamed( AqualifeRoutes.verifyEmailOtp);
              Navigator.of(context).pushNamed(AqualifeRoutes.verifyEmailOtp,
                  arguments: VerifyEmailOtpParameters(
                      registerData: state.dataUpdated['data']));

              // EmailDialog.showEmailDialog(
              //     context, state.dataUpdated['message']);
              showSuccessToast('${state.dataUpdated['message']}', context);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AqualifeRoutes.home,
                (Route<dynamic> route) => false,
              );

              showSuccessToast('${state.dataUpdated['message']}', context);
            }
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //    AqualifeRoutes.home,
            //   (Route<dynamic> route) => false,
            // );

            // showSuccessToast('${state.dataUpdated['message']}', context);
          } else {
            showErrorToast(state.dataUpdated['message'], context);
          }
        }

        if (state is ProfilePhotoUpdated) {
          BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
          // showSuccessToast('Profile photo updated.', context);
        }
      },
      builder: (context, state) {
        if (state is ProfileLoaded) {
          _setProfileDataImage(state);
        }

        return Theme(
          data: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: errorfield == '' ? colorDarkGray : colorRed,
            ),
          ),
          child: Container(
            height: height * 0.9,
            color: Colors.transparent,
            margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocProvider<PhotoBloc>.value(
                        value: photoBloc,
                        child: BlocConsumer<PhotoBloc, PhotoState>(
                          listener: (context, photoState) {
                            if (photoState is PhotoSet) {
                              _showPhotoConfirmDialog(
                                  context, photoState.photo);
                            }
                          },
                          builder: (context, photoState) {
                            Image? image;

                            if (profileImage != null) {
                              // image = profileImage!;
                              image = Image.network(
                                profileImage!,
                                fit: BoxFit.fill,
                              );
                            } else {
                              image = Image.asset('assets/icons/no_photo.png');
                            }

                            return Center(
                              child: Stack(
                                children: [
                                  Container(
                                    height: height / 5.8,
                                    color: colorBackground,
                                    child: AspectRatio(
                                      aspectRatio: 1 / 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // color: colorBabyBlue,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: width * 0.008,
                                            color: colorBorderGray,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: image,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 6,
                                    bottom: 0.0,
                                    child: InkWell(
                                      onTap: () =>
                                          _showSelectionDialog(context),
                                      child: Container(
                                        height: height * 0.05,
                                        width: height * 0.05,
                                        decoration: BoxDecoration(
                                          color: colorWhite,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: width * 0.008,
                                            color: colorBorderGray,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: mainColor,
                                          size: 25.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // SizedBox(height: sizeBetween * 0.5),
                      /* ------------------------------------------------------- Nickname input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Text(
                          'Nickname*',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                                color: error
                                    ? colorRed
                                    : errorfield == 'error' ||
                                            errorfield == 'errornick'
                                        ? colorRed
                                        : colorGreyBox,
                                // blurRadius: 15.0,
                                offset: Offset(
                                    0.0,
                                    error
                                        ? 3
                                        : errorfield == 'error' ||
                                                errorfield == 'errornick'
                                            ? 3
                                            : 0))
                          ],
                          border: Border.all(color: colorGreyBox),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: AqualifeInputField(
                          key: _fullNameKey,
                          controller: _fullNameController,
                          // hint: 'Example: 123456789',
                          validator: Validator.valueExists,
                          keyboard: TextInputType.emailAddress,
                          border: InputBorder.none,
                          focusNode: _fullNameFocus,
                          onValueChanged: (value) {
                            if (value != '') {
                              setState(() {
                                errorfield = '';
                              });
                            }
                          },
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errornick'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorFullName,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: error
                                        ? colorRed
                                        : errorfield == 'error' ||
                                                errorfield == 'errornick'
                                            ? colorRed
                                            : colorGreyBox),
                              ),
                            )
                          : SizedBox(),
                      /* ----------------------------------------------------------- Firstname/Forename input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Text(
                          'First Name*',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                                color: error
                                    ? colorRed
                                    : errorfield == 'error' ||
                                            errorfield == 'errorfirst'
                                        ? colorRed
                                        : colorGreyBox,
                                // blurRadius: 15.0,
                                offset: Offset(
                                    0.0,
                                    error
                                        ? 3
                                        : errorfield == 'error' ||
                                                errorfield == 'errorfirst'
                                            ? 3
                                            : 0))
                          ],
                          border: Border.all(color: colorGreyBox),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: AqualifeInputField(
                          key: _firstNameKey,
                          controller: _firstNameController,
                          // hint: 'Example: 123456789',
                          validator: Validator.valueExists,
                          keyboard: TextInputType.emailAddress,
                          border: InputBorder.none,
                          focusNode: _firstNameFocus,
                          onValueChanged: (value) {
                            if (state is ProfileEditLoaded && value != '') {
                              errorfield = '';
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(ProfileEditLoad(errorField: errorfield));
                            }
                          },
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errorfirst'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorFirstName,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: error
                                        ? colorRed
                                        : errorfield == 'error' ||
                                                errorfield == 'errorfirst'
                                            ? colorRed
                                            : colorGreyBox),
                              ),
                            )
                          : SizedBox(),
                      /* ----------------------------------------------------------- Last Name/ Surname input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Text(
                          'Last Name*',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                                color: error
                                    ? colorRed
                                    : errorfield == 'error' ||
                                            errorfield == 'errorlast'
                                        ? colorRed
                                        : colorGreyBox,
                                // blurRadius: 15.0,
                                offset: Offset(
                                    0.0,
                                    error
                                        ? 3
                                        : errorfield == 'error' ||
                                                errorfield == 'errorlast'
                                            ? 3
                                            : 0))
                          ],
                          border: Border.all(color: colorGreyBox),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: AqualifeInputField(
                          key: _lastNameKey,
                          controller: _lastNameController,
                          // hint: 'Example: 123456789',
                          validator: Validator.valueExists,
                          keyboard: TextInputType.emailAddress,
                          border: InputBorder.none,
                          focusNode: _lastNameFocus,
                          onValueChanged: (value) {
                            if (state is ProfileEditLoaded && value != '') {
                              errorfield = '';
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(ProfileEditLoad(errorField: errorfield));
                            }
                          },
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errorlast'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorLastName,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: error
                                        ? colorRed
                                        : errorfield == 'error' ||
                                                errorfield == 'errorlast'
                                            ? colorRed
                                            : colorGreyBox),
                              ),
                            )
                          : SizedBox(),
                      /* ----------------------------------------------------------- Muslim Friendly input field */
                      isMuslimFriendly == true
                          ? Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                    child: Text(
                                      'Please select one:',
                                      style: TextStyle(
                                        fontFamily: fontFamilyMain,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: colorBackground,
                                      boxShadow: [
                                        BoxShadow(
                                            color: error
                                                ? colorRed
                                                : errorfield == 'error' ||
                                                        errorfield ==
                                                            'errormuslim'
                                                    ? colorRed
                                                    : colorGreyBox,
                                            // blurRadius: 15.0,
                                            offset: Offset(
                                                0.0,
                                                error
                                                    ? 3
                                                    : errorfield == 'error' ||
                                                            errorfield ==
                                                                'errormuslim'
                                                        ? 3
                                                        : 0))
                                      ],
                                      border: Border.all(color: colorGreyBox),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        child: DropdownButton<String>(
                                          key: _muslimKey,
                                          // hint: Text(
                                          //   'Muslim Friendly *',
                                          //   style: TextStyle(
                                          //     color: colorDarkGray,
                                          //     fontSize: 11,
                                          //     fontWeight: FontWeight.w300,
                                          //   ),
                                          // ),
                                          value: _muslimController.text == ''
                                              ? null
                                              : _muslimController.text ==
                                                      'Muslim-Friendly Content Only'
                                                  ? 'Muslim-Friendly Content Only'
                                                  : 'Include Non-Halal Content',
                                          items: getMuslim
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  color: colorBlack,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          // Step 5.
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              if (state is ProfileEditLoaded &&
                                                  newValue != '') {
                                                errorfield = '';
                                                BlocProvider.of<ProfileBloc>(
                                                        context)
                                                    .add(ProfileEditLoad(
                                                        errorField:
                                                            errorfield));
                                              }

                                              if (newValue ==
                                                  'Muslim-Friendly Content Only') {
                                                _muslimController.text =
                                                    'Muslim-Friendly Content Only';
                                                setState(() {
                                                  isMuslim = true;
                                                });
                                              } else {
                                                _muslimController.text =
                                                    'Include Non-Halal Content';
                                                setState(() {
                                                  isMuslim = false;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorfield == 'error' ||
                                          errorfield == 'errormuslim'
                                      ? Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(
                                            errorMuslim,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: error
                                                    ? colorRed
                                                    : errorfield == 'error' ||
                                                            errorfield ==
                                                                'errormuslim'
                                                        ? colorRed
                                                        : colorGreyBox),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            )
                          : Container(),
                      /* ----------------------------------------------------------- Mobile No input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Text(
                          'Mobile No',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                                color: error
                                    ? colorRed
                                    : errorfield == 'error' ||
                                            errorfield == 'errorcontact'
                                        ? colorRed
                                        : colorGreyBox,
                                // blurRadius: 15.0,
                                offset: Offset(
                                    0.0,
                                    error
                                        ? 3
                                        : errorfield == 'error' ||
                                                errorfield == 'errorcontact'
                                            ? 3
                                            : 0))
                          ],
                          border: Border.all(color: colorGreyBox),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Row(
                          children: [
                            BlocProvider<CountryBloc>(
                              create: (context) {
                                // creditRecords.clear();
                                return CountryBloc()..add(CountryLoad());
                              },
                              child: BlocConsumer<CountryBloc, CountryState>(
                                listener: (context, state) {
                                  if (state is CountryError) {
                                    showErrorToast(state.error, context);
                                    // ErrorDialog.showErrorDialog(
                                    //     context, state.error);
                                  }
                                },
                                builder: (context, state) {
                                  if (state is CountryListLoaded) {
                                    getCode = _getCodes(state.countries);
                                  }

                                  if (state is CountryNetworkError) {
                                    _connectivity.initialise();
                                    _connectivity.myStream
                                        .listen((source) async {
                                      var connectionResult =
                                          await Connectivity()
                                              .checkConnectivity();

                                      if (connectionResult.contains(
                                              ConnectivityResult.mobile) &&
                                          connectionResult.contains(
                                              ConnectivityResult.wifi)) {
                                        if (!context.mounted) return;
                                        BlocProvider.of<CountryBloc>(context)
                                            .add(CountryLoad());
                                      }
                                    });
                                  }

                                  return AqualifeSelectValue(
                                    key: codeKey,
                                    availableValues: getCode,
                                    selectedValue: selectedCode,
                                    hint: 'Code',
                                    onClick: ((String selectedValue) => {
                                          selectedCode = selectedValue,
                                        }),
                                    width: width * 0.3,
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: AqualifeInputField(
                                key: _contactKey,
                                controller: _contactController,
                                // hint: 'Example: 123456789',
                                validator: Validator.valueExists,
                                keyboard: TextInputType.number,
                                border: InputBorder.none,
                                focusNode: _contactFocus,
                                onValueChanged: (value) {
                                  if (value != '') {
                                    setState(() {
                                      errorfield = '';
                                      error = false;
                                      _contactKey.currentState?.validate();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        // AqualifeInputField(
                        //   key: _contactKey,
                        //   controller: _contactController,
                        //   // hint: 'Example: 123456789',
                        //   validator: Validator.valueExists,
                        //   keyboard: TextInputType.emailAddress,
                        //   border: InputBorder.none,
                        //   focusNode: _contactFocus,
                        //   onValueChanged: (value) {
                        //     if (value != '') {
                        //       if (state is ProfileEditLoaded && value != '') {
                        //         errorfield = '';
                        //         BlocProvider.of<ProfileBloc>(context).add(
                        //             ProfileEditLoad(errorField: errorfield));
                        //       }
                        //     }
                        //   },
                        // ),
                      ),
                      errorfield == 'error' || errorfield == 'errorcontact'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorContact,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: error
                                        ? colorRed
                                        : errorfield == 'error' ||
                                                errorfield == 'errorcontact'
                                            ? colorRed
                                            : colorGreyBox),
                              ),
                            )
                          : SizedBox(),
                      /* ----------------------------------------------------------- Gender field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Text(
                          'Gender*',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: width,
                        decoration: BoxDecoration(
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                                color: error
                                    ? colorRed
                                    : errorfield == 'error' ||
                                            errorfield == 'errorgender'
                                        ? colorRed
                                        : colorGreyBox,
                                // blurRadius: 15.0,
                                offset: Offset(
                                    0.0,
                                    error
                                        ? 3
                                        : errorfield == 'error' ||
                                                errorfield == 'errorgender'
                                            ? 3
                                            : 0))
                          ],
                          border: Border.all(color: colorGreyBox),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            child: DropdownButton<String>(
                              key: _genderKey,
                              value: _genderController.text == ''
                                  ? null
                                  : _genderController.text == 'male'
                                      ? 'Male'
                                      : 'Female',
                              items: getGender.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      color: colorBlack,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      fontFamily: fontFamilyMain,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (state is ProfileEditLoaded &&
                                      newValue != '') {
                                    errorfield = '';
                                    BlocProvider.of<ProfileBloc>(context).add(
                                        ProfileEditLoad(
                                            errorField: errorfield));
                                  }

                                  if (newValue == 'Male') {
                                    _genderController.text = 'male';
                                  } else {
                                    _genderController.text = 'female';
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errorgender'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorGender,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: error
                                        ? colorRed
                                        : errorfield == 'error' ||
                                                errorfield == 'errorgender'
                                            ? colorRed
                                            : colorGreyBox),
                              ),
                            )
                          : SizedBox(),
                      /* ----------------------------------------------------------- Date of Birth input field */
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Text(
                          'DOB *',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                                color: error
                                    ? colorRed
                                    : errorfield == 'error' ||
                                            errorfield == 'errordob'
                                        ? colorRed
                                        : colorGreyBox,
                                // blurRadius: 15.0,
                                offset: Offset(
                                    0.0,
                                    error
                                        ? 3
                                        : errorfield == 'error' ||
                                                errorfield == 'errordob'
                                            ? 3
                                            : 0))
                          ],
                          border: Border.all(color: colorGreyBox),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: AqualifeInputField(
                          key: _dobKey,
                          controller: _dobController,
                          // hint: 'Example: 123456789',
                          validator: Validator.valueExists,
                          keyboard: TextInputType.text,
                          border: InputBorder.none,
                          focusNode: _dobFocus,
                          onValueChanged: (value) {
                            setState(() {
                              errorfield = '';
                            });
                          },
                          onTap: () {
                            var date = DateTime.now();
                            DateTime newDateInitial;

                            if (_dobController.text.isNotEmpty) {
                              newDateInitial = DateFormat(appDateFormat)
                                  .parse(_dobController.text);
                            } else {
                              newDateInitial = DateTime(
                                  date.year - minAgeDOB, date.month, date.day);
                            }

                            DatePicker.showSimpleDatePicker(
                              context,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(
                                  DateTime.now().year - minAgeDOB, 12, 31),
                              initialDate: newDateInitial,
                              dateFormat: appDateFormat,
                              titleText: 'Date of Birth',
                              locale: DateTimePickerLocale.en_us,
                              looping: false,
                              // itemTextStyle: TextStyle(fontSize: 20),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                _dobController.text = DateFormat(appDateFormat)
                                    .format(selectedDate);

                                dateSelect = selectedDate;

                                if (state is ProfileEditLoaded) {
                                  errorfield = '';

                                  if (!context.mounted) return;
                                  BlocProvider.of<ProfileBloc>(context).add(
                                      ProfileEditLoad(errorField: errorfield));
                                }
                              } else {
                                dateSelect = newDateInitial;
                              }
                            });
                          },
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errordob'
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorDob,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: error
                                        ? colorRed
                                        : errorfield == 'error' ||
                                                errorfield == 'errordob'
                                            ? colorRed
                                            : colorGreyBox),
                              ),
                            )
                          : SizedBox(),
                      Container(
                        margin: EdgeInsets.only(top: 17),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AqualifeStyleButton(
                                height: height / 14,
                                title: isProcessing ? 'Processing...' : 'Save',
                                backgroundColor:
                                    isProcessing ? colorLightGray : mainColor,
                                textColor:
                                    isProcessing ? colorDarkGray : colorWhite,
                                onPressed: isProcessing
                                    ? () {}
                                    : () {
                                        _validateAndUpdatePersonal();
                                        FocusScope.of(context).unfocus();
                                      } //_validateAndSend,
                                ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 14, bottom: 15),
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Log Out',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: colorBlack,
                                      ),
                                      textScaler:
                                          TextScaler.linear(scaleFactor),
                                    ),
                                    Container(
                                      width: width * 0.045,
                                      height: width * 0.045,
                                      color: colorBackground,
                                      margin: EdgeInsets.only(left: 5),
                                      child: Image(
                                        image: AssetImage(
                                            'assets/icons/settings/logout.png'),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  BlocProvider.of<AuthenticationBloc>(context)
                                      .add(AuthenticationLoggedOut());
                                  Storage().token = '';
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      AqualifeRoutes.login,
                                      (Route<dynamic> route) => false);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<String> _getCodes(List<Country> countries) {
    List<String> codes = [];
    for (var value in countries) {
      codes.add(value.callCode ?? '');
    }

    return codes;
  }

  void _validateAndUpdatePersonal() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (_fullNameController.text.isEmpty) {
      errorfield = 'errornick';
      _fullNameFocus.requestFocus();
      errorFullName = 'Nickname is required!';
      // showErrorToast('Please enter nickname!', context);

      BlocProvider.of<ProfileBloc>(context)
          .add(ProfileEditLoad(errorField: errorfield));
    } else if (_firstNameController.text.isEmpty) {
      errorfield = 'errorfirst';
      _firstNameFocus.requestFocus();
      errorFirstName = 'First Name is required!';
      // showErrorToast('Please enter first name/ forename!', context);

      BlocProvider.of<ProfileBloc>(context)
          .add(ProfileEditLoad(errorField: errorfield));
    } else if (_lastNameController.text.isEmpty) {
      errorfield = 'errorlast';
      _lastNameFocus.requestFocus();
      errorLastName = 'Last Name is required!';
      // showErrorToast('Please enter last name/ surname!', context);

      BlocProvider.of<ProfileBloc>(context)
          .add(ProfileEditLoad(errorField: errorfield));
    } else if (_contactController.text.isEmpty) {
      errorfield = 'errorcontact';
      _contactFocus.requestFocus();
      errorContact = 'Mobile No. is required!';
      // showErrorToast('Please enter last name/ surname!', context);

      BlocProvider.of<ProfileBloc>(context)
          .add(ProfileEditLoad(errorField: errorfield));
    } else if (_genderController.text.isEmpty) {
      errorfield = 'errorgender';
      _genderFocus.requestFocus();
      errorGender = 'Gender is required!';
      // showErrorToast('Please choose gender!', context);

      BlocProvider.of<ProfileBloc>(context)
          .add(ProfileEditLoad(errorField: errorfield));
    } else if (_muslimController.text.isEmpty) {
      errorfield = 'errormuslim';
      _muslimFocus.requestFocus();
      errorMuslim = 'Halal or Non Halal content option is required!';
      // showErrorToast('Please choose Muslim friendly!', context);

      BlocProvider.of<ProfileBloc>(context)
          .add(ProfileEditLoad(errorField: errorfield));
    } else if (_dobController.text.isEmpty) {
      errorfield = 'errordob';
      _dobFocus.requestFocus();
      errorDob = 'DOB is required!';
      // showErrorToast('Please enter date of birth!', context);

      BlocProvider.of<ProfileBloc>(context)
          .add(ProfileEditLoad(errorField: errorfield));
    } else {
      showConfirmationDialog(context);
    }
  }

  void _setProfileData() {
    var profile = widget.profile['profile'];
    var formatter = DateFormat(appDateFormat);
    var dateNow = DateTime.now();

    _fullNameController.text = profile['name'] ?? '';
    _firstNameController.text = profile['forename'] ?? '';
    _lastNameController.text = profile['surname'] ?? '';
    _dobController.text =
        profile['dob'].toString() != '' && profile['dob'].toString().isNotEmpty
            ? formatter.format(DateTime.parse(profile['dob']))
            : formatter.format(
                DateTime(dateNow.year - minAgeDOB, dateNow.month, dateNow.day));
    // _emailController.text = profile['email'] ?? '';
    _contactController.text =
        profile['contact'].substring(profile['contact'].indexOf("-") + 1) ?? '';
    _genderController.text = profile['gender'] ?? '';
    _muslimController.text = profile['isMuslim'] == null
        ? ''
        : profile['isMuslim'] == true
            ? 'Muslim-Friendly Content Only'
            : 'Include Non-Halal Content';

    selectedCode = profile['contact'] != ''
        ? profile['contact'].substring(0, profile['contact'].indexOf("-"))
        : '60';
  }

  void _setProfileDataImage(ProfileState state) {
    var profile = (state as ProfileLoaded).userProfile.profile;

    // ignore: unnecessary_null_comparison
    if (profile != null) {
      profileImage = profile.image;

      if (profileImage != null) {
        // image = profileImage!;
        image = Image.network(
          profileImage!,
          //  "https://staging-loyalty-bp.incitefood.com/storages/imgs/2022/04/123804_0_000_9.png",
          fit: BoxFit.fill,
        );
      } else {
        image = Image.asset('assets/icons/no_photo.png');
      }
    }
  }

  Future _showSelectionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(24, 12, 24, 16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select photo',
                style: TextStyle(
                  fontSize: 16,
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                ),
                textScaler: TextScaler.linear(scaleFactor),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
            ],
          ),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                child: Text(
                  'Take Photo',
                  style: TextStyle(
                    fontSize: 14,
                    color: mainColor,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: marginHorizontal),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                child: Text(
                  'Pick from Gallery',
                  style: TextStyle(
                    fontSize: 14,
                    color: mainColor,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ),
            SizedBox(height: marginHorizontal),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorRed,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxHeight: 300,
        maxWidth: 300,
      );

      if (pickedFile != null) {
        _cropImage(File(pickedFile.path));
      }
    } catch (e) {
      // print("Error picking image: $e");
    }
  }

  Future<void> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      // aspectRatioPresets removed. Use aspectRatio instead.
      // aspectRatio:
      //     CropAspectRatio(ratioX: 1, ratioY: 1), //Example of a 1:1 ratio.
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Image Cropper',
          toolbarColor: colorBlack,
          backgroundColor: colorBlack,
          hideBottomControls: true,
          toolbarWidgetColor: colorWhite,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          dimmedLayerColor: colorTransparent,
        ),
        IOSUiSettings(
          title: 'Image Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _image = File(croppedFile.path);
        photoBloc.add(GetPhoto(photo: _image));
      });
    }
  }

  Future _showPhotoConfirmDialog(BuildContext context, File photo) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var bytes = photo.readAsBytesSync();
    imageBytes = base64Encode(bytes);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          backgroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          title: Column(
            children: [
              Container(
                child: Text(
                  'Upload Photo Confirmation',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  textScaler: TextScaler.linear(scaleFactor),
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
            ],
          ),
          content: Container(
            color: colorWhite,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: height / 5.5,
                    height: height / 5.5,
                    decoration: BoxDecoration(
                      color: colorTransparent,
                      // shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.file(photo).image,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AqualifeStyleButton(
                            backgroundColor: mainColor,
                            height: height / 14,
                            width: width,
                            title: 'Update Profile Photo',
                            onPressed: _confirmUpdatePhoto,
                            // () {
                            //   var bytes = photo.readAsBytesSync();
                            //   var image = base64Encode(bytes);
                            //   BlocProvider.of<ProfileBloc>(context)
                            //       .add(ProfilePhotoUpdate(image: image));

                            //   Timer(Duration(seconds: 1), () {
                            //     Navigator.pop(context);
                            //   });
                            // },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              // color: colorBabyBlue,
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmUpdatePhoto() {
    Navigator.pop(context);

    BlocProvider.of<ProfileBloc>(context)
        .add(ProfilePhotoUpdate(image: imageBytes!));
  }

  showConfirmationDialog(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          backgroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          content: Container(
            color: colorBackground,
            alignment: Alignment.center,
            height: height * 0.35,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: width * 0.2,
                        width: width * 0.2,
                        color: colorTransparent,
                        child: Image(
                          image: AssetImage('assets/icons/reminder.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        // color: colorLightBlue,
                        alignment: Alignment.center,
                        // padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Please make sure all the data entered is correct.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colorBlack,
                          ),
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: AqualifeStyleButton(
                              backgroundColor: mainColor,
                              height: height / 16,
                              width: width,
                              title: 'Confirm',
                              onPressed: () {
                                Navigator.pop(context);
                                FocusScope.of(context).unfocus();

                                setProcessingStatus(true);

                                setState(() {
                                  Storage().page = 'profileReg';
                                  updateProfile();
                                });
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              FocusScope.of(context).unfocus();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              // color: colorBabyBlue,
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void updateProfile() {
    BlocProvider.of<ProfileBloc>(context).add(ProfileRegUpdate(
      surname: _lastNameController.text.trim(),
      forename: _firstNameController.text.trim(),
      name: _fullNameController.text.trim(),
      contact: '$selectedCode-${_contactController.text.trim()}',
      gender: _genderController.text.trim(),
      dob: _dobController.text.trim(),
      isMuslim: isMuslim,
      vMuslim: widget.profile['vMuslim'],
      vExtra: widget.profile['vExtra'],
      vProfile: widget.profile['vProfile'],
    ));
  }
}
