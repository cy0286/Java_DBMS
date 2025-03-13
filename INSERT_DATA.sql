-- 문법
INSERT INTO TABLE_NAME
 (COLUMN_NAME
, COLUMN_NAME)
VALUES 
 (DATA
, DATA)
;

-- 장르 TABLE에 데이터 넣기
INSERT INTO GNR
 (GNR_ID -- VARCHAR2 (20 CHAR)
, GNR_NM) -- VARCHAR2 (10 CHAR)
VALUES
 ('GR-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(1, 6, '0') -- GR-20250305-000001
, '액션')
;

INSERT INTO GNR
 (GNR_ID
, GNR_NM)
VALUES
 ('GR-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(2, 6, '0')
, '코미디')
;

INSERT INTO GNR
 (GNR_ID
, GNR_NM) 
VALUES
 ('GR-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(3, 6, '0')
, '모험')
;

INSERT INTO GNR
 (GNR_ID
, GNR_NM) 
VALUES
 ('GR-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(4, 6, '0')
, '호러')
;

INSERT INTO GNR
 (GNR_ID
, GNR_NM) 
VALUES
 ('GR-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(5, 6, '0')
, NULL)
;

INSERT INTO ACTR
 (ACTR_ID
, ACTR_NM
, ACTR_PHT)
VALUES
 ('AC-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(1, 6, '0')
, '라이언 레이놀즈'
, 'photo URL1')
;

INSERT INTO ACTR
 (ACTR_ID
, ACTR_NM
, ACTR_PHT)
VALUES
 ('AC-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(2, 6, '0')
, '조쉬 브롤린'
, 'photo URL2')
;

INSERT INTO ACTR
 (ACTR_ID
, ACTR_NM
, ACTR_PHT)
VALUES
 ('AC-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(3, 6, '0')
, '모레나 바가킨'
, 'photo URL3')
;

INSERT INTO ACTR
 (ACTR_ID
, ACTR_NM
, ACTR_PHT)
VALUES
 ('AC-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(4, 6, '0')
, '에드 스크레인'
, 'photo URL4')
;

INSERT INTO ACTR
 (ACTR_ID
, ACTR_NM
, ACTR_PHT)
VALUES
 ('AC-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(ACTR_PK_SEQ.NEXTVAL, 6, '0')
, '마동석'
, '마동석프로필사진URL')
;

-- MySQL / MariaDB -> PK(Auto Increment) Insert 할 때마다 1식 자동으로 증가
-- Oracle -> Auto Increment 속성이 없음
-- 			 -> 대신 순번을 발급 (시퀀스)
-- ex) 1. 은행 업무 - 순번표 뽑기 (1씩 증가)
--	   2. 로또(명당) - 미리 뽑아둔 것을 줌
--     3. 서비스센터 - 순번 뽑기
-- 시퀀스는 1, 2의 역할을 모두 함
-- 시퀀스를 사용할 때 주의점!
--  순번을 초기화 시킬 수 없다.
--  50번까지 뽑아놓고 다시 1번부터 시작하게 만들수가 없다.
-- 		이걸 하고 싶으면 시퀀스를 지우고 다시 만든다.

SELECT ACTR_PK_SEQ.NEXTVAL -- ACTR_PK_SEQ 순번표 기계에서 다음 번호를 뽑는다.
     , ACTR_PK_SEQ.CURRVAL -- ACTR_PK_SEQ 순번표 기계가 마지막에 뽑은 번호를 보여준다.
  FROM DUAL;

SELECT ACTR_PK_SEQ.CURRVAL
  FROM DUAL;

-- 다음 배우를 새롭게 추가한다면
-- 아이디는 무엇으로 해야할까?
-- 'AC-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(4, 6, '0') 이용함
-- 아이디는 항상 새로운 값으로 만들어야 함

