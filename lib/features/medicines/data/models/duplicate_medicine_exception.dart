/// Thrown when the backend responds with 409 Conflict,
/// indicating the medicine already exists for this profile.
class DuplicateMedicineException implements Exception {
  final String message;

  const DuplicateMedicineException({
    this.message = 'Medicine already exists.',
  });

  @override
  String toString() => 'DuplicateMedicineException: $message';
}
