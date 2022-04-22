import 'package:get/state_manager.dart';

class RadioButtonController extends GetxController {
  int selectedIndex = 0;
  int selectedPayment = 0;

  changeRadioButton(int value) {
    selectedIndex = value;
    update();
  }

  changePaymentMehod(int value) {
    selectedPayment = value;
    update();
  }
}
