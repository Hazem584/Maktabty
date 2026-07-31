import 'package:maktabty/core/validation/validation_result.dart';

class WorkHoursValidator {
  const WorkHoursValidator._();

  static ValidationKey? validate({
    int? shift1StartMinutes,
    int? shift1EndMinutes,
    int? shift2StartMinutes,
    int? shift2EndMinutes,
  }) {
    final firstError = _validateShift(shift1StartMinutes, shift1EndMinutes);
    if (firstError != null) return firstError;
    final secondError = _validateShift(shift2StartMinutes, shift2EndMinutes);
    if (secondError != null) return secondError;

    if (shift1StartMinutes != null &&
        shift1EndMinutes != null &&
        shift2StartMinutes != null &&
        shift2EndMinutes != null &&
        shift2StartMinutes < shift1EndMinutes &&
        shift1StartMinutes < shift2EndMinutes) {
      return ValidationKey.overlappingShifts;
    }
    return null;
  }

  static ValidationKey? _validateShift(int? start, int? end) {
    if ((start == null) != (end == null)) {
      return ValidationKey.invalidShiftTimes;
    }
    if (start != null && end != null && end <= start) {
      return ValidationKey.invalidShiftTimes;
    }
    return null;
  }
}
