import 'package:e_square_ott_app/feature/explore/controller/explore_controller.dart';
import 'package:e_square_ott_app/feature/home/controller/file_controller.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../controller/search_tab_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ExploreController>(() => ExploreController(), fenix: true);
    Get.lazyPut<SearchTabController>(() => SearchTabController());
    Get.lazyPut<FileController>(() => FileController(), fenix: true);
  }
}

