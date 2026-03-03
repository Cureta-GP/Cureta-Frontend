enum AddRecordUploadCategory { prescription, labTest, scan, report, other }

class AddRecordUploadedFile {
  const AddRecordUploadedFile({
    required this.id,
    required this.name,
    required this.extension,
    required this.sizeBytes,
    this.path,
  });

  final String id;
  final String name;
  final String extension;
  final int sizeBytes;
  final String? path;

  bool get isPdf => extension.toLowerCase() == 'pdf';
}
