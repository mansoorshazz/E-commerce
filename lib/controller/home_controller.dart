import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/state_manager.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeController extends GetxController {
  bool isFabVisible = true;
  int tappedIndex = 0;
  List categoryNames = [];
  List favoriteProductNames = [];

  YoutubePlayerController? youtubePlayerController;

  final List<String> ids = [
    'kV__iZuxDGE',
    'FKhhh7hHJ-A',
    'GejXnyse-b4',
    'hs1HoLs4SD0',
    'GaF3pH1bPg4',
    '8w4qPUSG17Y',
    'gdeqbg8QFJM',
  ];

  changeCategory(int index) {
    tappedIndex = index;
    update();
  }

  getTheCategoryNames() async {
    final doc = await FirebaseFirestore.instance.collection('Categories').get();
    categoryNames = doc.docs.map((e) => e.data()['categoryName']).toList();
    update();
  }

  getTheFavoritesProductsNames() async {
    final doc = await FirebaseFirestore.instance.collection('Categories').get();
    favoriteProductNames =
        doc.docs.map((e) => e.data()['categoryName']).toList();
    update();
  }

  @override
  void onInit() async {
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: 'kV__iZuxDGE',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        loop: true,
        mute: true,
        hideControls: true,
        forceHD: true,
        hideThumbnail: true,
        enableCaption: false,
        useHybridComposition: false,
      ),
    );
    youtubePlayerController!.setVolume(0);
    youtubePlayerController!.play();
    youtubePlayerController!.mute();
    super.onInit();
  }

  @override
  void dispose() {
    youtubePlayerController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
