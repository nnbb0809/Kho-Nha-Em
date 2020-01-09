/*1. Tạo cơ sở dữ liệu Sach gồm các bảng sau:
    Sach(MaS, TenS, SoLuong, Gia, MaNXB, NamXB, TenTG)
    NhaXB(MaNXB, TenNXB, DiaChi)*/
create database SACH
go 
use SACH
create table NhaXB
(
MaNXB varchar(10) primary key,
TenNXB nvarchar(50),
DiaChi nvarchar(150)
)
create table Sach
(
MaS varchar(5) not null primary key,
TenS nvarchar(50),
SoLuong int,
Gia numeric(15),
MaNXB varchar(10),
NamXB date,
TenTG nvarchar(50)
foreign key (MaNXB) references NhaXB
)
--2. Thêm mới mỗi bảng 2-3 dòng dữ liệu
insert into NhaXB values('N0001',N'NXB Kim Đồng',N'K907 NGUYỄN LƯƠNG BẰNG- QUẬN LIÊU CHIỂU- ĐÀ NẴNG')
insert into NhaXB values('N0002',N'NXB Giáo Dục',N'TỔ 27A, NẠI HIÊN ĐÔNG, SƠN TRÀ, TP. ĐÀ NẴNG')
insert into NhaXB values('N0003',N'NXB Tuổi Trẻ',N'KHỐI HẬU XÁ, TỔ 37, PHƯỜNG THANH HÀ, TP. HỘI AN, TỈNH QUẢNG NAM.')

insert into Sach values('S0001',N'Tắt đèn','5','75000','N0003','2018',N'Ngô Tất Tố')
insert into Sach values('S0002',N'Thơ Tố Hữu','15','100000','N0002','2019',N'Tố Hữu')
insert into Sach values('S0003',N'Khi người lớn Cô Đơn','8','59000','N0003','2018',N'Vũ')
--3. Viết hàm trả về tên sách nếu biết mã sách
create function B3(@TenS nvarchar(50))
returns varchar(10)
as
begin
	Declare @t varchar(10)
	set @t = (select MaS from Sach where TenS = @TenS)
	return @t
end
select dbo.B3(N'Tắt đèn')
--4. Viết hàm trả về số lượng sách của nhà xuất bản nếu biết tên nhà xuất bản
alter function B4(@TenNXB nvarchar(50))
returns int
as
begin
	Declare @t int
	set @t = (select COUNT(TenS) from NhaXB join Sach on NhaXB.MaNXB = Sach.MaNXB where TenNXB = @TenNXB)
	return @t
end
select dbo.B4(N'NXB Tuổi Trẻ')
/*5. Viết thủ tục thêm mới dữ liệu vào bảng sách như mô tả dưới đây:
Input: MaS, TenS, SoLuong, Gia, MaXB, NamXB, TenTG
Output: 0 nếu bị lỗi, 1 nếu thành công
Các bước thực hiện:
B1. Kiểm tra SoLuong có hợp lệ không (hợp lệ: SoLuong > 0). Nếu không hợp lệ, kết thúc thủ tục và trả về giá trị 0
B2: Kiểm tra MaNXB đã tồn tại trong bảng NhaXB chưa. Nếu chưa tồn tại, kết thúc thủ tục và trả về giá trị 0.
Bước 3. Thêm mới dữ liệu với các giá trị input
Bước 4. Nếu thêm mới thành công thì trả về 1, ngược lại trả về 0.*/
create proc B5 @MaS varchar(10),
			   @TenS nvarchar(50),
			   @SoLuong int,
			   @Gia numeric(15),
			   @MaNXB varchar(10),
			   @TenTG nvarchar(50),
			   @check char(1) out
as
begin
--B1:
	If @SoLuong <= 0 
	Set @check = '0'
	return
--B2: 
	Declare @dem int
	Set @dem = (Select count(*) from NhaXB where @MaNXB = MaNXB)
	if @dem is null
	set @check = '0'
		return
end
--B3 
insert into Sach values(@MaS, @TenS, @SoLuong, @Gia, @MaNXB, @TenTG)
--B4: 

--6. Khi thêm mới dữ liệu vào bảng Sach hãy đảm bảo rằng số lượng luôn lớn hơn 0.
alter trigger B6
on Sach for insert
as
begin
	Declare @SoLuong int
	set @SoLuong = (select SoLuong from inserted)
	if @SoLuong <= 0
	begin
		Print 'Error' 
		rollback
	end
end
insert into Sach values('S0004',N'fdgdfz','0','75000','N0003','2018',N'Ngô Tất Tố')