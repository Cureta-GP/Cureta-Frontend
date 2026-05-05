class OcrConfirmRequest {
  final List<String> medicines;

  OcrConfirmRequest({required this.medicines});

  Map<String, dynamic> toJson() {
    return {"medicines": medicines};
  }
}
