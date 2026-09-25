import 'package:e_square_ott_app/feature/profile/controller/legal_controller.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<LegalController>(() => LegalController(), fenix: true);
  }
}
