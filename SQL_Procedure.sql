    -- Thêm nhân viên
    -- Kiểm tra xem thủ tục ThemNhanVien đã tồn tại chưa
    IF OBJECT_ID('dbo.ThemNhanVien', 'P') IS NOT NULL
        DROP PROCEDURE dbo.ThemNhanVien;
    GO

    -- Tạo thủ tục ThemNhanVien
    CREATE PROCEDURE ThemNhanVien
        @Manhanvien INT,
        @Tennhanvien VARCHAR(100),
        @Gioitinh VARCHAR(10) = NULL,
        @Ngaysinh DATE = NULL,
        @Diachi VARCHAR(255) = NULL,
        @Sodienthoai VARCHAR(15) = NULL,
        @Email VARCHAR(100) = NULL,
        @Maphongban INT = NULL,
        @Machucvu INT,
        @Ngayvaocongty DATE = NULL,
        @NgatKetThuc DATE = NULL,
        @Loai VARCHAR(50),
        @Trangthai VARCHAR(50) = NULL
    AS
    BEGIN
        -- Chèn thông tin nhân viên mới vào bảng tblNhanVien
        INSERT INTO tblNhanVien (Manhanvien, Tennhanvien, Gioitinh, Ngaysinh, Diachi, Sodienthoai, Email, Maphongban, Machucvu, Ngayvaocongty, Trangthai)
        VALUES (@Manhanvien, @Tennhanvien, @Gioitinh, @Ngaysinh, @Diachi, @Sodienthoai, @Email, @Maphongban, @Machucvu, @Ngayvaocongty, @Trangthai);

        -- Chèn thông tin hợp đồng vào bảng tblHopDong
        INSERT INTO tblHopDong(Manhanvien, Ngaybatdau, Ngayketthuc, Loaihopdong)
        VALUES(@Manhanvien, @Ngayvaocongty, @NgatKetThuc, @Loai);

        -- (Tùy chọn) Bạn có thể thêm dòng này để xem dữ liệu vừa được chèn
        SELECT * FROM tblNhanVien WHERE Manhanvien = @Manhanvien;
    END;
    GO

    -- Ví dụ về cách sử dụng thủ tục ThemNhanVien để thêm một nhân viên mới
    -- Thay đổi các giá trị sau cho phù hợp với dữ liệu bạn muốn thêm
    EXEC ThemNhanVien
        @Manhanvien = 5, -- Thay bằng mã nhân viên mới (phải là duy nhất vì là khóa chính)
        @Tennhanvien = N'Lê Văn C', -- Thay bằng tên nhân viên
        @Gioitinh = N'Nam', -- Thay bằng giới tính
        @Ngaysinh = '1998-08-15', -- Thay bằng ngày sinh
        @Diachi = N'Hồ Chí Minh', -- Thay bằng địa chỉ
        @Sodienthoai = '0901234567', -- Thay bằng số điện thoại
        @Email = 'levanc.new@example.com', -- Thay bằng email (phải là duy nhất, lỗi cũ là do email này đã tồn tại)
        @Maphongban = 2, -- Thay bằng mã phòng ban (nếu có)
        @Machucvu = 2, -- Thay bằng mã chức vụ (không được NULL)
        @Ngayvaocongty = '2025-03-19', -- Thay bằng ngày vào công ty (nếu có)
        @NgatKetThuc = '2026-03-20', -- Thay bằng ngày kết thúc (nếu có)
        @Loai = N'Toan thoi gian', -- Thay bằng loại hợp đồng (nếu có)
        @Trangthai = N'Đang làm việc'; -- Thay bằng trạng thái
    GO

    select * from tblNhanVien

go;
--  Sửa thông tin  nhân viên 
    CREATE PROCEDURE SuaThongTinNV
        @Manhanvien INT, 
        @Tennhanvien NVARCHAR(100), 
        @Gioitinh NVARCHAR(10), 
        @Ngaysinh DATE, 
        @Diachi NVARCHAR(255), 
        @Sodienthoai NVARCHAR(15), 
        @Email NVARCHAR(100), 
        @Maphongban INT, 
        @Machucvu INT, 
        @Ngayvaocongty DATE, 
        @Trangthai NVARCHAR(50)
    AS
    BEGIN
        UPDATE tblNhanVien
        SET Tennhanvien = @Tennhanvien, Gioitinh = @Gioitinh, Ngaysinh = @Ngaysinh, Diachi = @Diachi, 
            Sodienthoai = @Sodienthoai, Email = @Email, Maphongban = @Maphongban, 
            Machucvu = @Machucvu, Ngayvaocongty = @Ngayvaocongty, Trangthai = @Trangthai
        WHERE Manhanvien = @Manhanvien;
    END;
    EXEC SuaThongTinNV 1, N'Nguyễn Văn Vượng', N'Nam', '1991-08-20', N'Hải Phòng', '0987654321', 'nguyenb@email.com', 3, 2, '2023-02-15', N'Nghỉ việc';

    select * from tblNhanVien

