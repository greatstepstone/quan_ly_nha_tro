# Kế hoạch phát triển: Quản Lý Nhà Trọ (Property Management App)

Dựa trên quá trình phát triển ứng dụng và những thay đổi kiến trúc gần đây của bạn, dưới đây là danh sách phân loại các công việc (Task) bạn đã hoàn thành và những bước cần thực hiện tiếp theo.

## ✅ Đã Hoàn Thành (Finished)
*Đây là những tính năng và nền tảng kiến trúc bạn đã xây dựng thành công.*

- [x] **Giao diện tĩnh (Static UI):** Đã xây dựng các màn hình chính (Trang chủ, Phòng, Khách thuê, Hóa đơn, Cài đặt).
- [x] **Kiến trúc Models cốt lõi:** Định nghĩa và tái cấu trúc các model (`Property`, `Room`, `Tenant`, `MeterReading`, `Invoice`, `User`).
- [x] **Chuẩn hóa Model (Multi-tenant ready):** Thêm thuộc tính `ownerId` trên toàn bộ các thực thể để chuẩn bị cho việc đồng bộ cloud và phân quyền dữ liệu.
- [x] **Tái cấu trúc biểu phí (Fees)**: Loại bỏ các phí cứng (`internetFee`, `trashFee`,...) để chuyển sang module dịch vụ linh hoạt với model `Service` mới và áp dụng enum `BillingType`.
- [x] **Định tuyến (Routing):** Thiết lập hệ thống chuyển trang sử dụng thư viện `go_router`.
- [x] **Mock Data:** Cập nhật file mock data hoàn chỉnh, tương thích thành công với model mới nhất.
- [x] **Kiến trúc Modular DAO:** Tái cấu trúc database từ monolithic `AppDao` sang các DAO chuyên biệt (`RoomDao`, `PropertyDao`, etc.) để tăng tính ổn định và dễ bảo trì.

---

## 🚨 Phải Làm (Must Do)
*Đây là những công việc cốt lõi cần làm ngay để ứng dụng chuyển từ bản dựng tĩnh (static) sang ứng dụng thực tiễn.*

- [x] **Tích hợp Database cục bộ (Local Storage):** Setup SQLite (hoặc `drift`/`isar`) để lưu trữ dữ liệu các model offline trên thiết bị.
- [x] **Kết nối UI với Database:** Thay thế toàn bộ `MockData` trên các màn hình bằng dữ liệu thật đọc ra từ Local Database (tạo kho chứa dữ liệu - Repositories/Data Providers). Chi tiết tại [SUB_TASKS_UI_CONNECT_LOCAL_DB.md](SUB_TASKS_UI_CONNECT_LOCAL_DB.md).
- [x] **Quản lý trạng thái (State Management):** Tích hợp Riverpod để theo dõi và cập nhật state. Chi tiết tại [SUB_TASKS_UI_STATE_MANAGEMENT.md](SUB_TASKS_UI_STATE_MANAGEMENT.md).
- [x] **Tích hợp Supabase (Backend as a Service):** Cơ sở hạ tầng cloud để đồng bộ hóa dữ liệu trực tuyến. Chi tiết tại [SUB_TASKS_CONNECT_SUPABASE.md](SUB_TASKS_CONNECT_SUPABASE.md).
- [ ] **Xác thực người dùng (Authentication):** Hoàn thiện luồng Đăng nhập/Đăng ký dành cho chủ trọ, kết nối với Supabase Auth.

---

## 🔶 Cần Làm (Need to Do)
*Những tính năng quan trọng để ứng dụng có thể xử lý đúng nghiệp vụ quản lý nhà trọ.*

