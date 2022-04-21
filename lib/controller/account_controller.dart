import 'dart:io';
import 'package:e_commerce_app/model/Firebase/account.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  File? file;

  imageUpload() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    file = File(image.path);
    Account.uploadProfileImage(image, file!);
  }
}
