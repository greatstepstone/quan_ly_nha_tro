/// Stub — resolved at compile time by conditional imports.
/// The real implementations live in export_helper_web.dart and export_helper_mobile.dart.
library export_helper;

export 'export_helper_stub.dart'
    if (dart.library.html) 'export_helper_web.dart'
    if (dart.library.io) 'export_helper_mobile.dart';