go
--  Lấy danh sách nhân viên
    CREATE PROCEDURE LayDSNhanVien
    AS
    BEGIN
        SELECT * FROM tblNhanVien;
    END;

    EXEC LayDSNhanVien;

go
--  Cập nhật nghỉ phép 
    -- Kiểm tra xem thủ tục ThemYeuCauPhep đã tồn tại chưa
    IF OBJECT_ID('dbo.ThemYeuCauPhep', 'P') IS NOT NULL
        DROP PROCEDURE dbo.ThemYeuCauPhep;
    GO

    -- Tạo thủ tục ThemYeuCauPhep
    CREATE PROCEDURE ThemYeuCauPhep
        @Mayeucau INT PRIMARY KEY,
        @Manhanvien INT,
        @Ngaybatdau DATE,
        @Ngayketthuc DATE,
        @Loaiphep VARCHAR(50),
        @Trangthai VARCHAR(50)
    AS
    BEGIN
        -- Kiểm tra xem mã nhân viên có hợp lệ không (tồn tại trong bảng tblNhanVien)
        IF NOT EXISTS (SELECT 1 FROM tblNhanVien WHERE Manhanvien = @Manhanvien)
        BEGIN
            -- Nếu mã nhân viên không tồn tại, trả về lỗi và kết thúc thủ tục
            RAISERROR('Mã nhân viên không hợp lệ. Vui lòng kiểm tra lại.', 16, 1);
            RETURN; -- Kết thúc thủ tục
        END;

        -- Kiểm tra thêm các trường hợp hợp lệ khác nếu cần
        -- Ví dụ: Kiểm tra xem ngày bắt đầu có nhỏ hơn hoặc bằng ngày kết thúc không
        IF @Ngaybatdau > @Ngayketthuc
        BEGIN
            RAISERROR('Ngày bắt đầu không được lớn hơn ngày kết thúc.', 16, 1);
            RETURN;
        END;

        -- Kiểm tra xem ngày bắt đầu có phải là ngày trong tương lai (nếu cần)
        IF @Ngaybatdau <= GETDATE()
        BEGIN
            RAISERROR('Ngày bắt đầu phải là ngày trong tương lai.', 16, 1);
            RETURN;
        END;

        -- Nếu tất cả các kiểm tra đều hợp lệ, tiến hành chèn thông tin yêu cầu nghỉ phép
        INSERT INTO tblYeuCauPhep (Mayeucau, Manhanvien, Ngaybatdau, Ngayketthuc, Loaiphep, Trangthai)
        VALUES (@Mayeucau, @Manhanvien, @Ngaybatdau, @Ngayketthuc, @Loaiphep, @Trangthai);

        SELECT * FROM tblYeuCauPhep WHERE Mayeucau = @Mayeucau;
    END;
    GO

    -- Ví dụ về cách sử dụng thủ tục ThemYeuCauPhep
    -- Thay đổi các giá trị sau cho phù hợp với dữ liệu bạn muốn thêm
    EXEC ThemYeuCauPhep
        @Mayeucau = 101, -- Thay bằng mã yêu cầu nghỉ phép mới
        @Manhanvien = 1, -- Thay bằng mã nhân viên (phải tồn tại trong tblNhanVien)
        @Ngaybatdau = '2025-04-05', -- Thay bằng ngày bắt đầu nghỉ phép
        @Ngayketthuc = '2025-04-10', -- Thay bằng ngày kết thúc nghỉ phép
        @Loaiphep = N'Nghỉ phép năm', -- Thay bằng loại phép
        @Trangthai = N'Chờ duyệt'; -- Thay bằng trạng thái
    GO

    select * from  tblYeuCauPhep

