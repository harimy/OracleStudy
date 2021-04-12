SELECT USER
FROM DUAL;
--==>> SCOTT


SELECT *
FROM TBL_입고;
--==>>
/*
1	H001	21/04/09	20	400
2	H002	21/04/09	30	500
3	H003	21/04/09	40	600
4	H004	21/04/09	50	700
5	H005	21/04/09	60	800
6	H006	21/04/09	70	900
7	H007	21/04/09	80	1000
8	C001	21/04/09	30	800
9	C002	21/04/09	40	900
10	C003	21/04/09	50	1000
11	C004	21/04/09	60	1100
12	C005	21/04/09	70	1200
13	C006	21/04/09	80	1300
14	C007	21/04/09	90	1400
15	E001	21/04/09	80	990
16	E002	21/04/09	70	880
17	E003	21/04/09	60	770
18	E004	21/04/09	50	660
19	E005	21/04/09	40	550
20	E006	21/04/09	30	440
21	E007	21/04/09	20	330
*/

SELECT *
FROM TBL_출고;
--==>>
/*
1	H001	21/04/09	1	1100
2	H002	21/04/09	2	1200
3	H003	21/04/09	3	1300
4	H004	21/04/09	4	1400
5	H005	21/04/09	5	1500
6	H006	21/04/09	6	1600
7	H007	21/04/09	7	1700
8	C001	21/04/09	2	1900
9	C002	21/04/09	3	1910
10	C003	21/04/09	4	1920
11	C004	21/04/09	5	1930
12	C005	21/04/09	6	1940
13	C006	21/04/09	7	1950
14	C007	21/04/09	8	1960
*/

SELECT *
FROM TBL_상품;
--==>>
/*
H001	홈런볼	1500	19
H002	새우깡	1200	28
H003	자갈치	1000	37
H004	감자깡	 900	46
H005	꼬깔콘	1100	55
H006	꼬북칩	2000	64
H007	맛동산	1700	73
C001	다이제	2000	28
C002	사브레	1800	37
C003	에이스	1700	46
C004	버터링	1900	55
C005	아이비	1700	64
C006	웨하스	1200	73
C007	오레오	1900	82
E001	엠엔엠	 600	80
E002	아폴로	 500	70
E003	쫀드기	 300	60
E004	비틀즈	 600	50
E005	마이쮸	 800	40
E006	에그몽	 900	30
E007	차카니	 900	20
*/

--○ 생성된 프로시저(PRC_출고_UPDATE) 정상 작동 여부 확인
--   → 프로시저 호출 
--   『재고19 / 출고1』인 홈런볼 출고내역 변경
EXEC PRC_출고_UPDATE(1, 21);
--==>> 에러 발생
/*
ORA-20002: 재고 부족~!!!
*/

EXEC PRC_출고_UPDATE(1, 20);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0

SELECT *
FROM TBL_출고;
--==>> 1	H001	21/04/09	20	1100



-- 내가 풀이한 내용
--○ 생성된 프로시저(PRC_입고_UPDATE) 정상 작동 여부 확인
--   → 프로시저 호출 
--   『입고20 / 재고0』인 홈런볼 출고내역 변경
EXEC PRC_입고_UPDATE(1, 1);
--==>> 에러 발생
/*
ORA-20002: 재고 부족~!!!
*/

--   → 프로시저 호출 
--   『입고20 / 재고0』인 홈런볼 입고내역 변경
EXEC PRC_입고_UPDATE(1, 25);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	5

SELECT *
FROM TBL_입고;
--==>> 1	H001	21/04/09	25	400

-- 입고는 20 → 25 로 변경되었고,
-- 재고는 0 → 5 로 변경되었다.

--   → 프로시저 호출 
--   테스트 전 상태로 데이터 되돌림
EXEC PRC_입고_UPDATE(1, 20);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0

SELECT *
FROM TBL_입고;
--==>> 1	H001	21/04/09	20	400



-- 내가 풀이한 내용
--○ 생성된 프로시저(PRC_출고_DELETE) 정상 작동 여부 확인
SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0

SELECT *
FROM TBL_출고;
--==>> 1	H001	21/04/09	20	1100

--   → 프로시저 호출 
--   『출고20 / 재고0』인 홈런볼 출고내역 삭제
EXEC PRC_출고_DELETE(1);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	20

