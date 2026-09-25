import 'dart:convert';

import 'package:e_square_ott_app/constants/app_url.dart';
import 'package:e_square_ott_app/models/request/create_order_payload.dart';
import 'package:e_square_ott_app/models/request/verify_subscription_payload.dart';
import 'package:e_square_ott_app/models/response/all_plans_model.dart';
import 'package:e_square_ott_app/models/response/create_order_model.dart';
import 'package:e_square_ott_app/models/response/subscription_status_model.dart';
import 'package:e_square_ott_app/models/response/upgrade_order_response.dart';
import 'package:e_square_ott_app/models/response/verify_subscription_model.dart';
import 'package:e_square_ott_app/shared/service/storage_service.dart';
import 'package:http/http.dart' as http;

class SubscriptionDatasource {
  Future<SubscriptionPlansResponse?> allPlans() async {
    final url = Uri.parse(AppUrl.allPlans);
    var response = await http.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return SubscriptionPlansResponse.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<CreateOrderResponse?> createOrder({
    required CreateOrderPayload payload,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      return null;
    }
    final url = Uri.parse(AppUrl.createOrder);
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("create order ${response.body}");
      return CreateOrderResponse.fromJson(jsonDecode(response.body));
    } else {
      print("create order error ${response.body}");
      return null;
    }
  }

  Future<VerifySubscriptionResponse?> verifySubscription({
    required VerifySubscriptionPayload payload,
  }) async {
    final token = await StorageService.getToken();
    if (token == null) {
      return null;
    }
    final url = Uri.parse(AppUrl.verifyOrder);
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("verify subscription ${response.body}");
      return VerifySubscriptionResponse.fromJson(jsonDecode(response.body));
    } else {
      print("verify subscription error ${response.body}");
      return null;
    }
  }

  Future<UpgradeOrderResponse?> upgradePlan({required String id}) async {
    final token = await StorageService.getToken();
    if (token == null) {
      return null;
    }
    final url = Uri.parse(AppUrl.upgradePlan);
    var response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"planId": id}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("upgrade plan ${response.body}");
      return UpgradeOrderResponse.fromJson(jsonDecode(response.body));
    } else {
      print("upgrade plan error ${response.body}");
      return null;
    }
  }

  Future<SubscriptionStatusResponse?> statusSubscription() async {
    final token = await StorageService.getToken();
    if (token == null) {
      return null;
    }
    final url = Uri.parse(AppUrl.planStatus);
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("subscription status ${response.body}");
      return SubscriptionStatusResponse.fromJson(jsonDecode(response.body));
    } else {
      print("subscription status error ${response.body}");
      return null;
    }
  }
}
