###############################################################
# GÖREVLER
###############################################################


# GÖREV 1: Veriyi Anlama (Data Understanding) ve Hazırlama
           # 1. Flo verisine SQL databaseden ulaşın.
           # 2. Veri setinde
                     # a. ılk 10 gözlem,
                     # b. Değişken isimleri,
                     # c. Boş değer,
                     # d. Değişken tipleri, incelemesi yapınız.
           # 3. Omnichannel müşterilerin hem online'dan hemde offline platformlardan alışveriş yaptığını ifade etmektedir. Herbir müşterinin toplam
           # alışveriş sayısı ve harcaması için yeni değişkenler oluşturun.
           # 4. Değişken tiplerini inceleyiniz.
           # 5. Alışveriş kanallarındaki müşteri sayısının, ortalama alınan ürün sayısının ve ortalama harcamaların dağılımına bakınız.
           # 6. En fazla kazancı getiren ilk 10 müşteriyi sıralayınız.
           # 7. En fazla siparişi veren ilk 10 müşteriyi sıralayınız.

# GÖREV 2: RFM Metriklerinin Hesaplanması

# GÖREV 3: RF ve RFM Skorlarının Hesaplanması

# GÖREV 4: RF Skorlarının Segment Olarak Tanımlanması

# GÖREV 5: Aksiyon zamanı!
           # 1. Segmentlerin recency, frequnecy ve monetary ortalamalarını inceleyiniz.
           # 2. RFM analizi yardımı ile 2 case için ilgili profildeki müşterileri bulunuz.
                   # a. FLO bünyesine yeni bir kadın ayakkabı markası dahil ediyor. Dahil ettiği markanın ürün fiyatları genel müşteri tercihlerinin üstünde. Bu nedenle markanın
                   # tanıtımı ve ürün satışları için ilgilenecek profildeki müşterilerle özel olarak iletişime geçeilmek isteniliyor. Sadık müşterilerinden(champions,loyal_customers),
                   # ortalama 250 TL üzeri ve kadın kategorisinden alışveriş yapan kişiler özel olarak iletişim kuralacak müşteriler. Bu müşterilerin id numaralarını getiriniz.

                   # b. Erkek ve Çoçuk ürünlerinde %40'a yakın indirim planlanmaktadır. Bu indirimle ilgili kategorilerle ilgilenen geçmişte iyi müşteri olan ama uzun süredir
                   # alışveriş yapmayan kaybedilmemesi gereken müşteriler, uykuda olanlar ve yeni gelen müşteriler özel olarak hedef alınmak isteniliyor. Uygun profildeki müşterilerin id'lerini getiriniz.
*/







/*
###############################################################
# GÖREV 1: Veriyi  Hazırlama ve Anlama (Data Understanding)
###############################################################
#Veri setinde;
        # a. ılk 10 gözlem,
        # b. Değişken isimleri,
        # c. Boyut,
        # d. Boş değer,
        # e. Değişken tipleri, incelemesi yapınız.

*/

-- a. Ilk 10 gözlem
SELECT TOP 10 * FROM flodb.dbo.flo
;


SELECT  * FROM flodb.INFORMATION_SCHEMA.COLUMNS
;


-- b. Değişken isimleri
SELECT COLUMN_NAME AS DEGISKEN_ISIMLERI
FROM flodb.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FLO'
;


--c. Boyut
SELECT COUNT(*) AS SATIR_SAYISI , 
       (SELECT COUNT(COLUMN_NAME) AS DEGISKEN_ISIMLERI
    FROM flodb.INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'FLO') AS KOLON_SAYISI
FROM flodb.dbo.flo 
;

-- d. Boş değer
SELECT * FROM flodb.dbo.flo WHERE master_id IS NULL;
SELECT * FROM flodb.dbo.flo WHERE order_channel IS NULL;
SELECT * FROM flodb.dbo.flo WHERE last_order_channel IS NULL;
SELECT * FROM flodb.dbo.flo WHERE first_order_date IS NULL;
SELECT * FROM flodb.dbo.flo WHERE last_order_date IS NULL;
SELECT * FROM flodb.dbo.flo WHERE last_order_date_online IS NULL;
SELECT * FROM flodb.dbo.flo WHERE last_order_date_offline IS NULL;
SELECT * FROM flodb.dbo.flo WHERE order_num_total_ever_online IS NULL;
SELECT * FROM flodb.dbo.flo WHERE order_num_total_ever_offline IS NULL;
SELECT * FROM flodb.dbo.flo WHERE customer_value_total_ever_offline IS NULL;
SELECT * FROM flodb.dbo.flo WHERE customer_value_total_ever_online IS NULL;
SELECT * FROM flodb.dbo.flo WHERE interested_in_categories_12 IS NULL;
--SELECT * FROM flodb.dbo.flo WHERE store_type IS NULL;


-- e. Değişken tipleri incelemesi
SELECT COLUMN_NAME, DATA_TYPE 
FROM flodb.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FLO'
;


-- e. Kısıtlı Databaseden, Playground da tablo olusturma
SELECT * FROM flodb.dbo.flo

