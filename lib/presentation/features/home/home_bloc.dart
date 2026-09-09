import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../config/storage.dart';
import '../../../data/error/exceptions.dart';
import '../../../data/model/profile/home_page.dart';
import '../../../data/repositories/repositories.dart';
import 'home.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final RewardRepository? rewardRepository;

  HomeBloc({required this.userRepository, this.rewardRepository})
      : super(HomeInitial()) {
    on<HomeLoad>((event, emit) async {
      await _mapHomeLoadEventToState(emit);
    });
    on<VoucherBrandLoad>((event, emit) async {
      await _mapVoucherBrandLoadEventToState(emit, event);
    });
  }

  Future<bool> checkInternet() async {
    var connectionResult = await Connectivity().checkConnectivity();

    return connectionResult.contains(ConnectivityResult.none);
  }

  Future<void> _mapHomeLoadEventToState(Emitter<HomeState> emit) async {
    emit(HomeProcessing());
    var internet = await checkInternet();

    if (!internet) {
      try {
        String token =
            await Storage().secureStorage.read(key: 'push_token') ?? '';

        var homePage = await userRepository.getHomePage(token: Storage().token);

        if (homePage is HomePage) {
          emit(HomeLoaded(token: token, homePage: homePage));
        } else {
          if (homePage['isMaintenance'] == true) {
            emit(HomeMaintenanceError(message: homePage['message']));
          } else {
            HomeError(error: homePage['message']);
          }
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(HomeSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(HomeError(error: e.message));
        } else {
          emit(HomeError(error: e.toString()));
        }
      }
    } else {
      emit(HomeNetworkError('No internet Connection.'));
    }
  }

  Future<void> _mapVoucherBrandLoadEventToState(
      Emitter<HomeState> emit, event) async {
    emit(HomeProcessing());
    var internet = await checkInternet();

    if (!internet) {
      try {
        var vouchersBrands = await rewardRepository?.searchVouchersBrands(
            token: Storage().token, keywords: event.keywords);

        if (vouchersBrands['data'] != null) {
          emit(VoucherBrandLoaded(searchData: vouchersBrands['data']));
        } else if (vouchersBrands['isMaintenance'] == true) {
          emit(HomeMaintenanceError(message: vouchersBrands['message']));
        } else {
          HomeError(error: vouchersBrands['message']);
        }
      } catch (e) {
        if (e is InvalidSessionException) {
          emit(HomeSessionError(error: e.message));
        } else if (e is InvalidStatusException) {
          emit(HomeError(error: e.message));
        } else {
          emit(HomeError(error: e.toString()));
        }
      }
    } else {
      emit(HomeNetworkError('No internet Connection.'));
    }
  }
}
