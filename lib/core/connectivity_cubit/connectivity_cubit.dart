import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'connectivity_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  late StreamSubscription connectivityStreamSubscription;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    // Check the initial connectivity state when the cubit is created
    checkInternetConnection();

    // Set up the stream subscription to monitor changes
    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectionType.wifi);
      } else if (connectivityResult == ConnectivityResult.mobile) {
        emitInternetConnected(ConnectionType.mobile);
      } else if (connectivityResult == ConnectivityResult.none) {
        emitInternetDisconnected();
      }
    });
  }

  Future<void> checkInternetConnection() async {
    try {
      var connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        emit(InternetDisconnected());
      } else if (connectivityResult == ConnectivityResult.wifi) {
        emit(InternetConnected(connectionType: ConnectionType.wifi));
      } else if (connectivityResult == ConnectivityResult.mobile) {
        emit(InternetConnected(connectionType: ConnectionType.mobile));
      } else {
        emit(InternetLoading());
      }
    } catch (e) {
      emit(InternetDisconnected());
    }
  }

  void emitInternetConnected(ConnectionType connectionType) =>
      emit(InternetConnected(connectionType: connectionType));

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
