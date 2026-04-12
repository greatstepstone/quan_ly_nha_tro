# Kế Hoạch Thay Thế MockData Sang Local DB (KISS)

Tài liệu này theo dõi tiến độ công việc thay thế hoàn toàn `MockData` bằng các lệnh gọi thực tế xuống SQLite/Drift thông qua `appDb.appDao`. 

> **Tiêu chí chung:**
> - Sử dụng `appDb` global.
> - Sử dụng `StreamBuilder` để tự động render list khi có thay đổi.
> - Dùng các Companion classes của Drift (`RoomsCompanion`, `TenantsCompanion`...) để insert/update.
> - Loại bỏ dần import của `mock_data.dart`.

---

## 1. Tính năng Nhà Trọ (Properties)
- [x] **`properties_list_page.dart`**: Render list nhà trọ bằng `StreamBuilder` + `watchAllProperties()`.
- [x] **`add_property_page.dart`**: Lưu nhà trọ & cấu hình dịch vụ chung bằng `insertProperty()` và `insertService()`.

## 2. Tính năng Phòng (Rooms)
- [x] **`rooms_list_page.dart`**: Render list phòng theo thuộc tính (Lọc theo `propertyId`).
- [x] **`room_detail_page.dart`**: Lấy thông tin phòng, hiển thị dịch vụ & khách thuê.
- [x] **`add_room_page.dart` (Nếu có) / Logic tạo phòng**: Lưu vào bảng `Rooms`.
- [x] **Tính năng xóa/sửa phòng**: Cập nhật thông tin qua `updateRoom()` / `deleteRoom()`.

## 3. Tính năng Khách Thuê (Tenants)
- [x] **`tenants_list_page.dart`**: Render danh sách người thuê bằng `StreamBuilder`.
- [x] **`tenant_detail_page.dart`**: Xem chi tiết người nộp/thuê.
- [x] **`edit_tenant_page.dart`**: Logic thêm mới và sửa người thuê. Insert vào `Tenants` table. Xử lý gán `tenantId` cho bảng `Rooms`.

## 4. Tính năng Chỉ Số Điện Nước (Meter Readings)
- [x] **`meter_readings_page.dart`**: Lấy danh sách chốt điện nước của tháng.
- [x] **`meter_reading_detail_page.dart`**: Lưu thông tin chỉ số điện nước mới vào `MeterReadings`. Cập nhật trạng thái `isRecorded = true`.

## 5. Tính năng Hóa Đơn (Invoices)
- [x] **`invoice_status_page.dart`**: Lọc danh sách hóa đơn theo trạng thái (Đã thu, Chờ đóng, Quá hạn...).
- [x] **`create_invoice_page.dart`**: Logic chốt tiền phòng, dịch vụ và tạo bản ghi vào `Invoices`.

## 6. Tính năng Báo Cáo (Reports)
- [x] **`property_report_page.dart`**: Đọc tổng hợp (SUM) tiền thu, hóa đơn từ `Invoices` để vẽ biểu đồ và thống kê.

---
*Lưu ý: Sau khi hoàn thiện toàn bộ danh sách này, chúng ta có thể an toàn xóa **`lib/core/data/mock_data.dart`** khỏi dự án.*
