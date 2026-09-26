import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/home/datasource/whislist_datasource.dart';
import 'package:e_square_ott_app/models/response/check_series_model.dart';
import 'package:e_square_ott_app/models/response/saved_series_response.dart';
import 'package:e_square_ott_app/models/response/toogle_saved_series_model.dart';
import 'package:e_square_ott_app/shared/widgets/custom_sncakbar.dart';
import 'package:get/get.dart';

class WhislistController extends GetxController {
  final WhislistDatasource datasource = WhislistDatasource();

  final isDeleteStatus = Status.init.obs;
  final isAllDeleteStatus = Status.init.obs;
  final getAllSavedWhislistStatus = Status.init.obs;
  final getOtherWhislistStatus = Status.init.obs;
  final checkSavedWhislistStatus = Status.init.obs;
  final addWishListStatus = Status.init.obs;

  final isMoreWhislist = false.obs;
  final pageNumber = 1.obs;
  final limit = 10.obs;

  final allSavedWhislist = Rxn<SavedSeriesResponse?>();
  final otherWhislistResponse = Rxn<SavedSeriesResponse?>();
  final checkSavedWhislistResponse = Rxn<CheckSavedSeriesResponse?>();
  final toggleSavedWhislistResponse = Rxn<ToggleSavedSeriesResponse?>();