SELECT *
FROM TBL_출고;
--==>>
/*
2	H002	21/04/09	2	1200
3	H003	21/04/09	3	1300
4	H004	21/04/09	4	1400
5	H005	21/04/09	5	1500
6	H006	21/04/09	6	1600
7	H007	21/04/09	7	1700
8	C001	21/04/09	2	1900
9	C002	21/04/09	3	1910
10	C003	21/04/09	4	1920
11	C004	21/04/09	5	1930
12	C005	21/04/09	6	1940
13	C006	21/04/09	7	1950
14	C007	21/04/09	8	1960
*/
--> H001에 대한 출고내역 사라짐

-- 데이터 되돌림
ROLLBACK;


--○ 생성된 프로시저(PRC_입고_DELETE) 정상 작동 여부 확인
-- 내가 풀이한 내용

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0

SELECT *
FROM TBL_입고;
--==>> 1	H001	21/04/09	20	400

--   → 프로시저 호출 
--   『입고20 / 재고0』인 홈런볼 출고내역 삭제
EXEC PRC_입고_DELETE(1);
--==>> 에러 발생
/*
ORA-20002: 재고 부족~!!!
*/
--> 재고가 0인 상태에서 입고20 만큼을 삭제하려고 하면
--  남은 재고가 -20인 음수값으로 떨어지기 때문에 에러가 발생함

--   → 프로시저 호출 
--   『재고20 / 입고20』인 차카니 입고내역 삭제
EXEC PRC_입고_DELETE(21);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> E007	차카니	900	0

SELECT *
FROM TBL_입고;
--==>> 
/*
1	H001	21/04/09	20	400
2	H002	21/04/09	30	500
3	H003	21/04/09	40	600
4	H004	21/04/09	50	700
5	H005	21/04/09	60	800
6	H006	21/04/09	70	900
7	H007	21/04/09	80	1000
8	C001	21/04/09	30	800
9	C002	21/04/09	40	900
10	C003	21/04/09	50	1000
11	C004	21/04/09	60	1100
12	C005	21/04/09	70	1200
13	C006	21/04/09	80	1300
14	C007	21/04/09	90	1400
15	E001	21/04/09	80	990
16	E002	21/04/09	70	880
17	E003	21/04/09	60	770
18	E004	21/04/09	50	660
19	E005	21/04/09	40	550
20	E006	21/04/09	30	440
*/
--> 입고번호가 21번인 차카니에 대한 입고 내역이 삭제되었음 


--------------------------------------------------------------------------------
--○ 트리거 실습 관련 테이블 생성(TBL_TEST1)
CREATE TABLE TBL_TEST1
( ID    NUMBER
, NAME  VARCHAR2(30)
, TEL   VARCHAR2(60)
);
--==>> Table TBL_TEST1이(가) 생성되었습니다.


--○ 생성된 테이블에 제약조건 추가
ALTER TABLE TBL_TEST1
ADD CONSTRAINT TEST1_ID_PK PRIMARY KEY(ID);
--==>> Table TBL_TEST1이(가) 변경되었습니다.


--○ 트리거 실습 관련 테이블 생성(TBL_TEST1)
CREATE TABLE TBL_EVENTLOG
( MEMO  VARCHAR2(200)
, ILJA  DATE DEFAULT SYSDATE
);
--==>> Table TBL_EVENTLOG이(가) 생성되었습니다.

SELECT *
FROM TBL_TEST1;
--==>> 조회 결과 없음

SELECT *
FROM TBL_EVENTLOG;
--==>> 조회 결과 없음 


--○ 날짜 세션 정보 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.


--○ TBL_TEST1 테이블에 데이터 입력
INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(1, '김가영', '010-1111-1111');
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(2, '김서현', '010-2222-2222');
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(3, '이유림', '010-3333-3333');
--==>> 1 행 이(가) 삽입되었습니다.


--○ TBL_TEST1 테이블의 데이터 수정
UPDATE TBL_TEST1
SET NAME = '김나영'
WHERE ID = 1;
--==>> 1 행 이(가) 업데이트되었습니다.

UPDATE TBL_TEST1
SET NAME = '김다영'
WHERE ID = 1;
--==>> 1 행 이(가) 업데이트되었습니다.

UPDATE TBL_TEST1
SET NAME = '김동현'
WHERE ID = 2;
--==>> 1 행 이(가) 업데이트되었습니다.


