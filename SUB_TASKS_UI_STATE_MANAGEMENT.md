# SUB-TASKS: UI State Management (Riverpod Integration)

Mục tiêu: Chuyển đổi từ việc sử dụng `StreamBuilder` đơn lẻ sang hệ thống quản lý trạng thái tập trung bằng **Riverpod**. Điều này giúp code gọn gàng hơn, dễ bảo trì và đảm bảo UI cập nhật tức thì khi dữ liệu thay đổi.

---

## 1. Thiết lập Foundation
- [x] **Dependencies**: Thêm `flutter_riverpod` và `riverpod_annotation` vào `pubspec.yaml`.
- [x] **Setup ProviderScope**: Bao bọc `MainApp` bằng `ProviderScope` trong `main.dart`.
- [x] **Common Providers**: Tạo `databaseProvider` để inject `AppDatabase` vào mọi nơi.

## 2. Core Providers (Database Sync)
- [x] **Property Providers**:
    - `propertiesStreamProvider`: Watch danh sách nhà trọ.
    - `propertyDetailProvider(id)`: Watch thông tin 1 nhà trọ cụ thể.
- [x] **Room Providers**:
    - `roomsStreamProvider(propertyId)`: Watch danh sách phòng theo nhà.
    - `roomDetailProvider(id)`: Watch 1 phòng.
- [x] **Invoice Providers**:
    - `invoicesStreamProvider(roomId)`: Watch danh sách hóa đơn.
- [x] **Tenant Providers**:
    - `tenantsStreamProvider(propertyId)`: Watch danh sách khách thuê.

## 3. Refactor UI (Migration)
- [x] **Home Page**: Chuyển sang `ConsumerWidget`, sử dụng `ref.watch` để lấy thống kê tổng quan.
- [x] **Room List & Detail**: Thay thế `StreamBuilder` bằng `ref.watch(roomProvider)`.
- [x] **Invoices**: Đồng bộ trạng thái hóa đơn mới tạo mà không cần quay lại trang trước.
- [x] **Meter Readings**: Đảm bảo chỉ số mới ghi xuất hiện ngay lập tức trên dashboard.

## 4. Advanced Logic & Optimizations
- [ ] **Filtering Logic**: Di chuyển logic filter (ví dụ: lọc hóa đơn theo tháng/trạng thái) từ UI sang `Provider`.
- [ ] **Loading/Error Handling**: Sử dụng `.when()` của Riverpod để xử lý UI loading và lỗi đồng nhất toàn project.
- [ ] **Optimistic Updates (Optional)**: Cập nhật UI ngay lập tức trước khi DB phản hồi (nếu cần trải nghiệm cực nhanh).

---
*Lưu ý: Việc chuyển sang Riverpod sẽ giúp loại bỏ sự phụ thuộc quá nhiều vào biến toàn cục `appDb`.*
