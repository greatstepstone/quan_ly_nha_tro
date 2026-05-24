# Ứng dụng Quản lý Nhà trọ (quan_ly_nha_tro)

Ứng dụng di động dành cho chủ nhà trọ giúp quản lý thông tin phòng trọ, khách thuê, hợp đồng, ghi số điện nước, tính toán hóa đơn và xem báo cáo thống kê doanh thu.

## 🚀 Đặc điểm nổi bật
* **Kiến trúc Ngoại tuyến trước (Offline-First):** Sử dụng cơ sở dữ liệu cục bộ Drift (SQLite) để hoạt động mượt mà ngay cả khi mất mạng. Tự động đồng bộ với Supabase khi có kết nối internet.
* **Mô hình MVVM kết hợp Riverpod:** Tách biệt hoàn toàn logic quản lý trạng thái (ViewModel) khỏi giao diện hiển thị (View).
* **Đóng gói bảo mật:** Cấu hình làm tối nghĩa mã nguồn (Obfuscation) và tối ưu hóa tài nguyên cho thiết bị Android.

## 🛠️ Công nghệ sử dụng
* **Framework:** Flutter (Dart)
* **Local Database:** Drift (SQLite)
* **Backend & Sync:** Supabase
* **State Management:** Riverpod
* **Báo cáo & Tiện ích:** PDF, Printing (in hóa đơn), fl_chart (biểu đồ thống kê)

## 📁 Cấu trúc thư mục (Feature-First)
* `lib/core/`: Cơ sở dữ liệu Drift, services đồng bộ, theme, tiện ích và các widgets dùng chung.
* `lib/features/`: Các mô-đun tính năng nghiệp vụ biệt lập:
  * `auth/`: Đăng nhập, đăng ký và xác thực tài khoản.
  * `properties/`: Quản lý nhà trọ, dãy trọ và dịch vụ đi kèm.
  * `rooms/`: Quản lý danh sách phòng, trạng thái phòng.
  * `tenants/`: Quản lý thông tin khách thuê.
  * `contracts/`: Lập hợp đồng, điều khoản tùy chọn.
  * `meter_readings/`: Chốt số điện, nước định kỳ.
  * `invoices/`: Tính toán hóa đơn phòng trọ và xuất tệp PDF.
  * `reports/`: Xem báo cáo doanh thu và tỉ lệ phòng trống.

## ⚙️ Hướng dẫn chạy dự án

### 1. Cấu hình môi trường
Tạo tệp `.env` ở thư mục gốc dự án:
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### 2. Cài đặt và Khởi chạy
Chạy các lệnh sau trong Terminal tại thư mục gốc:
```bash
# Tải các gói thư viện
flutter pub get

# Biên dịch sinh mã tự động (Drift DAOs, Models...)
flutter pub run build_runner build --delete-conflicting-outputs

# Chạy ứng dụng
flutter run
```
