/// Stub — resolved at compile time by conditional imports.
/// The real implementations live in export_service_web.dart and export_service_mobile.dart.
library;

export 'export_service_stub.dart'
    if (dart.library.html) 'export_service_web.dart'
    if (dart.library.io) 'export_service_mobile.dart';
