class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.details, this.errorCode});

  final String message;
  final int? statusCode;
  final dynamic details;

  /// WP error code e.g. 'profile_incomplete', 'membership_required', 'membership_pending'
  final String? errorCode;

  bool get isProfileIncomplete => errorCode == 'profile_incomplete';
  bool get isMembershipRequired => errorCode == 'membership_required';
  bool get isMembershipPending => errorCode == 'membership_pending';

  @override
  String toString() => 'ApiException($statusCode/$errorCode): $message';
}
