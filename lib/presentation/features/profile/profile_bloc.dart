import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/storage.dart';
import '../../../data/error/exceptions.dart';
import '../../../data/repositories/repositories.dart';
import 'profile.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  bool reloadBack = false;

  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<ProfileStart>((event, emit) async {
      emit(ProfileInitial());
    });
    on<ProfileLoad>((event, emit) async {
      await _mapProfileLoadEventToState(event, emit);
    });
    on<ProfilePhotoUpdate>((event, emit) async {
      await _mapProfilePhotoUpdateEventToState(event, emit);
    });
    // on<ProfileRegUpdate>((event, emit) async {
    //   await _mapProfileRegUpdateEventToState(event, emit);
    // });
    on<ProfileUpdate>((event, emit) async {
      await _mapProfileUpdateEventToState(event, emit);
    });
    on<ProfileEditLoad>((event, emit) async {
      await _mapProfileEditLoadEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to get profile info/ user details
  Future<void> _mapProfileLoadEventToState(
      ProfileLoad event, Emitter<ProfileState> emit) async {
    if (reloadBack == false) {
      emit(ProfileReloading());
    } else {
      emit(ProfileReload());
    }

    var internet = await checkInternet();

    if (!internet) {
      try {
        if (state is! ProfileUpdating) {
          // yield ProfileProcessing();
        }
        var userProfile =
            await userRepository.getUserProfile(token: Storage().token);

        if (userProfile is Map) {
          if (userProfile['isMaintenance'] == true) {
            emit(ProfileMaintenanceError(message: userProfile['message']));
          } else {
            ProfileError(error: userProfile['message']);
          }
        } else {
          emit(ProfileLoaded(userProfile: userProfile));
        }
      } catch (e) {
        // if (e is InvalidSessionException) {
        //   emit(ProfileSessionError(error: e.message));
        // } else if (e is InvalidStatusException) {
        //   emit(ProfileError(error: e.message));
        // } else {
        //   emit(ProfileError(error: e.toString()));
        // }
      }
    } else {
      emit(ProfileNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to update profile photo to API
  Future<void> _mapProfilePhotoUpdateEventToState(
      ProfilePhotoUpdate event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfilePhotoUpdating());
      var updatePhoto = await userRepository.updateProfilePhoto(
          token: Storage().token, image: event.image);

      if (!updatePhoto['isMaintenance'] && updatePhoto['status'] == true) {
        emit(ProfilePhotoUpdated());
      } else {
        emit(ProfileMaintenanceError(message: updatePhoto['message']));
      }

      // add(ProfileLoad());
    } catch (e) {
      if (e is InvalidSessionException) {
        emit(ProfileSessionError(error: e.message));
      } else {
        emit(ProfileError(error: e.toString()));
      }
    }
  }

  // // Function to Register profile info
  // Future<void> _mapProfileRegUpdateEventToState(
  //     ProfileRegUpdate event, Emitter<ProfileState> emit) async {
  //   var checkInternet =
  //       await Connectivity().checkConnectivity() != ConnectivityResult.none;

  //   if (checkInternet == true) {
  //     try {
  //       emit(ProfileUpdating());
  //       var updated = await userRepository.updateRegProfile(
  //         token: Storage().token,
  //         name: event.name,
  //         surname: event.surname,
  //         forename: event.forename,
  //         contact: event.contact,
  //         dob: event.dob,
  //         gender: event.gender,
  //         isMuslim: event.isMuslim,
  //         vMuslim: event.vMuslim,
  //         vExtra: event.vExtra!,
  //         vProfile: event.vProfile,
  //       );

  //       if (updated['isMaintenance'] == true) {
  //         emit(ProfileMaintenanceError(message: updated['message']));
  //       } else {
  //         emit(ProfileRegUpdated(dataUpdated: updated));
  //       }
  //     } catch (e) {
  //       if (e is InvalidSessionException) {
  //         emit(ProfileSessionError(error: e.message));
  //       } else if (e is InvalidStatusException) {
  //         emit(ProfileError(error: e.message));
  //       } else {
  //         emit(ProfileError(error: e.toString()));
  //       }
  //     }
  //   } else {
  //     emit(ProfileNetworkError(error: 'No internet Connection.'));
  //   }
  // }

  //  Function to update profile info/ user details
  Future<void> _mapProfileUpdateEventToState(
      ProfileUpdate event, Emitter<ProfileState> emit) async {
    var internet = await checkInternet();

    if (!internet) {
      try {
        emit(ProfileUpdating());
        var profileUpdated = await userRepository.updateProfile(
          token: Storage().token,
          name: event.name,
          surname: event.surname,
          forename: event.forename,
          dob: event.dob,
          gender: event.gender,
        );

        if (!profileUpdated['isMaintenance']) {
          if (profileUpdated['status'] == true) {
            emit(ProfileUpdated());
          }
        } else {
          emit(ProfileMaintenanceError(message: profileUpdated['message']));
        }

        // add(ProfileLoad());
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(ProfileSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(ProfileError(error: e.message));
        } else {
          emit(ProfileError(error: e.toString()));
        }
      }
    } else {
      emit(ProfileNetworkError(error: 'No internet Connection.'));
    }
  }

  // Function to update profile info/ user details after register
  Future<void> _mapProfileEditLoadEventToState(
      ProfileEditLoad event, Emitter<ProfileState> emit) async {
    var internet = await checkInternet();

    if (!internet) {
      emit(ProfileEditLoaded(errorField: event.errorField));
    } else {
      emit(ProfileNetworkError(error: 'No internet Connection.'));
    }
  }
}