- [x] **Logic tính Hóa đơn (Invoice Calculation):** Tự động tính chốt tiền phòng mỗi tháng = Tiền phòng + Phí điện + Phí nước (tùy theo `waterBillingType`) + Dịch vụ động (`Services`).
- [x] **Nghiệp vụ chốt điện nước (Meter Readings):** Luồng nhập số điện/nước hàng tháng tự động lưu "Chỉ số mới" của tháng này thành "Chỉ số cũ" của tháng sau.
- [x] **Chức năng sửa phòng / thêm khách:** Các form nhập liệu để Chủ trọ thực sự Sửa thông tin Phòng và Thêm Khách thuê vào phòng trống.
- [x] **Chế độ Tối (Dark Mode):** Cơ chế đổi theme và Code logic cho nút Cài đặt Hệ thống trên trang `settings_page`.
- [x] **Tái cấu trúc Resources (MVVM/Clean Architecture):** Tách AppColors, AppStrings, AppValues vào `lib/core/resources/` chuẩn bị cho đa ngôn ngữ.
- [x] **Đa Ngôn ngữ (Localization):** Code logic đổi ngôn ngữ trên trang `settings_page` (Tiếng Việt / Tiếng Anh).
- [ ] **Quản lý Tiền cọc (Deposit Tracking):** Quản lý trạng thái thu/trả tiền cọc và khấu trừ khi thanh lý hợp đồng.
- [ ] **Báo cáo doanh thu (Excel Export):** Xuất file Excel báo cáo tổng thu chi hàng tháng/năm để chủ trọ làm sổ sách.
- [ ] **Quản lý Hợp đồng & Giấy tờ:** Lưu trữ ảnh chụp hợp đồng và CCCD của khách thuê để phục vụ đăng ký tạm trú.

---

## 🌟 Có Thể Làm (Can Do - Nice to haves)
*Những tính năng nâng cao giúp ứng dụng của bạn trở nên chuyên nghiệp và khác biệt.*

- [x] **Xuất & Chia sẻ Hóa Đơn:** Export hóa đơn dưới dạng Ảnh (Image) hoặc PDF format để gửi trực tiếp qua Zalo/Messenger cho khách thuê.
- [x] **Dashboard Thống kê:** Thêm biểu đồ trực quan xem tổng doanh thu hàng tháng, tỷ lệ lấp đầy phòng trống.
- [x] **Thông báo (Push Notifications/Reminders):** Nhắc nhở local trên điện thoại các ngày tới hạn thu tiền phòng hoặc hóa đơn đã quá hạn (Overdue).
- [x] **Thiết lập & Quản lý Dịch vụ:** Giao diện cho phép chủ trọ chỉnh sửa lại giá điện, giá nước, và cấu hình thêm/bớt các dịch vụ (rác, wifi...) sau khi đã tạo nhà trọ.
- [x] **Hỗ trợ iOS:** Khởi tạo và cấu hình project iOS (Info.plist, Icons, App Store setup).
- [ ] **Gỡ bỏ Web (Future):** Sau khi hoàn thiện bản Mobile, tiến hành gỡ bỏ platform Web để tối ưu hóa dự án.
- [ ] **Tích hợp Sentry (Crash Reporting):** Theo dõi và tự động báo cáo các lỗi crash ứng dụng thời gian thực để cải thiện độ ổn định.
- [ ] **Quản lý Chi phí bảo trì:** Ghi lại các khoản chi sửa chữa, bảo trì thiết bị trong nhà trọ để tính lợi nhuận ròng.
- [ ] **Tự động hóa CI/CD:** Thiết lập GitHub Actions để tự động kiểm tra lỗi và đóng gói ứng dụng (Build APK/AAB).

---

## 🛡️ Yêu cầu phi chức năng (Non-Functional)
*Các tiêu chuẩn về chất lượng, bảo mật và trải nghiệm người dùng.*

- [ ] **Bảo mật & Quyền riêng tư:** Mã hóa dữ liệu nhạy cảm (CCCD, SĐT) và tuân thủ nghị định bảo vệ dữ liệu cá nhân (PDPD).
- [ ] **Chế độ Ngoại tuyến (Offline-first):** Đảm bảo 100% tính năng cốt lõi hoạt động ổn định khi không có internet.
- [ ] **Hiệu suất & Tối ưu:** Tối ưu hóa tốc độ tải danh sách lớn và đảm bảo ứng dụng khởi động dưới 3 giây.
- [ ] **Khả năng tiếp cận (Accessibility):** Hỗ trợ phóng to font chữ hệ thống và giao diện dễ dùng cho người lớn tuổi.
- [ ] **Đồng bộ hóa tin cậy:** Xử lý xung đột dữ liệu (Conflict Resolution) khi đồng bộ giữa SQLite và Supabase.

