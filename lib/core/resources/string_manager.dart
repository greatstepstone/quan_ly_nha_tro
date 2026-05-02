class AppStrings {
  static String currentLocale = 'vi';
  static bool get isEn => currentLocale == 'en';

  // General
  static String get appName => isEn ? 'Property Management' : 'Quản Lý Nhà Trọ';
  static String get cancel => isEn ? 'Cancel' : 'Hủy';
  static String get save => isEn ? 'Save' : 'Lưu';
  static String get error => isEn ? 'Error' : 'Lỗi';
  static String get success => isEn ? 'Success' : 'Thành công';
  static String get edit => isEn ? 'Edit' : 'Chỉnh sửa';
  static String get confirm => isEn ? 'Confirm' : 'Xác nhận';
  static String get delete => isEn ? 'Delete' : 'Xóa';
  static String get ok => isEn ? 'OK' : 'Đồng ý';
  static String get close => isEn ? 'Close' : 'Đóng';
  static String get info => isEn ? 'Info' : 'Thông tin';
  static String get zero => '0';
  static String get loading => isEn ? 'Loading...' : 'Đang tải...';
  static String get retry => isEn ? 'Retry' : 'Thử lại';
  static String get errorTitle => isEn ? 'Something went wrong' : 'Đã có lỗi xảy ra';
  static String get errorDesc => isEn ? 'We couldn\'t load the data. Please try again later.' : 'Không thể tải dữ liệu. Vui lòng thử lại sau.';


  // Home Page
  static String get homeGreeting => isEn ? 'Hello,' : 'Xin chào,';
  static String get homeRole => isEn ? 'Owner' : 'Chủ trọ';
  static String get totalRevenue => isEn ? 'THIS MONTH REVENUE' : 'TỔNG THU THÁNG NÀY';
  static String get totalDebt => isEn ? 'OUTSTANDING DEBT' : 'TỔNG NỢ CHƯA THU';
  static String get totalRooms => isEn ? 'ROOMS' : 'SỐ PHÒNG';
  static String get monthlyTasks => isEn ? 'MONTHLY TASKS' : 'NGHIỆP VỤ HÀNG THÁNG';
  static String get meterReadings => isEn ? 'Meter Readings' : 'Ghi điện nước';
  static String get createInvoices => isEn ? 'Create Invoices' : 'Lập hóa đơn';
  static String get management => isEn ? 'MANAGEMENT' : 'QUẢN LÝ';
  static String get properties => isEn ? 'Properties' : 'Nhà trọ';
  static String get rooms => isEn ? 'Rooms' : 'Phòng trọ';
  static String get tenants => isEn ? 'Tenants' : 'Khách thuê';
  static String get invoices => isEn ? 'Invoices' : 'Hóa đơn';

  // Settings
  static String get settings => isEn ? 'System Settings' : 'Cài đặt Hệ thống';
  static String get accountOptions => isEn ? 'ACCOUNT OPTIONS' : 'TÙY CHỌN TÀI KHOẢN';
  static String get appPreferences => isEn ? 'APP PREFERENCES' : 'CÀI ĐẶT ỨNG DỤNG';
  static String get language => isEn ? 'Language' : 'Ngôn ngữ';
  static String get darkMode => isEn ? 'Dark Mode' : 'Chế độ tối';
  static String get logout => isEn ? 'Logout' : 'Đăng xuất';
  static String get profile => isEn ? 'Personal Info' : 'Thông tin cá nhân';
  static String get notifications => isEn ? 'Notifications' : 'Thông báo';
  static String get security => isEn ? 'Security & Privacy' : 'Bảo mật & Quyền riêng tư';
  static String get help => isEn ? 'Help & Support' : 'Trợ giúp & Hỗ trợ';
  static String get askLogout => isEn ? 'Logout?' : 'Đăng xuất?';
  static String get sureLogout => isEn ? 'Are you sure you want to logout?' : 'Bạn có chắc muốn đăng xuất?';

  // Owner Profile
  static String get profileTitle => isEn ? 'Owner Profile' : 'Thông tin chủ trọ';
  static String get verifiedIdentity => isEn ? 'Verified Identity' : 'Đã xác minh danh tính';
  static String get phoneNumber => isEn ? 'PHONE NUMBER' : 'SỐ ĐIỆN THOẠI';
  static String get contactEmail => isEn ? 'CONTACT EMAIL' : 'EMAIL LIÊN HỆ';
  static String get permanentAddress => isEn ? 'PERMANENT ADDRESS' : 'ĐỊA CHỈ THƯỜNG TRÚ';
  static String get joinDate => isEn ? 'JOIN DATE' : 'NGÀY THAM GIA';
  static String get monthsAgo => isEn ? '9 months ago' : '9 tháng trước';
  static String get managedRooms => isEn ? 'Managed Rooms' : 'Phòng đang quản lý';
  static String get credibilityRating => isEn ? 'Credibility Rating' : 'Đánh giá uy tín';
  static String get responseRate => isEn ? 'Response Rate' : 'Tỷ lệ phản hồi';
  static String get editInfo => isEn ? 'Edit Information' : 'Chỉnh sửa thông tin';
  static String get privacyPolicySnippet => isEn 
      ? 'All personal information is secured according to\nAzure Clarity\'s policy.' 
      : 'Mọi thông tin cá nhân đều được bảo mật theo quy định\ncủa Azure Clarity.';

  // Properties List
  static String get propertiesListTitle => isEn ? 'Properties List' : 'Danh sách nhà trọ';
  static String get propertyName => isEn ? 'Property Name' : 'Tên nhà trọ';
  static String get propertyAddress => isEn ? 'Property Address' : 'Địa chỉ nhà trọ';
  static String get addNewPropertyTitle => isEn ? 'Add a new property' : 'Thêm nhà trọ mới';
  static String get addNewPropertyDesc => isEn ? 'Start managing a new property with full contract and tenant details.' : 'Bắt đầu quản lý nhà trọ mới với đầy đủ thông tin hợp đồng và khách thuê.';
  static String get addNowBtn => isEn ? 'Add Now' : 'Thêm ngay';
  static String get editProperty => isEn ? 'Edit Property' : 'Chỉnh sửa nhà trọ';
  static String get searchPropertyHint => isEn ? 'Search properties...' : 'Tìm kiếm nhà trọ...';
  static String get noPropertyFound => isEn ? 'No properties found' : 'Chưa có dữ liệu nhà trọ';
  static String get roomsCountSuffix => isEn ? 'rooms' : 'phòng';


  // Property Hints
  static String get propertyNameHint => isEn ? 'Ex: Azure House - District 1' : 'Ví dụ: Azure House - Quận 1';
  static String get propertyAddressHint => isEn ? 'House number, street name, ward/commune...' : 'Số nhà, tên đường, phường/xã...';

  // Property Config
  static String get propertyConfig => isEn ? 'PROPERTY CONFIGURATION' : 'CẤU HÌNH NHÀ TRỌ';
  static String get basicInfo => isEn ? 'BASIC INFORMATION' : 'THÔNG TIN CƠ BẢN';
  static String get commonPriceConfig => isEn ? 'COMMON PRICE CONFIGURATION' : 'CẤU HÌNH ĐƠN GIÁ CHUNG';
  static String get billingSystem => isEn ? 'BILLING SYSTEM' : 'HỆ THỐNG TÍNH PHÍ';
  static String get perKwh => isEn ? 'PER KWH' : 'MỖI KWH';
  static String get perM3 => isEn ? 'PER M3' : 'MỖI M3';
  static String get monthly => isEn ? 'MONTHLY' : 'HÀNG THÁNG';
  static String get fixed => isEn ? 'FIXED' : 'CỐ ĐỊNH';
  static String get otherFee => isEn ? 'Other Fees' : 'Phí khác';
  static String get saveChanges => isEn ? 'Save Changes' : 'Lưu thay đổi';
  

  // Property messages
  static String get addPropertySuccess => isEn ? 'Property added successfully' : 'Thêm nhà trọ thành công';
  static String get addPropertyError => isEn ? 'Error adding property' : 'Lỗi thêm nhà trọ';
  static String get editPropertySuccess => isEn ? 'Property updated successfully' : 'Cập nhật nhà trọ thành công';
  static String get editPropertyError => isEn ? 'Error updating property' : 'Lỗi cập nhật nhà trọ';
  static String get deletePropertySuccess => isEn ? 'Property deleted successfully' : 'Xóa nhà trọ thành công';
  static String get deletePropertyError => isEn ? 'Error deleting property' : 'Lỗi xóa nhà trọ';
  static String get totalProperties => isEn ? 'TOTAL PROPERTIES' : 'TỔNG SỐ NHÀ';
  static String get totalRoomsLabel => isEn ? 'TOTAL ROOMS' : 'TỔNG SỐ PHÒNG';



  

  // Services List
  static String get servicesListTitle => isEn ? 'Services List' : 'Danh sách dịch vụ';
  static String get internet => isEn ? 'Internet' : 'Internet';
  static String get trash => isEn ? 'Trash' : 'Rác';
  static String get electricity => isEn ? 'Electricity' : 'Điện';
  static String get water => isEn ? 'Water' : 'Nước';
  static String get electricityBill => isEn ? 'Electricity Bill' : 'Hóa đơn điện';
  static String get waterBill => isEn ? 'Water Bill' : 'Hóa đơn nước';
  static String get internetBill => isEn ? 'Internet Bill' : 'Hóa đơn internet';
  static String get trashBill => isEn ? 'Trash Bill' : 'Hóa đơn rác';


  // Rooms List
  static String get roomsListTitle => isEn ? 'Rooms List' : 'Danh sách phòng';
  static String get filterAll => isEn ? 'All' : 'Tất cả';
  static String get filterEmpty => isEn ? 'Empty' : 'Đang trống';
  static String get filterRented => isEn ? 'Rented' : 'Đã thuê';
  static String get filterMaintenance => isEn ? 'Maintenance' : 'Đang sửa';
  static String get searchRoomHint => isEn ? 'Search room by name or number...' : 'Tìm kiếm phòng theo tên hoặc số phòng...';
  static String get noRoomFound => isEn ? 'No rooms found' : 'Không tìm thấy phòng phù hợp';
  static String get noRoomYet => isEn ? 'No rooms yet' : 'Chưa có phòng nào';
  static String get statusString => isEn ? 'Status' : 'Trạng thái';
  static String get addNewRoomTitle => isEn ? 'Add a new room' : 'Thêm phòng mới vào hệ thống';
  static String get addNewRoomDesc => isEn ? 'Start managing a new room with full contract and tenant details.' : 'Bắt đầu quản lý phòng mới với đầy đủ thông tin hợp đồng và khách thuê.';
  static String get quickStats => isEn ? 'QUICK STATS' : 'THÔNG SỐ NHANH';
  static String get occupiedRoomsLabel => isEn ? 'Occupied rooms' : 'Phòng đã có người ở';
  static String get occupancyRate => isEn ? 'Occupancy Rate' : 'Công suất lấp đầy';

  // Result Message
  static String get emptyFieldsError => isEn ? 'Please fill in all fields' : 'Vui lòng điền đầy đủ thông tin';
  static String get notLoggedInError => isEn ? 'You are not logged in' : 'Bạn chưa đăng nhập';

  static String get addRoomSuccess => isEn ? 'Room added successfully' : 'Thêm phòng thành công';
  static String get addRoomError => isEn ? 'Error adding room' : 'Lỗi thêm phòng';


  // others
  static String get totalDebtUnpaid => isEn ? 'Total Unpaid Debt' : 'Tổng nợ chưa thu';

  // Home widget labels
  static String get homeHome => isEn ? 'Home' : 'Trang chủ';
  static String get homeProperties => isEn ? 'Properties' : 'Nhà trọ';
  static String get homeRooms => isEn ? 'Rooms' : 'Phòng trọ';
  static String get homeTenants => isEn ? 'Tenants' : 'Khách thuê';
  static String get homeInvoices => isEn ? 'Invoices' : 'Hóa đơn';
  static String get homeManagement => isEn ? 'MANAGEMENT' : 'QUẢN LÝ';
  static String get homeReports => isEn ? 'STATISTICS AND REPORTS' : 'THỐNG KÊ VÀ BÁO CÁO';
  static String get homePerformance => isEn ? 'Operational Performance' : 'Hiệu suất vận hành';
  static String get homeOccupancyRate => isEn ? 'Occupancy rate reached 92% this month.' : 'Tỷ lệ lấp đầy đạt 92% trong tháng này.';
  static String get homePoints => isEn ? '/ 10 points' : '/ 10 điểm';

  static String get homePropertiesSuffix => isEn ? 'Buildings' : 'Tòa nhà';
  static String get homeRoomsSuffix => isEn ? 'Empty rooms' : 'Phòng trống';
  static String get homeTenantsSuffix => isEn ? 'Contracts' : 'Hợp đồng';
  static String get homeInvoicesSuffix => isEn ? 'Unpaid' : 'Chưa thanh toán';

  static String get currencySymbol => isEn ? '\$' : 'đ';
  static String get homeRevenue => isEn ? 'Revenue' : 'Doanh thu';
  static String get homeDebt => isEn ? 'Debt Management' : 'Quản lý Nợ';
  static String get homeExportData => isEn ? 'Export Data' : 'Xuất dữ liệu';
  static String get homeExcelReport => isEn ? 'Excel Report' : 'Báo cáo Excel';

  static String get month => isEn ? 'Month' : 'Tháng';
  static String get perMonth => isEn ? 'per Month' : 'mỗi tháng';
  static String get electricityPrice => isEn ? 'Electricity Price' : 'Giá điện';
  static String get waterPrice => isEn ? 'Water Price' : 'Giá nước';

  // Login Page
  static String get loginReadyToManage => isEn ? 'Ready to Manage?' : 'Sẵn sàng quản lý?';
  static String get loginSignInToStart => isEn ? 'Sign in now to start optimizing your business process.' : 'Đăng nhập ngay để bắt đầu tối ưu quy trình kinh doanh của bạn.';
  static String get loginEmailHint => isEn ? 'Email (test@example.com)' : 'Email (test@example.com)';
  static String get loginPassword => isEn ? 'Password' : 'Mật khẩu';
  static String get loginEmailSignIn => isEn ? 'Email Sign In' : 'Đăng nhập Email';
  static String get loginQuickDev => isEn ? 'Quick Dev Login' : 'Quick Dev Login';
  static String get loginGuestMode => isEn ? 'Experience without an account' : 'Trải nghiệm không cần tài khoản';
  static String get loginOrContinueWith => isEn ? 'Or continue with' : 'Hoặc tiếp tục với';
  static String get loginFooter => isEn ? '© 2026 Azure Clarity. Designed for simplicity.' : '© 2026 Azure Clarity. Thiết kế cho sự đơn giản.';
  static String get loginEmailPasswordRequired => isEn ? 'Please enter Email and Password' : 'Vui lòng nhập Email và Mật khẩu';
  static String get loginDevUser => isEn ? 'Developer User' : 'Developer User';
  static String get loginDevAccountCreated => isEn ? 'Dev account created. Please check email or try again.' : 'Tài khoản Dev đã được tạo. Vui lòng kiểm tra email hoặc thử lại.';
  static String get loginErrorPrefix => isEn ? 'Error: ' : 'Lỗi: ';
  static String get loginFailPrefix => isEn ? 'Login failed: ' : 'Đăng nhập thất bại: ';
  static String get loginTryGuestBtn => isEn ? 'Try Guest Mode' : 'Thử Guest Mode';
  static String get loginGeneralError => isEn ? 'Login error. Please try again.' : 'Lỗi đăng nhập. Vui lòng thử lại.';
  static String get loginServerConnectionError => isEn ? 'Could not connect to server. Please try again.' : 'Không thể kết nối với máy chủ. Vui lòng thử lại.';
  static String get loginManagementEcosystem => isEn ? 'Management Ecosystem' : 'Management Ecosystem';
}
