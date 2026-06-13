// qr_share_token_request.dart
import 'package:cureta/features/qr/data/models/qr_share_filters.dart';

class QrShareTokenRequest {
  final String profileId;
  final QrShareFilters? filters;
  final int expiryMinutes;

  QrShareTokenRequest({
    required this.profileId,
    this.filters,
    this.expiryMinutes = 15,
  });

  Map<String, dynamic> toJson() {
    return {
      'profile_id': profileId,
      if (filters != null) 'filters': filters!.toJson(),
      'expiry_minutes': expiryMinutes,
    };
  }
}