  final RxMap<String, bool> isSavedMap = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getAllSavedWhislist();
  }

  // ── Getters ──
  List<SavedSeries> get savedSeriesList =>
      allSavedWhislist.value?.data.savedSeries ?? [];

  int get totalSavedCount =>
      allSavedWhislist.value?.data.stats.totalSaved ?? savedSeriesList.length;

  bool get hasSavedSeries => savedSeriesList.isNotEmpty;

  bool isDramaSaved(String dramaId) {
    if (isSavedMap.containsKey(dramaId)) {
      return isSavedMap[dramaId] ?? false;
    }
    return savedSeriesList.any((item) => item.drama.id == dramaId);
  }

  // ── 1. Get All Saved Wishlist (Page 1 / Initial / Refresh) ──
  Future<void> getAllSavedWhislist() async {
    getAllSavedWhislistStatus.value = Status.loading;
    pageNumber.value = 1;

    try {
      final response = await datasource.getAllSavedSeries(
        pageNo: pageNumber.value,
        limit: limit.value,
      );

      if (response != null && response.success) {
        allSavedWhislist.value = response;
        isMoreWhislist.value = response.data.pagination.hasNextPage;

        for (final item in response.data.savedSeries) {
          isSavedMap[item.drama.id] = true;
        }

        getAllSavedWhislistStatus.value = Status.success;
      } else {
        getAllSavedWhislistStatus.value = Status.error;
      }
    } catch (e) {
      print("[WhislistController] getAllSavedWhislist error: $e");
      getAllSavedWhislistStatus.value = Status.error;
    }
  }

  // ── 2. Get Other / Next Page Wishlist (Pagination) ──
  Future<void> getOtherWhislist() async {
    if (!isMoreWhislist.value ||
        getOtherWhislistStatus.value == Status.loading) {
      return;
    }

    try {
      getOtherWhislistStatus.value = Status.loading;
      final nextPage = pageNumber.value + 1;

      final response = await datasource.getAllSavedSeries(
        pageNo: nextPage,
        limit: limit.value,
      );

      if (response != null && response.success) {
        otherWhislistResponse.value = response;
        pageNumber.value = nextPage;
        isMoreWhislist.value = response.data.pagination.hasNextPage;

        final currentList = allSavedWhislist.value?.data.savedSeries ?? [];
        final newItems = response.data.savedSeries;

        allSavedWhislist.value = SavedSeriesResponse(
          success: response.success,
          statusCode: response.statusCode,
          message: response.message,
          data: SavedSeriesData(
            savedSeries: [...currentList, ...newItems],
            pagination: response.data.pagination,
            stats: response.data.stats,
          ),
        );

        for (final item in newItems) {
          isSavedMap[item.drama.id] = true;
        }

        getOtherWhislistStatus.value = Status.success;
      } else {
        getOtherWhislistStatus.value = Status.error;
      }
    } catch (e) {
      print("[WhislistController] getOtherWhislist error: $e");
      getOtherWhislistStatus.value = Status.error;
    }
  }

  // ── 3. Delete Saved Series (Single Item) ──
  Future<bool> deleteSavedSeries({
    required String id,
    String? dramaId,
  }) async {
    isDeleteStatus.value = Status.loading;

    try {
      final success = await datasource.deleteSavedSeries(id: id);
      if (success) {
        if (allSavedWhislist.value != null) {
          final updatedList = allSavedWhislist.value!.data.savedSeries
              .where((item) =>
                  item.id != id &&
                  item.savedId != id &&
                  (dramaId == null || item.drama.id != dramaId))
              .toList();

          allSavedWhislist.value = SavedSeriesResponse(
            success: allSavedWhislist.value!.success,
            statusCode: allSavedWhislist.value!.statusCode,
            message: allSavedWhislist.value!.message,
            data: SavedSeriesData(
              savedSeries: updatedList,
              pagination: allSavedWhislist.value!.data.pagination,
              stats: SavedSeriesStats(
                totalSaved: updatedList.length,
                currentFilteredCount: updatedList.length,
              ),
            ),
          );
        }

        if (dramaId != null) {
          isSavedMap[dramaId] = false;
        }

        AppSnackbar.success(
          'Series removed from your Saved List',
          title: 'Removed',
        );
        isDeleteStatus.value = Status.success;
        return true;
      } else {
        AppSnackbar.error('Failed to remove series', title: 'Error');
        isDeleteStatus.value = Status.error;
        return false;
      }
    } catch (e) {
      print("[WhislistController] deleteSavedSeries error: $e");
      isDeleteStatus.value = Status.error;
      return false;
    }
  }

  // ── 4. Clear All Saved Series ──
  Future<bool> clearAllSavedSeries() async {
    isAllDeleteStatus.value = Status.loading;

    try {
      final success = await datasource.clearAllSavedSeries();
      if (success) {
        if (allSavedWhislist.value != null) {
          allSavedWhislist.value = SavedSeriesResponse(
            success: allSavedWhislist.value!.success,
            statusCode: allSavedWhislist.value!.statusCode,
            message: allSavedWhislist.value!.message,
            data: SavedSeriesData(
              savedSeries: [],
              pagination: allSavedWhislist.value!.data.pagination,
              stats: SavedSeriesStats(
                totalSaved: 0,
                currentFilteredCount: 0,
              ),
            ),
          );
        }

        isSavedMap.clear();
        AppSnackbar.info('Saved list cleared', title: 'Cleared');
        isAllDeleteStatus.value = Status.success;
        return true;
      } else {
        AppSnackbar.error('Failed to clear saved series', title: 'Error');
        isAllDeleteStatus.value = Status.error;
        return false;
      }
    } catch (e) {
      print("[WhislistController] clearAllSavedSeries error: $e");
      isAllDeleteStatus.value = Status.error;
      return false;
    }
  }

  // ── 5. Toggle Saved Series (Add / Remove) ──
  Future<ToggleSavedSeriesResponse?> toggleSavedSeries({
    required String dramaId,
  }) async {
    if (dramaId.isEmpty) {
      print("[WhislistController] toggleSavedSeries called with empty dramaId");
      return null;
    }

    addWishListStatus.value = Status.loading;

    try {
      final response = await datasource.toggleSavedSeries(dramaId: dramaId);
      if (response != null && response.success) {
        toggleSavedWhislistResponse.value = response;
        final isNowSaved = response.data.isSaved;
        isSavedMap[dramaId] = isNowSaved;

        if (isNowSaved) {
          AppSnackbar.success(
            response.message.isNotEmpty
                ? response.message
                : 'Series added to your Saved List',
            title: 'Saved',
          );
        } else {
          if (allSavedWhislist.value != null) {
            final updatedList = allSavedWhislist.value!.data.savedSeries
                .where((item) => item.drama.id != dramaId)
                .toList();

            allSavedWhislist.value = SavedSeriesResponse(
              success: allSavedWhislist.value!.success,
              statusCode: allSavedWhislist.value!.statusCode,
              message: allSavedWhislist.value!.message,
              data: SavedSeriesData(
                savedSeries: updatedList,
                pagination: allSavedWhislist.value!.data.pagination,
                stats: SavedSeriesStats(
                  totalSaved: response.data.totalSaved,
                  currentFilteredCount: updatedList.length,
                ),
              ),
            );
          }

          AppSnackbar.info(
            response.message.isNotEmpty
                ? response.message
                : 'Series removed from your Saved List',
            title: 'Removed',
          );
        }

        addWishListStatus.value = Status.success;
        return response;
      } else {
        addWishListStatus.value = Status.error;
        return null;
      }
    } catch (e) {
      print("[WhislistController] toggleSavedSeries error: $e");
      addWishListStatus.value = Status.error;
      return null;
    }
  }

  // ── 6. Check if Drama is Saved ──
  Future<bool> checkSavedSeries({required String dramaId}) async {
    checkSavedWhislistStatus.value = Status.loading;

    try {
      final response = await datasource.checkSavedSeries(dramaId: dramaId);
      if (response != null && response.success) {
        checkSavedWhislistResponse.value = response;
        final isSavedVal = response.data.isSaved;
        isSavedMap[dramaId] = isSavedVal;
        checkSavedWhislistStatus.value = Status.success;
        return isSavedVal;
      } else {
        checkSavedWhislistStatus.value = Status.error;
        return false;
      }
    } catch (e) {
      print("[WhislistController] checkSavedSeries error: $e");
      checkSavedWhislistStatus.value = Status.error;
      return false;
    }
  }
}
