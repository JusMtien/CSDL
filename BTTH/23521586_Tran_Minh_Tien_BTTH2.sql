
--1.In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất. \
select MASP, TENSP
from SANPHAM
WHERE NUOCSX= 'Trung Quoc';


select MASP,TENSP
FROM SANPHAM
WHERE NUOCSX= 'Trung Quoc'



--2.In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”. 
select * from SANPHAM
select MASP, TENSP
from SANPHAM
WHERE  DVT='cay' or DVT='quyen'; ---in( 'cay', 'quyen')



SELECT MASP,TENSP,DVT
FROM SANPHAM
WHERE DVT IN ('cay','quyen');
--3.In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết 
--thúc là “01”. 
select MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE 'B%' AND  MASP LIKE '%01'


SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE 'B%01'


--4. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 
--đến 40.000. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX='Trung Quoc' and GIA BETWEEN 30000 AND 40000
--5.In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản 
--xuất có giá từ 30.000 đến 40.000. 
(SELECT MASP, TENSP 
FROM SANPHAM
WHERE NUOCSX='Trung Quoc' and GIA between 30000 and 40000)
union
(SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX='Thai Lan' and GIA between 30000 and 40000);



select MASP, TENSP 
FROM  SANPHAM
WHERE NUOCSX='Thai Lan' AND GIA BETWEEN 30000 AND 40000
UNION
select MASP, TENSP 
FROM  SANPHAM
WHERE NUOCSX='Trung Quoc' AND GIA BETWEEN 30000 AND 40000

--6.In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007. 
SET DATEFORMAT DMY
select SOHD,TRIGIA
FROM HOADON
WHERE NGHD='1/1/2007' OR NGHD='2/1/2007';
--.7.In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và 
--trị giá của hóa đơn (giảm dần).

SELECT SOHD, NGHD,TRIGIA
FROM HOADON
WHERE month(NGHD)=1 AND YEAR(NGHD)=2007
ORDER BY NGHD ASC, TRIGIA DESC;

SELECT SOHD, TRIGIA
FROM HOADON
WHERE MONTH(NGHD)=1 AND YEAR(NGHD)=2007
ORDER BY NGHD ASC , TRIGIA DESC
--8.In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007. 
SELECT kh.MAKH, kh.HOTEN
FROM KHACHHANG kh join HOADON hd on kh.MAKH=hd.MAKH and hd.NGHD='1/1/2007';

SELECT KH.MAKH, HOTEN
FROM KHACHHANG KH JOIN HOADON HD ON KH.MAKH= HD.MAKH 
WHERE HD.NGHD='1/1/2007'

--9.In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 
--28/10/2006. 
set dateformat dmy
select hd.SOHD, hd.TRIGIA,nv.HOTEN,hd.NGHD
from NHANVIEN nv join HOADON hd on hd.MANV=nv. MANV
 where nv.HOTEN='Nguyen Van B' and hd.NGHD='28/10/2006';




--10. In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” 
--mua trong tháng 10/2006. 
select sp.MASP, TENSP
FROM SANPHAM sp JOIN CTHD ct on sp.MASP = ct.MASP
                join HOADON hd on hd.SOHD =ct.SOHD
				join KHACHHANG kh on kh.MAKH =hd.MAKH
where HOTEN ='Nguyen Van A' and year(NGHD)=2006 and month(NGHD)=10;


SELECT MASP, TENSP
FROM SANPHAM 
WHERE MASP IN 
              ( SELECT MASP 
			      FROM HOADON HD JOIN KHACHHANG KH ON HD.MAKH= KH.MAKH 
				                  JOIN CTHD CT ON CT.SOHD=HD.SOHD

				  WHERE HOTEN='Nguyen Van A' AND MONTH(NGHD)=10 AND YEAR(NGHD)=2006)
--11. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”. -- hoi/ giao / tru
select * from CTHD
--select distinct SOHD, MASP
--from CTHD
--where MASP='BB01'or MASP='BB02' -where MASP in (BB01, BBO2)
select * 
from CTHD
WHERE MASP='BB01'
UNION
SELECT * 
FROM CTHD
WHERE MASP='BB02'
--12. Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”, mỗi sản phẩm 
--mua với số lượng từ 10 đến 20. 
select distinct SOHD, MASP
from  CTHD
where MASP in ('BB01', 'BB02') and (SL between 10 and 20)

(SELECT DISTINCT SOHD, MASP
FROM CTHD 
WHERE MASP='BB01' AND SL BETWEEN 10 AND 20
)
UNION

(SELECT DISTINCT SOHD, MASP
FROM CTHD
WHERE MASP='BB02' AND SL BETWEEN 10 AND 20
)
--13. Tìm các số hóa đơn mua cùng lúc 2 sản phẩm có mã số “BB01” và “BB02”, mỗi sản 
--phẩm mua với số lượng từ 10 đến 20. 
(select SOHD
from CTHD 
Where MASP= 'BB01' and (SL between 10 and 20))
intersect --- ra nhieu de thi, xet ca hai dieu kien
(select SOHD
from CTHD
where MASP ='BB02' and (SL between 10 and 20));


(SELECT SOHD
FROM CTHD 
WHERE MASP='BB01'  AND (SL BETWEEN 10 AND 20))
INTERSECT

(SELECT SOHD 
FROM CTHD
WHERE MASP='BB02' AND (SL BETWEEN 10 AND 20))

--14. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất hoặc các sản 
--phẩm được bán ra trong ngày 1/1/2007. union-- thuong xuyen ra
select MASP, TENSP
FROM SANPHAM
WHERE MASP IN ((SELECT MASP 
FROM SANPHAM
WHERE NUOCSX='Trung Quoc')
UNION
(select MASP
from HOADON hd join CTHD ct on hd.SOHD=ct.SOHD
where NGHD='1/1/2007'))


 SELECT MASP, TENSP
 FROM SANPHAM
 WHERE MASP IN 
 (
SELECT MASP
FROM SANPHAM 
WHERE NUOCSX='Trung Quoc' 

UNION

SELECT  MASP
FROM HOADON HD JOIN CTHD CT ON HD.SOHD= CT.SOHD
WHERE HD.NGHD='1/1/2007'

)




--15. In ra danh sách các sản phẩm (MASP,TENSP) không bán được. 

select MASP, TENSP
from SANPHAM
where MASP in 
((select MASP
FROM SANPHAM)
EXCEPT
(SELECT DISTINCT ct.MASP
from CTHD ct));

SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP NOT IN 
                  ( SELECT DISTINCT MASP 
				     FROM HOADON HD JOIN CTHD CT ON CT.SOHD= HD.SOHD
					 WHERE YEAR(NGHD)=2006
				)
--16. In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006. 
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP not in ( SELECT distinct MASP
               FROM CTHD CT JOIN HOADON HD ON HD.SOHD = HD.SOHD
			   WHERE YEAR(NGHD)=2006);

--(SELECT MASP, TENSP
--FROM SANPHAM
--EXCEPT
--(SELECT 
--17. In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán 
--được trong năm 2006. 
SELECT MASP,TENSP
FROM SANPHAM
WHERE NUOCSX= 'Trung Quoc' and MASP not in ( select distinct MASP
                                              from CTHD ct join HOADON hd on ct.SOHD= hd.SOHD
											  where year( NGHD) =2006);