INSERT INTO MV
 (MV_ID
, MV_TTL
, MV_ORGNL_TTL
, MV_SUB_TTL
, MV_LNG
, MV_RNG_TM
, MV_OPN_DT
, MV_DESC
, MV_PSTR
, MV_OPN_STTS
, MV_RTNG
, MV_CST
, MV_PRFT)
VALUES
  ('MV-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(MV_PK_SEQ.NEXTVAL, 6, '0') -- MV_ID
, '데드풀 2' -- MV_TTL
, 'Deadpool 2'-- MV_ORGNL_TTL
, NULL -- MV_SUB_TTL
, '영어' -- MV_LNG
, 117 -- MV_RNG_TM
, TO_DATE('2018-05-16', 'YYYY-MM-DD')-- MV_OPN_DT
, '암 치료를 위한 비밀 실험에 참여한 후, 강력한 힐링팩터 능력을 지닌 슈퍼히어로 데드풀로 거듭난 웨이드 윌슨은 여자친구 바네사와 더없이 행복한 시간을 보낸다. 그러나 행복도 잠시, 눈 앞에서 소중한 연인을 잃어버리고 삶의 의미를 상실하지만 자기 치유 능력 때문에 죽고 싶어도 죽지를 못한다. 밑바닥까지 내려간 데드풀은 더 나은 사람이 되기로 결심한다. 한편 미래에서 온 케이블은 러셀을 집요하게 쫓는다. 데드풀은 팀 엑스포스를 결성하고, 뭘 해도 운이 따르는 도미노가 엑스포스에 합류하는데...' -- MV_DESC
, 'DEADPOOL2 POSTER URL' -- MV_PSTR
, 'Y' -- MV_OPN_STTS
, '19' -- MV_RTNG
, 11000000 -- MV_CST
, 785896632) -- MV_PRFT
;

INSERT INTO MV
 (MV_ID
, MV_TTL
, MV_ORGNL_TTL
, MV_SUB_TTL
, MV_LNG
, MV_RNG_TM
, MV_OPN_DT
, MV_DESC
, MV_PSTR
, MV_OPN_STTS
, MV_RTNG
, MV_CST
, MV_PRFT)
VALUES
  ('MV-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(MV_PK_SEQ.NEXTVAL, 6, '0') -- MV_ID
, '데드풀' -- MV_TTL
, 'Deadpool'-- MV_ORGNL_TTL
, NULL -- MV_SUB_TTL
, '영어' -- MV_LNG
, 108 -- MV_RNG_TM
, TO_DATE('2016-02-17', 'YYYY-MM-DD')-- MV_OPN_DT
, '특수부대 요원 출신의 용병 웨이드 윌슨은 취향과 장난기마저 똑 닮은 바네사를 만나 행복한 나날을 보낸다. 하지만 행복은 광고처럼 짧은 법. 말기 암 선고를 받은 웨이드는 비밀 임상실험에 참여하며 재기를 노린다. 극한의 고문으로 이뤄진 실험 후 웨이드는 암을 치료할뿐더러 무한한 재생 능력을 얻으며 불사의 존재가 된다. 하지만 동시에 부작용으로 호러영화에 어울릴 법한 외양을 갖는다. 스스로 슈트까지 지어 입고 데드풀이 된 웨이드는 자신을 고문한 자를 찾아 제대로 복수한 뒤 당당히 바네사 앞에 나서려 한다.' -- MV_DESC
, 'DEADPOOL POSTER URL' -- MV_PSTR
, 'Y' -- MV_OPN_STTS
, '19' -- MV_RTNG
, 58000000 -- MV_CST
, 782837347) -- MV_PRFT
;

-- MV-20250305-000001 데드풀 2
-- MV-20250305-000002 데드풀
-- GR-20250305-000001 액션
-- GR-20250305-000002 코미디
-- GR-20250305-000003 모험

INSERT INTO MV_GNR
 (GNR_ID
, MV_ID)
VALUES 
 ('GR-20250305-000003'
, 'MV-20250305-000002')
;

