import 'package:get/get.dart';

class ExploreItemModel {
  final String id;
  final String tag;
  final String title;
  final String genre;
  final String description;
  final String image;
  final RxBool isInMyList;

  ExploreItemModel({
    required this.id,
    this.tag = 'TRAILER PREVIEW',
    required this.title,
    required this.genre,
    required this.description,
    required this.image,
    bool isInList = false,
  }) : isInMyList = isInList.obs;
}
