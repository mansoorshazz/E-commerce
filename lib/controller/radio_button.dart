import 'package:get/state_manager.dart';

class RadioButtonController extends GetxController {
  int selectedIndex = 0;

  changeRadioButton(int value) {
    selectedIndex = value;
    update();
  }
}
