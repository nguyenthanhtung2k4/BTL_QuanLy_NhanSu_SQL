-- Tạo tài khoản cho Quản lý
CREATE LOGIN QuanLy WITH PASSWORD = 'Password123!';
CREATE USER QuanLyUser FOR LOGIN QuanLy;
go
-- Tạo tài khoản cho Nhân viên
CREATE LOGIN NhanVien WITH PASSWORD = 'Password123!';
CREATE USER NhanVienUser FOR LOGIN NhanVien;

-- Tạo tài khoản cho Khách hàng
CREATE LOGIN KhachHang WITH PASSWORD = 'Password123!';
CREATE USER KhachHangUser FOR LOGIN KhachHang;
--Cấp quyền quản lý quản lý có toàn quyền trong database
GRANT CONTROL ON DATABASE::Quan_Ly_Nhan_Su TO QuanLyUser;
--Cấp quyền cho tài khoản Nhân viên,nhân viên có thể xem lương của mình nhưng không thể chỉnh sửa
GRANT SELECT ON tblLuong TO NhanVienUser;
DENY UPDATE, DELETE ON tblLuong TO NhanVienUser;
-- Cấp quyền cho tài khoản Khách hàng khách hàng chỉ có thể xem danh sách phòng ban và chức vụ
GRANT SELECT ON tblPhongBan TO KhachHangUser;
GRANT SELECT ON tblChucVu TO KhachHangUser;
-- Kiểm tra tất cả quyền của tài khoản Quản lý
EXECUTE AS USER = 'QuanLyUser';
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
REVERT;
--Kiểm tra quyền của tài khoản Nhân viên
EXECUTE AS USER = 'NhanVienUser';
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
REVERT;
--Kiểm tra quyền của tài khoản Khách hàng
EXECUTE AS USER = 'KhachHangUser';
SELECT * FROM fn_my_permissions(NULL, 'DATABASE');
REVERT;

--Kiểm tra danh sách các Role và thành viên

SELECT r.name AS [Tên nhóm quyền], m.name AS [Tên tài khoản]
FROM sys.database_role_members rm
JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id;


-- Kiểm tra các quyền bị từ chối (DENY)
SELECT dp.name AS [Tên tài khoản], pr.permission_name AS [Tên quyền], pr.state_desc AS [Trạng thái quyền]
FROM sys.database_principals dp
JOIN sys.database_permissions pr 
ON dp.principal_id = pr.grantee_principal_id
WHERE pr.state_desc = 'DENY';


-- //////////////////// Mã hóa

-- Câu lệnh
    --  C1
    SELECT ENCRYPTBYPASSPHRASE('MyPassphrase', 'Thông tin nhạy cảm');
    SELECT CONVERT(NVARCHAR(MAX), DECRYPTBYPASSPHRASE('MyPassphrase', ColumnData));
    --  C2
    CREATE SYMMETRIC KEY MyKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY PASSWORD = 'StrongPassword!';
    OPEN SYMMETRIC KEY MyKey
    DECRYPTION BY PASSWORD = 'StrongPassword!';
    INSERT INTO MyTable (ColumnData)
    VALUES (ENCRYPTBYKEY(KEY_GUID('MyKey'), 'Thông tin nhạy cảm'));
    SELECT CAST(DECRYPTBYKEY(ColumnData) AS NVARCHAR(MAX)) AS DecryptedData
    FROM MyTable;
    CLOSE SYMMETRIC KEY MyKey;
