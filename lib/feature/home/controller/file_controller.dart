import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/home/datasource/home_datasource.dart';
import 'package:e_square_ott_app/models/response/upload_file_model.dart';
import 'package:e_square_ott_app/shared/widgets/custom_sncakbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class FileController extends GetxController {
  final HomeDatasource homeDatasource = HomeDatasource();
  final ImagePicker _picker = ImagePicker();

  final Rx<Status> isFileUpload = Status.init.obs;
  final RxString uploadedUrl = ''.obs;
  final Rxn<UploadFileResponseModel?> uploadResponse =
      Rxn<UploadFileResponseModel?>();

  /// Picks an image from Gallery or Camera and uploads it to the server.
  /// Returns the uploaded file URL upon success.
  Future<String?> pickAndUploadImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) {
        return null;
      }

      isFileUpload.value = Status.loading;

      final result = await homeDatasource.uploadFileSingle(pickedFile.path);

      if (result != null && result.success && result.data != null) {
        uploadResponse.value = result;
        final url = result.data!.url;
        uploadedUrl.value = url;
        isFileUpload.value = Status.success;

        AppSnackbar.success(
          result.message.isNotEmpty
              ? result.message
              : 'File uploaded successfully.',
        );

        return url;
      } else {
        isFileUpload.value = Status.error;
        AppSnackbar.error('File upload failed. Please try again.');
        return null;
      }
    } catch (e) {
      isFileUpload.value = Status.error;
      print("pickAndUploadImage error: $e");
      AppSnackbar.error('Error uploading file: $e');
      return null;
    } finally {
      isFileUpload.value = Status.init;
    }
  }

  /// Helper to clear currently uploaded URL state
  void clearUploadedUrl() {
    uploadedUrl.value = '';
    uploadResponse.value = null;
    isFileUpload.value = Status.init;
  }
}
