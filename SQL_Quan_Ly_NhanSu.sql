
-- Xóa cơ sở dữ liệu nếu đã tồn tại
DROP DATABASE IF EXISTS Quan_Ly_Nhan_Su;

-- Tạo cơ sở dữ liệu mới
CREATE DATABASE Quan_Ly_Nhan_Su;
USE Quan_Ly_Nhan_Su;
-- Xóa bảng nếu đã tồn tại
IF OBJECT_ID('tblChucVu', 'U') IS NOT NULL
    DROP TABLE tblChucVu;
go;
IF OBJECT_ID('tblPhongBan', 'U') IS NOT NULL
    DROP TABLE tblPhongBan;
go;
IF OBJECT_ID('tblNhanVien', 'U') IS NOT NULL
    DROP TABLE tblNhanVien;
go;
IF OBJECT_ID('tblLuong', 'U') IS NOT NULL
    DROP TABLE tblLuong;
go;
IF OBJECT_ID('tblLichLamViec', 'U') IS NOT NULL
    DROP TABLE tblLichLamViec;
go;
IF OBJECT_ID('tblYeuCauPhep', 'U') IS NOT NULL
    DROP TABLE tblYeuCauPhep;
go;
IF OBJECT_ID('tblKhenThuongKyLuat', 'U') IS NOT NULL
    DROP TABLE tblKhenThuongKyLuat;
go;
IF OBJECT_ID('tblHopDong', 'U') IS NOT NULL
    DROP TABLE tblHopDong;
go;

-- Tạo bảng Chức Vụ
CREATE TABLE tblChucVu (
    Machucvu INT PRIMARY KEY,        
    Tenchucvu VARCHAR(100) NOT NULL,          
    Mucluongcoban DECIMAL(10, 2) NOT NULL     
);

-- Tạo bảng Phòng Ban
CREATE TABLE tblPhongBan (
    Maphongban INT PRIMARY KEY, 
    Tenphongban VARCHAR(100) NOT NULL,   
    Motaphong TEXT NOT NULL  
);

-- Tạo bảng Nhân Viên
CREATE TABLE tblNhanVien (
    Manhanvien INT PRIMARY KEY,             
    Tennhanvien VARCHAR(100) NOT NULL,               
    Gioitinh VARCHAR(10),                   
    Ngaysinh DATE,                           
    Diachi VARCHAR(255),                    
    Sodienthoai VARCHAR(15),                
    Email VARCHAR(100) UNIQUE,                     
    Maphongban INT,                         
    Machucvu INT NOT NULL,                   
    Ngayvaocongty DATE,                     
    Trangthai VARCHAR(50),                  
    FOREIGN KEY (Maphongban) REFERENCES tblPhongBan(Maphongban) ON DELETE CASCADE,
    FOREIGN KEY (Machucvu) REFERENCES tblChucVu(Machucvu) ON DELETE CASCADE
);

-- Tạo bảng Lương
CREATE TABLE tblLuong (
    Manhanvien INT,                         
    Machucvu INT NOT NULL,                
    Mucluong DECIMAL(10, 2) NOT NULL,                
    Ngaycapnhatluong DATE NOT NULL,                  
    Phucap DECIMAL(10, 2),                  
    PRIMARY KEY (Manhanvien, Ngaycapnhatluong),  
    FOREIGN KEY (Manhanvien) REFERENCES tblNhanVien(Manhanvien) ON DELETE CASCADE,
    FOREIGN KEY (Machucvu) REFERENCES tblChucVu(Machucvu) ON DELETE NO ACTION

);

-- Tạo bảng Lịch Làm Việc
CREATE TABLE tblLichLamViec (
    Manhanvien INT,                         
    Ngaylamviec DATE,                       
    Giobatdau TIME,                         
    Gioketthuc TIME,                        
    Trangthai VARCHAR(50),                  
    PRIMARY KEY (Manhanvien, Ngaylamviec),  
    FOREIGN KEY (Manhanvien) REFERENCES tblNhanVien(Manhanvien) ON DELETE CASCADE
);

