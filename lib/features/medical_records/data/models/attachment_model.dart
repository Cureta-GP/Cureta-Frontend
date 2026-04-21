class AttachmentModel {
  final String id;
  final String recordId;
  final String fileUrl;
  final String attachmentType;
  final String fileName;

  const AttachmentModel({
    required this.id,
    required this.recordId,
    required this.fileUrl,
    required this.attachmentType,
    required this.fileName,
  });

  // ── Computed ──────────────────────────────────────────────────────────────

  bool get isPdf => fileName.toLowerCase().endsWith('.pdf');

  bool get isImage {
    if (attachmentType.toLowerCase().contains('image')) return true;
    final name = fileName.toLowerCase();
    return name.endsWith('.jpg') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.png') ||
        name.endsWith('.gif') ||
        name.endsWith('.webp');
  }

  /// 'pdf' | 'image' | 'file'
  String get fileType => isPdf ? 'pdf' : (isImage ? 'image' : 'file');

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as String,
      recordId: json['record_id'] as String,
      fileUrl: json['file_url'] as String,
      attachmentType: json['attachment_type'] as String,
      fileName: json['file_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'record_id': recordId,
    'file_url': fileUrl,
    'attachment_type': attachmentType,
    'file_name': fileName,
  };
}
