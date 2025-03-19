

--Câu 1:Trigger tự động cập nhật thời gian sửa đổi khi thay đổi thông tin nhân viên
CREATE TRIGGER trg_UpdateTime_NV
ON tblNhanVien
AFTER UPDATE
AS
BEGIN
    PRINT 'Thông tin nhân viên đã được cập nhật';
END;

-- Test
UPDATE tblNhanVien
SET Tennhanvien = 'Nguyễn Văn ákjdas'
WHERE Manhanvien = 1;

go
--Câu 2 :Trigger tự động thêm lịch làm việc khi nhân viên được thêm mới
CREATE TRIGGER trg_InsertLichLamViec
ON tblNhanVien
AFTER INSERT
AS
BEGIN
    INSERT INTO tblLichLamViec (Manhanvien, Ngaylamviec, Giobatdau, Gioketthuc, Trangthai)
    SELECT Manhanvien, GETDATE(), '08:00', '17:00', 'Có mặt' FROM INSERTED;
    PRINT 'Lịch làm việc đã được thêm cho nhân viên mới';
END;

-- Test
INSERT INTO tblNhanVien (Manhanvien, Tennhanvien, Gioitinh, Ngaysinh, Diachi, Sodienthoai, Email, Maphongban, Machucvu, Ngayvaocongty, Trangthai)
VALUES (6, 'Nguyễn Quang Hieu', 'Nam', '1995-04-10', 'Hà Nội', '0123456796', 'hieunq@example.com', 3, 4, '2023-01-01', 'Đang làm');

go
--Câu 3 :Trigger tự động xóa thông tin khen thưởng khi nhân viên bị xóa
CREATE TRIGGER trg_DeleteKhenThuong
ON tblNhanVien
AFTER DELETE
AS
BEGIN
    DELETE FROM tblKhenThuongKyLuat
    WHERE Manhanvien IN (SELECT Manhanvien FROM DELETED);
    PRINT 'Thông tin khen thưởng của nhân viên đã bị xóa';
END;

-- Test
DELETE FROM tblNhanVien WHERE Manhanvien = 5;


go
--Câu 4: Trigger tự động thay đổi trạng thái yêu cầu phép khi hết hạn

CREATE TRIGGER trg_UpdateTrangThaiYeuCauPhep
ON tblYeuCauPhep
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED WHERE Ngayketthuc < GETDATE())
    BEGIN
        UPDATE tblYeuCauPhep
        SET Trangthai = 'Hết hạn'
        WHERE Ngayketthuc < GETDATE();
        PRINT 'Trạng thái yêu cầu phép đã được cập nhật thành "Hết hạn"';
    END
END;

-- Test
UPDATE tblYeuCauPhep
SET Ngayketthuc = '2021-03-01', Trangthai = 'Chờ phê duyệt'
WHERE Mayeucau = 1;

GO
--Câu 5:Trigger tự động tính lại lương khi mức lương cơ bản thay đổi
CREATE TRIGGER trg_UpdateLuong
ON tblLuong
AFTER UPDATE
AS
BEGIN
    DECLARE @NewSalary DECIMAL(10, 2);
    SELECT @NewSalary = Mucluong FROM INSERTED;
    
    UPDATE tblLuong
    SET Mucluong = @NewSalary
    WHERE Manhanvien IN (SELECT Manhanvien FROM INSERTED);
    
    PRINT 'Mức lương đã được cập nhật trong bảng tblLuong';
END;


UPDATE tblLuong
SET Mucluong = 22000000
WHERE Manhanvien = 1;

go
--Câu 6:Trigger tự động thêm ghi chú khen thưởng vào bảng khen thưởng
CREATE TRIGGER trg_ThêmKhenThuong
ON tblKhenThuongKyLuat
AFTER INSERT
AS
BEGIN
    DECLARE @Note VARCHAR(255);
    SELECT @Note = 'Được khen thưởng: ' + Loai FROM INSERTED;

    PRINT 'Ghi chú khen thưởng đã được thêm vào bảng khen thưởng';
END;


INSERT INTO tblKhenThuongKyLuat (Manhanvien, Ngay, Loai, Lydo)
VALUES (1, '2021-06-01', 'Khen thưởng', 'Hoàn thành xuất sắc công việc');

go
--Câu 7:Trigger tự động cảnh báo khi mức lương của nhân viên vượt quá một ngưỡng nhất định
CREATE TRIGGER trg_CanhBaoLuong
ON tblLuong
AFTER INSERT
AS
BEGIN
    DECLARE @Salary DECIMAL(10, 2);
    SELECT @Salary = Mucluong FROM INSERTED;
    
    IF @Salary > 30000000
    BEGIN
        PRINT 'Cảnh báo: Mức lương của nhân viên vượt quá ngưỡng cho phép!';
    END
END;

-- Test
INSERT INTO tblLuong (Manhanvien, Machucvu, Mucluong, Ngaycapnhatluong, Phucap)
VALUES (1, 2, 35000000, '2023-06-01', 2000000);


go
--Câu 8:Trigger tự động cập nhật trạng thái nhân viên khi chuyển phòng ban
CREATE TRIGGER trg_UpdateTrangThaiNhanVien
ON tblNhanVien
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED WHERE Maphongban <> (SELECT Maphongban FROM DELETED))
    BEGIN
        UPDATE tblNhanVien
        SET Trangthai = 'Chuyển phòng ban'
        WHERE Manhanvien IN (SELECT Manhanvien FROM INSERTED);
        PRINT 'Trạng thái nhân viên đã được cập nhật thành "Chuyển phòng ban"';
    END
END;

-- Test
UPDATE tblNhanVien
SET Maphongban = 2
WHERE Manhanvien = 1;

go
--Câu 9:Trigger tự động cập nhật trạng thái khi nhân viên được thăng chức
CREATE TRIGGER trg_ThangChuc
ON tblNhanVien
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED WHERE Machucvu <> (SELECT Machucvu FROM DELETED))
    BEGIN
        UPDATE tblNhanVien
        SET Trangthai = 'Được thăng chức'
        WHERE Manhanvien IN (SELECT Manhanvien FROM INSERTED);
        PRINT 'Trạng thái nhân viên đã được cập nhật thành "Được thăng chức"';
    END
END;

-- Test
UPDATE tblNhanVien
SET Machucvu = 1
WHERE Manhanvien = 3;

go
--Câu 10:Trigger tự động xóa yêu cầu nghỉ phép khi nhân viên nghỉ việc
CREATE TRIGGER trg_XoaYeuCauPhep
ON tblNhanVien
AFTER DELETE
AS
BEGIN
    DELETE FROM tblYeuCauPhep
    WHERE Manhanvien IN (SELECT Manhanvien FROM DELETED);
    PRINT 'Yêu cầu nghỉ phép của nhân viên đã bị xóa';
END;

-- Test
DELETE FROM tblNhanVien WHERE Manhanvien = 4;


go
--Câu 11:Trigger tự động thông báo khi nhân viên bị kỷ luật
CREATE TRIGGER trg_ThongBaoKyLuat
ON tblKhenThuongKyLuat
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM INSERTED WHERE Loai = 'Kỷ luật')
    BEGIN
        PRINT 'Thông báo: Nhân viên bị kỷ luật';
    END
END;

-- Test
INSERT INTO tblKhenThuongKyLuat (Manhanvien, Ngay, Loai, Lydo)
VALUES (1, '2023-06-01', 'Kỷ luật', 'Đi muộn 3 lần trong tháng');