-- Tạo bảng Yêu Cầu Nghỉ Phép
CREATE TABLE tblYeuCauPhep (
    Mayeucau INT PRIMARY KEY,               
    Manhanvien INT,                         
    Ngaybatdau DATE,                        
    Ngayketthuc DATE,                       
    Loaiphep VARCHAR(50),                   
    Trangthai VARCHAR(50),                  
    FOREIGN KEY (Manhanvien) REFERENCES tblNhanVien(Manhanvien) ON DELETE CASCADE
);

-- Tạo bảng Khen Thưởng & Kỷ Luật
CREATE TABLE tblKhenThuongKyLuat (
    Manhanvien INT,                         
    Ngay DATE,                              
    Loai VARCHAR(50),                       
    Lydo TEXT,                              
    PRIMARY KEY (Manhanvien, Ngay),         
    FOREIGN KEY (Manhanvien) REFERENCES tblNhanVien(Manhanvien) ON DELETE CASCADE
);

-- Tạo bảng Hợp Đồng Lao Động
CREATE TABLE tblHopDong (
    Manhanvien INT PRIMARY KEY,             
    Ngaybatdau DATE,                        
    Ngayketthuc DATE,                        
    Loaihopdong VARCHAR(50),                 
    FOREIGN KEY (Manhanvien) REFERENCES tblNhanVien(Manhanvien) ON DELETE CASCADE
);

-- Chèn dữ liệu vào bảng tblChucVu
INSERT INTO tblChucVu (Machucvu, Tenchucvu, Mucluongcoban) VALUES
(1, 'Giám Đốc', 25000000),
(2, 'Trưởng Phòng Kinh Doanh', 18000000),
(3, 'Nhân Viên Nhân Sự', 9000000),
(4, 'Kế Toán Trưởng', 15000000),
(5, 'Marketing Manager', 13000000),
(6, 'Nhân Viên Kế Toán', 10000000),
(7, 'Nhân Viên IT', 11000000),
(8, 'Trưởng Phòng IT', 19000000),
(9, 'Nhân Viên Marketing', 9500000),
(10, 'Nhân Viên Kinh Doanh', 10000000);

-- Chèn dữ liệu vào bảng tblPhongBan
INSERT INTO tblPhongBan (Maphongban, Tenphongban, Motaphong) VALUES
(1, 'Phòng Kinh Doanh', 'Quản lý hoạt động kinh doanh'),
(2, 'Phòng Nhân Sự', 'Quản lý nhân viên và phúc lợi'),
(3, 'Phòng IT', 'Quản lý công nghệ thông tin'),
(4, 'Phòng Marketing', 'Quảng bá và tiếp thị sản phẩm'),
(5, 'Phòng Tài Chính', 'Quản lý tài chính công ty');

-- Chèn dữ liệu vào bảng tblNhanVien
INSERT INTO tblNhanVien (Manhanvien, Tennhanvien, Gioitinh, Ngaysinh, Diachi, Sodienthoai, Email, Maphongban, Machucvu, Ngayvaocongty, Trangthai) VALUES
(3, 'Pham Thanh Son', 'Nam', '1992-09-20', 'Đà Nẵng', '0123456791', 'sonpt@example.com', 3, 4, '2021-03-22', 'Đang làm'),
(4, 'Le Minh Tam', 'Nữ', '1988-11-02', 'Cần Thơ', '0123456792', 'tamlm@example.com', 4, 1, '2019-08-30', 'Đang làm'),
(5, 'Hoang Thi Bich', 'Nữ', '1993-01-10', 'Hải Phòng', '0123456793', 'bichht@example.com', 5, 5, '2020-11-18', 'Nghỉ việc'),
(1, 'Nguyen Thi Lan', 'Nữ', '1990-05-01', 'Hà Nội', '0123456789', 'lannt@example.com', 1, 2, '2020-01-01', 'Đang làm'),
(2, 'Tran Minh Tu', 'Nam', '1985-07-14', 'Hồ Chí Minh', '0123456790', 'tutm@example.com', 2, 3, '2018-04-15', 'Đang làm');

