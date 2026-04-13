    # Sub-tasks: Supabase Cloud Integration

Tài liệu này theo dõi các bước tích hợp **Supabase** vào ứng dụng để cung cấp khả năng lưu trữ đám mây, xác thực người dùng và đồng bộ hóa dữ liệu trực tuyến.

---

## 🏗️ 1. Setup Cơ Sở Hạ Tầng (Infrastucture)
- [x] **Tạo project Supabase**: Thiết lập project mới trên Supabase Dashboard.
- [x] **Cấu hình Database (PostgreSQL)**:
    - [x] Tạo các bảng `properties`, `rooms`, `tenants`, `meter_readings`, `invoices`, `services` tương ứng với Schema ở Local DB.
    - [x] Thiết lập Foreign Key relationships.
    - [x] Thêm cột `owner_id` (UUID) và liên kết với bảng `auth.users`.
- [x] **Row Level Security (RLS)**:
    - [x] Thiết lập chính sách bảo mật để người dùng chỉ thấy/sửa dữ liệu của chính họ (`owner_id = auth.uid()`).

## 🔐 2. Authentication (Xác thực)
- [x] **Tích hợp Supabase Auth Client**: Thêm dependency `supabase_flutter` và khởi tạo trong `main.dart`.
- [x] **Trang Đăng nhập (Login Page)**: Xây dựng UI và logic đăng nhập bằng Email/Password.
- [x] **Trang Đăng ký (Register Page)**: Cho phép chủ trọ tạo tài khoản mới.
- [x] **Auth Wrapper**: Tự động chuyển hướng người dùng đến Home nếu đã login, hoặc Auth page nếu chưa.

## 🔄 3. Đồng bộ hóa dữ liệu (Data Sync Strategy)
- [x] **Remote Data Sources**: Xây dựng các service class để fetch/push dữ liệu lên Supabase.
- [x] **Offline-First Wrapper**: Logic ưu tiên đọc/ghi Local DB trước, sau đó đồng bộ ngầm (background sync) lên Cloud.
- [x] **Xử lý Xung đột (Conflict Resolution)**: Đảm bảo dữ liệu mới nhất được ưu tiên (dựa trên `updated_at`).

## 📡 4. Realtime Features (Optional)
- [ ] **Supabase Realtime**: Lắng nghe thay đổi dữ liệu từ Cloud để cập nhật UI ngay lập tức khi có thay đổi từ thiết bị khác.

---
> [!NOTE]
> Việc tích hợp Cloud cần được thực hiện cẩn thận để không làm gián đoạn trải nghiệm Offline hiện có của người dùng.
