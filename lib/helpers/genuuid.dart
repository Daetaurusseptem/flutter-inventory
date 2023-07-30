import 'package:uuid/uuid.dart';

String generateUniqueId() {
  const uuid = Uuid();
  return uuid.v4(); // Generates a new random unique ID
}