-- Chèn dữ liệu vào bảng tblLuong
INSERT INTO tblLuong (Manhanvien, Machucvu, Mucluong, Ngaycapnhatluong, Phucap) VALUES
(3,7, 10000000, '2021-06-01', 500000),
(4,4, 20000000, '2021-06-01', 3000000),
(5,5, 12000000, '2021-06-01', 2500000),
(1, 2, 18000000, '2023-01-01', 2000000),
(2, 3, 9000000, '2023-01-01', 1000000);


-- Insert dữ liệu vào tblLichLamViec
INSERT INTO tblLichLamViec (Manhanvien, Ngaylamviec, Giobatdau, Gioketthuc, Trangthai) VALUES
(1, '2021-06-01', '08:00', '17:00', 'Có mặt'),
(2, '2021-06-01', '08:00', '17:00', 'Có mặt'),
(3, '2021-06-01', '08:30', '17:30', 'Có mặt'),
(4, '2021-06-01', '09:00', '18:00', 'Nghỉ phép'),
(5, '2021-06-01', '08:00', '17:00', 'Vắng mặt');

-- Insert dữ liệu vào tblYeuCauPhep
INSERT INTO tblYeuCauPhep (MayeuCau, Manhanvien, Ngaybatdau, Ngayketthuc, Loaiphep, Trangthai) VALUES
(1, 1, '2021-07-01', '2021-07-05', 'Nghỉ phép', 'Được phê duyệt'),
(2, 2, '2021-07-10', '2021-07-12', 'Nghỉ ốm', 'Chờ phê duyệt'),
(3, 3, '2021-08-15', '2021-08-20', 'Nghỉ phép', 'Được phê duyệt'),
(4, 4, '2021-09-01', '2021-09-03', 'Nghỉ lễ', 'Được phê duyệt'),
(5, 5, '2021-09-05', '2021-09-07', 'Nghỉ phép', 'Chờ phê duyệt');

-- Insert dữ liệu vào tblKhenThuongKyLuat
INSERT INTO tblKhenThuongKyLuat (Manhanvien, Ngay, Loai, Lydo) VALUES
(1, '2021-06-15', 'Khen thưởng', 'Hoàn thành xuất sắc công việc'),
(2, '2021-06-20', 'Kỷ luật', 'Đi muộn 3 lần trong tháng'),
(3, '2021-06-25', 'Khen thưởng', 'Đạt thành tích xuất sắc trong dự án'),
(4, '2021-07-01', 'Khen thưởng', 'Có sáng kiến giúp cải tiến công việc'),
(5, '2021-07-10', 'Kỷ luật', 'Không hoàn thành công việc đúng thời hạn');

-- Insert dữ liệu vào tblHopDong
INSERT INTO tblHopDong (Manhanvien, Ngaybatdau, Ngayketthuc, Loaihopdong) VALUES
(1, '2021-06-01', '2023-06-01', 'Toàn thời gian'),
(2, '2019-08-15', '2022-08-15', 'Bán thời gian'),
(3, '2020-02-01', '2023-02-01', 'Toàn thời gian'),
(4, '2021-05-15', '2023-05-15', 'Thời vụ'),
(5, '2021-11-01', '2022-11-01', 'Bán thời gian');


SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT * FROM tblChucVu;
SELECT * FROM tblPhongBan;
SELECT * FROM tblNhanVien;
SELECT * FROM tblLuong;
SELECT * FROM tblLichLamViec;
SELECT * FROM tblYeuCauPhep;
SELECT * FROM tblKhenThuongKyLuat;
SELECT * FROM tblHopDong;
