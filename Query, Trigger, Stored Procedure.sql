USE MYHOTEL;
DELIMITER \\
-- @block STORED PROCEDURE 1 --
DROP PROCEDURE IF EXISTS GoiDichVu\\
CREATE PROCEDURE GoiDichVu (IN MaKhachHang VARCHAR(8))
BEGIN
    DECLARE count int DEFAULT 0;
    SET count = (SELECT COUNT(HDGDV_MKH) FROM HOADONGOIDICHVU WHERE HDGDV_MKH = MaKhachHang);
    IF count > 0 THEN
    SELECT HOADONGOIDICHVU.HDGDV_TG AS 'Tên Gói', HOADONGOIDICHVU.SoKhach AS 'Số Khách', HOADONGOIDICHVU.NgayBatDau AS 'Ngày Bắt đầu', 
            ADDDATE(HOADONGOIDICHVU.NgayBatDau, INTERVAL GOIDICHVU.SoNgay DAY) AS 'Ngày kết thúc', HOADONGOIDICHVU.SoNgaySuDungConLai AS 'Số ngày sử dụng còn lại'
    FROM HOADONGOIDICHVU
    WHERE HOADONGOIDICHVU.HDGDV_MKH = MaKhachHang;
    ELSE SELECT CONCAT('YOUR PARAMETER ',MaKhachHang,' DOES NOT EXIST!') AS 'ERROR';
    END IF;
END\\
-- @block STORED PROCEDURE 2 --
DROP PROCEDURE IF EXISTS ThongKeLuotKhach\\
CREATE PROCEDURE ThongKeLuotKhach (IN MCN VARCHAR(50), IN NamThongKe INT(5))
BEGIN
    SELECT MONTH(NgayNhanPhong) AS 'Tháng', SUM(SoKhach) AS 'Tổng số lượt khách'
    FROM (SELECT TinhTrang, SoKhach, PT_MCN, NgayNhanPhong FROM DONDATPHONG INNER JOIN PHONGTHUE ON MaDatPhong = PT_MDP)
    WHERE PT_MCN = MCN AND TinhTrang = 1 AND YEAR(NgayNhanPhong) = NamThongKe
    GROUP BY MONTH(NgayNhanPhong)
    ORDER BY MONTH(NgayNhanPhong);
END\\
-- @block TRIGGER 1a --
DROP TRIGGER IF EXISTS update_TongTienGoiDichVu\\
CREATE TRIGGER update_TongTienGoiDichVu
AFTER INSERT ON HOADONGOIDICHVU FOR EACH ROW
BEGIN
    DECLARE temp INT DEFAULT 1;
    SET temp = (SELECT Loai FROM KHACHHANG WHERE MaKhachHang = HDGDV_MKH);
    IF temp = 2 THEN SET NEW.TongTien = ((SELECT GiaFROM GOIDICHVUWHERE TenGoi = HDGDV_TG) * 9 / 10);
    ELSEIF temp = 3 THEN
        BEGIN
            SET NEW.SoNgaySuDungConLai = SoNgaySuDungConLai + 1;
            SET NEW.TongTien = ((SELECT Gia FROM GOIDICHVU WHERE TenGoi = HDGDV_TG) * 17 / 20);
        END;
    ELSEIF temp = 4 THEN
        BEGIN
            SET NEW.SoNgaySuDungConLai = SoNgaySuDungConLai + 2;
            SET NEW.TongTien = ((SELECT Gia FROM GOIDICHVU WHERE TenGoi = HDGDV_TG) * 4 / 5);
        END;
    END IF;
END\\
-- @block TRIGGER 1b --
DROP TRIGGER IF EXISTS update_TongTienDonDatPhong\\
CREATE TRIGGER update_TongTienDonDatPhong
AFTER INSERT ON DONDATPHONG FOR EACH ROW
BEGIN
    DECLARE temp INT DEFAULT 1;
    SET temp = (SELECT Loai FROM KHACHHANG WHERE MaKhachHang = DDP_MKH);
    IF DDP_TG IS NULL THEN
            IF temp = 2 THEN SET NEW.TongTien = TongTien * 9 / 10;
            ELSEIF temp = 3 THEN SET NEW.TongTien = TongTien * 17 / 20;
            ELSEIF temp = 4 THEN SET NEW.TongTien = TongTien * 4 / 5;
            END IF;
    ELSE
        BEGIN
            SET NEW.TongTien = 0;
            UPDATE HOADONGOIDICHVU
            SET NEW.SoNgaySuDungConLai = SoNgaySuDungConLai - TIMESTAMPDIFF(DAY, DONDATPHONG.NgayNhanPhong, DONDATPHONG.NgayTraPhong);
        END;
    END IF;
END\\
-- @block TRIGGER 1c --
DROP TRIGGER IF EXISTS update_Diem\\
CREATE TRIGGER update_Diem
AFTER INSERT ON KHACHHANG FOR EACH ROW
BEGIN
    SET NEW.Diem = FLOOR(((SELECT TongTien FROM HOADONGOIDICHVU WHERE HDGDV_MKH = MaKhachHang) + (SELECT TongTien FROM DONDATPHONG WHERE DDP_MKH = MaKhachHang)) / 1000);
END\\
-- @block TRIGGER 1d --
DROP TRIGGER IF EXISTS update_LoaiKhachHang\\
CREATE TRIGGER update_LoaiKhachHang
AFTER INSERT ON KHACHHANG FOR EACH ROW
BEGIN
    IF Diem < 50 THEN SET NEW.Loai = 1;
    ELSEIF Diem < 100 THEN SET NEW.Loai = 2;
    ELSEIF Diem < 1000 THEN SET NEW.Loai = 3;
    ELSE SET NEW.Loai = 4;
    END IF;
END\\
-- @block TRIGGER 2 --
DROP TRIGGER IF EXISTS constraint_OverlappingPackage\\
CREATE TRIGGER constraint_OverlappingPackage
BEFORE INSERT ON HOADONGOIDICHVU FOR EACH ROW
BEGIN
    DECLARE temp DATETIME;
    SET temp = ADDDATE(NgayBatDau, INTERVAL 1 YEAR);
    IF (EXISTS(SELECT * FROM HOADONGOIDICHVU WHERE HDGDV_TG = NEW.HDGDV_TG)) THEN
        IF (NEW.NgayBatDau BETWEEN (SELECT NgayBatDau FROM HOADONGOIDICHVU WHERE HDGDV_TG = NEW.HDGDV_TG) AND temp) 
        THEN signal sqlstate '45000';
        END IF;
    END IF;
END\\
DELIMITER ;