--○ TBL_TEST1 테이블의 데이터 삭제
DELETE
FROM TBL_TEST1
WHERE ID = 3;
--==>> 1 행 이(가) 삭제되었습니다.

DELETE
FROM TBL_TEST1
WHERE ID = 2;
--==>> 1 행 이(가) 삭제되었습니다.

DELETE
FROM TBL_TEST1
WHERE ID = 1;
--==>> 1 행 이(가) 삭제되었습니다.


--○ 확인
SELECT *
FROM TBL_TEST1;
--==>> 조회 결과 없음


--○ TBL_EVENTLOG 테이블 조회
SELECT *
FROM TBL_EVENTLOG;
--==>>
/*
MEMO	                        ILJA
INSERT 쿼리문이 수행되었습니다.	2021-04-12 15:22:05
INSERT 쿼리문이 수행되었습니다.	2021-04-12 15:22:50
INSERT 쿼리문이 수행되었습니다.	2021-04-12 15:23:11
UPDATE 쿼리문이 수행되었습니다.	2021-04-12 15:23:52
UPDATE 쿼리문이 수행되었습니다.	2021-04-12 15:24:02
UPDATE 쿼리문이 수행되었습니다.	2021-04-12 15:24:26
DELETE 쿼리문이 수행되었습니다.	2021-04-12 15:25:15
DELETE 쿼리문이 수행되었습니다.	2021-04-12 15:25:30
DELETE 쿼리문이 수행되었습니다.	2021-04-12 15:25:49
*/


--○ 오라클 서버의 시간이 16:03인 상태로 테스트
INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(4, '박민지', '010-4444-4444');
--==>> 1 행 이(가) 삽입되었습니다.

UPDATE TBL_TEST1
SET TEL = '010-4141-4141'
WHERE ID=4;
--==>> 1 행 이(가) 업데이트되었습니다.

DELETE
FROM TBL_TEST1
WHERE ID = 4;
--==>> 1 행 이(가) 삭제되었습니다.


--○ BEFORE STATEMENT TRIGGER 실습 진행

-- 1. 시스템 시간 변경 
--   (오라클이 설치된 피씨의 시간을 따르기 때문에 원격에서는 실습 진행 불가)

-- 2. 오라클 서버의 시간이 19:00인 상태로 테스트
INSERT INTO TBL_TEST1(ID, NAME, TEL)
VALUES(5, '심혜진', '010-5555-5555');
--==>> 에러 발생


--○ BEFORE ROW TRIGGER 실습 진행을 위한 테이블 생성(TBL_TEST2) → 부모 테이블
CREATE TABLE TBL_TEST2
( CODE  NUMBER
, NAME  VARCHAR2(40)
, CONSTRAINT TEST2_CODE_PK PRIMARY KEY(CODE)
);
--==>> Table TBL_TEST2이(가) 생성되었습니다.

--○ BEFORE ROW TRIGGER 실습 진행을 위한 테이블 생성(TBL_TEST3) → 자식 테이블
CREATE TABLE TBL_TEST3
( SID   NUMBER
, CODE  NUMBER
, SU    NUMBER
, CONSTRAINT TEST3_SID_PK PRIMARY KEY(SID)
, CONSTRAINT TEST3_CODE_FK FOREIGN KEY(CODE)
             REFERENCES TBL_TEST2(CODE)
);
--==>> Table TBL_TEST3이(가) 생성되었습니다.

--○ 부모 테이블에 데이터 입력
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(1, '냉장고');
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(2, '세탁기');
INSERT INTO TBL_TEST2(CODE, NAME) VALUES(3, '건조기');
--==>> 1 행 이(가) 삽입되었습니다. * 3

SELECT *
FROM TBL_TEST2;
--==>>
/*
1	냉장고
2	세탁기
3	건조기
*/


COMMIT;
--==>> 커밋 완료.


