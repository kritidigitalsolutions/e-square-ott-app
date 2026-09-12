import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../controller/search_tab_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchTabController>(() => SearchTabController());
  }
}
