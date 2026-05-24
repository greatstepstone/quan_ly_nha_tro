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
  static String get home => isEn ? 'Home' : 'Trang chủ';
  static String get reports => isEn ? 'Reports' : 'Báo cáo';
  static String get zero => '0';
  static String get loading => isEn ? 'Loading...' : 'Đang tải...';
  static String get retry => isEn ? 'Retry' : 'Thử lại';
  static String get errorTitle =>
      isEn ? 'Something went wrong' : 'Đã có lỗi xảy ra';
  static String get errorDesc =>
      isEn
          ? 'We couldn\'t load the data. Please try again later.'
          : 'Không thể tải dữ liệu. Vui lòng thử lại sau.';

  // Image Picker
  static String get takePhoto => isEn ? 'Take Photo' : 'Chụp ảnh';
  static String get chooseFromGallery =>
      isEn ? 'Choose from Gallery' : 'Chọn từ thư viện';

  // Home Page
  static String get homeGreeting => isEn ? 'Hello,' : 'Xin chào,';
  static String get homeRole => isEn ? 'Owner' : 'Chủ trọ';
  static String get totalRevenue =>
      isEn ? 'THIS MONTH REVENUE' : 'TỔNG THU THÁNG NÀY';
  static String get totalDebt => isEn ? 'OUTSTANDING DEBT' : 'TỔNG NỢ CHƯA THU';
  static String get totalRooms => isEn ? 'ROOMS' : 'SỐ PHÒNG';
  static String get monthlyTasks =>
      isEn ? 'MONTHLY TASKS' : 'NGHIỆP VỤ HÀNG THÁNG';
  static String get meterReadings => isEn ? 'Meter Readings' : 'Ghi điện nước';
  static String get updateReadings => isEn ? 'Update readings' : 'Cập nhật chỉ số';
  static String get createInvoices => isEn ? 'Create Invoices' : 'Lập hóa đơn';
  static String get currentMonthPeriod => isEn ? 'Current month' : 'Kỳ tháng hiện tại';
  static String get cashFlow => isEn ? 'Cash Flow' : 'Thu chi';
  static String get cashLedger => isEn ? 'Cash Ledger' : 'Sổ quỹ tiền mặt';
  static String get management => isEn ? 'MANAGEMENT' : 'QUẢN LÝ';
  static String get properties => isEn ? 'Properties' : 'Nhà trọ';
  static String get rooms => isEn ? 'Rooms' : 'Phòng trọ';
  // static String get tenants => isEn ? 'Tenants' : 'Khách thuê';
  static String get invoices => isEn ? 'Invoices' : 'Hóa đơn';

  // Settings
  static String get settings => isEn ? 'Settings' : 'Cài đặt';
  static String get accountOptions =>
      isEn ? 'ACCOUNT OPTIONS' : 'TÙY CHỌN TÀI KHOẢN';
  static String get appPreferences =>
      isEn ? 'APP PREFERENCES' : 'CÀI ĐẶT ỨNG DỤNG';
  static String get language => isEn ? 'Language' : 'Ngôn ngữ';
  static String get darkMode => isEn ? 'Dark Mode' : 'Chế độ tối';
  static String get logout => isEn ? 'Logout' : 'Đăng xuất';
  static String get profile => isEn ? 'Personal Info' : 'Thông tin cá nhân';
  static String get notifications => isEn ? 'Notifications' : 'Thông báo';
  static String get security =>
      isEn ? 'Security & Privacy' : 'Bảo mật & Quyền riêng tư';
  static String get help => isEn ? 'Help & Support' : 'Trợ giúp & Hỗ trợ';
  static String get askLogout => isEn ? 'Logout?' : 'Đăng xuất?';
  static String get sureLogout =>
      isEn ? 'Are you sure you want to logout?' : 'Bạn có chắc muốn đăng xuất?';

  // Owner Profile
  static String get profileTitle =>
      isEn ? 'Owner Profile' : 'Thông tin chủ trọ';
  static String get verifiedIdentity =>
      isEn ? 'Verified Identity' : 'Đã xác minh danh tính';
  static String get phoneNumber => isEn ? 'PHONE NUMBER' : 'SỐ ĐIỆN THOẠI';
  static String get contactEmail => isEn ? 'CONTACT EMAIL' : 'EMAIL LIÊN HỆ';
  static String get permanentAddress =>
      isEn ? 'PERMANENT ADDRESS' : 'ĐỊA CHỈ THƯỜNG TRÚ';
  static String get joinDate => isEn ? 'JOIN DATE' : 'NGÀY THAM GIA';
  static String get monthsAgo => isEn ? '9 months ago' : '9 tháng trước';
  static String get managedRooms =>
      isEn ? 'Managed Rooms' : 'Phòng đang quản lý';
  static String get credibilityRating =>
      isEn ? 'Credibility Rating' : 'Đánh giá uy tín';
  static String get responseRate => isEn ? 'Response Rate' : 'Tỷ lệ phản hồi';
  static String get editInfo =>
      isEn ? 'Edit Information' : 'Chỉnh sửa thông tin';
  static String get privacyPolicySnippet =>
      isEn
          ? 'All personal information is secured according to\nAzure Clarity\'s policy.'
          : 'Mọi thông tin cá nhân đều được bảo mật theo quy định\ncủa Azure Clarity.';

  // Properties List
  static String get propertiesListTitle =>
      isEn ? 'Properties List' : 'Danh sách nhà trọ';
  static String get propertyName => isEn ? 'Property Name' : 'Tên nhà trọ';
  static String get propertyAddress =>
      isEn ? 'Property Address' : 'Địa chỉ nhà trọ';
  static String get addNewPropertyTitle =>
      isEn ? 'Add a new property' : 'Thêm nhà trọ mới';
  static String get addNewPropertyDesc =>
      isEn
          ? 'Start managing a new property with full contract and tenant details.'
          : 'Bắt đầu quản lý nhà trọ mới với đầy đủ thông tin hợp đồng và khách thuê.';
  static String get addNowBtn => isEn ? 'Add Now' : 'Thêm ngay';
  static String get editProperty =>
      isEn ? 'Edit Property' : 'Chỉnh sửa nhà trọ';
  static String get searchPropertyHint =>
      isEn ? 'Search properties...' : 'Tìm kiếm nhà trọ...';
  static String get noPropertyFound =>
      isEn ? 'No properties found' : 'Chưa có dữ liệu nhà trọ';
  static String get roomsCountSuffix => isEn ? 'rooms' : 'phòng';

  // Property Hints
  static String get propertyNameHint =>
      isEn ? 'Ex: Azure House - District 1' : 'Ví dụ: Azure House - Quận 1';
  static String get propertyAddressHint =>
      isEn
          ? 'House number, street name, ward/commune...'
          : 'Số nhà, tên đường, phường/xã...';

  // Property Config
  static String get propertyConfig =>
      isEn ? 'PROPERTY CONFIGURATION' : 'CẤU HÌNH NHÀ TRỌ';
  static String get basicInfo =>
      isEn ? 'BASIC INFORMATION' : 'THÔNG TIN CƠ BẢN';
  static String get commonPriceConfig =>
      isEn ? 'COMMON PRICE CONFIGURATION' : 'CẤU HÌNH ĐƠN GIÁ CHUNG';
  static String get billingSystem =>
      isEn ? 'BILLING SYSTEM' : 'HỆ THỐNG TÍNH PHÍ';
  static String get perKwh => isEn ? 'PER KWH' : 'MỖI KWH';
  static String get perM3 => isEn ? 'PER M3' : 'MỖI M3';
  static String get monthly => isEn ? 'MONTHLY' : 'HÀNG THÁNG';
  static String get fixed => isEn ? 'FIXED' : 'CỐ ĐỊNH';
  static String get perPerson => isEn ? 'PER PERSON' : 'TRÊN NGƯỜI';
  static String get otherFee => isEn ? 'Other Fees' : 'Phí khác';
  static String get saveChanges => isEn ? 'Save Changes' : 'Lưu thay đổi';

  // Property messages
  static String get addPropertySuccess =>
      isEn ? 'Property added successfully' : 'Thêm nhà trọ thành công';
  static String get addPropertyError =>
      isEn ? 'Error adding property' : 'Lỗi thêm nhà trọ';
  static String get editPropertySuccess =>
      isEn ? 'Property updated successfully' : 'Cập nhật nhà trọ thành công';
  static String get editPropertyError =>
      isEn ? 'Error updating property' : 'Lỗi cập nhật nhà trọ';
  static String get deletePropertySuccess =>
      isEn ? 'Property deleted successfully' : 'Xóa nhà trọ thành công';
  static String get deletePropertyError =>
      isEn ? 'Error deleting property' : 'Lỗi xóa nhà trọ';
  static String get totalProperties =>
      isEn ? 'TOTAL PROPERTIES' : 'TỔNG SỐ NHÀ';
  static String get totalRoomsLabel => isEn ? 'TOTAL ROOMS' : 'TỔNG SỐ PHÒNG';

  // Services List
  static String get servicesListTitle =>
      isEn ? 'Services List' : 'Danh sách dịch vụ';
  static String get internet => isEn ? 'Internet' : 'Internet';
  static String get trash => isEn ? 'Trash' : 'Rác';
  static String get electricity => isEn ? 'Electricity' : 'Điện';
  static String get water => isEn ? 'Water' : 'Nước';
  static String get electricityBill =>
      isEn ? 'Electricity Bill' : 'Hóa đơn điện';
  static String get waterBill => isEn ? 'Water Bill' : 'Hóa đơn nước';
  static String get internetBill => isEn ? 'Internet Bill' : 'Hóa đơn internet';
  static String get trashBill => isEn ? 'Trash Bill' : 'Hóa đơn rác';

  // Rooms List
  static String get roomsListTitle => isEn ? 'Rooms List' : 'Danh sách phòng';
  static String get filterAll => isEn ? 'All' : 'Tất cả';
  static String get filterEmpty => isEn ? 'Empty' : 'Đang trống';
  static String get filterRented => isEn ? 'Rented' : 'Đã thuê';
  static String get filterMaintenance => isEn ? 'Maintenance' : 'Đang sửa';
  static String get searchRoomHint =>
      isEn
          ? 'Search room by name or number...'
          : 'Tìm kiếm phòng theo tên hoặc số phòng...';
  static String get noRoomFound =>
      isEn ? 'No rooms found' : 'Không tìm thấy phòng phù hợp';
  static String get noRoomYet => isEn ? 'No rooms yet' : 'Chưa có phòng nào';
  static String get statusString => isEn ? 'Status' : 'Trạng thái';
  static String get addNewRoomTitle =>
      isEn ? 'Add a new room' : 'Thêm phòng mới vào hệ thống';
  static String get addNewRoomDesc =>
      isEn
          ? 'Start managing a new room with full contract and tenant details.'
          : 'Bắt đầu quản lý phòng mới với đầy đủ thông tin hợp đồng và khách thuê.';
  static String get quickStats => isEn ? 'QUICK STATS' : 'THÔNG SỐ NHANH';
  static String get occupiedRoomsLabel =>
      isEn ? 'Occupied rooms' : 'Phòng đã có người ở';
  static String get occupancyRate =>
      isEn ? 'Occupancy Rate' : 'Công suất lấp đầy';

  // Result Message
  static String get emptyFieldsError =>
      isEn ? 'Please fill in all fields' : 'Vui lòng điền đầy đủ thông tin';
  static String get notLoggedInError =>
      isEn ? 'You are not logged in' : 'Bạn chưa đăng nhập';

  static String get addRoomSuccess =>
      isEn ? 'Room added successfully' : 'Thêm phòng thành công';
  static String get addRoomError =>
      isEn ? 'Error adding room' : 'Lỗi thêm phòng';

  // others
  static String get totalDebtUnpaid =>
      isEn ? 'Total Unpaid Debt' : 'Tổng nợ chưa thu';

  // Home widget labels
  static String get homeHome => isEn ? 'Home' : 'Trang chủ';
  static String get homeProperties => isEn ? 'Properties' : 'Nhà trọ';
  static String get homeRooms => isEn ? 'Rooms' : 'Phòng trọ';
  static String get homeTenants => isEn ? 'Tenants' : 'Khách thuê';
  static String get homeInvoices => isEn ? 'Invoices' : 'Hóa đơn';
  static String get homeManagement => isEn ? 'MANAGEMENT' : 'QUẢN LÝ';
  static String get homeReports =>
      isEn ? 'STATISTICS AND REPORTS' : 'THỐNG KÊ VÀ BÁO CÁO';
  static String get homePerformance =>
      isEn ? 'Operational Performance' : 'Hiệu suất vận hành';
  static String get homeOccupancyRate =>
      isEn
          ? 'Occupancy rate reached 92% this month.'
          : 'Tỷ lệ lấp đầy đạt 92% trong tháng này.';
  static String get homePoints => isEn ? '/ 10 points' : '/ 10 điểm';

  static String get homePropertiesSuffix => isEn ? 'Buildings' : 'Tòa nhà';
  static String get homeRoomsSuffix => isEn ? 'Empty rooms' : 'Phòng trống';
  static String get homeTenantsSuffix => isEn ? 'Tenants' : 'Khách thuê';
  static String get homeContractsSuffix => isEn ? 'Contracts' : 'Hợp đồng';
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
  static String get loginReadyToManage =>
      isEn ? 'Ready to Manage?' : 'Sẵn sàng quản lý?';
  static String get loginSignInToStart =>
      isEn
          ? 'Sign in now to start optimizing your business process.'
          : 'Đăng nhập ngay để bắt đầu tối ưu quy trình kinh doanh của bạn.';
  static String get loginEmailHint =>
      isEn ? 'Email (test@example.com)' : 'Email (test@example.com)';
  static String get loginPassword => isEn ? 'Password' : 'Mật khẩu';
  static String get loginEmailSignIn =>
      isEn ? 'Email Sign In' : 'Đăng nhập Email';
  static String get loginQuickDev =>
      isEn ? 'Quick Dev Login' : 'Quick Dev Login';
  static String get loginGuestMode =>
      isEn
          ? 'Experience without an account'
          : 'Trải nghiệm không cần tài khoản';
  static String get loginOrContinueWith =>
      isEn ? 'Or continue with' : 'Hoặc tiếp tục với';
  static String get loginFooter =>
      isEn
          ? '© 2026 Azure Clarity. Designed for simplicity.'
          : '© 2026 Azure Clarity. Thiết kế cho sự đơn giản.';
  static String get loginEmailPasswordRequired =>
      isEn
          ? 'Please enter Email and Password'
          : 'Vui lòng nhập Email và Mật khẩu';
  static String get loginDevUser => isEn ? 'Developer User' : 'Developer User';
  static String get loginDevAccountCreated =>
      isEn
          ? 'Dev account created. Please check email or try again.'
          : 'Tài khoản Dev đã được tạo. Vui lòng kiểm tra email hoặc thử lại.';
  static String get loginErrorPrefix => isEn ? 'Error: ' : 'Lỗi: ';
  static String get loginFailPrefix =>
      isEn ? 'Login failed: ' : 'Đăng nhập thất bại: ';
  static String get loginTryGuestBtn =>
      isEn ? 'Try Guest Mode' : 'Thử Guest Mode';
  static String get loginGeneralError =>
      isEn
          ? 'Login error. Please try again.'
          : 'Lỗi đăng nhập. Vui lòng thử lại.';
  static String get loginServerConnectionError =>
      isEn
          ? 'Could not connect to server. Please try again.'
          : 'Không thể kết nối với máy chủ. Vui lòng thử lại.';
  static String get loginManagementEcosystem =>
      isEn ? 'Management Ecosystem' : 'Hệ sinh thái Quản lý';

  // Sign Up Page
  static String get signUpTitle => isEn ? 'Create Account' : 'Tạo tài khoản';
  static String get signUpSubtitle =>
      isEn
          ? 'Join us to start managing your properties professionally.'
          : 'Tham gia cùng chúng tôi để bắt đầu quản lý nhà trọ chuyên nghiệp.';
  static String get signUpFullName => isEn ? 'Full Name' : 'Họ và tên';
  static String get signUpFullNameHint =>
      isEn ? 'Enter your full name' : 'Nhập họ và tên của bạn';
  static String get signUpEmailHint => isEn ? 'Email address' : 'Địa chỉ email';
  static String get signUpPasswordHint =>
      isEn ? 'Create password' : 'Tạo mật khẩu';
  static String get signUpBtn => isEn ? 'Sign Up' : 'Đăng ký';
  static String get signUpAlreadyHaveAccount =>
      isEn ? 'Already have an account?' : 'Đã có tài khoản?';
  static String get signUpLoginNow => isEn ? 'Login Now' : 'Đăng nhập ngay';
  static String get signUpSuccess =>
      isEn
          ? 'Account created successfully! Please verify your email.'
          : 'Tạo tài khoản thành công! Vui lòng xác minh email.';
  static String get signUpError =>
      isEn
          ? 'Sign up failed. Please try again.'
          : 'Đăng ký thất bại. Vui lòng thử lại.';
  static String get signUpConfirmPassword =>
      isEn ? 'Confirm Password' : 'Xác nhận mật khẩu';
  static String get signUpPasswordMismatch =>
      isEn ? 'Passwords do not match' : 'Mật khẩu không khớp';
  static String get signUpNoAccountYet =>
      isEn ? "Don't have an account?" : 'Chưa có tài khoản?';
  static String get signUpCreateOne => isEn ? 'Create One' : 'Tạo ngay';

  // Invoices & Export
  static String get invoiceTitle => isEn ? 'Create Invoice' : 'Lập hóa đơn';
  static String get invoiceRoomInfo =>
      isEn ? 'ROOM INFORMATION' : 'THÔNG TIN PHÒNG';
  static String get invoiceTenantLabel => isEn ? 'Tenant: ' : 'Khách thuê: ';
  static String get invoiceElectricityWater =>
      isEn ? 'Electricity & Water' : 'Điện & Nước';
  static String get invoiceElectricOld =>
      isEn ? 'Old Electric' : 'Chỉ số điện cũ';
  static String get invoiceElectricNew =>
      isEn ? 'New Electric' : 'Chỉ số điện mới';
  static String get invoiceWaterOld => isEn ? 'Old Water' : 'Chỉ số nước cũ';
  static String get invoiceWaterNew => isEn ? 'New Water' : 'Chỉ số nước mới';
  static String get invoiceElectricCost => isEn ? 'Electric Cost' : 'Tiền điện';
  static String get invoiceWaterCost => isEn ? 'Water Cost' : 'Tiền nước';
  static String get invoiceRentServices =>
      isEn ? 'Rent & Services' : 'Tiền phòng & Dịch vụ';
  static String get invoiceNotes => isEn ? 'Notes' : 'Ghi chú';
  static String get invoiceNotesHint =>
      isEn
          ? 'Enter notes for this invoice...'
          : 'Nhập ghi chú cho hóa đơn này...';
  static String get invoiceTotalAmountToPay =>
      isEn ? 'Total amount to pay' : 'Tổng số tiền cần thanh toán';
  static String get invoiceExportBtn =>
      isEn ? 'Export Invoice' : 'Xuất hóa đơn';
  static String get invoiceSaveBtn => isEn ? 'Save Invoice' : 'Lưu hóa đơn';
  static String get invoiceUpdateBtn =>
      isEn ? 'Update Invoice' : 'Cập nhật hóa đơn';
  static String get invoiceSaveSuccess =>
      isEn ? 'Invoice saved successfully for ' : 'Đã lưu hóa đơn ';
  static String get invoiceSaveError => isEn ? 'Error: ' : 'Lỗi: ';
  static String get invoiceMustSaveBeforeExport =>
      isEn
          ? 'Please save invoice before exporting!'
          : 'Vui lòng lưu hóa đơn trước khi xuất!';
  static String get invoiceRoomNotFound =>
      isEn ? 'Room not found.' : 'Không tìm thấy phòng.';
  static String get invoiceLoginRequired =>
      isEn ? 'Please login again' : 'Vui lòng đăng nhập lại';
  static String get invoiceStatusTitle =>
      isEn ? 'Invoice Status' : 'Trạng thái hóa đơn';
  static String get invoiceFilterAll => isEn ? 'All' : 'Tất cả';
  static String get invoiceFilterNotCreated =>
      isEn ? 'Not Created' : 'Chưa lập';
  static String get invoiceFilterWaitingPayment =>
      isEn ? 'Waiting Payment' : 'Chờ thanh toán';
  static String get invoiceFilterPaid => isEn ? 'Paid' : 'Đã thu';
  static String get invoiceFilterOverdue => isEn ? 'Overdue' : 'Quá hạn';
  static String get invoiceCountSuffix => isEn ? 'invoices' : 'hóa đơn';
  static String get invoiceLoadRoomsError =>
      isEn ? 'Error loading rooms: ' : 'Lỗi tải phòng: ';
  static String get invoiceLoadInvoicesError =>
      isEn ? 'Error loading invoices: ' : 'Lỗi tải hóa đơn: ';
  static String get invoiceEmptyStateAll =>
      isEn
          ? 'No invoices yet. Tap + to create one.'
          : 'Chưa có hóa đơn nào. Nhấn + để tạo hóa đơn.';
  static String get invoiceEmptyStateFilterPrefix =>
      isEn ? 'No invoices with status "' : 'Không có hóa đơn ở trạng thái "';
  static String get invoiceEmptyStateFilterSuffix => isEn ? '".' : '".';
  static String get invoiceCreateBtnLabel =>
      isEn ? 'Create Invoice' : 'Tạo hóa đơn';

  static String get invoiceTotal => isEn ? 'TOTAL AMOUNT' : 'TỔNG CỘNG';
  static String get invoiceExportPdfSuccess =>
      isEn ? 'PDF exported successfully!' : 'Đã xuất PDF thành công!';
  static String get invoiceExportPdfShare =>
      isEn ? 'Opening PDF sharing...' : 'Đã mở danh sách chia sẻ PDF!';
  static String get invoiceExportPdfError =>
      isEn ? 'Error exporting PDF: ' : 'Lỗi xuất PDF: ';
  static String get invoicePdfFooter =>
      isEn
          ? 'Property Management Software - Azure Clarity'
          : 'Phần mềm Quản lý Nhà Trọ - Azure Clarity';
  static String get invoicePdfFileName => isEn ? 'invoice' : 'hoa_don';
  static String get invoicePdfShareText =>
      isEn ? 'Room Invoice' : 'Hóa đơn tiền phòng';
  static String get monthSuffix => isEn ? 'Month' : 'Tháng';

  // Reports & Costs
  static String get totalCosts => isEn ? 'TOTAL COSTS' : 'TỔNG CHI PHÍ';
  static String get maintenanceAndRepair =>
      isEn ? 'Maintenance & Repair' : 'Bảo trì & Sửa chữa';
  static String get costOther => isEn ? 'Other Costs' : 'Chi phí khác';

  // Reports & Revenue
  static String get monthlyRevenue =>
      isEn ? 'Monthly Revenue' : 'Doanh thu hàng tháng';
  static String get costAllocation =>
      isEn ? 'Cost Allocation' : 'Phân bổ chi phí';
  static String get viewPropertyReport =>
      isEn ? 'View property-wise report' : 'Xem báo cáo theo nhà trọ';
  static String get yearLabel => isEn ? 'Year' : 'Năm';
  static String get maintenance => isEn ? 'Maintenance' : 'Bảo trì';
  static String get vsLastMonth =>
      isEn ? 'vs last month' : 'so với tháng trước';
  static String get vsLastYear => isEn ? 'vs last year' : 'so với năm trước';

  // Reports & Vacancy
  static String get roomDistribution =>
      isEn ? 'Room Distribution' : 'Phân bổ tỷ lệ phòng';
  static String get depositLabel => isEn ? 'Deposit' : 'Đặt cọc';

  // Property Specific Reports
  static String get revenueByMonth =>
      isEn ? 'Revenue by Month' : 'Doanh thu theo tháng';
  static String get totalAllTime =>
      isEn ? 'Total All Time' : 'Tổng tất cả thời gian';
  static String get invoiceSummary =>
      isEn ? 'Invoice Summary' : 'Tổng hợp hóa đơn';
  static String get roomStatusDistribution =>
      isEn ? 'Room Status Distribution' : 'Phân bổ trạng thái phòng';
  static String get propertyInfo =>
      isEn ? 'Property Information' : 'Thông tin nhà trọ';

  // Tenants
  static String get verified => isEn ? 'VERIFIED' : 'ĐÃ XÁC MINH';
  static String get unverified => isEn ? 'UNVERIFIED' : 'CHƯA XÁC MINH';
  static String get fromDatePrefix => isEn ? 'From: ' : 'Từ: ';
  static String get depositPrefix => isEn ? 'Deposit: ' : 'Cọc: ';

  // Tenant List Page
  static String get tenants => isEn ? 'Tenants' : 'Danh sách khách thuê';
  static String get searchTenantHint =>
      isEn ? 'Search tenants...' : 'Tìm kiếm khách thuê...';
  static String get filterCheckedOut => isEn ? 'Checked Out' : 'Đã trả phòng';
  static String get noTenantsYet =>
      isEn ? 'No tenants yet' : 'Chưa có khách thuê';
  static String get noTenantsFound =>
      isEn ? 'No tenants found' : 'Không tìm thấy khách thuê';
  static String get addNewTenantTitle =>
      isEn ? 'Add new tenant' : 'Thêm khách mới';
  static String get addNewTenantDesc =>
      isEn
          ? 'Register new tenant information into the system'
          : 'Đăng ký thông tin khách thuê mới vào hệ thống';
  static String get managementProfessional =>
      isEn ? 'Professional Management' : 'Quản lý chuyên nghiệp';
  static String get managementProfessionalDesc =>
      isEn
          ? 'All tenant information, contracts and payments are centrally managed.'
          : 'Tất cả thông tin khách thuê, hợp đồng và thanh toán được quản lý tập trung.';

  // Contracts
  static String get contracts => isEn ? 'Contracts' : 'Hợp đồng';
  static String get contractList =>
      isEn ? 'Contracts List' : 'Danh sách hợp đồng';
  static String get contractDetail =>
      isEn ? 'Contract Details' : 'Chi tiết hợp đồng';
  static String get addContract => isEn ? 'Add Contract' : 'Thêm hợp đồng';
  static String get editContract =>
      isEn ? 'Edit Contract' : 'Chỉnh sửa hợp đồng';
  static String get rentPrice => isEn ? 'Rent Price' : 'Giá thuê';
  static String get startDate => isEn ? 'Start Date' : 'Ngày bắt đầu';
  static String get endDate => isEn ? 'End Date' : 'Ngày kết thúc';
  static String get contractStatus => isEn ? 'Status' : 'Trạng thái';
  static String get contractActive => isEn ? 'Active' : 'Đang hiệu lực';
  static String get contractExpired => isEn ? 'Expired' : 'Đã hết hạn';
  static String get contractTerminated => isEn ? 'Terminated' : 'Đã chấm dứt';
  static String get terminateContract =>
      isEn ? 'Terminate Contract' : 'Chấm dứt hợp đồng';
  static String get renewContract =>
      isEn ? 'Renew Contract' : 'Gia hạn hợp đồng';
  static String get noContractYet =>
      isEn ? 'No contracts yet' : 'Chưa có hợp đồng nào';
  static String get searchContractHint =>
      isEn ? 'Search contracts...' : 'Tìm kiếm hợp đồng...';
  static String get selectEmptyRoom =>
      isEn ? 'Select empty room' : 'Chọn phòng trống';
  static String get selectTenant => isEn ? 'Select tenant' : 'Chọn khách thuê';
  static String get contractDuration =>
      isEn ? 'Contract Duration' : 'Thời hạn hợp đồng';
  static String get noDuration => isEn ? 'No fixed term' : 'Không thời hạn';
  static String get contractCreatedSuccess =>
      isEn ? 'Contract created successfully' : 'Đã tạo hợp đồng mới';
  static String get selectRoomValidation =>
      isEn ? 'Please select a room' : 'Vui lòng chọn phòng';
  static String get selectTenantValidation =>
      isEn ? 'Please select a tenant' : 'Vui lòng chọn khách thuê';
  static String get enterPriceValidation =>
      isEn ? 'Please enter price' : 'Vui lòng nhập giá';
  static String get errorLoadingRooms =>
      isEn ? 'Error loading rooms' : 'Lỗi tải danh sách phòng';
  static String get errorLoadingTenants =>
      isEn ? 'Error loading tenants' : 'Lỗi tải danh sách khách thuê';

  // Error Dialog
  static String get hideTechnicalDetails =>
      isEn ? 'Hide Technical Details' : 'Ẩn chi tiết kỹ thuật';
  static String get showTechnicalDetails =>
      isEn ? 'Show Technical Details' : 'Xem chi tiết kỹ thuật';
  static String get copyLogSuccess =>
      isEn
          ? 'Error log copied to clipboard'
          : 'Đã sao chép log lỗi vào bộ nhớ tạm';
  static String get copy => isEn ? 'Copy' : 'Sao chép';
  static String get sendReport => isEn ? 'Send Report' : 'Gửi báo cáo';
  static String get appErrorReportSubject =>
      isEn ? 'Property Management App Error' : 'Lỗi ứng dụng Quản Lý Nhà Trọ';

  // Error Report Labels
  static String get errorReportHeader =>
      '--- ${isEn ? 'ERROR REPORT' : 'BÁO CÁO LỖI'} ---';
  static String get errorReportTitle => isEn ? 'Title' : 'Tiêu đề';
  static String get errorReportMessage => isEn ? 'Message' : 'Nội dung';
  static String get errorReportTimestamp => isEn ? 'Timestamp' : 'Thời gian';
  static String get errorReportTechnicalDetails =>
      isEn ? 'Technical Details' : 'Chi tiết kỹ thuật';
  static String get errorReportStackTrace =>
      isEn ? 'Stack Trace' : 'Truy vết ngăn xếp';
}
