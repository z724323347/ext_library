import 'package:flutter/foundation.dart';

import 'adapter_wrapper.dart';

/// Util functions for the Adapter Framework.
class AdapterUtils {
  /// [AdapterBehavior] order.
  ///
  /// For breakpoints with the same value, ordering
  /// controls proper breakpoint behavior resolution.
  /// Preserve input order for breakpoints..
  /// Tags are always ranked last because they are
  /// inert.
  static Map<AdapterBehavior, int> breakpointCompartorList = {
    AdapterBehavior.AUTOSCALEDOWN: 0,
    AdapterBehavior.RESIZE: 0,
    AdapterBehavior.AUTOSCALE: 0,
    AdapterBehavior.TAG: 1,
  };

  /// Comparator function to order [AdapterBreakpoint]s.
  ///
  /// Order breakpoints from smallest to largest based
  /// on breakpoint value.
  /// When breakpoint values are equal, map
  /// [AdapterBehavior] to their
  /// ordering value in [breakpointCompartorList]
  /// and compare.
  static int breakpointComparator(AdapterBreakpoint a, AdapterBreakpoint b) {
    // If breakpoints are equal, return in comparator order.
    if (a.breakpoint == b.breakpoint) {
      return breakpointCompartorList[a.behavior]!
          .compareTo(breakpointCompartorList[b.behavior]!);
    }

    // Breakpoints are not equal can be compared directly.
    return a.breakpoint.compareTo(b.breakpoint);
  }

  /// Print a visual view of [breakpointSegments]
  /// for debugging purposes.
  static String debugLogBreakpointSegments(
      List<AdapterBreakpointSegment> breakpointSegments) {
    var stringBuffer = StringBuffer();
    stringBuffer.write('|');
    for (int i = 0; i < breakpointSegments.length; i++) {
      // Convenience variable.
      AdapterBreakpointSegment segment = breakpointSegments[i];
      stringBuffer.write(segment.breakpoint.round());
      List<dynamic> attributes = [];
      String? name = segment.adapterBreakpoint.name;
      if (name != null) attributes.add(name);
      double scaleFactor = segment.adapterBreakpoint.scaleFactor;
      if (scaleFactor != 1) attributes.add(scaleFactor);
      if (attributes.isNotEmpty) {
        stringBuffer.write('(');
        for (int i = 0; i < attributes.length; i++) {
          stringBuffer.write(attributes[i]);
          if (i != attributes.length - 1) stringBuffer.write('|');
        }
        stringBuffer.write(')');
      }
      stringBuffer.write(' ----- ');
      if (segment.segmentType == AdapterBehavior.AUTOSCALEDOWN &&
          segment.breakpoint < segment.adapterBreakpoint.breakpoint) {
        stringBuffer.write(
            '${describeEnum(segment.segmentType)} from ${segment.adapterBreakpoint.breakpoint.round()}');
      } else {
        stringBuffer.write(describeEnum(segment.adapterBreakpoint.behavior));
      }
      if (i != breakpointSegments.length - 1) {
        stringBuffer.write(' ----- ');
      }
    }
    stringBuffer.write(' ----- ∞ |');
    debugPrint(stringBuffer.toString());
    return stringBuffer.toString();
  }
}

enum AdapterPlatform {
  android,
  fuchsia,
  iOS,
  linux,
  macOS,
  windows,
  web,
  ohos,
}

extension TargetPlatformExtension on String {
  AdapterPlatform get adapterPlatform {
    switch (this) {
      case 'android':
        return AdapterPlatform.android;
      case 'fuchsia':
        return AdapterPlatform.fuchsia;
      case 'ios':
        return AdapterPlatform.iOS;
      case 'linux':
        return AdapterPlatform.linux;
      case 'macos':
        return AdapterPlatform.macOS;
      case 'windows':
        return AdapterPlatform.windows;
      case 'ohos':
        return AdapterPlatform.ohos;
    }

    return AdapterPlatform.android;
  }
}
