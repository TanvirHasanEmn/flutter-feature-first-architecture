import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../network/api_client.dart';



class StripeService {


  static final StripeService instance = StripeService();

  final secretkey = "jey";

  Future<void> setupPaymentMethod() async {
    try {

      String? setupIntentClientSecret = await _createSetupIntent();

      if (setupIntentClientSecret == null) {
        log('Setup Intent creation failed');
        return;
      }

      log('Setup Intent Created: $setupIntentClientSecret');


      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          setupIntentClientSecret: setupIntentClientSecret,
          merchantDisplayName: "Manospro",
        ),
      );


      await _confirmSetupIntent(setupIntentClientSecret);
    } catch (e) {
      log('Setup Failed: $e');
    }
  }

  Future<void> _confirmSetupIntent(String setupIntentClientSecret) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      log('Setup Successful!');

      await _getSetupDetails(setupIntentClientSecret);
    } catch (e) {
      log('Setup Confirmation Failed: $e');
    }
  }

  Future<void> _getSetupDetails(String setupIntentClientSecret) async {
    try {
      final Dio dio = Dio();

      final setupIntentId = setupIntentClientSecret.split('_secret')[0];
      log('Setup Intent ID: $setupIntentId');


      var response = await dio.get(
        "https://api.stripe.com/v1/setup_intents/$setupIntentId",
        options: Options(
          headers: {
            "Authorization": "Bearer $secretkey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );

      log('Response Status: ${response.statusCode}');
      log('Response Data: ${response.data}');


      final selectedDate = dateTimeSymbolMap();
      final selectedTime = dateTimeSymbolMap();
      final date = selectedDate;


      final Map<String, dynamic> requestBody = {
        "date": date,
        "time": selectedTime,
        "paymentMethodId": "id"
      };

      if (response.data != null && response.data['payment_method'] != null) {
        String paymentMethodId = response.data['payment_method'];
        log('Payment Method ID: $paymentMethodId');
        if (paymentMethodId.isNotEmpty){
          final response = await NetworkCaller().postRequest(
            'url',
            body: requestBody,
          );
          if (response.isSuccess) {
            // Get.offAll(() => NavBar());
            // Get.snackbar('Success', 'Booking created successfully');
            // Handle success
          } else {
            final errorMessage = response.responseData['message'] ??
                'Failed to create booking';
            // Get.snackbar('Error', errorMessage);
          }

        }

      } else {
        log('No payment method returned from Stripe');
      }
    } catch (e) {
      log('Failed to retrieve setup details: $e');
    }
  }

  Future<String?> _createSetupIntent() async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "payment_method_types[]": "card",
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/setup_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $secretkey",
          },
        ),
      );

      if (response.data != null) {
        log('Setup Intent Response: ${response.data}');
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      log('Error creating SetupIntent: $e');
      return null;
    }
  }



  String convertToIso8601(String original) {
    final dt = DateTime.parse(original).toUtc();
    final formatted =
        dt.toIso8601String().substring(0, 23) + "+00:00";
    return formatted;
  }
}