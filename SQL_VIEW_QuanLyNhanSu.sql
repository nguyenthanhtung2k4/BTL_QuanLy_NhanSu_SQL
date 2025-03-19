-- 1. View danh sách nhân viên kèm theo tên phòng ban
CREATE VIEW vw_NhanVien_PhongBan AS
SELECT nv.Manhanvien, nv.Tennhanvien, pb.Tenphongban, nv.Trangthai
FROM tblNhanVien nv
JOIN tblPhongBan pb ON nv.Maphongban = pb.Maphongban;
-- Chức năng: Hiển thị danh sách nhân viên kèm theo tên phòng ban của họ.

select  *  from  vw_NhanVien_PhongBan
SELECT  *  FROM  tblNhanVien
go;
-- 2. View danh sách nhân viên kèm theo chức vụ
CREATE VIEW vw_NhanVien_ChucVu AS
SELECT nv.Manhanvien, nv.Tennhanvien, cv.Tenchucvu, nv.Trangthai
FROM tblNhanVien nv
JOIN tblChucVu cv ON nv.Machucvu = cv.Machucvu;
-- Chức năng: Hiển thị danh sách nhân viên với chức vụ của họ.
SELECT * FROM vw_NhanVien_ChucVu
go;

-- 3. View lương nhân viên mới nhất
CREATE VIEW vw_LuongMoiNhat AS
SELECT l.Manhanvien, nv.Tennhanvien, l.Mucluong, l.Ngaycapnhatluong
FROM tblLuong l
JOIN tblNhanVien nv ON l.Manhanvien = nv.Manhanvien
WHERE l.Ngaycapnhatluong = (SELECT MAX(Ngaycapnhatluong) FROM tblLuong WHERE Manhanvien = l.Manhanvien);
-- Chức năng: Hiển thị mức lương mới nhất của từng nhân viên.
go;
--  Xem  nhân viên mới
SELECT * FROM  vw_LuongMoiNhat
-- 4. View danh sách nhân viên đã từng được khen thưởng
CREATE VIEW vw_NhanVien_KhenThuong AS
SELECT kt.Manhanvien, nv.Tennhanvien, kt.Loai, kt.Lydo
FROM tblKhenThuongKyLuat kt
JOIN tblNhanVien nv ON kt.Manhanvien = nv.Manhanvien
WHERE kt.Loai = 'Khen thưởng';
-- Chức năng: Liệt kê những nhân viên đã từng được khen thưởng.
SELECT * FROM vw_NhanVien_KhenThuong

-- 5. View lịch làm việc của nhân viên
CREATE VIEW vw_LichLamViec AS
SELECT llv.Manhanvien, nv.Tennhanvien, llv.Ngaylamviec, llv.Giobatdau, llv.Gioketthuc, llv.Trangthai
FROM tblLichLamViec llv
JOIN tblNhanVien nv ON llv.Manhanvien = nv.Manhanvien;
-- Chức năng: Hiển thị lịch làm việc của từng nhân viên.

SELECT * FROM vw_LichLamViec

-- 6. View danh sách hợp đồng lao động còn hiệu lực
CREATE VIEW vw_HopDongHieuLuc AS
SELECT hd.Manhanvien, nv.Tennhanvien, hd.Ngaybatdau, hd.Ngayketthuc, hd.Loaihopdong
FROM tblHopDong hd
JOIN tblNhanVien nv ON hd.Manhanvien = nv.Manhanvien
WHERE hd.Ngayketthuc >= GETDATE();
-- Chức năng: Hiển thị hợp đồng lao động còn hiệu lực của nhân viên.
--   in ra màn hình 
Select * from  vw_HopDongHieuLuc
select * from  tblHopdong

-- 7. View danh sách nhân viên có yêu cầu nghỉ phép chưa duyệt
CREATE VIEW vw_YeuCauPhep_ChuaDuyet AS
SELECT yp.Mayeucau, yp.Manhanvien, nv.Tennhanvien, yp.Ngaybatdau, yp.Ngayketthuc, yp.Loaiphep
FROM tblYeuCauPhep yp
JOIN tblNhanVien nv ON yp.Manhanvien = nv.Manhanvien
WHERE yp.Trangthai = 'Chưa duyệt';
-- Chức năng: Hiển thị các yêu cầu nghỉ phép chưa được phê duyệt.
select * from  vw_YeuCauPhep_ChuaDuyet

-- 8. View tổng số nhân viên theo từng phòng ban
CREATE VIEW vw_TongNhanVien_PhongBan AS
SELECT pb.Tenphongban, COUNT(nv.Manhanvien) AS SoLuongNhanVien
FROM tblPhongBan pb
LEFT JOIN tblNhanVien nv ON pb.Maphongban = nv.Maphongban
GROUP BY pb.Tenphongban;
-- Chức năng: Thống kê số lượng nhân viên trong từng phòng ban.
select * from  vw_TongNhanVien_PhongBan

-- 9. View danh sách nhân viên nữ
CREATE VIEW vw_NhanVienNu AS
SELECT Manhanvien, Tennhanvien, Gioitinh, Ngaysinh, Diachi, Sodienthoai, Email
FROM tblNhanVien
WHERE Gioitinh = 'Nữ';
-- Chức năng: Hiển thị danh sách tất cả nhân viên nữ trong công ty.
select * from  vw_NhanVienNu

-- 10. View nhân viên có mức lương cao nhất
CREATE VIEW vw_NhanVien_LuongCaoNhat AS
SELECT nv.Manhanvien, nv.Tennhanvien, cv.Tenchucvu, l.Mucluong
FROM tblNhanVien nv
JOIN tblLuong l ON nv.Manhanvien = l.Manhanvien
JOIN tblChucVu cv ON nv.Machucvu = cv.Machucvu
WHERE l.Mucluong = (SELECT MAX(Mucluong) FROM tblLuong);
-- Chức năng: Hiển thị nhân viên có mức lương cao nhất trong công ty.
select * from  vw_NhanVien_LuongCaoNhat