--  Nhan vien
-- C1
    DROP TABLE Nhanvien_Encrypted
    
    CREATE TABLE Nhanvien_Encrypted (
        Manhanvien INT PRIMARY KEY,
        Tennhanvien VARCHAR(100),
        Gioitinh VARCHAR(10),
        Ngaysinh DATE,
        Diachi VARCHAR(255),
        Sodienthoai VARBINARY(255), -- Lưu trữ số điện thoại đã mã hóa
        Email VARBINARY(255),       -- Lưu trữ email đã mã hóa
        Maphongban INT,
        Machucvu INT,
        Ngayvaocongty DATE,
        Trangthai VARCHAR(50)
    );

    INSERT INTO Nhanvien_Encrypted (Manhanvien, Tennhanvien, Gioitinh, Ngaysinh, Diachi, Sodienthoai, Email, Maphongban, Machucvu, Ngayvaocongty, Trangthai)
    SELECT
        Manhanvien,
        Tennhanvien,
        Gioitinh,
        Ngaysinh,
        Diachi,
        ENCRYPTBYPASSPHRASE('SQL_BTL', Sodienthoai),
        ENCRYPTBYPASSPHRASE('SQL_BTL', Email),
        Maphongban,
        Machucvu,
        Ngayvaocongty,
        Trangthai
    FROM
        tblNhanVien;

    --  Giai ma hoa
    SELECT
        Manhanvien,
        Tennhanvien,
        Gioitinh,
        Ngaysinh,
        Diachi,
        CONVERT(VARCHAR(MAX), DECRYPTBYPASSPHRASE('SQL_BTL', Sodienthoai)) AS Sodienthoai_Decrypted,
        CONVERT(VARCHAR(MAX), DECRYPTBYPASSPHRASE('SQL_BTL', Email)) AS Email_Decrypted,
        Maphongban,
        Machucvu,
        Ngayvaocongty,
        Trangthai
    FROM
        Nhanvien_Encrypted;
    
-- c2
        -- Create MASTER KEY ENCRYPTION BY PASSWORD = 'tong@'
        -- CREATE CERTIFICATE MyCertificate
        -- WITH SUBJECT = 'Certificate for Symmetric Key Encryption';
        -- GO
        -- USE Northwind
        -- CREATE SYMMETRIC KEY MySymmetricKey
        -- WITH ALGORITHM = AES_256
        -- ENCRYPTION BY CERTIFICATE MyCertificate;
        -- GO
        GO
        DROP SYMMETRIC KEY MySymmetricKey;

        --  tao key
        CREATE SYMMETRIC KEY MySymmetricKey
            WITH ALGORITHM = AES_256
            ENCRYPTION BY PASSWORD = 'StrongPassword!';
        
        -- Tao bang moi
        CREATE TABLE Nhanvien_Encrypted (
            Manhanvien VARCHAR(50), -- Lưu ý: Bảng gốc có Manhanvien là INT
            Tennhanvien VARCHAR(100),
            Email_MaHoa VARBINARY(MAX),
            Sodienthoai_MaHoa VARBINARY(MAX),
            Maphongban INT,
            Machucvu INT
        );
        GO
        --  ma hoa
        OPEN SYMMETRIC KEY MySymmetricKey
            DECRYPTION BY PASSWORD = 'StrongPassword!';

        INSERT INTO Nhanvien_Encrypted (Manhanvien, Tennhanvien, Email_MaHoa, Sodienthoai_MaHoa, Maphongban, Machucvu)
        SELECT
            Manhanvien,
            Tennhanvien,
            ENCRYPTBYKEY(KEY_GUID('MySymmetricKey'), CAST(Email AS NVARCHAR(MAX))),
            ENCRYPTBYKEY(KEY_GUID('MySymmetricKey'), CAST(Sodienthoai AS NVARCHAR(MAX))),
            Maphongban,
            Machucvu
        FROM
            tblNhanVien;

        CLOSE SYMMETRIC KEY MySymmetricKey;
        GO

        SELECT * FROM Nhanvien_Encrypted;
    --  giai ma hoa
    OPEN SYMMETRIC KEY MySymmetricKey
        DECRYPTION BY PASSWORD = 'StrongPassword!';
    GO

    SELECT
        CONVERT(VARCHAR(MAX),DECRYPTBYKEY(Email_MaHoa)) as  Emaol_De
        ,
        CONVERT(VARCHAR(MAX),DECRYPTBYKEY(Sodienthoai_MaHoa)) as Sodienthoai_De

    FROM
        Nhanvien_Encrypted;
    GO

    CLOSE SYMMETRIC KEY MySymmetricKey;
    GO