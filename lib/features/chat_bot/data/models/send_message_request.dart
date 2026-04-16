class SendMessageRequest {
  final String message;
  final String profileId;
  final String? sessionId;
  final String appLanguage;

  SendMessageRequest({
    required this.message,
    required this.profileId,
    this.sessionId,
    required this.appLanguage,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'profile_id': profileId,
    if (sessionId != null) 'session_id': sessionId,
    'app_language': appLanguage,
  };
}
