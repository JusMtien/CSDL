--18. Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
--B1:HOADON( tim, xuat, truy van... bang 1)
--B2: da mua tat ca san pham (SANPHAM)
--B3: CTHD( ket bang 1, bang 2)
select hd.SOHD
from HOADON hd join CTHD ct on hd.SOHD= ct.SOHD--
                join SANPHAM sp on sp.MASP =ct. MASP-- phep ket
where NUOCSX = 'Singapore'-- dieu khien
group by hd.SOHD-- di dem trong cthd co bao nhieu san pham trong do singapore sx
having count( distinct ct.MASP) =(select count(MASP) 
                                        from SANPHAM
										where NUOCSX = 'Singapore');


--select not exist
   select SOHD
   from HOADON hd
   where not exists (select * 
                            from SANPHAM sp
							where NUOCSX ='Singapore' and not exists (select *
							                                           from  CTHD ct
																	   where ct.MASP =sp.MASP
																	   and ct.SOHD =hd.SOHD))

select  SOHD
FROM HOADON HD
WHERE NOT EXISTS (
				 SELECT * 
				 FROM SANPHAM SP
				 WHERE NUOCSX='Singapore'
			      AND NOT EXISTS (
									SELECT *
									FROM CTHD CT
									WHERE CT.MASP= SP.MASP AND
									       CT.SOHD=HD.SOHD
										   ))


--19. Tìm số hóa đơn trong năm 2006 đã mua  tất cả các sản phẩm do Singapore sản
--xuất.
select hd.SOHD
from HOADON hd join CTHD ct on hd.SOHD =ct.SOHD
               join SANPHAM sp on  sp.MASP = ct.MASP

where sp.NUOCSX='Singapore' and year(hd.NGHD)='2006'
group by hd.SOHD
having count ( distinct ct.MASP)= (select count( MASP)
                                             from SANPHAM
											 where NUOCSX='Singapore');

SELECT SOHD
FROM HOADON HD
WHERE YEAR(NGHD)=2006 AND NOT EXISTS 
				( SELECT * 
				   FROM SANPHAM SP
				   WHERE NUOCSX='Singapore'
				   AND NOT EXISTS (	
									SELECT * 
									FROM CTHD CT
									WHERE  CT.MASP=SP.MASP AND CT.SOHD=HD.SOHD))

--20. Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
select count(*) as SoLuong
from HOADON hd
where hd.MAKH is null;


SELECT COUNT(*) AS SO_LUONG
FROM HOADON 
WHERE MAKH IS NULL
--21. Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
select count( distinct MASP) as SoLuong
from CTHD ct join HOADON hd on ct.SOHD= hd.SOHD
where year(NGHD)=2006;


SELECT COUNT( DISTINCT MASP) AS SO_LUONG
FROM CTHD CT JOIN HOADON HD ON CT.SOHD= HD.SOHD
WHERE YEAR( NGHD)=2006

--22. Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
select min(TRIGIA)as ThapNhat, max(TRIGIA)as CaoNhat
from HOADON


SELECT MAX(TRIGIA) AS CAO_NHAT, MIN(TRIGIA) AS THAP_NHAT
FROM HOADON

--23. Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
select avg(TRIGIA)
from HOADON
where year(NGHD)=2006
SELECT AVG(TRIGIA) AS TRI_GIA_TB
FROM HOADON
WHERE YEAR(NGHD)=2006

--24. Tính doanh thu bán hàng trong năm 2006.
select sum( TRIGIA)
from HOADON
where year(NGHD) =2006;

SELECT SUM(TRIGIA) AS DOANH_THU
FROM HOADON
WHERE YEAR(NGHD)=2006
--25. Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
 select SOHD
 from HOADON hd
  where year(NGHD)=2006 and	
						   TRIGIA= (select max(TRIGIA) 
									from HOADON)

SELECT TOP 1 SOHD
FROM HOADON
WHERE YEAR(NGHD)=2006
ORDER BY TRIGIA DESC

--select top1 																	
select top 1 with ties SOHD 
from HOADON
where year(NGHD) =2006 
order by TRIGIA DESC

--26. Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
select HOTEN
from KHACHHANG kh join HOADON hd on kh.MAKH= hd.MAKH
where year(hd.NGHD)=2006 and TRIGIA= (select max(TRIGIA)
											from HOADON hd);
SELECT TOP 1 WITH TIES KH.HOTEN, KH.MAKH
FROM KHACHHANG KH JOIN HOADON HD ON KH.MAKH=HD.MAKH
WHERE YEAR( NGHD)=2006 
ORDER BY TRIGIA DESC
											
