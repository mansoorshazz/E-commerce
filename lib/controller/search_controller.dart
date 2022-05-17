import 'package:get/state_manager.dart';

class SearchController extends GetxController {
  String searchText = '';

  getSearchTExt(String value) {
    searchText = value;
    update();
  }
}
