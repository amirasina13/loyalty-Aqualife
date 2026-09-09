import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../config/storage.dart';
import '../../../data/repositories/repositories.dart';
import '../../../domain/entities/entities.dart';
import '../authentication/authentication.dart';
import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    required this.userRepository,
    required this.authenticationBloc,
  }) : super(LoginInitial()) {
    // on<LoginLoad>((event, emit) async {
    //   await mapLoginLoadToState(event, emit);
    // });
    on<LoginEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  // Function to login
  Future<void> mapEventToState(event, Emitter<LoginState> emit) async {
    if (event is LoginPressed) {
      emit(LoginProcessing());
      var internet = await checkInternet();

      if (!internet) {
        try {
          var pushToken =
              await Storage().secureStorage.read(key: 'push_token') ?? '';

          var userEntity = UserEntity(
            id: event.email,
            email: event.email,
            password: event.password,
            pushToken: pushToken,
          );

          var loginData = await userRepository.login(
            user: userEntity,
          );

          if (!loginData['isMaintenance']) {
            authenticationBloc.add(AuthenticationLoggedIn(
                token: loginData['data']['token'],
                loginData: loginData['data']));

            emit(LoginFinished(loginData['data']));
          } else {
            emit(LoginMaintenanceError(message: loginData['message']));
          }
        } catch (error) {
          if (error is! String) {
            emit(LoginError(error.toString()));
          } else {
            emit(LoginError(error));
          }
        }
      } else {
        emit(LoginNetworkError('No internet Connection.'));
      }
    }
  }
}
