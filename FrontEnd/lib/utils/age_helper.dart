class AgeHelper {
  static String calculateAge(String dob) {
    try {
      final parts = dob.split('/');
      if (parts.length != 3) return '';

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final birthDate = DateTime(year, month, day);
      final today = DateTime.now();

      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      return '$age years';
    } catch (_) {
      return '';
    }
  }
}