SELECT *
INTO flo
FROM flodb.dbo.flo

-- WHERE 1 = 0;  -- Bu koşul hiçbir satırın seçilmemesini sağlar, sadece yapısı kopyalanır
SELECT * FROM flo


-- 3. Omnichannel müşterilerin hem online'dan hemde offline platformlardan alışveriş yaptığını ifade etmektedir.
-- Herbir müşterinin toplam alışveriş sayısı ve harcaması için yeni değişkenler oluşturun.
ALTER TABLE flo ADD order_num_total AS (order_num_total_ever_online + order_num_total_ever_offline);
SELECT * FROM flo

ALTER TABLE flo ADD customer_value_total AS (customer_value_total_ever_offline + customer_value_total_ever_online);
SELECT * FROM flo




-- 4. Alışveriş kanallarındaki müşteri sayısının, ortalama alınan ürün sayısının ve ortalama harcamaların dağılımına bakınız.
SELECT order_channel, 
       COUNT(master_id) AS COUNT_MASTER_ID, 
     ROUND(AVG(order_num_total), 0) AS AVG_ORDER_NUM_TOTAL, 
     ROUND(AVG(customer_value_total), 0) AS AVG_CUSTOMER_VALUE_TOTAL 
FROM flo
GROUP BY order_channel;


-- # 6. En fazla kazancı getiren ilk 10 müşteriyi sıralayınız.
SELECT TOP 10 * FROM flo ORDER BY customer_value_total DESC;

-- # 7. En fazla siparişi veren ilk 10 müşteriyi sıralayınız.
SELECT TOP 10 * FROM flo ORDER BY order_num_total DESC;




/*
###############################################################
# GÖREV 2: RFM Metriklerinin Hesaplanması
###############################################################
*/

-- # Veri setindeki en son alışverişin yapıldığı tarihten 2 gün sonrasını analiz tarihi olarak alınacaktır.
-- 2021-05-30 max tarihtir.
SELECT MAX(last_order_date) AS MAX_SON_ALISVERIS_TARIHI FROM flo;

-- analysis_date = (2021,6,1)
-- customer_id, recency, frequnecy ve monetary değerlerinin yer aldığı yeni bir rfm adında tablo oluşturunuz.
SELECT master_id AS CUSTOMER_ID,
       DATEDIFF(DAY, last_order_date, '20210601') AS RECENCY,
     order_num_total AS FREQUENCY,
     customer_value_total AS MONETARY,
     NULL RECENCY_SCORE,
     NULL FREQUENCY_SCORE,
     NULL MONETARY_SCORE
INTO RFM
FROM flo
;

-- Recency, Frequency ve Monetary değerlerinin incelenmesi
SELECT * FROM RFM;

/*
###############################################################
# GÖREV 3: RF ve RFM Skorlarının Hesaplanması (Calculating RF and RFM Scores)
###############################################################
#  Recency, Frequency ve Monetary metriklerinin 1-5 arasında skorlara çevrilmesi ve
# Bu skorları recency_score, frequency_score ve monetary_score olarak kaydedilmesi
*/

-- RECENCY_SCORE Oluşturulması
UPDATE RFM SET RECENCY_SCORE = 
(SELECT SCORE FROM
(SELECT A.*,
        NTILE(5) OVER(ORDER BY Recency DESC) SCORE
FROM RFM AS A
) T 
WHERE T.Customer_ID = RFM.Customer_ID
);

SELECT * FROM RFM

-- FREQUENCY_SCORE Oluşturulması
UPDATE RFM SET FREQUENCY_SCORE = 
(SELECT SCORE FROM
(SELECT A.*,
        NTILE(5) OVER(ORDER BY Frequency) AS SCORE
FROM RFM AS A
) T 
WHERE T.Customer_ID = RFM.Customer_ID
);

SELECT * FROM RFM

-- MONETARY_SCORE Oluşturulması
UPDATE RFM SET MONETARY_SCORE = 
(SELECT SCORE FROM
(SELECT A.*,
        NTILE(5) OVER(ORDER BY Monetary) AS SCORE
FROM RFM AS A
) T 
WHERE T.Customer_ID = RFM.Customer_ID
);



-- Oluşan skorların incelenmesi
SELECT * FROM RFM;

-- # RECENCY_SCORE ve FREQUENCY_SCORE’u tek bir değişken olarak ifade edilmesi ve RF_SCORE olarak kaydedilmesi
ALTER TABLE RFM ADD RF_SCORE AS (CONVERT(VARCHAR,RECENCY_SCORE) + CONVERT(VARCHAR,FREQUENCY_SCORE));

SELECT * FROM RFM;

-- # RECENCY_SCORE ve FREQUENCY_SCORE ve MONETARY_SCORE'u tek bir değişken olarak ifade edilmesi ve RFM_SCORE olarak kaydedilmesi
ALTER TABLE RFM ADD RFM_SCORE AS (CONVERT(VARCHAR,RECENCY_SCORE) + CONVERT(VARCHAR,FREQUENCY_SCORE) + CONVERT(VARCHAR, MONETARY_SCORE));


