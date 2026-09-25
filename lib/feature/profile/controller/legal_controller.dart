import 'package:e_square_ott_app/constants/enum.dart';
import 'package:e_square_ott_app/feature/profile/datasource/profile_datasource.dart';
import 'package:e_square_ott_app/models/response/legal_document_model.dart';
import 'package:get/get.dart';

class LegalController extends GetxController {
  final ProfileDatasource datasource = ProfileDatasource();
  final privacyPolicyResponse = Rxn<LegalDocumentResponse?>();
  final termAndCondtionResponse = Rxn<LegalDocumentResponse?>();
  final privacyStatus = Status.init.obs;
  final termAndCondtionStatus = Status.init.obs;

  Future<void> getPrivacyPolicy() async {
    privacyStatus.value = Status.loading;
    final result = await datasource.privacyPolicy();
    if (result != null) {
      privacyPolicyResponse.value = result;
      privacyStatus.value = Status.success;
    } else {
      privacyStatus.value = Status.error;
    }
  }

  Future<void> getTermAndCondition() async {
    termAndCondtionStatus.value = Status.loading;
    final result = await datasource.termAndCondition();
    if (result != null) {
      termAndCondtionResponse.value = result;
      termAndCondtionStatus.value = Status.success;
    } else {
      termAndCondtionStatus.value = Status.error;
    }
  }
}
