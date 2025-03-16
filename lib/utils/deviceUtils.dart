import 'package:gaimon/gaimon.dart';

enum HapticLevel {
  light,
  medium,
  heavy,
  soft,
  rigid,
  success,
  warning,
  error,
  tap
}

class HapticUtil {
  static vibrate({HapticLevel? level = HapticLevel.tap}) async {
    final supportsHaptic = await Gaimon.canSupportsHaptic;
    if (supportsHaptic) {
      switch (level) {
        case HapticLevel.light:
          Gaimon.light();
          break;
        case HapticLevel.medium:
          Gaimon.medium();
          break;
        case HapticLevel.heavy:
          Gaimon.heavy();
          break;
        case HapticLevel.soft:
          Gaimon.soft();
          break;
        case HapticLevel.rigid:
          Gaimon.rigid();
          break;
        case HapticLevel.success:
          Gaimon.success();
          break;
        case HapticLevel.warning:
          Gaimon.warning();
          break;
        case HapticLevel.error:
          Gaimon.error();
          break;
        case HapticLevel.tap:
          Gaimon.selection();
          break;
        default:
          Gaimon.selection();
          break;
      }
    }
  }
}
