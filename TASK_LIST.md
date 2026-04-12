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

---

## 🚨 Phải Làm (Must Do)
*Đây là những công việc cốt lõi cần làm ngay để ứng dụng chuyển từ bản dựng tĩnh (static) sang ứng dụng thực tiễn.*

- [x] **Tích hợp Database cục bộ (Local Storage):** Setup SQLite (hoặc `drift`/`isar`) để lưu trữ dữ liệu các model offline trên thiết bị.
- [x] **Kết nối UI với Database:** Thay thế toàn bộ `MockData` trên các màn hình bằng dữ liệu thật đọc ra từ Local Database (tạo kho chứa dữ liệu - Repositories/Data Providers). Chi tiết tại [SUB_TASKS_UI_CONNECT_LOCAL_DB.md](SUB_TASKS_UI_CONNECT_LOCAL_DB.md).
- [ ] **Quản lý trạng thái (State Management):** Tích hợp Riverpod để theo dõi và cập nhật state. Chi tiết tại [SUB_TASKS_UI_STATE_MANAGEMENT.md](SUB_TASKS_UI_STATE_MANAGEMENT.md).
- [ ] **Tích hợp Supabase (Backend as a Service):** Cơ sở hạ tầng cloud để đồng bộ hóa dữ liệu trực tuyến.
- [ ] **Xác thực người dùng (Authentication):** Hoàn thiện luồng Đăng nhập/Đăng ký dành cho chủ trọ, kết nối với Supabase Auth.

---

## 🔶 Cần Làm (Need to Do)
*Những tính năng quan trọng để ứng dụng có thể xử lý đúng nghiệp vụ quản lý nhà trọ.*

- [ ] **Logic tính Hóa đơn (Invoice Calculation):** Tự động tính chốt tiền phòng mỗi tháng = Tiền phòng + Phí điện + Phí nước (tùy theo `waterBillingType`) + Dịch vụ động (`Services`).
- [ ] **Nghiệp vụ chốt điện nước (Meter Readings):** Luồng nhập số điện/nước hàng tháng tự động lưu "Chỉ số mới" của tháng này thành "Chỉ số cũ" của tháng sau.
- [ ] **Chức năng thêm/sửa/xóa (CRUD):** Các form nhập liệu để Chủ trọ thực sự tạo được Phòng, Thêm Khách thuê, Thiết lập Dịch vụ.
- [ ] **Chế độ Tối (Dark Mode) & Ngôn ngữ:** Code logic cho các nút cài đặt hệ thống trên trang `settings_page`.

---

## 🌟 Có Thể Làm (Can Do - Nice to haves)
*Những tính năng nâng cao giúp ứng dụng của bạn trở nên chuyên nghiệp và khác biệt.*

- [ ] **Xuất & Chia sẻ Hóa Đơn:** Export hóa đơn dưới dạng Ảnh (Image) hoặc PDF format để gửi trực tiếp qua Zalo/Messenger cho khách thuê.
- [ ] **Dashboard Thống kê:** Thêm biểu đồ trực quan xem tổng doanh thu hàng tháng, tỷ lệ lấp đầy phòng trống.
- [ ] **Thông báo (Push Notifications/Reminders):** Nhắc nhở local trên điện thoại các ngày tới hạn thu tiền phòng hoặc hóa đơn đã quá hạn (Overdue).
- [ ] **Phân quyền Khách thuê (Tenant Portal):** Dựa vào `ownerId` và `tenantId`, cho phép app có chế độ đăng nhập dành riêng cho khách để họ tự theo dõi hóa đơn phòng mình.
