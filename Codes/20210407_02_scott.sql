SELECT USER
FROM DUAL;
--==>> SCOTT

--■■■ UPDATE ■■■--

-- 1. 테이블에서 기존 데이터를 변경하는 구문.
 
-- 2. 형식 및 구조
-- UPDATE 테이블명
-- SET 컬럼명=변경할 값, 컬럼명=변경할값, ...
-- [WHERE 조건절]
 
SELECT *
FROM TBL_SAWON; 

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

--○ TBL_SAWON 테이블에서 사원번호 1003번 사원의
--   주민번호를 『8303082234567』로 수정한다.
UPDATE TBL_SAWON
SET JUBUN = '8303082234567'
WHERE SANO = 1003;

SELECT *
FROM TBL_SAWON; 

-- 실행 후 COMMIT 또는 ROLLBACK을 반드시 선택적으로 실행 
COMMIT;
--==>> 커밋 완료.

--○ TBL_SAWON 테이블에서 1005번 사원의 입사일과 급여를
--   각각 2018-02-22, 2200으로 변경한다.
UPDATE TBL_SAWON
SET HIREDATE = TO_DATE('2018-02-22', 'YYYY-MM-DD')
  , SAL = 2200
WHERE SANO = 1005;
--==>> 1 행 이(가) 업데이트되었습니다.

SELECT *
FROM TBL_SAWON; 

-- 실행 후 COMMIT 또는 ROLLBACK을 반드시 선택적으로 실행 
COMMIT;
--==>> 커밋 완료.

--○ TBL_INSA 테이블 복사(데이터만)
CREATE TABLE TBL_INSABACKUP
AS
SELECT *
FROM TBL_INSA;
--==>> Table TBL_INSABACKUP이(가) 생성되었습니다.


--○ TBL_INSABACKUP 테이블에서
--   직위가 과장과 부장만 수당 10% 인상~!!!

-- 내가 풀이한 내용
SELECT *
FROM TBL_INSABACKUP;


UPDATE TBL_INSABACKUP
SET SUDANG = SUDANG * 1.1
WHERE JIKWI IN ('과장', '부장');

ROLLBACK;

-- 함께 풀이한 내용
SELECT NAME "사원명", JIKWI "직위", SUDANG "수당", SUDANG*1.1 "10%인상된 수당"
FROM TBL_INSABACKUP
WHERE JIKWI IN ('과장', '부장');
--==>>
/*
홍길동	부장	200000	220000
이순애	부장	160000	176000
이기자	과장	150000	165000
김종서	부장	130000	143000
이상헌	과장	150000	165000
박문수	과장	165000	181500
김인수	부장	170000	187000
김영길	과장	170000	187000
정정해	과장	124000	136400
지재환	부장	160000	176000
최석규	과장	187000	205700
문길수	과장	150000	165000
허경운	부장	150000	165000
권영미	과장	104000	114400
이미경	부장	160000	176000
*/

UPDATE TBL_INSABACKUP
SET SUDANG = SUDANG * 1.1
WHERE JIKWI IN ('과장', '부장');
--==>> 15개 행 이(가) 업데이트되었습니다.

SELECT *
FROM TBL_INSABACKUP;

--○ TBL_INSABACKUP 테이블에서 전화번호가 016, 017, 018, 019 로 시작하는
--   전화번호인 경우 이를 모두 010 으로 변경한다.

-- (X) 
UPDATE TBL_INSABACKUP
SET TEL = 010
WHERE TEL IN (016, 017, 018, 019);


-- 내가 풀이한 내용 
UPDATE TBL_INSABACKUP
SET TEL = CONCAT('010',SUBSTR(TEL, 4))
WHERE SUBSTR(TEL, 1, 3) IN ('016', '017', '018', '019');
--==>> 24개 행 이(가) 업데이트되었습니다.


-- 함께 풀이한 내용
-- (수정할 내용 작성)
UPDATE TBL_INSABACKUP
SET 기존 전화번호의 앞 세자리만 '010'으로 수정하고 나머지 번호는 그대로 유지 
WHERE 전화번호의 앞 3자리가 '016', '017', '018', '019';

-- (바꿀 내용 확인)
SELECT TEL "기존전화번호" , '010' ||  SUBSTR(TEL, 4) "변경된 전화번호"
FROM TBL_INSABACKUP
WHERE SUBSTR(TEL, 1, 3) IN ('016', '017', '018', '019');

-- (업데이트 수행)
UPDATE TBL_INSABACKUP
SET TEL = '010' || SUBSTR(TEL, 4)
WHERE SUBSTR(TEL, 1, 3) IN ('016', '017', '018', '019');
--==>> 24개 행 이(가) 업데이트되었습니다.

-- (확인)
SELECT *
FROM TBL_INSABACKUP;

--○ TBL_SAWON 테이블 백업 (2021-04-07 10:00:00)
-->  이렇게 백업해두면 10시 이후로 추가된 사람은 복구되지 않는다 → 불완전 복구
CREATE TABLE TBL_SAWONBACKUP
AS
SELECT *
FROM TBL_SAWON;
--==>> Table TBL_SAWONBACKUP이(가) 생성되었습니다.
--> TBL_SAWON 테이블의 데이터들만 백업을 수행
--  즉, 다른 이름의 테이블 형태로 저장해둔 상황

--○ 확인
SELECT *
FROM TBL_SAWONBACKUP;
SELECT *
FROM TBL_SAWON;

UPDATE TBL_SAWON
SET SANAME = '이무림';
--==>> 16개 행 이(가) 업데이트되었습니다.

-- 위와 같이 UPDATE 처리 이후에 COMMIT 을 수행하였기 때문에
-- ROLLBACK 은 불가능한 상황이다.
-- 하지만, TBL_SAWONBACKUP 테이블에 데이터를 백업해 두었다.
-- SANAME 컬럼의 내용만 추출하여 '이무림' 대신 넣어줄 수 있다는 것이다. 

UPDATE TBL_SAWON
SET SANAME = '김가영'
WHERE SANO = 1001;

UPDATE TBL_SAWON
SET SANAME = '김서현'
WHERE SANO = 1002;

UPDATE TBL_SAWON
SET SANAME = '김아별'
WHERE SANO = 1003;

UPDATE TBL_SAWON
SET SANAME = TBL_SAWONBACKUP 테이블의 1004번 사원의 사원명; 

UPDATE TBL_SAWON
SET SANAME=( SELECT SANAME
             FROM TBL_SAWONBACKUP
             WHERE SANO = TBL_SAWON.SANO);
--==>> 16개 행 이(가) 업데이트되었습니다.

SELECT *
FROM TBL_SAWON;

COMMIT;