/*
데드풀 2(MV-20250305-000001) 라이언 레이놀즈(AC-20250305-000001) Wade Wilson
데드풀 2(MV-20250305-000001) 라이언 레이놀즈(AC-20250305-000001) Deadpool
데드풀 2(MV-20250305-000001) 라이언 레이놀즈(AC-20250305-000001) Juggernaut (voice)
데드풀 2(MV-20250305-000001) 조쉬 브롤린(AC-20250305-000002) Cable
데드풀 2(MV-20250305-000001) 모레나 바가킨(AC-20250305-000003) Vanessa
데드풀 (MV-20250305-000002) 에드 스크레인(AC-20250305-000004) Ajax
데드풀 (MV-20250305-000002) 라이언 레이놀즈(AC-20250305-000001) Deadpool
데드풀 (MV-20250305-000002) 모레나 바가킨(AC-20250305-000003) Vanessa
 */

INSERT INTO CAST
 (CAST_ID
, CAST_NM
, MV_ID
, ACTR_ID)
VALUES
 ('CA-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(CAST_PK_SEQ.NEXTVAL, 6, '0') -- CAST_ID
, 'Wade Wilson'   -- CAST_NM
, 'MV-20250305-000001' -- MV_ID
, 'AC-20250305-000001') -- ACTR_ID
;

INSERT INTO CAST
 (CAST_ID
, CAST_NM
, MV_ID
, ACTR_ID)
VALUES
 ('CA-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(CAST_PK_SEQ.NEXTVAL, 6, '0') -- CAST_ID
, 'Deadpool'   -- CAST_NM
, 'MV-20250305-000001' -- MV_ID
, 'AC-20250305-000001') -- ACTR_ID
;

INSERT INTO CAST
 (CAST_ID
, CAST_NM
, MV_ID
, ACTR_ID)
VALUES
 ('CA-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(CAST_PK_SEQ.NEXTVAL, 6, '0') -- CAST_ID
, 'Juggernaut (voice)'   -- CAST_NM
, 'MV-20250305-000001' -- MV_ID
, 'AC-20250305-000001') -- ACTR_ID
;

INSERT INTO CAST
 (CAST_ID
, CAST_NM
, MV_ID
, ACTR_ID)
VALUES
 ('CA-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(CAST_PK_SEQ.NEXTVAL, 6, '0') -- CAST_ID
, 'Cable'   -- CAST_NM
, 'MV-20250305-000001' -- MV_ID
, 'AC-20250305-000002') -- ACTR_ID
;

INSERT INTO CAST
 (CAST_ID
, CAST_NM
, MV_ID
, ACTR_ID)
VALUES
 ('CA-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(CAST_PK_SEQ.NEXTVAL, 6, '0') -- CAST_ID
, 'Vanessa'   -- CAST_NM
, 'MV-20250305-000001' -- MV_ID
, 'AC-20250305-000003') -- ACTR_ID
;

INSERT INTO CAST
 (CAST_ID
, CAST_NM
, MV_ID
, ACTR_ID)
VALUES
 ('CA-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(CAST_PK_SEQ.NEXTVAL, 6, '0') -- CAST_ID
, 'Ajax'   -- CAST_NM
, 'MV-20250305-000002' -- MV_ID
, 'AC-20250305-000004') -- ACTR_ID
;

INSERT INTO CAST
 (CAST_ID
, CAST_NM
, MV_ID
, ACTR_ID)
VALUES
 ('CA-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(CAST_PK_SEQ.NEXTVAL, 6, '0') -- CAST_ID
, 'Deadpool'   -- CAST_NM
, 'MV-20250305-000002' -- MV_ID
, 'AC-20250305-000001') -- ACTR_ID
;

INSERT INTO CAST
 (CAST_ID
, CAST_NM
, MV_ID
, ACTR_ID)
VALUES
 ('CA-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(CAST_PK_SEQ.NEXTVAL, 6, '0') -- CAST_ID
, 'Vanessa'   -- CAST_NM
, 'MV-20250305-000002' -- MV_ID
, 'AC-20250305-000003') -- ACTR_ID
;

/*
 *    배우(ACTR)
 *       1
 *       |
 *       N
 *    출연(CAST)
 *       N
 *       |
 *       1
 *    영화(MV)
 *       1
 *       |
 *       N
 *    분류(MV_GNR)
 *       N
 *       |
 *       1
 *    장르(GNR) 
 * 
 */