--  Khen thuong 
    drop TRIGGER trg_ThêmKhenThuong
    -- Kiểm tra xem thủ tục ThemKhenThuong đã tồn tại chưa
    IF OBJECT_ID('dbo.ThemKhenThuong', 'P') IS NOT NULL
        DROP PROCEDURE dbo.ThemKhenThuong;
    GO

    -- Tạo thủ tục ThemKhenThuong
    CREATE PROCEDURE ThemKhenThuong
        @Manhanvien INT,
        @Ngay DATE,
        @Loai VARCHAR(50),
        @Lydo TEXT
    AS
    BEGIN
        -- Kiểm tra xem mã nhân viên có hợp lệ không (tồn tại trong bảng tblNhanVien)
        IF NOT EXISTS (SELECT 1 FROM tblNhanVien WHERE Manhanvien = @Manhanvien)
        BEGIN
            -- Nếu mã nhân viên không tồn tại, trả về lỗi và kết thúc thủ tục
            RAISERROR('Mã nhân viên không hợp lệ. Vui lòng kiểm tra lại.', 16, 1);
            RETURN; -- Kết thúc thủ tục
        END;

        -- Kiểm tra xem bản ghi khen thưởng cho nhân viên và ngày này đã tồn tại chưa
        IF EXISTS (SELECT 1 FROM tblKhenThuongKyLuat WHERE Manhanvien = @Manhanvien AND Ngay = @Ngay)
        BEGIN
            -- Nếu đã tồn tại, trả về lỗi và kết thúc thủ tục
            RAISERROR('Đã tồn tại thông tin khen thưởng/kỷ luật cho nhân viên này vào ngày này.', 16, 1);
            RETURN; -- Kết thúc thủ tục
        END;

        -- Nếu mã nhân viên hợp lệ và bản ghi chưa tồn tại, tiến hành chèn thông tin khen thưởng
        INSERT INTO tblKhenThuongKyLuat (Manhanvien, Ngay, Loai, Lydo)
        VALUES (@Manhanvien, @Ngay, @Loai, @Lydo);

        -- (Tùy chọn) Bạn có thể thêm dòng này để xem dữ liệu vừa được chèn
        -- SELECT * FROM tblKhenThuongKyLuat WHERE Manhanvien = @Manhanvien AND Ngay = @Ngay;
    END;
    GO

    -- Ví dụ về cách sử dụng thủ tục ThemKhenThuong để thêm một bản ghi khen thưởng
    -- Thay đổi các giá trị sau cho phù hợp với dữ liệu bạn muốn thêm
    EXEC ThemKhenThuong
        @Manhanvien = 3, -- Thay bằng mã nhân viên đã tồn tại trong tblNhanVien
        @Ngay = '2025-03-20', -- Thay bằng ngày khen thưởng
        @Loai = N'Thưởng', -- Thay bằng loại (ví dụ: Thưởng, Kỷ luật)
        @Lydo = N'Hoàn thành xuất sắc dự án.'; -- Thay bằng lý do khen thưởng


        select * from tblKhenThuongKyLuat
    GO

select * from  tblKhenThuongKyLuat
--  Thêm lịch làm việc 
    go;
    CREATE PROCEDURE ThemLichLamViec  
        @Manhanvien INT,  
        @Ngaylamviec DATE,  
        @Giobatdau TIME,  
        @Gioketthuc TIME,  
        @Trangthai VARCHAR(50)  
    AS  
    BEGIN  
        INSERT INTO tblLichLamViec (Manhanvien, Ngaylamviec, Giobatdau, Gioketthuc, Trangthai)  
        VALUES (@Manhanvien, @Ngaylamviec, @Giobatdau, @Gioketthuc, @Trangthai);  
    END;

    EXEC ThemLichLamViec 1,'2025-01-01','08:00:00','17:00:00','vang';

    select * from  tblLichLamViec
go 
--  Laays ddanh sahc theoo phong ban
    CREATE PROCEDURE LayDSNVTheoPB  
        @Maphongban INT  
    AS  
    BEGIN  
        SELECT Manhanvien, Tennhanvien, Sodienthoai, Email  
        FROM tblNhanVien  
        WHERE Maphongban = @Maphongban;
        
    END;

    EXEC LayDSNVTheoPB 1;

go 
-- Xoa nhan vien
    CREATE PROCEDURE XoaDLNhanVien  
        @Manhanvien INT  
    AS  
    BEGIN  
        BEGIN TRANSACTION;  

        DELETE FROM tblLuong WHERE Manhanvien = @Manhanvien;  
        DELETE FROM tblLichLamViec WHERE Manhanvien = @Manhanvien;  
        DELETE FROM tblYeuCauPhep WHERE Manhanvien = @Manhanvien;  
        DELETE FROM tblKhenThuongKyLuat WHERE Manhanvien = @Manhanvien;  
        DELETE FROM tblHopDong WHERE Manhanvien = @Manhanvien;  
        DELETE FROM tblNhanVien WHERE Manhanvien = @Manhanvien;  

        COMMIT TRANSACTION;  
    END;

    EXEC XoaDLNhanVien 6;
    SELECT * FROM tblNhanVien

go 
-- Cap nha[ chuc vu 
    CREATE PROCEDURE CapNhatChucVu  
        @Manhanvien INT,  
        @Machucvu INT  
    AS  
    BEGIN  
        UPDATE tblNhanVien  
        SET Machucvu = @Machucvu  
        WHERE Manhanvien = @Manhanvien;  
    END;


    select * from  tblNhanVien
    select * from  tblChucVu

    EXEC CapNhatChucVu 4, 1;
go
    CREATE PROCEDURE CheckHopDong
        @Manhanvien INT
    AS
    BEGIN
        SELECT * 
        FROM tblHopDong 
        WHERE Manhanvien = @Manhanvien AND Ngaybatdau <= GETDATE() AND Ngayketthuc >= GETDATE();
    END;

    EXEC CheckHopDong 5;


    SELECT * FROM tblHopDong
