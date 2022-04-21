import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';

class FavoriteController extends GetxController {
  List favoriteProductNames = [];

  getTheFavoritesProductsNames() async {
    final doc = await FirebaseFirestore.instance.collection('Categories').get();
    favoriteProductNames =
        doc.docs.map((e) => e.data()['categoryName']).toList();
    update();
  }

                         





}
