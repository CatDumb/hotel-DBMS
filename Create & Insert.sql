DROP DATABASE IF EXISTS MYHOTEL;
CREATE DATABASE MYHOTEL;
USE MYHOTEL;
-- Drop exists tables to load new ones
DROP TABLE IF EXISTS chinhanh;
DROP TABLE IF EXISTS hinhanh_chinhanh;
DROP TABLE IF EXISTS khu;
DROP TABLE IF EXISTS loaiphong;
DROP TABLE IF EXISTS thongtingiuong;
DROP TABLE IF EXISTS chinhanh_co_loaiphong;
DROP TABLE IF EXISTS phong;
DROP TABLE IF EXISTS loaivattu;
DROP TABLE IF EXISTS loaivattu_trong_loaiphong;
DROP TABLE IF EXISTS vattu;
DROP TABLE IF EXISTS nhacungcap;
DROP TABLE IF EXISTS cungcapvattu;
DROP TABLE IF EXISTS khachhang;
DROP TABLE IF EXISTS goidichvu;
DROP TABLE IF EXISTS hoadongoidichvu;
DROP TABLE IF EXISTS dondatphong;
DROP TABLE IF EXISTS phongthue;
DROP TABLE IF EXISTS hoadon;
DROP TABLE IF EXISTS doanhnghiep;
DROP TABLE IF EXISTS dichvu;
DROP TABLE IF EXISTS dichvuspa;
DROP TABLE IF EXISTS loaihangdoluuniem;
DROP TABLE IF EXISTS thuonghieudoluuniem;
DROP TABLE IF EXISTS matbang;
DROP TABLE IF EXISTS hinhanhcuahang;
DROP TABLE IF EXISTS khunggiohoatdong;
-- @block 1 --
CREATE TABLE IF NOT EXISTS CHINHANH (
    MaChiNhanh INT NOT NULL AUTO_INCREMENT,
    Tinh VARCHAR(50) NOT NULL,
    DiaChi VARCHAR(255) NOT NULL,
    DienThoai INT NOT NULL,
    Email VARCHAR(50) NOT NULL,
    CONSTRAINT PK_CHINHANH PRIMARY KEY (MaChiNhanh)
);
-- @block 1 CHINHANH --
INSERT INTO CHINHANH (Tinh, DiaChi, DienThoai, Email)
VALUES (
        'Alime',
        '255 Jandex Street, District 13',
        0901392331,
        'ChienHugo111@gmail.com'
    ),
    (
        'Binary',
        '1080 Pixel Street, District 144',
        0800281220,
        'DuySocket222@yahoo.com'
    ),
    (
        'Canary',
        '720 HDMI Street, District 6',
        0833281520,
        'LokLok322@hcmut.edu.vn'
    ),
    (
        'Dharma',
        '480 Low Res Street, District 64',
        091221120,
        'ZuDuYu52@icloud.com'
    );