-- 라이언 레이놀즈가 나오는 영화를 찾아봄
SELECT M.MV_TTL
     , G.GNR_ID
  FROM MV M
 INNER JOIN MV_GNR MG
    ON M.MV_ID = MG.MV_ID
 INNER JOIN GNR G
    ON MG.GNR_ID = G.GNR_ID
;

-- INSERT - 테이블에 ROW를 추가
-- UPDATE - COLUMN의 값을 수정
-- DELETE - 조건에 해당하는 모든 ROW를 물리적으로 삭제

-- 문법
UPDATE 테이블이름
   SET 값을 변경할 컬럼 = 변경할 값
     , 값을 변경할 컬럼 = 변경할 값
     , ...
; -- 테이블에 존재하는 모든 ROW의 COLUMN의 값을 수정한다.    
-- WHERE 조건이 없는 UPDATE는 쓰면 안 됨! 모든 데이터가 다 수정되기 때문임

UPDATE 테이블이름
   SET 값을 변경할 컬럼 = 변경할 값
     , ...
  WHERE 조건
; -- 테이블에서 조건에 해당하는 ROW의 컬럼의 값을 수정한다.
 
DELETE 
  FROM 삭제시킬 데이터가 있는 테이블의 이름
 WHERE 조건;

-- 배우의 프로필 사진을 갱신
UPDATE ACTR
   SET ACTR_PHT = '새로운 프로필 사진 URL'
     , ACTR_NM = '레이놀즈 라이언'
 WHERE ACTR_ID = 'AC-20250305-000001'
; 

COMMIT

ROLLBACK;

SELECT *
  FROM ACTR
;  

DELETE
  FROM ACTR
; -- 조건이 없으므로 ACTR의 모든 ROW를 삭제함  

-- 영화에 출연한적이 없는 마동석 배우를 삭제한다.
DELETE
  FROM ACTR
 WHERE ACTR_ID = 'AC-20250305-000007'
;

SELECT MV_ID
     , MV_TTL
     , MV_ORGNL_TTL
     , MV_SUB_TTL
     , MV_LNG
     , MV_RNG_TM
     /*, FLOOR(MV_RNG_TM / 60) || '시간' || MOD(MV_RNG_TM, 60) || '분'*/
     , TO_CHAR(MV_OPN_DT, 'YYYY-MM-DD') AS MV_OPN_DT
     , MV_DESC
     , MV_PSTR
     , CASE MV_OPN_STTS
        WHEN 'Y' THEN '개봉됨'
        ELSE '개봉예정'
       END AS MV_OPN_STTS
     , CASE MV_RTNG
        WHEN 'ALL' THEN '전체관람가'
        ELSE MV_RTNG || '세 이상 관람가'
       END AS MV_RTNG
     , MV_CST
     , MV_PRFT
  FROM MV;

SELECT GNR_ID
     , GNR_NM
  FROM GNR;

SELECT GNR_ID
  FROM MV_GNR
 WHERE MV_ID = 'MV-20250305-000001'

SELECT MV_ID
  FROM MV_GNR
 WHERE GNR_ID = 'GR-20250305-000001'

INSERT INTO GNR
 (GNR_ID
, GNR_NM)
VALUES
 ('GR-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(GNR_PK_SEQ.NEXTVAL, 6, '0')
, '스릴러');

SELECT *
  FROM GNR;

-- ROLLBACK을 했을 때 시퀀스 값은 돌아가지 않음
ROLLBACK;

SELECT 'MV-' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '-' || LPAD(MV_PK_SEQ.NEXTVAL, 6, '0') AS MV_ID
  FROM DUAL
;

SELECT ACTR_ID
     , ACTR_NM
     , ACTR_PHT
  FROM ACTR
 WHERE ACTR_NM = ;

SELECT CAST_ID
    , CAST_NM
    , MV_ID
    , ACTR_ID
 FROM CAST
WHERE CAST_ID = 'CA-20250305-000010';

SELECT ACTR_ID	
  FROM CAST
 WHERE CAST_ID = 'CA-20250305-000001';