-- Son duruma göz atılması
SELECT * FROM RFM;

/*
###############################################################
# GÖREV 4: RF Skorlarının Segment Olarak Tanımlanması
###############################################################
# Oluşturulan RFM skorların daha açıklanabilir olması için segment tanımlama ve RF_SCORE'u segmentlere çevirme
*/

-- sEGMENT adında yeni bir kolon oluşturma
ALTER TABLE RFM ADD SEGMENT VARCHAR(50);

-- Hibernating sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='hibernating'
WHERE RECENCY_SCORE LIKE '[1-2]%' AND FREQUENCY_SCORE LIKE '[1-2]%'

SELECT * FROM RFM;

-- at Risk sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='at_Risk'
WHERE RECENCY_SCORE LIKE '[1-2]%' AND FREQUENCY_SCORE LIKE '[3-4]%'

-- Can't Loose sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='cant_loose'
WHERE RECENCY_SCORE LIKE '[1-2]%' AND FREQUENCY_SCORE LIKE '[5]%'

-- About to Sleep sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='about_to_sleep'
WHERE RECENCY_SCORE LIKE '[3]%' AND FREQUENCY_SCORE LIKE '[1-2]%'

-- Need Attention sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='need_attention'
WHERE RECENCY_SCORE LIKE '[3]%' AND FREQUENCY_SCORE LIKE '[3]%'

-- Loyal Customers sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='loyal_customers'
WHERE RECENCY_SCORE LIKE '[3-4]%' AND FREQUENCY_SCORE LIKE '[4-5]%'

-- Promising sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='promising'
WHERE RECENCY_SCORE LIKE '[4]%' AND FREQUENCY_SCORE LIKE '[1]%'

-- New Customers sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='new_customers'
WHERE RECENCY_SCORE LIKE '[5]%' AND FREQUENCY_SCORE LIKE '[1]%'

-- Potential Loyalist sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='potential_loyalists'
WHERE RECENCY_SCORE LIKE '[4-5]%' AND FREQUENCY_SCORE LIKE '[2-3]%'

-- Champions sınıfının oluşturulması
UPDATE RFM SET SEGMENT ='champions'
WHERE RECENCY_SCORE LIKE '[5]%' AND FREQUENCY_SCORE LIKE '[4-5]%'

SELECT RFM_SCORE, SEGMENT FROM RFM;

/*
###############################################################
# GÖREV 5: Aksiyon zamanı!
###############################################################
# 1. Segmentlerin recency, frequnecy ve monetary ortalamalarını inceleyiniz.
*/

SELECT SEGMENT,
       COUNT(RECENCY) AS COUNT_RECENCY,
     AVG(RECENCY) AS AVG_RECENCY,
     COUNT(FREQUENCY) AS COUNT_FREQUENCY,
     ROUND(AVG(FREQUENCY),3) AS AVG_FREQUENCY,
     COUNT(MONETARY) AS COUNT_MONETARY,
     ROUND(AVG(MONETARY),3) AS AVG_MONETARY
FROM RFM
GROUP BY SEGMENT
;

/*
# 2. RFM analizi yardımı ile 2 case için ilgili profildeki müşterileri bulunuz.

# a. FLO bünyesine yeni bir kadın ayakkabı markası dahil ediyor. Dahil ettiği markanın ürün fiyatları genel müşteri tercihlerinin üstünde. Bu nedenle markanın
# tanıtımı ve ürün satışları için ilgilenecek profildeki müşterilerle özel olarak iletişime geçilmek isteniliyor. Bu müşterilerin sadık, ortalama 250 TL üzeri ve
# kadın kategorisinden alışveriş yapan kişiler olması planlandı. Müşterilerin id numaralarını getiriniz.

*/

(SELECT A.CUSTOMER_ID, B.interested_in_categories_12  
FROM RFM AS A,
     flo AS B 
WHERE  A.CUSTOMER_ID = B.master_id
AND A.SEGMENT IN ('champions', 'loyal_customers')
AND (B.customer_value_total / B.order_num_total) > 250
AND B.interested_in_categories_12 LIKE '%KADIN%'
)
;


/*
# b. Erkek ve Çoçuk ürünlerinde %40'a yakın indirim planlanmaktadır. Bu indirimle ilgili kategorilerle ilgilenen geçmişte iyi müşterilerden olan ama uzun süredir
# alışveriş yapmayan ve yeni gelen müşteriler özel olarak hedef alınmak isteniliyor. Uygun profildeki müşterilerin id'lerini getiriniz.
*/

(SELECT A.CUSTOMER_ID, B.interested_in_categories_12  
FROM RFM AS A,
     flo AS B 
WHERE  A.CUSTOMER_ID = B.master_id
AND A.SEGMENT IN ('cant_loose', 'hibernating', 'new_customers')
AND B.interested_in_categories_12 LIKE '%ERKEK%' OR B.interested_in_categories_12 LIKE '%COCUK%'
)
;
