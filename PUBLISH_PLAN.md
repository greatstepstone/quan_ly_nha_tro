# 🚀 Kế Hoạch Phát Hành Ứng Dụng (Publish Plan)

Tài liệu này hướng dẫn các bước cần thiết để đưa ứng dụng **Quản Lý Nhà Trọ** lên Google Play Store một cách chuyên nghiệp.

---

## 🛠 Giai đoạn 1: Chuẩn bị Kỹ thuật (Technical Preparation)

- [ ] **1. Đổi Package Name (Android Application ID)**
  - Hiện tại: `com.example.quan_ly_nha_tro` (Cần đổi trước khi lên Store).
  - Gợi ý: `com.yourdomain.quanlynhatro`.
  - File cần sửa: `android/app/build.gradle`.
- [ ] **2. Tạo App Icon & Splash Screen**
  - Sử dụng gói `flutter_launcher_icons` và `flutter_native_splash`.
  - Icon cần có kích thước tối đa 512x512 cho Store.
- [ ] **3. Cấu hình Signing (Ký ứng dụng)**
  - Tạo tệp `upload-keystore.jks`.
  - Cấu hình tệp `android/key.properties` (Không được push lên Git công khai).
  - Cập nhật `build.gradle` để sử dụng cấu hình ký này.
- [ ] **4. Tối ưu hóa Build**
  - Sử dụng Proguard/R8 để thu nhỏ mã nguồn (Shrinking/Obfuscation).
  - Kiểm tra các quyền (Permissions) trong `AndroidManifest.xml` (Bỏ bớt quyền không dùng).
- [ ] **5. Khởi tạo & Cấu hình iOS**
  - Chạy `flutter create --platforms=ios .`.
  - Cấu hình `Info.plist` (Camera, Photo Library, Notifications).
  - Thiết lập Bundle ID trong Xcode (khớp với Android Package Name).

---

## 🎨 Giai đoạn 2: Marketing & Store Assets

- [ ] **1. Chụp ảnh màn hình (Screenshots)**
  - Cần ít nhất 4-5 ảnh chụp các tính năng: Dashboard, Danh sách phòng, Lập hóa đơn, Biểu đồ.
  - Sử dụng thiết bị có màn hình 6.5 inch và Tablet 10 inch để chụp.
- [ ] **2. Viết nội dung Store Listing**
  - **Tiêu đề**: Quản Lý Nhà Trọ - Chuyên nghiệp & Miễn phí.
  - **Mô tả ngắn**: Giải pháp quản lý phòng trọ, điện nước và hóa đơn ngay trên điện thoại.
  - **Mô tả chi tiết**: Liệt kê đầy đủ các tính năng nổi bật (Offline mode, Sync cloud, Xuất PDF/Ảnh...).
- [ ] **3. Chính sách bảo mật (Privacy Policy)**
  - Tạo một trang web đơn giản (sử dụng GitHub Pages hoặc Google Sites).
  - Nội dung mô tả cách ứng dụng thu thập và xử lý dữ liệu người dùng (Email, Dữ liệu phòng trọ).

---

## 📤 Giai đoạn 3: Google Play Console

- [ ] **1. Đăng ký tài khoản Developer**
  - Phí một lần: 25$ trả cho Google.
- [ ] **2. Tạo ứng dụng mới trên Console**
  - Hoàn thành các bảng khảo sát về: Nội dung (Content Rating), Dữ liệu (Data Safety).
- [ ] **3. Chạy thử nghiệm nội bộ (Internal Testing)**
  - Upload file `.aab` (Android App Bundle).
  - Mời 5-10 người dùng thử nghiệm để tìm lỗi nhỏ cuối cùng.
- [ ] **4. Đưa lên sản xuất (Production)**
  - Gửi Google xét duyệt (Thường mất 2-7 ngày cho lần đầu).

## 🍏 Giai đoạn 3.5: Apple App Store (Dành riêng cho iOS)

- [ ] **1. Đăng ký Apple Developer Program**
  - Phí hàng năm: 99$.
- [ ] **2. Cấu hình App Store Connect**
  - Tạo App ID, Certificates, và Provisioning Profiles.
- [ ] **3. TestFlight**
  - Upload bản build qua Xcode hoặc Transporter để test trên iPhone thật.

---

## 📈 Giai đoạn 4: Sau khi phát hành (Post-Launch)

- [ ] **1. Theo dõi lỗi (Monitoring)**
  - Kiểm tra **Crashlytics** thường xuyên.
  - Phản hồi các nhận xét (Reviews) của người dùng trên Store.
- [ ] **2. Cập nhật tính năng (Updates)**
  - Lên kế hoạch cho Version 1.1.0: Thêm tính năng nhắc nợ qua Zalo tự động, hoặc sao lưu dữ liệu ra tệp Excel.
