# Kế Hoạch Kiểm Thử Toàn Diện (Full Test Plan)
## Dự án: Quản Lý Nhà Trọ (Azure Clarity)

Tài liệu này phác thảo các kịch bản kiểm thử cần thiết để đảm bảo ứng dụng hoạt động ổn định, bảo mật và mang lại trải nghiệm người dùng cao cấp nhất.

---

### 1. Luồng Xác thực & Onboarding (Auth & Onboarding)
Mục tiêu: Đảm bảo người dùng mới có trải nghiệm mượt mà và bảo mật.

| ID | Kịch bản kiểm thử | Kết quả mong đợi |
|:---|:---|:---|
| A1 | Khởi chạy lần đầu | Hiển thị màn hình Onboarding (Giới thiệu). |
| A2 | Khởi chạy lần sau | Bỏ qua Onboarding, vào thẳng trang Login hoặc Home. |
| A3 | Đăng nhập Social (Google/Apple/FB) | Đăng nhập thành công, lưu token vào Supabase, chuyển vào trang Home. |
| A4 | Chế độ Khách (Guest Mode) | Vào được App mà không cần đăng nhập, dữ liệu chỉ lưu Local. |
| A5 | Đăng xuất (Logout) | Xóa session, xóa trạng thái Guest, quay lại trang LoginPage. |
| A6 | Kiểm tra Session Persistence | Đóng app và mở lại, người dùng vẫn giữ trạng thái đăng nhập. |

---

### 2. Quản lý Bất động sản & Phòng (Property & Room)
Mục tiêu: Đảm bảo dữ liệu cốt lõi được quản lý chính xác.

| ID | Kịch bản kiểm thử | Kết quả mong đợi |
|:---|:---|:---|
| P1 | Thêm Tòa nhà/Dãy trọ mới | Lưu thành công vào SQLite với các dịch vụ (Điện, Nước, Internet...). |
| P2 | Chỉnh sửa thông tin Tòa nhà | Cập nhật giá dịch vụ thành công. |
| P3 | Thêm Phòng mới | Thuộc đúng Tòa nhà, hiển thị đúng trạng thái (Trống). |
| P4 | Tìm kiếm & Lọc Phòng | Tìm được phòng theo tên hoặc theo Tòa nhà. |
| P5 | Xóa Tòa nhà (Cascade Delete) | Xóa tòa nhà sẽ xóa tất cả phòng và hợp đồng liên quan (tùy cấu hình). |

---

### 3. Quản lý Khách thuê & Hợp đồng (Tenant & Contract)
Mục tiêu: Quản lý thông tin cư dân.

| ID | Kịch bản kiểm thử | Kết quả mong đợi |
|:---|:---|:---|
| T1 | Thêm Khách thuê vào phòng | Trạng thái phòng chuyển từ "Trống" sang "Đang ở". |
| T2 | Chỉnh sửa thông tin khách | Cập nhật số điện thoại, CCCD thành công. |
| T3 | Trả phòng (Check-out) | Xóa khách/hợp đồng, phòng quay lại trạng thái "Trống". |
| T4 | Chụp ảnh CCCD | (Tính năng tương lai) Lưu ảnh vào máy hoặc Cloud thành công. |

---

### 4. Chỉ số Điện Nước & Hóa đơn (Meter & Invoices)
Mục tiêu: Đảm bảo tính toán tài chính chính xác 100%.

| ID | Kịch bản kiểm thử | Kết quả mong đợi |
|:---|:---|:---|
| M1 | Ghi chỉ số Điện/Nước tháng mới | Phải lớn hơn hoặc bằng chỉ số cũ. |
| M2 | Tính toán hóa đơn tự động | (Chỉ số mới - cũ) * Đơn giá + Phí dịch vụ = Tổng tiền chính xác. |
| M3 | Xuất hóa đơn (PNG/PDF) | Ảnh hóa đơn chuyên nghiệp, đầy đủ thông tin, có thể chia sẻ qua Zalo/FB. |
| M4 | Xác nhận thanh toán | Hóa đơn chuyển trạng thái từ "Chưa thu" sang "Đã thu". |
| M5 | Thống kê doanh thu | Báo cáo tháng hiển thị đúng tổng tiền đã thu và còn nợ. |

---

### 5. Dữ liệu & Hiệu năng (Data & Performance)
Mục tiêu: Độ ổn định của cơ sở dữ liệu.

| ID | Kịch bản kiểm thử | Kết quả mong đợi |
|:---|:---|:---|
| D1 | Kiểm tra SQLite Offline | App vẫn hoạt động đầy đủ khi không có mạng. |
| D2 | Đồng bộ Supabase | (Tính năng đang phát triển) Dữ liệu Local tự đẩy lên Cloud khi có mạng. |
| D3 | Backup & Restore | Dữ liệu không bị mất khi ứng dụng cập nhật phiên bản mới. |
| D4 | Xử lý dữ liệu lớn | App không bị lag khi có >100 phòng và hàng ngàn hóa đơn. |

---

### 6. Giao diện & UX (UI/UX Branding)
Mục tiêu: Cảm giác cao cấp (Premium).

| ID | Kịch bản kiểm thử | Kết quả mong đợi |
|:---|:---|:---|
| U1 | Chế độ Sáng/Tối (Dark Mode) | Chuyển đổi mượt mà, màu sắc Azure Clarity nhất quán. |
| U2 | Đa ngôn ngữ (VI/EN) | Toàn bộ Text trong app được dịch chính xác. |
| U3 | Phản hồi xúc giác (Haptics) | Rung nhẹ khi nhấn nút hoặc hoàn thành tác vụ (trên Mobile). |
| U4 | Responsive Layout | Hiển thị tốt trên cả màn hình điện thoại nhỏ và máy tính bảng. |

---

### Kết luận
Kế hoạch này bao phủ toàn bộ các chức năng đã triển khai. Các lỗi về Import và DAO vừa qua đã được xử lý, tạo nền tảng vững chắc cho việc kiểm thử tính đúng đắn của dữ liệu (Data Integrity).
