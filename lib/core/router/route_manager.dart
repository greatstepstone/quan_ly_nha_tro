class AppRoutes {
  // ---------------------------------------------------------
  // Route Names (Used for context.pushNamed / context.goNamed)
  // ---------------------------------------------------------
  static const String login = 'login';
  static const String home = 'home';
  static const String reports = 'reports';
  static const String settings = 'settings';
  static const String signUp = 'sign_up';

  static const String properties = 'properties';
  static const String propertyAdd = 'property_add';
  static const String propertyEdit = 'property_edit';

  static const String rooms = 'rooms';
  static const String roomAdd = 'room_add';
  static const String roomDetail = 'room_detail';
  static const String roomEdit = 'room_edit';

  static const String tenants = 'tenants';
  static const String tenantAdd = 'tenant_add';
  static const String tenantDetail = 'tenant_detail';
  static const String tenantEdit = 'tenant_edit';

  static const String contracts = 'contracts';
  static const String contractDetail = 'contract_detail';
  static const String contractAdd = 'contract_add';
  static const String contractEdit = 'contract_edit';

  // Error Dialog

  static const String meterReadings = 'meter_readings';
  static const String meterReadingDetail = 'meter_reading_detail';

  static const String invoices = 'invoices';
  static const String invoiceCreate = 'invoice_create';

  static const String propertyReport = 'property_report';
  static const String profile = 'profile';

  // ---------------------------------------------------------
  // Route Paths (Used only inside app_router.dart for config)
  // ---------------------------------------------------------
  static const String loginPath = '/login';
  static const String homePath = '/';
  static const String reportsPath = '/reports';
  static const String settingsPath = '/settings';
  static const String signUpPath = '/sign-up';

  static const String propertiesPath = '/properties';
  static const String propertyAddPath = '/properties/add';
  static const String propertyEditPath = '/properties/:id/edit';

  static const String roomsPath = '/rooms';
  static const String roomAddPath = '/rooms/add';
  static const String roomDetailPath = '/rooms/:id';
  static const String roomEditPath = '/rooms/:id/edit';

  static const String tenantsPath = '/tenants';
  static const String tenantAddPath = '/rooms/:id/add-tenant';
  static const String tenantDetailPath = '/tenants/:id';
  static const String tenantEditPath = '/tenants/:id/edit';

  static const String contractsPath = '/contracts';
  static const String contractDetailPath = '/contracts/:id';
  static const String contractAddPath = '/contracts/add';
  static const String contractEditPath = '/contracts/:id/edit';

  static const String meterReadingsPath = '/meter-readings';
  static const String meterReadingDetailPath = '/meter-readings/:roomId';

  static const String invoicesPath = '/invoices';
  static const String invoiceCreatePath = '/invoices/create';

  static const String propertyReportPath = '/reports/property';
  static const String profilePath = '/settings/profile';
}
