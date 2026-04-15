# Kế hoạch Kiểm thử Thủ công (Manual Test Scenarios)

Tài liệu này bao gồm các kịch bản kiểm thử (test cases) thủ công giúp bạn tự xác minh các tính năng hiện đã hoàn thiện trong ứng dụng `Quản Lý Nhà Trọ`. 

Do hiện tại các chức năng nhập liệu (CRUD) chưa hoàn tất 100%, các kịch bản kiểm thử này sẽ tập trung vào sự ổn định của UI, việc kết nối với Database (SQLite) và luồng xử lý trạng thái bằng Riverpod.

---

## 🟢 1. Kiểm thử Khởi tạo & Điều hướng (Navigation & Setup)
**Mục tiêu:** Đảm bảo ứng dụng cài đặt thành công, Database khởi tạo đúng cách và thanh điều hướng hoạt động trơn tru.

| Test Case | Các bước thực hiện | Kết quả mong đợi |
| :--- | :--- | :--- |
| **TC-1.1: Mở ứng dụng lần đầu** | 1. Mở ứng dụng.<br>2. Quan sát màn hình chờ và Trang chủ (Home). | App không bị crash. Cấu trúc Database SQLite (Drift) được khởi tạo thành công dưới nền. Trang Chủ hiển thị mà không báo lỗi. |
| **TC-1.2: Điều hướng Bottom Bar** | 1. Chạm lần lượt vào các tab ở thanh điều hướng dưới cùng (Trang Chủ, Phòng, Khách thuê, Hóa đơn, Cài đặt). | Ứng dụng chuyển đổi mượt mà giữa các trang. Sidebar/Bottom bar cập nhật trạng thái "Active" chính xác dựa trên `go_router`. |
| **TC-1.3: Điều hướng lùi (Back)** | 1. Mở một trang phụ (ví dụ: nhấn xem chi tiết từ một thẻ Phòng).<br>2. Nhấn nút "Back" trên AppBar hoặc vuốt lùi trên điện thoại. | Ứng dụng quay lại màn hình trước đó chính xác, không bị lỗi màn hình đen hay kẹt trang. |

---

## 🟢 2. Kiểm thử Kết nối Local Database & Riverpod
**Mục tiêu:** Xác minh rằng UI đã thực sự ngừng sử dụng `MockData` tĩnh và đang phản ứng (reactive) với dữ liệu từ Local SQLite thông qua Riverpod.

| Test Case | Các bước thực hiện | Kết quả mong đợi |
| :--- | :--- | :--- |
| **TC-2.1: Tải danh sách Phòng** | 1. Mở tab **Phòng (Rooms)**.<br>2. Chờ dữ liệu load. | Nếu DB rỗng, app hiện thông báo "Chưa có phòng" hoặc dạng Empty State đẹp mắt. Nếu đã có dữ liệu seed (dữ liệu mồi), phòng phải hiển thị đúng tên, trạng thái (Trống/Đã thuê) và giá tiền. |
| **TC-2.2: Tải danh sách Khách Thuê** | 1. Mở tab **Khách thuê (Tenants)**. | Danh sách khách thuê (nếu có trong DB) hiển thị kèm phòng tương ứng. Giao diện mượt mà. |
| **TC-2.3: Reload trạng thái (Hot Restart)** | 1. Thực hiện Hot Restart trên IDE (không phải Hot Reload).<br>2. Mở tab Phòng hoặc Khách thuê. | Dữ liệu xuất hiện ngay lập tức (hoặc qua 1 hiệu ứng loading ngắn). Chứng tỏ dữ liệu được lưu cục bộ, không bị mất đi khi tắt app. |

---

## 🟢 3. Kiểm thử Giao diện (Aesthetics & UI)
**Mục tiêu:** Đảm bảo mọi màn hình hiển thị chính xác, không bị lỗi vỡ layout hoặc tràn chữ.

| Test Case | Các bước thực hiện | Kết quả mong đợi |
| :--- | :--- | :--- |
| **TC-3.1: Cuộn danh sách dài** | 1. Mở màn hình danh sách (Phòng / Hóa đơn).<br>2. Vuốt dọc qua lại nhiều lần. | Danh sách cuộn trơn tru (smooth scrolling) khoảng 60fps. Không bị giật hoặc đứt gãy đồ họa. |
| **TC-3.2: Render các Font & Icon** | 1. Đi qua tất cả các trang.<br>2. Nhìn vào các icon (tiền mặt, lịch, nước, điện) và text. | Tất cả icon load đúng, font chữ sử dụng là font hiện đại (Inter/Roboto), không dùng font lỗi định dạng. Màu sắc sinh động, thống nhất theo thiết kế. |
| **TC-3.3: Empty States (Màn hình trống)** | 1. Ứng dụng ở trạng thái chưa có dữ liệu.<br>2. Nhìn vào trang danh sách Hóa đơn hoặc Khách thuê. | Có hình ảnh minh họa dễ thương hoặc dòng chữ "Bạn chưa có dữ liệu nào" được căn giữa hoàn chỉnh. |

---

## 🟢 4. Kiểm thử Hóa đơn (Chờ giao diện)
**Mục tiêu:** Trải nghiệm kết quả của thuật toán tính Tiền phòng, Điện, Nước và Dịch vụ bạn vừa thiết lập. *(Yêu cầu đã có màn hình hoặc nút Gọi lệnh tính tiền).*

| Test Case | Các bước thực hiện | Kết quả mong đợi |
| :--- | :--- | :--- |
| **TC-4.1: Tính Hóa Đơn Trực Tiếp** | 1. Mở tab **Hóa đơn**.<br>2. Nếu có nút "Tính tiền/Tạo Hóa đơn" cho một phòng cụ thể, hãy ấn vào. | Ứng dụng xử lý (loading) trong chốc lát và trả kết quả tổng tiền chính xác. Nếu thiếu chỉ số Điện/Nước, app sẽ hiển thị cảnh báo (SnackBar popup) thay vì crash ẩn. |

---

## 💡 Gợi ý cho bạn khi tự Test:
1. **Theo dõi Log console:** Trong khi test bằng điện thoại/máy ảo, hãy để ý console trên IDE. Nếu Riverpod báo lỗi provider hoặc SQLite báo lỗi khóa ngoại (Foreign key check), hãy note lại.
2. **Kiểm tra ngoại lệ (Edge Cases):** Cố gắng tắt/bật lại ứng dụng xem trạng thái của các bộ lọc (Filters) nếu có được lưu lại hay bị reset.
3. **Seed Data:** Nếu hiện tại UI đang "trắng trơn" vì chưa làm chức năng form "Thêm mới", bạn có thể tạo một đoạn code nhỏ dạng `DatabaseSeeder` chạy một lần lúc khởi động app để chèn giả một ít dữ liệu mẫu trực tiếp vào bảng SQLite, giúp bạn nhìn thấy form UI hoạt động ra sao.