--27. In ra danh sách 3 khách hàng đầu tiên (MAKH, HOTEN) sắp xếp theo doanh số giảm
--dần.
--
SELECT TOP 3 MaKH, HoTen
FROM KHACHHANG
ORDER BY DoanhSo DESC;


 SELECT TOP 3 MAKH, HOTEN
 FROM KHACHHANG 
 ORDER BY DOANHSO DESC

--28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao
--nhất.
select MASP, TENSP
from SANPHAM
where GIA = any( select distinct top 3 GIA
						from SANPHAM
						order by GIA DESC)
SELECT MASP, TENSP
FROM SANPHAM
WHERE GIA IN (
    SELECT DISTINCT TOP 3 GIA
    FROM SANPHAM
    ORDER BY GIA DESC
)


--29. In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1
--trong 3 mức giá cao nhất (của tất cả các sản phẩm).
select MASP, TENSP
from SANPHAM
where NUOCSX='Thai Lan' and GIA= any (select distinct top 3 GIA	
											from SANPHAM
											order by GIA DESC)

SELECT MASP, TENSP
FROM SANPHAM 
WHERE NUOCSX='Thai Lan' AND GIA IN ( SELECT DISTINCT TOP 3 GIA FROM SANPHAM ORDER BY GIA DESC)
--30. In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1
--trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
select MASP, TENSP
from SANPHAM
where NUOCSX= 'Trung Quoc' and 
                              GIA= any (select top 3 GIA
										from SANPHAM
										where NUOCSX='Trung Quoc' 
										order by GIA DESC);	
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX='Trung Quoc' AND GIA IN ( SELECT DISTINCT TOP 3 GIA FROM SANPHAM WHERE NUOCSX='Trung Quoc' ORDER BY GIA DESC)
--31. * In ra danh sách khách hàng nằm trong 3 hạng cao nhất (xếp hạng theo doanh số)
select MAKH, HOTEN
from KHACHHANG
where DOANHSO= any (select distinct top 3 DOANHSO
						from KHACHHANG
						order by DOANHSO desc);


--32. Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
select count(MASP) as Tong
from SANPHAM
where NUOCSX='Trung Quoc' 
select COUNT(MASP) AS TONGSO
FROM SANPHAM
WHERE NUOCSX='Trung Quoc'

--33. Tính tổng số sản phẩm của từng nước sản xuất.
select NUOCSX, count(*) as TONG
from SANPHAM
group by NUOCSX;

SELECT NUOCSX, COUNT(*) AS SO_LUONG
FROM SANPHAM
GROUP BY NUOCSX
--34. Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
select NUOCSX, max(GIA) as GiaCao, min(GIA) as GiaThap, avg(GIA) as GiaTB
from SANPHAM
group by NUOCSX


SELECT NUOCSX, MAX(GIA) AS CAO_NHAT, MIN(GIA) AS THAP_NHAT, AVG(GIA) AS TB
FROM SANPHAM
GROUP BY NUOCSX

--35. Tính doanh thu bán hàng mỗi ngày.
select NGHD, sum(TRIGIA) as DoanhThu
from HOADON
group by NGHD;

SELECT DAY(NGHD), SUM(TRIGIA) AS DOANHTHU
FROM HOADON
GROUP BY DAY(NGHD)
--36. Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
select MASP, sum(SL) as Tong
from CTHD ct join HOADON hd on ct.SOHD =hd.SOHD
where month(NGHD)=10 and year(NGHD)= 2006
group by MASP;

SELECT SUM( SL) AS TONGSL, MASP
FROM HOADON HD JOIN CTHD CT ON CT.SOHD= HD.SOHD
WHERE MONTH(NGHD)=10 AND YEAR(NGHD)=2006
GROUP BY MASP

--37. Tính doanh thu bán hàng của từng tháng trong năm 2006.
select month(NGHD) as Thang,sum(TRIGIA) as DoanhThu
from HOADON
where year(NGHD)= 2006
group by month(NGHD) 


SELECT MONTH(NGHD) AS THANG, SUM(TRIGIA) AS DOANTHU
FROM HOADON 
WHERE YEAR(NGHD)=2006
GROUP BY MONTH(NGHD)

--38. Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
select SOHD, count (MASP) as SoLuong
from CTHD 
group by SOHD
having count( MASP)>=4;



SELECT HD.SOHD, COUNT(MASP)
FROM HOADON HD JOIN CTHD CT ON CT.SOHD=HD.SOHD

GROUP BY HD.SOHD
HAVING COUNT(MASP)>=4