ALTER TABLE CHINHANH
MODIFY COLUMN MaChiNhanh varchar(50);
UPDATE CHINHANH
SET MaChiNhanh = CONCAT('CN', MaChiNhanh);
-- @block 2 --
CREATE TABLE IF NOT EXISTS HINHANH_CHINHANH (
    HA_MCN VARCHAR(50),
    HinhAnh VARCHAR(255) NOT NULL,
    CONSTRAINT PK_HINHANH PRIMARY KEY (HinhAnh),
    CONSTRAINT FK_HA_MCN FOREIGN KEY (HA_MCN) REFERENCES CHINHANH(MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 2 HINHANH_CHINHANH --
INSERT INTO HINHANH_CHINHANH (HA_MCN, HinhAnh)
VALUES ('CN1', 'youtube.com'),
    ('CN2', 'amazon.com'),
    ('CN3', 'facebook.com'),
    ('CN4', 'shoppe.vn');
-- @block 3 --
CREATE TABLE IF NOT EXISTS KHU (
    Khu_MCN VARCHAR(50),
    TenKhu VARCHAR(50) NOT NULL,
    CONSTRAINT PK_KHU PRIMARY KEY (TenKhu),
    CONSTRAINT FK_Khu_MCN FOREIGN KEY (Khu_MCN) REFERENCES CHINHANH (MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 3 KHU --
INSERT INTO KHU (Khu_MCN, TenKhu)
VALUES ('CN1', 'THANH HOA'),
    ('CN2', 'BRAZIL'),
    ('CN3', 'HAI PHONG'),
    ('CN4', 'HELL');
-- @block 4 --
CREATE TABLE IF NOT EXISTS LOAIPHONG (
    MaLoaiPhong INT NOT NULL AUTO_INCREMENT,
    TenLoaiPhong VARCHAR(50) NOT NULL,
    DienTich DECIMAL(4, 1) NOT NULL,
    SoKhach INT NOT NULL CHECK(
        SoKhach BETWEEN 1 AND 10
    ),
    MoTaKhac VARCHAR(255) DEFAULT NULL,
    CONSTRAINT PK_LOAIPHONG PRIMARY KEY (MaLoaiPhong)
);
-- @block 4 LOAIPHONG --
INSERT INTO LOAIPHONG (TenLoaiPhong, DienTich, SoKhach, MoTaKhac)
VALUES ('PHONG 1', 10.0, 1, 'PHONG CHO NGUOI CO DON'),
    (
        'PHONG 2',
        30.5,
        5,
        'PHONG CHO 5 AE TRONG 1 CHIEC XE TANK'
    ),
    ('PHONG 3', 60.0, 5, '5 AE NHUNG MA GIAU HON'),
    ('PHONG 4', 100.0, 1, 'PHONG CHO TI PHU');
-- @block 5 --
CREATE TABLE IF NOT EXISTS THONGTINGIUONG (
    TTG_MLP INT,
    KichThuoc DECIMAL(2, 1) NOT NULL,
    SoLuong INT NOT NULL DEFAULT 1 CHECK(
        SoLuong BETWEEN 1 AND 10
    ),
    CONSTRAINT PK_TTG PRIMARY KEY (KichThuoc),
    CONSTRAINT FK_TTG_MLP FOREIGN KEY (TTG_MLP) REFERENCES LOAIPHONG(MaLoaiPhong) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 5 THONTINGIUONG --
INSERT INTO THONGTINGIUONG (TTG_MLP, KichThuoc, SoLuong)
VALUES (1, 1.0, 1),
    (2, 2.0, 1),
    (3, 3.0, 1),
    (4, 4.0, 1);
-- @block 6 --
CREATE TABLE IF NOT EXISTS CHINHANH_CO_LOAIPHONG (
    Co_MLP INT,
    Co_MCN VARCHAR(50),
    GiaThue INT NOT NULL CHECK(GiaThue > -1),
    CONSTRAINT FK_Co_MLP FOREIGN KEY (Co_MLP) REFERENCES LOAIPHONG (MaLoaiPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Co_MCN FOREIGN KEY (Co_MCN) REFERENCES CHINHANH (MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 6 CHINHANH_CO_LOAIPHONG --
INSERT INTO CHINHANH_CO_LOAIPHONG (Co_MLP, Co_MCN, GiaThue)
VALUES (1, 'CN1', 1000),
    (2, 'CN2', 2000),
    (3, 'CN3', 3000),
    (4, 'CN4', 4000);
-- @block 7 --
CREATE TABLE IF NOT EXISTS PHONG (
    Phong_MCN VARCHAR(50),
    SoPhong VARCHAR(3) UNIQUE NOT NULL,
    Phong_TK VARCHAR(50) NOT NULL,
    Phong_MLP INT NOT NULL,
    CONSTRAINT FK_Phong_MCN FOREIGN KEY (Phong_MCN) REFERENCES KHU (Khu_MCN) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Phong_TK FOREIGN KEY (Phong_TK) REFERENCES KHU (TenKhu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Phong_MLP FOREIGN KEY (Phong_MLP) REFERENCES LOAIPHONG (MaLoaiPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_PHONG PRIMARY KEY (SoPhong)
);
-- @block 7 PHONG --
INSERT INTO PHONG (Phong_MCN, SoPhong, Phong_TK, Phong_MLP)
VALUES ('CN1', '101', 'THANH HOA', 1),
    ('CN2', '202', 'BRAZIL', 2),
    ('CN3', '303', 'HAI PHONG', 3),
    ('CN4', '404', 'HELL', 4);
-- @block 8 -- MaLoaiVatTu is of type VT0001
CREATE TABLE IF NOT EXISTS LOAIVATTU(
    MaLoaiVatTu INT(4) ZEROFILL NOT NULL,
    TenLoaiVatTu VARCHAR(50) NOT NULL,
    CONSTRAINT PK_LOAIVATTU PRIMARY KEY (MaLoaiVatTu)
);
--  @block 8 LOAIVATTU --
INSERT INTO LOAIVATTU (MaLoaiVatTu, TenLoaiVatTu)
VALUES (1, 'Vat tu 1'),
    (2, 'Vat tu 2'),
    (3, 'Vat tu 3'),
    (4, 'Vat tu 4');
ALTER TABLE LOAIVATTU
MODIFY COLUMN MaLoaiVatTu VARCHAR(6);
UPDATE LOAIVATTU
SET MaLoaiVatTu = CONCAT('VT', MaLoaiVatTu);
-- @block 9 --
CREATE TABLE IF NOT EXISTS LOAIVATTU_TRONG_LOAIPHONG (
    Trong_MLVT VARCHAR(6),
    Trong_MLP INT,
    SoLuong INT NOT NULL DEFAULT 1 CHECK(
        SoLuong BETWEEN 1 AND 20
    ),
    CONSTRAINT FK_Trong_MLVT FOREIGN KEY (Trong_MLVT) REFERENCES LOAIVATTU (MaLoaiVatTu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Trong_MLP FOREIGN KEY (Trong_MLP) REFERENCES LOAIPHONG (MaLoaiPhong) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 9 LOAIVATTU_TRONG_LOAIPHONG --
INSERT INTO LOAIVATTU_TRONG_LOAIPHONG(Trong_MLVT, Trong_MLP, SoLuong)
VALUES ('VT0001', 1, DEFAULT),
    ('VT0002', 2, 2),
    ('VT0003', 3, 3),
    ('VT0004', 4, 4);
-- @block 10 -- references to chinhanh maybe redundant
CREATE TABLE IF NOT EXISTS VATTU (
    VT_MCN VARCHAR(50),
    VT_MLVT VARCHAR(6),
    SttVatTu INT NOT NULL CHECK(SttVatTu > -1),
    TinhTrang VARCHAR(50) NOT NULL,
    VT_SP VARCHAR(3),
    CONSTRAINT FK_VT_MLVT FOREIGN KEY (VT_MLVT) REFERENCES LOAIVATTU (MaLoaiVatTu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_VT_MCN_SP FOREIGN KEY (VT_MCN, VT_SP) REFERENCES PHONG (Phong_MCN, SoPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_VATTU PRIMARY KEY (SttVatTu)
);
-- @block 10 VATTU --
INSERT INTO VATTU (VT_MCN, VT_MLVT, STTVatTu, TinhTrang, VT_SP)
VALUES ('CN1', 'VT0001', 1, 'TOT', 101),
    ('CN2', 'VT0002', 2, 'TOT', 202),
    ('CN3', 'VT0003', 3, 'TOT', 303),
    ('CN4', 'VT0004', 4, 'TOT', 404);
-- @block 11 -- MaNhaCungCap is of type NCC0001
CREATE TABLE IF NOT EXISTS NHACUNGCAP (
    MaNhaCungCap INT(4) ZEROFILL NOT NULL,
    TenNhaCungCap VARCHAR(50) NOT NULL,
    Email VARCHAR(50),
    DiaChi VARCHAR(255) NOT NULL,
    CONSTRAINT PK_NHACUNGCAP PRIMARY KEY (MaNhaCungCap)
);
-- @block 11 NHACUNGCAP --
INSERT INTO NHACUNGCAP (MaNhaCungCap, TenNhaCungCap, Email, DiaChi)
VALUES (1, 'Hiep', 'tthh@gmail.com', '1 ltk'),
    (2, 'Khoa', 'nmmk@gmail.com', '2 ltk'),
    (3, 'Duy', 'lkd@gmail.com', '3 ltk'),
    (1000, 'Hung', 'tpmh@gmail.com', '4 ltk');
ALTER TABLE NHACUNGCAP
MODIFY COLUMN MaNhaCungCap VARCHAR(7);
UPDATE NHACUNGCAP
SET MaNhaCungCap = CONCAT('NCC', MaNhaCungCap);
-- @block 12 --
CREATE TABLE IF NOT EXISTS CUNGCAPVATTU (
    CCVT_MNCC VARCHAR(7),
    CCVT_MLVT VARCHAR(6),
    CCVT_MCN VARCHAR(50),
    CONSTRAINT FK_CCVT_MNCC FOREIGN KEY (CCVT_MNCC) REFERENCES NHACUNGCAP (MaNhaCungCap) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_CCVT_MLVT FOREIGN KEY (CCVT_MLVT) REFERENCES LOAIVATTU (MaLoaiVatTu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_CCVT_MCN FOREIGN KEY (CCVT_MCN) REFERENCES CHINHANH (MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 12 CUNGCAPVATTU --
INSERT INTO CUNGCAPVATTU (CCVT_MNCC, CCVT_MLVT, CCVT_MCN)
VALUES ('NCC0001', 'VT0001', 'CN1'),
    ('NCC0002', 'VT0002', 'CN2'),
    ('NCC0003', 'VT0003', 'CN3'),
    ('NCC1000', 'VT0004', 'CN4');
-- @block 13 -- MaKhachHang is of type KH000001
CREATE TABLE IF NOT EXISTS KHACHHANG(
    MaKhachHang INT(6) ZEROFILL NOT NULL,
    CCCD VARCHAR(12) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Diem INT NOT NULL DEFAULT 0 CHECK(Diem > -1),
    Loai INT NOT NULL DEFAULT 1 CHECK(
        Loai BETWEEN 1 AND 4
    ),
    CONSTRAINT PK_KHACHHANG PRIMARY KEY (MaKhachHang)
);
-- @block 13 KHACHHANG --
INSERT INTO KHACHHANG (MaKhachHang, CCCD, Email, Username, Diem, Loai)
VALUES (1, '000000', 'a@gmail.com', 'Phuc', 0, 1),
    (2, '111111', 'b@gmail.com', 'NK', 0, 2),
    (3, '222222', 'c@gmail.com', 'HH', 0, 3),
    (4, '333333', 'd@gmail.com', 'TV', 0, 4);
ALTER TABLE KHACHHANG
MODIFY COLUMN MaKhachHang VARCHAR(8);
UPDATE KHACHHANG
SET MaKhachHang = CONCAT ('KH', MaKhachHang);
-- @block 14 --
CREATE TABLE IF NOT EXISTS GOIDICHVU (
    TenGoi VARCHAR(50),
    SoNgay INT NOT NULL CHECK (
        SoNgay BETWEEN 1 AND 100
    ),
    SoKhach INT NOT NULL CHECK (
        SoKhach BETWEEN 1 AND 10
    ),
    Gia DECIMAL(12, 1) NOT NULL,
    CONSTRAINT PK_GOIDICHVU PRIMARY KEY (TenGoi)
);
-- @block 14 GOIDICHVU --
INSERT INTO GOIDICHVU (TenGoi, SoNgay, SoKhach, Gia)
VALUES ('Goi1', 1, 1, 1000),
    ('Goi2', 2, 2, 2000),
    ('Goi3', 3, 3, 3000),
    ('Goi4', 4, 4, 4000);
-- @block 15 --
CREATE TABLE IF NOT EXISTS HOADONGOIDICHVU (
    HDGDV_MKH VARCHAR(8),
    HDGDV_TG VARCHAR(50),
    NgayGioMua DATETIME NOT NULL,
    NgayBatDau DATETIME NOT NULL,
    /* CHECK (NgayBatDau > NgayGioMua) */
    TongTien INT NOT NULL,
    CONSTRAINT FK_HDGDV_MKH FOREIGN KEY (HDGDV_MKH) REFERENCES KHACHHANG (MaKhachHang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_HDGDV_TG FOREIGN KEY (HDGDV_TG) REFERENCES GOIDICHVU (TenGoi) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_HOADONGOIDICHVU PRIMARY KEY (NgayGioMua)
);
-- @block 15 HOADONGOIDICHVU --
INSERT INTO HOADONGOIDICHVU (
        HDGDV_MKH,
        HDGDV_TG,
        NgayGioMua,
        NgayBatDau,
        TongTien
    )
VALUES (
        'KH000001',
        'Goi1',
        '2022-1-1 23:59:59',
        '2022-1-2 23:59:59',
        1000
    ),
    (
        'KH000002',
        'Goi2',
        '2022-1-14 23:59:59',
        '2022-1-15 23:59:59',
        2000
    ),
    (
        'KH000003',
        'Goi3',
        '2022-2-26 23:59:59',
        '2022-2-27 23:59:59',
        3000
    ),
    (
        'KH000004',
        'Goi4',
        '2022-9-7 23:59:59',
        '2022-9-7 23:59:59',
        4000
    );
ALTER TABLE HOADONGOIDICHVU
ADD SoNgaySuDungConLai INT;
UPDATE HOADONGOIDICHVU
SET SoNgaySuDungConLai = (
        SELECT SoNgay
        FROM GOIDICHVU
        WHERE HDGDV_TG = TenGoi
    );
-- @block 16 --
CREATE TABLE IF NOT EXISTS DONDATPHONG (
    MaDatPhong INT(6) ZEROFILL AUTO_INCREMENT,
    NgayGioDat DATETIME NOT NULL,
    NgayNhanPhong DATETIME NOT NULL,
    /* CHECK (NgayNhanPhong > NgayGioDat) */
    NgayTraPhong DATETIME NOT NULL,
    /* CHECK (NgayTraPhong > NgayNhanPhong) */
    TinhTrang INT NOT NULL CHECK (
        TinhTrang BETWEEN 0 AND 3
    ),
    TongTien INT NOT NULL DEFAULT 0 CHECK(TongTien > -1),
    DDP_MKH VARCHAR(8),
    DDP_TG VARCHAR(50),
    SoKhach INT NOT NULL CHECK (SoKhach > -1),
    CONSTRAINT FK_DDP_MKH FOREIGN KEY (DDP_MKH) REFERENCES KHACHHANG (MaKhachHang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_DDP_TG FOREIGN KEY (DDP_TG) REFERENCES GOIDICHVU (TenGoi) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_DONDATPHONG PRIMARY KEY (MaDatPhong)
);
-- @block 16 DONDATPHONG --
INSERT INTO DONDATPHONG (
        NgayGioDat,
        NgayNhanPhong,
        NgayTraPhong,
        TinhTrang,
        TongTien,
        DDP_MKH,
        DDP_TG,
        SoKhach
    )
VALUES (
        '2022-02-13 01:51:10',
        '2022-06-12 12:09:20',
        '2022-09-19 11:01:05',
        0,
        1000,
        'KH000001',
        NULL,
        1
    ),
    (
        '2022-03-03 19:03:34',
        '2022-06-24 04:36:37',
        '2022-09-30 00:38:31',
        1,
        2000,
        'KH000002',
        NULL,
        2
    ),
    (
        '2022-04-10 09:00:02',
        '2022-08-18 01:41:43',
        '2022-10-20 07:24:45',
        2,
        0,
        'KH000003',
        'Goi3',
        3
    ),
    (
        '2022-05-02 02:27:49',
        '2022-09-08 18:37:16',
        '2022-10-30 18:35:19',
        3,
        0,
        'KH000004',
        'Goi4',
        4
    );
ALTER TABLE DONDATPHONG
MODIFY COLUMN MaDatPhong VARCHAR(16);
UPDATE DONDATPHONG
SET MaDatPhong = CONCAT (
        'DP',
        '28112022',
        MaDatPhong
    );
-- @block 17 --
CREATE TABLE IF NOT EXISTS PHONGTHUE (
    PT_MDP VARCHAR(16),
    PT_MCN VARCHAR(50),
    PT_SP VARCHAR(3) NOT NULL,
    CONSTRAINT FK_PT_MDP FOREIGN KEY (PT_MDP) REFERENCES DONDATPHONG (MaDatPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_PT_MCN FOREIGN KEY (PT_MCN) REFERENCES PHONG (Phong_MCN) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_PT_SP FOREIGN KEY (PT_SP) REFERENCES PHONG (SoPhong) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 17 PHONGTHUE --
INSERT INTO PHONGTHUE (PT_MDP, PT_MCN, PT_SP)
VALUES ('DP28112022000001', 'CN1', 101),
    ('DP28112022000002', 'CN2', 202),
    ('DP28112022000003', 'CN3', 303),
    ('DP28112022000004', 'CN4', 404);
-- @block 18 --
CREATE TABLE IF NOT EXISTS HOADON (
    MaHoaDon INT(6) ZEROFILL AUTO_INCREMENT,
    /* Only takes the current hour and minute, the date is already in DonDatPhong */
    ThoiGianNhanPhong TIME,
    ThoiGianTraPhong TIME,
    HD_MDP VARCHAR(16),
    CONSTRAINT FK_HD_MDP FOREIGN KEY (HD_MDP) REFERENCES DONDATPHONG (MaDatPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PRIMARY KEY (MaHoaDon)
);
-- @block 18 HOADON --
INSERT INTO HOADON (ThoiGianNhanPhong, ThoiGianTraPhong, HD_MDP)
VALUES ('12:09:20', '11:01:05', 'DP28112022000001'),
    ('04:36:37', '00:38:31', 'DP28112022000002'),
    ('01:41:43', '07:24:45', 'DP28112022000003'),
    ('18:37:16', '18:35:19', 'DP28112022000004');
ALTER TABLE HOADON
MODIFY COLUMN MaHoaDon VARCHAR(16);
UPDATE HOADON
SET MaHoaDon = CONCAT('HD', '28112022', MaHoaDon);
-- @block 19 --
CREATE TABLE IF NOT EXISTS DOANHNGHIEP (
    MaDoanhNghiep INT(4) ZEROFILL NOT NULL,
    TenDoanhNghiep VARCHAR(100),
    CONSTRAINT PK_DOANHNGHIEP PRIMARY KEY (MaDoanhNghiep)
);
-- @block 19 DOANHNGHIEP --
INSERT INTO DOANHNGHIEP (MaDoanhNghiep, TenDoanhNghiep)
VALUES (1, 'Google'),
    (2, 'Meta'),
    (3, 'Apple'),
    (4, 'Microsoft');
ALTER TABLE DOANHNGHIEP
MODIFY COLUMN MaDoanhNghiep VARCHAR(6);
UPDATE DOANHNGHIEP
SET MaDoanhNghiep = CONCAT ('DN', MaDoanhNghiep);
-- @block 20 --
CREATE TABLE IF NOT EXISTS DICHVU (
    MaDichVu VARCHAR(6) NOT NULL,
    LoaiDichVu VARCHAR(1) NOT NULL,
    SoKhach INT DEFAULT 0 CHECK(SoKhach > -1),
    PhongCach VARCHAR(255),
    DV_MDN VARCHAR(6),
    CONSTRAINT FK_DV_MDN FOREIGN KEY (DV_MDN) REFERENCES DOANHNGHIEP (MaDoanhNghiep) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_DICHVU PRIMARY KEY (MaDichVu)
);
-- @block 20 DICHVU --
INSERT INTO DICHVU (MaDichVu, LoaiDichVu, SoKhach, PhongCach, DV_MDN)
VALUES ('DVS001', 'S', 1, 'MX', 'DN0003'),
    ('DVS002', 'S', 1, 'NN', 'DN0003'),
    ('DVS003', 'S', 1, 'CD', 'DN0003'),
    ('DVS004', 'S', 1, 'XH', 'DN0003'),
    ('DVM001', 'M', 1, 'MK', 'DN0004'),
    ('DVM002', 'M', 1, 'NV', 'DN0004'),
    ('DVM003', 'M', 1, 'AT', 'DN0004'),
    ('DVM004', 'M', 1, 'CA', 'DN0004');
-- @block 21 --
CREATE TABLE IF NOT EXISTS DICHVUSPA (
    DVS_MDV VARCHAR(6) NOT NULL,
    DichVuSpa VARCHAR(255),
    CONSTRAINT FK_DVS_MDV FOREIGN KEY (DVS_MDV) REFERENCES DICHVU (MaDichVu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_DICHVUSPA PRIMARY KEY (DichVuSpa)
);
-- @block 21 DICHVUSPA --
INSERT INTO DICHVUSPA (DVS_MDV, DichVuSpa)
VALUES ('DVS001', 'MAT XA'),
    ('DVS002', 'NGAM NUOC'),
    ('DVS003', 'CHUOM DA'),
    ('DVS004', 'XONG HOI');
-- @block 22 --
CREATE TABLE IF NOT EXISTS LOAIHANGDOLUUNIEM (
    LHDLN_MDV VARCHAR(6) NOT NULL,
    LoaiHang VARCHAR(255),
    CONSTRAINT FK_LHDLN_MDV FOREIGN KEY (LHDLN_MDV) REFERENCES DICHVU (MaDichVu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_LOAIHANGDOLUUNIEM PRIMARY KEY (LoaiHang)
);
-- @block 22 LOAIHANGDOLUUNIEM --
INSERT INTO LOAIHANGDOLUUNIEM (LHDLN_MDV, LoaiHang)
VALUES ('DVM001', 'MOC KHOA'),
    ('DVM002', 'NON VAI'),
    ('DVM003', 'AO THUN'),
    ('DVM004', 'CHUP ANH');
-- @block 23 --
CREATE TABLE IF NOT EXISTS THUONGHIEUDOLUUNIEM (
    THDLN_MDV VARCHAR(6) NOT NULL,
    ThuongHieu VARCHAR(100),
    CONSTRAINT FK_THDLN_MDV FOREIGN KEY (THDLN_MDV) REFERENCES DICHVU (MaDichVu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_THUONGHIEUDOLUUNIEM PRIMARY KEY (ThuongHieu)
);
-- @block 23 THUONGHIEUDOLUUNIEM --
INSERT INTO THUONGHIEUDOLUUNIEM (THDLN_MDV, ThuongHieu)
VALUES ('DVM001', 'GUCCI'),
    ('DVM002', 'DOLCE'),
    ('DVM003', 'COOLMATE'),
    ('DVM004', 'FUMA');
-- @block 24 --
CREATE TABLE IF NOT EXISTS MATBANG(
    MB_MCN VARCHAR(50) NOT NULL,
    STTMatBang INT NOT NULL UNIQUE DEFAULT 1 CHECK (
        STTMatBang BETWEEN 1 AND 50
    ),
    ChieuDai INT NOT NULL,
    ChieuRong INT NOT NULL,
    GiaThue INT NOT NULL CHECK(GiaThue > -1),
    MoTa VARCHAR(255),
    MB_MDV VARCHAR(6) NOT NULL,
    TenCuaHang VARCHAR(255),
    Logo VARCHAR(255),
    CONSTRAINT FK_MB_MDV FOREIGN KEY (MB_MDV) REFERENCES DICHVU(MaDichVu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_MB_MCN FOREIGN KEY (MB_MCN) REFERENCES CHINHANH(MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_MATBANG PRIMARY KEY (MB_MCN)
);
-- @block 24 MATBANG --
INSERT INTO MATBANG (
        MB_MCN,
        STTMatBang,
        ChieuDai,
        ChieuRong,
        GiaThue,
        MoTa,
        MB_MDV,
        TenCuaHang,
        Logo
    )
VALUES (
        'CN1',
        1,
        5,
        10,
        1000,
        'NULL',
        'DVM001',
        'NON SON',
        'A.COM'
    ),
    (
        'CN2',
        2,
        10,
        15,
        2000,
        'NULL',
        'DVM002',
        'PHUC LONG',
        'B.COM'
    ),
    (
        'CN3',
        3,
        15,
        20,
        3000,
        'NULL',
        'DVM003',
        'GOGI',
        'C.COM'
    ),
    (
        'CN4',
        4,
        20,
        25,
        4000,
        'NULL',
        'DVM004',
        'OZ',
        'D.COM'
    );
-- @block 25 --
CREATE TABLE IF NOT EXISTS HINHANHCUAHANG(
    HACH_MCN VARCHAR(50) NOT NULL,
    HACH_STTMatBang INT NOT NULL DEFAULT 1,
    HinhAnh VARCHAR(255),
    CONSTRAINT FK_HACH_MCN FOREIGN KEY (HACH_MCN) REFERENCES MATBANG(MB_MCN) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_HACK_STTMatBang FOREIGN KEY (HACH_STTMatBang) REFERENCES MATBANG(STTMatBang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_HINHANHCUAHANG PRIMARY KEY (HinhAnh)
);
-- @block 25 HINHANHCUAHANG --
INSERT INTO HINHANHCUAHANG (HACH_MCN, HACH_STTMatBang, HinhAnh)
VALUES ('CN1', 1, 'a.com'),
    ('CN2', 2, 'b.com'),
    ('CN3', 3, 'c.com'),
    ('CN4', 4, 'd.com');
-- @block 26 --
CREATE TABLE IF NOT EXISTS KHUNGGIOHOATDONG (
    KGHD_MCN VARCHAR(50) NOT NULL,
    KGHD_STTMatBang INT NOT NULL DEFAULT 1,
    GioBatDau TIME,
    GioKetThuc TIME,
    CONSTRAINT FK_KGHD_MCN FOREIGN KEY (KGHD_MCN) REFERENCES MATBANG(MB_MCN) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_KGHD_STTMatBang FOREIGN KEY (KGHD_STTMatBang) REFERENCES MATBANG(STTMatBang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_KHUNGGIOHOATDONG PRIMARY KEY (GioBatDau)
);
-- @block 26 KHUNGGIOHOATDONG --
INSERT INTO KHUNGGIOHOATDONG (KGHD_MCN, KGHD_STTMatBang, GioBatDau, GioKetThuc)
VALUES ('CN1', 1, '7:00:00', '17:00:00'),
    ('CN2', 2, '7:15:00', '17:00:00'),
    ('CN3', 3, '7:30:00', '17:00:00'),
    ('CN4', 4, '7:45:00', '17:00:00');