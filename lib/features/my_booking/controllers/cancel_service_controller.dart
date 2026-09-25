import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';

class CancelServiceState {
  final String selectedReason;
  final bool isLoading;
  final String? errorMessage;
  final List<String> reasons;

  const CancelServiceState({
    this.selectedReason = '',
    this.isLoading = false,
    this.errorMessage,
    this.reasons = const [
      'Esperando por mucho tiempo',
      'No se pudo contactar al proveedor de servicio',
      'El proveedor denegó el destino',
      'El proveedor denegó la recogida',
      'Dirección mostrada incorrecta',
      'Precio no razonable',
      'Pedir otro servicio',
      'Solo quiero cancelar',
    ],
  });

  CancelServiceState copyWith({
    String? selectedReason,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CancelServiceState(
      selectedReason: selectedReason ?? this.selectedReason,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      reasons: reasons,
    );
  }
}

class CancelServiceController extends Notifier<CancelServiceState> {
  @override
  CancelServiceState build() => const CancelServiceState();

  void selectReason(String reason) {
    state = state.copyWith(selectedReason: reason);
  }

  Future<String?> submitCancellation({
    required String bookingId,
    required String customReason,
  }) async {
    final finalReason = state.selectedReason == 'Others'
        ? customReason.trim()
        : state.selectedReason;

    if (finalReason.isEmpty) {
      return 'Por favor selecciona o escribe un motivo';
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final network = NetworkCaller();
      final response = await network.postRequest(
        'https://api.manospro.app/api/v1/booking/cancel-booking/$bookingId',
        body: {'cancelReason': finalReason},
        token: token,
      );

      state = state.copyWith(isLoading: false);

      if (response.isSuccess) {
        return null; // Success
      } else {
        final err = response.errorMessage.isNotEmpty
            ? response.errorMessage
            : 'Error al cancelar la reserva';
        state = state.copyWith(errorMessage: err);
        return err;
      }
    } catch (e) {
      final err = 'Excepción al cancelar: $e';
      state = state.copyWith(isLoading: false, errorMessage: err);
      return err;
    }
  }
}

final cancelServiceControllerProvider =
NotifierProvider<CancelServiceController, CancelServiceState>(
  CancelServiceController.new,
);