--○ 자식 테이블에 데이터 입력
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(1, 1, 20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(2, 1, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(3, 1, 40);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(4, 2, 20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(5, 2, 30);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(6, 2, 40);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(7, 1, 20);
INSERT INTO TBL_TEST3(SID, CODE, SU) VALUES(8, 2, 20);
--==>> 1 행 이(가) 삽입되었습니다. * 8


SELECT *
FROM TBL_TEST3;
--==>>
/*
1	1	20
2	1	30
3	1	40
4	2	20
5	2	30
6	2	40
7	1	20
8	2	20
*/

COMMIT;
--==>> 커밋 완료.


--○ 트리거 작성 이전 테스트
SELECT C.SID, P.CODE, P.NAME, C.SU
FROM TBL_TEST2 P JOIN TBL_TEST3 C
ON P.CODE = C.CODE;
--==>>
/*
1	1	냉장고	20
2	1	냉장고	30
3	1	냉장고	40
4	2	세탁기	20
5	2	세탁기	30
6	2	세탁기	40
7	1	냉장고	20
8	2	세탁기	20
*/

DELETE
FROM TBL_TEST2
WHERE CODE = 1;
--==>> 에러 발생
/*
ORA-02292: integrity constraint (SCOTT.TEST3_CODE_FK) violated - child record found
*/

DELETE
FROM TBL_TEST2
WHERE CODE = 2;
--==>> 에러 발생
/*
ORA-02292: integrity constraint (SCOTT.TEST3_CODE_FK) violated - child record found
*/

DELETE
FROM TBL_TEST2
WHERE CODE = 3;
--==>> 1 행 이(가) 삭제되었습니다.
--> 참조되지 않고 있기 때문에 삭제가 수행된다. 

COMMIT;
--==>> 커밋 완료.


--○ 트리거 작성 이후 다시 테스트
DELETE
FROM TBL_TEST2
WHERE CODE=1;
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_TEST2;
--==>> 2	세탁기

SELECT *
FROM TBL_TEST3;
--==>> 
/*
4	2	20
5	2	30
6	2	40
8	2	20
*/

COMMIT;
--==>> 커밋 완료.


--○ 트리거 실습 전에 테이블 정리
TRUNCATE TABLE TBL_입고;
--==>> Table TBL_입고이(가) 잘렸습니다.

TRUNCATE TABLE TBL_출고;
--==>> Table TBL_출고이(가) 잘렸습니다.

UPDATE TBL_상품
SET 재고수량 = 0;
--==>> 21개 행 이(가) 업데이트되었습니다.

COMMIT;
--==>> 커밋 완료.


--○ 입고 테이블에 입고 이벤트 발생
INSERT INTO TBL_입고(입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
VALUES(1, 'H001', SYSDATE, 100, 1000);
--==>> 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_입고;
--==>> 1	H001	2021-04-12 17:16:29	100	1000

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	100

COMMIT;
--==>> 커밋 완료.


--○ 작성한 트리거(TRG_IBGO) 테스트
-- 입고 테이블에 업데이트 이벤트 발생
UPDATE TBL_입고
SET 입고수량 = 50
WHERE 입고번호 = 1;
--==>> 1 행 이(가) 업데이트되었습니다.

SELECT *
FROM TBL_입고;
--==>> 1	H001	2021-04-12 17:16:29	50	1000

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	50

-- 입고 테이블에 삭제 이벤트 발생
DELETE
FROM TBL_입고
WHERE 입고번호 = 1;
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_입고;
--==>> 조회 결과 없음

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0

ROLLBACK;


--○ 작성한 트리거(TRG_CHULGO) 테스트
-- 테스트 전 데이터
SELECT *
FROM TBL_출고;
--==>> 조회 결과 없음

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	100


-- 출고 테이블에 출고 이벤트 발생
INSERT INTO TBL_출고(출고번호, 상품코드, 출고일자, 출고수량, 출고단가)
VALUES(1, 'H001', SYSDATE, 100, 1000);
--==>> 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_출고;
--==>> 1	H001	2021-04-12 18:00:14	100	1000

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0
--> 홈런볼 100개에서 0개로 재고 반영됨


-- 출고 테이블에 업데이트 이벤트 발생
UPDATE TBL_출고
SET 출고수량 = 50
WHERE 출고번호 = 1;
--==>> 1 행 이(가) 업데이트되었습니다.

SELECT *
FROM TBL_출고;
--==>> 1	H001	2021-04-12 18:00:14	50	1000
--> 출고 수량이 100개에서 50개로 변경됨

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	50
--> 재고수량이 0개에서 50개로 변경됨 


-- 출고 테이블에 삭제 이벤트 발생
DELETE
FROM TBL_출고
WHERE 출고번호 = 1;
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_출고;
--==>> 조회 결과 없음
--> 출고 내역이 정상적으로 삭제됨

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	100
--> 재고가 기존 개수(100개)로 돌아옴 