--39. Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
select SOHD, count(ct.MASP) as SoLuong
from SANPHAM sp join CTHD ct on sp.MASP= ct.MASP
where NUOCSX='Viet Nam'
group by SOHD
having count (ct.MASP)>=3;


SELECT CT.SOHD, COUNT(DISTINCT CT.MASP)
FROM CTHD CT JOIN SANPHAM SP ON CT.MASP=SP.MASP
WHERE NUOCSX='Viet Nam'
GROUP BY SOHD
HAVING COUNT(DISTINCT CT.MASP) =3






--40. Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
select top 1 with ties hd.MAKH, HOTEN, count(hd.MAKH) as SoLan
from KHACHHANG kh join HOADON hd on kh.MAKH =hd.MAKH
group by hd.MAKH, HOTEN
order by SoLan DESC

SELECT TOP 1 WITH TIES KH.MAKH, HOTEN
FROM KHACHHANG KH JOIN HOADON HD ON HD.MAKH= KH.MAKH
GROUP BY KH.MAKH, HOTEN
ORDER BY COUNT(HD.MAKH) DESC



--41. Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT TOP 1 WITH TIES MONTH(NGHD) AS THANG, YEAR(NGHD) AS NAM,SUM(TRIGIA) AS DOANHSO
FROM HOADON
WHERE YEAR( NGHD)=2006 
GROUP BY MONTH(NGHD),YEAR(NGHD)
ORDER BY DOANHSO DESC;


SELECT TOP 1 WITH TIES MONTH(NGHD), SUM(TRIGIA) AS DOANH_THU
FROM HOADON HD 
WHERE YEAR(NGHD)=2006 
GROUP BY MONTH(NGHD)
ORDER BY SUM(TRIGIA) DESC


--42. Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT TOP 1 WITH TIES ct.MASP, TENSP, SUM(SL) AS SOLUONGBANRA
FROM SANPHAM sp JOIN CTHD ct ON sp.MASP=ct.MASP
				JOIN HOADON  hd ON hd.SOHD =ct.SOHD
WHERE YEAR(NGHD)=2006
GROUP BY ct.MASP, TENSP
ORDER BY SOLUONGBANRA ASC


SELECT TOP 1 WITH TIES SP.MASP, TENSP, SUM(SL) AS SL
FROM  CTHD CT JOIN SANPHAM SP ON SP.MASP=CT.MASP
				JOIN HOADON HD ON HD.SOHD=CT.SOHD
WHERE YEAR(NGHD)=2006
GROUP BY SP.MASP, TENSP
ORDER BY SUM(SL) ASC


--43. *Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT NUOCSX,MASP,TENSP,GIA
FROM SANPHAM sp1
WHERE GIA IN (SELECT MAX(GIA)
						FROM SANPHAM sp2
						WHERE sp1.NUOCSX =sp2.NUOCSX);


SELECT MASP,TENSP, NUOCSX, GIA
FROM SANPHAM SP1
WHERE GIA IN ( SELECT MAX(GIA)
				FROM SANPHAM  SP2
				WHERE SP1.NUOCSX= SP2.NUOCSX)





--44. Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
select NUOCSX, count( distinct GIA) as MucGia, count(MASP) as SoSP
from SANPHAM
group by NUOCSX
having count(distinct GIA)>=3 and count( MASP)>=3




SELECT NUOCSX, COUNT( DISTINCT GIA) AS GIA
FROM SANPHAM
GROUP BY NUOCSX
HAVING COUNT(DISTINCT GIA) >=3 AND COUNT(DISTINCT MASP) >=3
--45. *Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều NHAT).

SELECT TOP 1 WITH TIES kh.MAKH, kh.HOTEN, COUNT(hd.MAKH) AS SOLAN
FROM KHACHHANG kh JOIN HOADON hd ON kh.MAKH =hd.MAKH
WHERE KH.MAKH IN (



SELECT TOP 10 WITH TIES MAKH, DOANHSO -- 10 KHACH HANG CO DOANH SO CAO NHAT
FROM KHACHHANG
ORDER BY DOANHSO DESC)
GROUP BY kh.MAKH, HOTEN
ORDER BY SOLAN DESC




SELECT TOP 1 WITH TIES KH.MAKH, KH.HOTEN
FROM KHACHHANG KH JOIN HOADON HD ON KH.MAKH=HD.MAKH
WHERE KH.MAKH IN (

SELECT TOP 10 WITH TIES MAKH
FROM KHACHHANG 

ORDER BY DOANHSO DESC
)
GROUP BY KH.MAKH, KH.HOTEN
ORDER BY COUNT(KH.MAKH) DESC

