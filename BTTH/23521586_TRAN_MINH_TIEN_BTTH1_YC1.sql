create database QuanLyKhachHang;
create table SACH
(MaSach char(5) primary key,
 TenSach NVarchar(20) not null,
 TheLoai NVarchar(50) not null,
 NXB NVarchar(20)

);
create table KHACH_HANG
(
MaKH char(5) primary key,
HoTen Nvarchar(25) not null,
NgaySinh smalldatetime,
DiaChi Nvarchar(50),
SoDT Varchar(15) not null,
NgDK smalldatetime not null
);
create table PHIEUMUA
(MaPM char(5) primary key,
MaKH char(5) foreign key references KHACH_HANG(MaKH),
NgayMua smalldatetime,
SoSachMua int
);
create table CHITIET_PHIEUMUA
(MaSach char(5),
MaPM char(5),
primary key(MaSach, MaPM)
);
alter table CHITIET_PHIEUMUA add foreign key(MaSach) references SACH(MaSach);
alter table CHITIET_PHIEUMUA add foreign key(MaPM) references PHIEUMUA(MaPM);
alter table PHIEUMUA add foreign key (MaKH) references KHACHHANG(MAKH);

