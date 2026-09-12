import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy-puts AuthController — created only when first accessed,
    // automatically disposed when the route is popped.
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
