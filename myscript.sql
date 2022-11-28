USE assignment;
-- @block 1 --
CREATE TABLE CHINHANH (
    MaChiNhanh INT NOT NULL AUTO_INCREMENT,
    Tinh VARCHAR(50) NOT NULL,
    DiaChi VARCHAR(255) NOT NULL,
    DienThoai INT NOT NULL,
    Email VARCHAR(50) NOT NULL,
    CONSTRAINT PK_CHINHANH PRIMARY KEY (MaChiNhanh)
);
-- @block 2 --
CREATE TABLE HINHANH_CHINHANH (
    HA_MCN VARCHAR(50),
    HinhAnh VARCHAR(255) NOT NULL,
    CONSTRAINT PK_HINHANH PRIMARY KEY (HinhAnh),
    CONSTRAINT FK_HA_MCN FOREIGN KEY (HA_MCN) REFERENCES CHINHANH(MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 3 --
CREATE TABLE KHU (
    Khu_MCN VARCHAR(50),
    TenKhu VARCHAR(50) NOT NULL,
    CONSTRAINT PK_KHU PRIMARY KEY (TenKhu),
    CONSTRAINT FK_Khu_MCN FOREIGN KEY (Khu_MCN) REFERENCES CHINHANH (MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 4 --
CREATE TABLE LOAIPHONG (
    MaLoaiPhong INT NOT NULL AUTO_INCREMENT,
    TenLoaiPhong VARCHAR(50) NOT NULL,
    DienTich DECIMAL(3, 2) NOT NULL,
    SoKhach UNSIGNED NOT NULL CHECK(
        SoKhach BETWEEN 1 AND 10
    ),
    MoTaKhac VARCHAR(255) DEFAULT NULL,
    CONSTRAINT PK_LOAIPHONG PRIMARY KEY (MaLoaiPhong)
);
-- @block 5 --
CREATE TABLE THONGTINGIUONG (
    TTG_MLP INT,
    KichThuoc DECIMAL(3, 1) NOT NULL,
    SoLuong UNSIGNED NOT NULL DEFAULT 1 CHECK(
        SoLuong BETWEEN 1 AND 10
    ),
    CONSTRAINT PK_TTG PRIMARY KEY (KichThuoc),
    CONSTRAINT FK_TTG_MLP FOREIGN KEY (TTG_MLP) REFERENCES LOAIPHONG(MaLoaiPhong) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 6 --
CREATE TABLE CHINHANH_CO_LOAIPHONG (
    Co_MLP INT,
    Co_MCN VARCHAR(50),
    GiaThue UNSIGNED NOT NULL,
    CONSTRAINT FK_Co_MLP FOREIGN KEY (Co_MLP) REFERENCES LOAIPHONG (MaLoaiPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Co_MCN FOREIGN KEY (Co_MCN) REFERENCES CHINHANH (MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 7 --
CREATE TABLE PHONG (
    Phong_MCN VARCHAR(50),
    SoPhong VARCHAR(3) UNIQUE NOT NULL,
    Phong_TK VARCHAR(50) NOT NULL,
    Phong_MLP INT NOT NULL,
    CONSTRAINT FK_Phong_MCN FOREIGN KEY (Phong_MCN) REFERENCES KHU (Khu_MCN) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Phong_TK FOREIGN KEY (Phong_TK) REFERENCES KHU (TenKhu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Phong_MLP FOREIGN KEY (Phong_MLP) REFERENCES LOAIPHONG (MaLoaiPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_PHONG PRIMARY KEY (SoPhong)
);
-- @block 8 -- MaLoaiVatTu is of type VT0001
CREATE TABLE LOAIVATTU(
    MaLoaiVatTu INT(4) ZEROFILL NOT NULL,
    TenLoaiVatTu VARCHAR(50) NOT NULL,
    CONSTRAINT PK_LOAIVATTU PRIMARY KEY (MaLoaiVatTu)
);
-- @block 9 --
CREATE TABLE LOAIVATTU_TRONG_LOAIPHONG (
    Trong_MLVT VARCHAR(6),
    Trong_MLP INT,
    SoLuong UNSIGNED NOT NULL DEFAULT 1 CHECK(
        SoLuong BETWEEN 1 AND 20
    ),
    CONSTRAINT FK_Trong_MLVT FOREIGN KEY (Trong_MLVT) REFERENCES LOAIVATTU (MaLoaiVatTu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Trong_MLP FOREIGN KEY (Trong_MLP) REFERENCES LOAIPHONG (MaLoaiPhong) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 10 -- references to chinhanh maybe redundant
CREATE TABLE VATTU (
    VT_MCN VARCHAR(50),
    VT_MLVT VARCHAR(6),
    SttVatTu UNSIGNED NOT NULL,
    TinhTrang VARCHAR(50) NOT NULL,
    VT_SP VARCHAR(3),
    CONSTRAINT FK_VT_MLVT FOREIGN KEY (VT_MLVT) REFERENCES LOAIVATTU (MaLoaiVatTu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_VT_MCN_SP FOREIGN KEY (VT_MCN, VT_SP) REFERENCES PHONG (Phong_MCN, SoPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_VATTU PRIMARY KEY (SttVatTu)
);
-- @block 11 -- MaNhaCungCap is of type NCC0001
CREATE TABLE NHACUNGCAP (
    MaNhaCungCap INT(4) ZEROFILL NOT NULL,
    TenNhaCungCap VARCHAR(50) NOT NULL,
    Email VARCHAR(50),
    DiaChi VARCHAR(255) NOT NULL,
    CONSTRAINT PK_NHACUNGCAP PRIMARY KEY (MaNhaCungCap)
);
-- @block 12 --
CREATE TABLE CUNGCAPVATTU (
    CCVT_MNCC VARCHAR(7),
    CCVT_MLVT VARCHAR(6),
    CCVT_MCN VARCHAR(50),
    CONSTRAINT FK_CCVT_MNCC FOREIGN KEY (CCVT_MNCC) REFERENCES NHACUNGCAP (MaNhaCungCap) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_CCVT_MLVT FOREIGN KEY (CCVT_MLVT) REFERENCES LOAIVATTU (MaLoaiVatTu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_CCVT_MCN FOREIGN KEY (CCVT_MCN) REFERENCES CHINHANH (MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 13 -- MaKhachHang is of type KH000001
CREATE TABLE KHACHHANG(
    MaKhachHang INT(6) NOT NULL ZEROFILL,
    CCCD VARCHAR(12) NOT NULL UNIQUE,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Diem UNSIGNED NOT NULL DEFAULT 0,
    Loai UNSIGNED NOT NULL DEFAULT 1,
    CONSTRAINT PK_KHACHHANG PRIMARY KEY (MaKhachHang)
);
-- @block 14 --
CREATE TABLE GOIDICHVU (
    TenGoi VARCHAR(50),
    SoNgay UNSIGNED NOT NULL CHECK (
        SoNgay BETWEEN 1 AND 100
    ),
    SoKhach UNSIGNED NOT NULL CHECK (
        SoKhach BETWEEN 1 AND 10
    ),
    Gia DECIMAL(12, 1) NOT NULL,
    CONSTRAINT PK_GOIDICHVU PRIMARY KEY (TenGoi)
);
-- @block 15 --
CREATE TABLE HOADONGOIDICHVU (
    HDGDV_MKH CHAR(8) NOT NULL,
    HDGDV_TG VARCHAR(50),
    NgayGioMua DATETIME NOT NULL,
    NgayBatDau DATETIME NOT NULL,
    -- CHECK (NgayBatDau > NgayGioMua) --
    TongTien INT NOT NULL,
    CONSTRAINT FK_HDGDV_MKH FOREIGN KEY (HDGDV_MKH) REFERENCES KHACHHANG (MaKhachHang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_HDGDV_TG FOREIGN KEY (HDGDV_TG) REFERENCES GOIDICHVU (TenGoi) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_HOADONGOIDICHVU PRIMARY KEY (NgayGioMua)
);
-- @block 16 --
CREATE TABLE DONDATPHONG (
    MaDatPhong INT(6) ZEROFILL AUTO_INCREMENT,
    NgayGioDat DATETIME NOT NULL,
    NgayNhanPhong DATETIME NOT NULL,
    -- CHECK (NgayNhanPhong > NgayGioDat) --
    NgayTraPhong DATETIME NOT NULL,
    -- CHECK (NgayTraPhong > NgayNhanPhong) --
    TinhTrang INT CHECK (
        TinhTrang > - 1
        AND TinhTrang < 4
    ),
    CONSTRAINT PK_DONDATPHONG PRIMARY KEY (MaDatPhong)
);
-- @block 17 --
CREATE TABLE PHONGTHUE (
    PT_MDP VARCHAR(16),
    PT_MCN VARCHAR(50),
    PT_SP VARCHAR(3) NOT NULL,
    CONSTRAINT FK_PT_MDP FOREIGN KEY (PT_MDP) REFERENCES DONDATPHONG (MaDatPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_PT_MCN FOREIGN KEY (PT_MCN) REFERENCES CHINHANH (MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_PT_SP FOREIGN KEY (PT_SP) REFERENCES PHONG (SoPhong) ON DELETE CASCADE ON UPDATE CASCADE
);
-- @block 18 --
CREATE TABLE HOADON (
    MaHoaDon VARCHAR(16),
    HD_MDP VARCHAR(16),
    CONSTRAINT FK_HD_MDP FOREIGN KEY (HD_MDP) REFERENCES DONDATPHONG (MaDatPhong) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PRIMARY KEY (MaHoaDon)
);
-- @block 19 --
CREATE TABLE DOANHNGHIEP (
    MaDoanhNghiep VARCHAR(6) NOT NULL,
    TenDoanhNghiep VARCHAR(100),
    CONSTRAINT PK_DOANHNGHIEP PRIMARY KEY (MaDoanhNghiep)
);
-- @block 20 --
CREATE TABLE DICHVU (
    LoaiDichVu VARCHAR(1) NOT NULL,
    MaDichVu VARCHAR(6) NOT NULL UNIQUE,
    SoKhach INT,
    PhongCach VARCHAR(255),
    DV_MDN VARCHAR(6) NOT NULL,
    CONSTRAINT FK_DV_MDN FOREIGN KEY (DV_MDN) REFERENCES DOANHNGHIEP (MaDoanhNghiep) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_DICHVU PRIMARY KEY (LoaiDichVu)
);
-- @block 21 --
CREATE TABLE DICHVUSPA (
    DVS_MDV VARCHAR(6) NOT NULL,
    DichVuSpa VARCHAR(255),
    CONSTRAINT FK_DVS_MDV FOREIGN KEY (DVS_MDV) REFERENCES DICHVU (MaDichVu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_DICHVUSPA PRIMARY KEY (DichVuSpa)
);
-- @block 22 --
CREATE TABLE LOAIHANGDOLUUNIEM (
    LHDLN_MDV VARCHAR(6) NOT NULL,
    LoaiHang VARCHAR(255),
    CONSTRAINT FK_LHDLN_MDV FOREIGN KEY (LHDLN_MDV) REFERENCES DICHVU (MaDichVu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_LOAIHANGDOLUUNIEM PRIMARY KEY (LoaiHang)
);
-- @block 23 --
CREATE TABLE THUONGHIEUDOLUUNIEM (
    THDLN_MDV VARCHAR(6) NOT NULL,
    ThuongHieu VARCHAR(100),
    CONSTRAINT FK_THDLN_MDV FOREIGN KEY (THDLN_MDV) REFERENCES DICHVU (MaDichVu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_THUONGHIEUDOLUUNIEM PRIMARY KEY (ThuongHieu)
);
-- @block 24 --
CREATE TABLE MATBANG(
    MB_MCN VARCHAR(50) NOT NULL,
    STTMatBang INT NOT NULL UNIQUE DEFAULT 1 CHECK (
        STTMatBang > 0
        AND STTMatBang < 51
    ),
    GiaThue INT NOT NULL,
    ChieuDai INT NOT NULL,
    ChieuRong INT NOT NULL,
    MoTa VARCHAR(255),
    MB_MDV VARCHAR(6) NOT NULL,
    TenCuaHang VARCHAR(255),
    CONSTRAINT FK_MB_MDV FOREIGN KEY (MB_MDV) REFERENCES DICHVU(MaDichVu) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_MB_MCN FOREIGN KEY (MB_MCN) REFERENCES CHINHANH(MaChiNhanh) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_MATBANG PRIMARY KEY (MB_MCN)
);
-- @block 25 --
CREATE TABLE HINHANHCUAHANG(
    HACH_MCN VARCHAR(50) NOT NULL,
    HACH_STTMatBang INT NOT NULL DEFAULT 1,
    HinhAnh VARCHAR(255),
    CONSTRAINT FK_HACH_MCN FOREIGN KEY (HACH_MCN) REFERENCES MATBANG(MB_MCN) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_HACH_STTMatBang FOREIGN KEY (HACH_STTMatBang) REFERENCES MATBANG(STTMatBang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_HINHANHCUAHANG PRIMARY KEY (HinhAnh)
);
-- @block 26 --
CREATE TABLE KHUNGGIOHOATDONG (
    KGHD_MCN VARCHAR(50) NOT NULL,
    KGHD_STTMatBang INT NOT NULL DEFAULT 1,
    GioBatDau TIME,
    GioKetThuc TIME,
    CONSTRAINT FK_KGHD_MCN FOREIGN KEY (KGHD_MCN) REFERENCES MATBANG(MB_MCN) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_KGHD_STTMatBang FOREIGN KEY (KGHD_STTMatBang) REFERENCES MATBANG(STTMatBang) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT PK_KHUNGGIOHOATDONG PRIMARY KEY (GioBatDau)
);