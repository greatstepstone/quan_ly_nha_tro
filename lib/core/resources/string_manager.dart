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
  static String get addNowBtn => isEn ? 'Add Now' : 'Thêm ngay';
  static String get quickStats => isEn ? 'QUICK STATS' : 'THÔNG SỐ NHANH';
  static String get occupiedRoomsLabel => isEn ? 'Occupied rooms' : 'Phòng đã có người ở';
  static String get occupancyRate => isEn ? 'Occupancy Rate' : 'Công suất lấp đầy';
}
