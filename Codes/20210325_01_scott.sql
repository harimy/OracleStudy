SELECT USER
FROM DUAL;
--==>> SCOTT

--○ 테이블 생성(TBL_EXAMPLE1)
CREATE TABLE TBL_EXAMPLE1
( NO    NUMBER
, NAME  VARCHAR2(10)
, ADDR  VARCHAR2(20)
);
--==>> Table TBL_EXAMPLE1이(가) 생성되었습니다.

--○ 테이블 생성(TBL_EXAMPLE2)
CREATE TABLE TBL_EXAMPLE2
( NO    NUMBER
, NAME  VARCHAR2(10)
, ADDR  VARCHAR2(20)
) TABLESPACE TBS_EDUA;
--==>> Table TBL_EXAMPLE2이(가) 생성되었습니다.

--○ TBL_EXAMPLE1 과 TBL_EXAMPLE2 테이블이
--   어떤 테이블스페이스에 저장되어 있는지 조회
SELECT TABLE_NAME, TABLESPACE_NAME
FROM USER_TABLES;
--==>>
/*
DEPT	USERS
EMP	USERS
BONUS	USERS
SALGRADE	USERS
TBL_EXAMPLE1	USERS
TBL_EXAMPLE2	TBS_EDUA
*/

--------------------------------------------------------------------------------

--■■■ 관계형 데이터베이스 ■■■--

-- 데이터를 테이블의 형태로 저장시켜 놓은 것
-- 그리고 이들 각 테이블들 간의 관계를 설정하는 것.

/*==================================
★ SELECT 문의 처리(PARSING) 순서 ★

   SELECT 컬럼명 -- ⑤
   FROM 테이블명 -- ①
   WHERE 조건절  -- ②
   GROUP BY 절   -- ③
   HAVING 절     -- ④
   ORDER BY 절   -- ⑥

==================================*/

--○ 현재 접속된 오라클 사용자(SCOTT) 소유의
--   테이블(TABLE), 뷰(VIEW)의 목록을 조회
SELECT *
FROM TAB;
--==>>
/*
BONUS	        TABLE	→ 보너스 정보 테이블
DEPT	        TABLE	→ DEPARTMENTS(부서) 정보 테이블
EMP	            TABLE	→ EMPLOYEES(사원) 정보 테이블
SALGRADE	    TABLE	→ 급여(SALARY) 등급 정보 테이블
TBL_EXAMPLE1	TABLE	
TBL_EXAMPLE2	TABLE	
*/

--○ 각 테이블의 정보 조회
SELECT *
FROM BONUS;
--==>> 데이터 존재하지 않음

SELECT *
FROM DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/


SELECT *
FROM EMP;
--==>> 
/*
7369	SMITH	CLERK	    7902	80/12/17	800		        20
7499	ALLEN	SALESMAN	7698	81/02/20	1600	300	    30
7521	WARD	SALESMAN	7698	81/02/22	1250	500	    30
7566	JONES	MANAGER	    7839	81/04/02	2975		    20
7654	MARTIN	SALESMAN	7698	81/09/28	1250	1400	30
7698	BLAKE	MANAGER	    7839	81/05/01	2850		    30
7782	CLARK	MANAGER	    7839	81/06/09	2450		    10
7788	SCOTT	ANALYST	    7566	87/07/13	3000		    20
7839	KING	PRESIDENT		    81/11/17	5000		    10
7844	TURNER	SALESMAN	7698	81/09/08	1500	0	    30
7876	ADAMS	CLERK	    7788	87/07/13	1100		    20
7900	JAMES	CLERK	    7698	81/12/03	950		        30
7902	FORD	ANALYST	    7566	81/12/03	3000		    20
7934	MILLER	CLERK	    7782	82/01/23	1300		    10
*/


SELECT *
FROM SALGRADE;
--==>>
/*
1	700	    1200
2	1201	1400
3	1401	2000
4	2001	3000
5	3001	9999
*/

--○ DEPT 테이블에 존재하는 컬럼의 정보(구조) 조회
DESCRIBE DEPT;
--==>>
/*
이름     널?       유형           
------ -------- ------------ 
DEPTNO NOT NULL NUMBER(2)    
DNAME           VARCHAR2(14) 
LOC             VARCHAR2(13) 
*/

--※ 우리가 흔히 웹사이트 등에서 회원가입을 수행할 경우
--   필수 입력 사항과 선택 입력 사항이 있다.
--   필수 입력 항목은 ID, PW, 성명, 주민번호, 전화번호 ...
--   등과 같은 컬럼이며, 이 값들은 회원가입 절차에 따라
--   반드시 필요한(존재해야 하는) 값이므로 NOT NULL 로 한다.

--   선택 입력 항목은 취미, 결혼여부, 차량소유여부, 특기, ...
--   등과 같은 컬럼이며, 이 값들은 회원가입 과정에서
--   반드시 필요한 값이 아니므로(즉, 입력하지 않아도 무방하므로)
--   NULL 이어도 상관 없는 상황이 된다.

--   DEPTNO     DNAME       LOC
--   부서번호   부서명      부서위치
--   NOT NULL   NULL 허용   NULL 허용

--EX)           인사부      서울      → 데이터 입력 불가
--     80                   인천      → 데이터 입력 가능
--     90                             → 데이터 입력 가능

--■■■ 오라클의 주요 자료형(DATA TYPE) ■■■--
/*
cf) MS-SQL 서버의 정수 표현 타입
    tinyint     0 ~ 255             1Byte
    smallint    -32,768 ~ 32,767    2Byte
    int         -21억 ~ 21억        4Byte
    bigint      엄청큼              8Byte
    
    MS-SQL 서버의 실수 표현 타입
    float, real
    
    MS-SQL 서버의 숫자 표현 타입
    decimal, numeric
    
    MS-SQL 서버의 문자 표현 타입
    char, varchar, Nvarchar
*/

--※ ORACLE 서버는 숫자 표현 타입이 한 가지로 통일되어 있다.
/*
1. 숫자형 NUMBER       → -10의 38승-1 ~ 10의 38승
          NUMBER(3)   → -999 ~ 999
          NUMBER(4)   → -9999 ~ 9999
          NUMBER(4,1) → -999.9 ~ 999.9
*/

--※ ORACLE 서버의 문자 표현 타입 
--   CHAR, VARCHAR2, NVARCHAR2
/*
2. 문자형 CHAR         - 고정형 크기
          CHAR(10)     - 무조건 10Byte 소모
          CHAR(10) ← '강의실'        6Byte 이지만 10Byte 를 소모
          CHAR(10) ← '잠깬박민지'   10Byte
          CHAR(10) ← 'OH잠깬박민지' 10Byte 를 초과하므로 입력 불가
                   
          VARCHAR2     - 가변형 크기
          VARCHAR2(10) ← '강의실'        6Byte
          VARCHAR2(10) ← '잠깬박민지'   10Byte
          VARCHAR2(10) ← 'OH잠깬박민지' 10Byte 를 초과하므로 입력 불가
          
          NCHAR        - 유니코드 기반 고정형 크기
          NCHAR(10)    - 10 글자
          
          NVARCHAR2    - 유니코드 기반 가변형 크기
          NVARCHAR(10) - 10 글자
          
3. 날짜형 DATE
*/

SELECT SYSDATE
FROM DUAL;
--==>> 21/03/25

--※ 날짜 형식에 대한 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.

SELECT SYSDATE
FROM DUAL;
--==>> 2021-03-25 11:35:53

--○EMP 테이블에서 사원번호와, 사원명, 급여, 커미션 정보만 조회
SELECT *
FROM EMP;

SELECT EMPNO, ENAME, SAL, COMM
FROM EMP;
--==>>
/*
7369	SMITH	800	
7499	ALLEN	1600	300
7521	WARD	1250	500
7566	JONES	2975	
7654	MARTIN	1250	1400
7698	BLAKE	2850	
7782	CLARK	2450	
7788	SCOTT	3000	
7839	KING	5000	
7844	TURNER	1500	0
7876	ADAMS	1100	
7900	JAMES	950	
7902	FORD	3000	
7934	MILLER	1300	
*/


--○ EMP 테이블에서 부서번호가 20번인 직원들의 정보 중
--   사원번호, 사원명, 직종명, 급여, 부서번호 조회
SELECT EMPNO, ENAME, JOB, SAL, DEPTNO
FROM EMP
WHERE DEPTNO=20;
--==>>
/*
7369	SMITH	CLERK	 800	20
7566	JONES	MANAGER	2975	20
7788	SCOTT	ANALYST	3000	20
7876	ADAMS	CLERK	1100	20
7902	FORD	ANALYST	3000	20
*/

DESCRIBE EMP;
--==>>
/*
이름       널?       유형           
-------- -------- ------------ 
EMPNO    NOT NULL NUMBER(4)    
ENAME             VARCHAR2(10) 
JOB               VARCHAR2(9)  
MGR               NUMBER(4)    
HIREDATE          DATE         
SAL               NUMBER(7,2)  
COMM              NUMBER(7,2)  
DEPTNO            NUMBER(2)
*/

SELECT *
FROM EMP;

--※ 테이블을 조회하는 과정에서 각 컬럼에 별칭(ALIAS)을 부여할 수 있다.
SELECT EMPNO AS "사원번호", ENAME "사원명", JOB 직종, SAL, DEPTNO
FROM EMP
WHERE DEPTNO=20;

--※ 테이블 조회 시 사용하는 별칭(ALIAS)의 기본 구문은
--   『AS "별칭명"』의 형태로 작성되며
--   이 때, 『AS』는 생략 가능하다.
--   또한, 『""』도 생략 가능하다.
--   하지만, 『""』를 생략할 경우 별칭명에 공백을 사용할 수 없다.
--   공백은 해당 컬럼의 종결을 의미하므로 별칭의 이름 내부에 공백을 사용할 경우
--   『""』를 사용하여 별칭을 부여할 수 있도록 처리해야 한다.

--○ EMP 테이블에서 부서번호가 20번과 30번 직원들의 정보 중
--   사원번호, 사원명, 직종명, 급여, 부서번호 항목을 조회한다.
--   단, 별칭(ALIAS)을 사용한다.
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE DEPTNO=20 OR DEPTNO=30;
--==>>
/*
7369	SMITH	CLERK	    800	    20
7499	ALLEN	SALESMAN	1600	30
7521	WARD	SALESMAN	1250	30
7566	JONES	MANAGER	    2975	20
7654	MARTIN	SALESMAN	1250	30
7698	BLAKE	MANAGER	    2850	30
7788	SCOTT	ANALYST	    3000	20
7844	TURNER	SALESMAN	1500	30
7876	ADAMS	CLERK	    1100	20
7900	JAMES	CLERK	    950	    30
7902	FORD	ANALYST 	3000	20
*/


SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE DEPTNO IN (20, 30);
--> IN 연산자를 활용하여 이와 같이 처리할 수 있으며
--  위에서 처리한 구문과 같은 결과를 반환하게 된다.


--○ EMP 테이블에서 직종이 CLERK 인 사원들의 정보를 모두 조회한다.
SELECT *
FROM EMP
WHERE JOB='CLERK';
--==>> 
/*
7369	SMITH	CLERK	7902	1980-12-17 00:00:00	800		20
7876	ADAMS	CLERK	7788	1987-07-13 00:00:00	1100	20
7900	JAMES	CLERK	7698	1981-12-03 00:00:00	950		30
7934	MILLER	CLERK	7782	1982-01-23 00:00:00	1300	10
*/

SELECT *
FROM EMP
WHERE JOB='clerk';

--※ 오라클에서... 입력된 데이터(값) 만큼은
--   반.드.시. 대·소문자 구분을 한다.


--○ EMP 테이블에서 직종이 CLERK 인 사원들 중
--   20번 부서에 근무하는 사원들의
--   사원번호, 사원명, 직종명, 급여, 부서번호 항목을 조회한다.
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE JOB='CLERK' AND DEPTNO=20;
--==>>
/*
7369	SMITH	CLERK	800	    20
7876	ADAMS	CLERK	1100	20
*/


--○ EMP 테이블에서 10번 부서에 근무하는 직원들 중
--   급여가 2500 이상인 사원들의 
--   사원명, 직종명, 급여, 부서번호 항목을 조회한다.
SELECT ENAME "사원명", JOB "직종명", SAL "급여", DEPTNO "부서번호"
FROM EMP
WHERE DEPTNO=10 AND SAL>=2500;
--==>>
/*
KING	PRESIDENT	5000	10
*/


--○ 테이블 복사
--> 내부적으로 대상 테이블 안에 있는 데이터 내용만 복사하는 과정

--※ EMP 테이블의 정보를 확인하여
--   이와 똑같은 데이터가 들어있는 EMPCOPY 테이블을 생성한다. (팀별로...)
DESCRIBE EMP;
DESC EMP;
--==>>
/*
이름       널?       유형           
-------- -------- ------------ 
EMPNO    NOT NULL NUMBER(4)    
ENAME             VARCHAR2(10) 
JOB               VARCHAR2(9)  
MGR               NUMBER(4)    
HIREDATE          DATE         
SAL               NUMBER(7,2)  
COMM              NUMBER(7,2)  
DEPTNO            NUMBER(2)  
*/

CREATE TABLE EMPCOPY4
( EMPNO     NUMBER(4)
, ENAME     VARCHAR2(10)
, JOB       VARCHAR2(9)
, MGR       NUMBER(4)
, HIREDATE  DATE
, SAL       NUMBER(7,2)
, COMM      NUMBER(7,2)
, DEPTNO    NUMBER(2) 
);
--==>> Table EMPCOPY4이(가) 생성되었습니다.

SELECT *
FROM EMPCOPY4;

--INSERT INTO EMPCOPY4 VALUES(..., ..., ..., ...);

CREATE TABLE TBL_EMP
AS
SELECT *
FROM EMP;
--==>> Table TBL_EMP이(가) 생성되었습니다.


--○ 복사한 테이블 확인
SELECT *
FROM TBL_EMP;
--==>>
/*
7369	SMITH	CLERK	    7902	1980-12-17 00:00:00	800		20
7499	ALLEN	SALESMAN	7698	1981-02-20 00:00:00	1600	300	    30
7521	WARD	SALESMAN	7698	1981-02-22 00:00:00	1250	500	    30
7566	JONES	MANAGER	    7839	1981-04-02 00:00:00	2975		    20
7654	MARTIN	SALESMAN	7698	1981-09-28 00:00:00	1250	1400	30
7698	BLAKE	MANAGER	    7839	1981-05-01 00:00:00	2850		    30
7782	CLARK	MANAGER	    7839	1981-06-09 00:00:00	2450		    10
7788	SCOTT	ANALYST	    7566	1987-07-13 00:00:00	3000		    20
7839	KING	PRESIDENT		    1981-11-17 00:00:00	5000		    10
7844	TURNER	SALESMAN	7698	1981-09-08 00:00:00	1500	0	    30
7876	ADAMS	CLERK	    7788	1987-07-13 00:00:00	1100		    20
7900	JAMES	CLERK	    7698	1981-12-03 00:00:00	950		        30
7902	FORD	ANALYST	    7566	1981-12-03 00:00:00	3000		    20
7934	MILLER	CLERK	    7782	1982-01-23 00:00:00	1300		    10
*/

--※ 날짜 관련 세션 정보 설정
ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

--○ 테이블 복사
CREATE TABLE TBL_DEPT
AS
SELECT *
FROM DEPT;
--==>> Table TBL_DEPT이(가) 생성되었습니다.

--○ 복사한 테이블 확인
SELECT *
FROM TBL_EMP;
SELECT *
FROM TBL_DEPT;


--○ 테이블의 커멘트 정보 확인
SELECT *
FROM USER_TAB_COMMENTS;
--==>>
/*
DEPT	        TABLE	
EMP	            TABLE	
BONUS	        TABLE	
SALGRADE	    TABLE	
TBL_EXAMPLE2	TABLE	
TBL_EXAMPLE1	TABLE	
EMPCOPY4	    TABLE	
TBL_EMP	        TABLE	
TBL_DEPT	    TABLE	
*/

--○ 테이블의 커멘트 정보 입력
COMMENT ON TABLE TBL_EMP IS '사원데이터';
--==>> Comment이(가) 생성되었습니다.

--○ 테이블의 커멘트 정보 입력 후 다시 확인
SELECT *
FROM USER_TAB_COMMENTS;

/*
TBL_DEPT	    TABLE	
TBL_EMP	        TABLE	사원데이터
EMPCOPY4	    TABLE	
TBL_EXAMPLE1	TABLE	
TBL_EXAMPLE2	TABLE	
SALGRADE	    TABLE	
BONUS	        TABLE	
EMP	            TABLE	
DEPT	        TABLE	
*/

--○ 테이블 레벨의 커멘트 정보 입력(TBL_DEPT → 부서데이터)
COMMENT ON TABLE TBL_DEPT IS '부서데이터';
--==>> Comment이(가) 생성되었습니다.

--○ 테이블의 커멘트 정보 입력 후 다시 확인
SELECT *
FROM USER_TAB_COMMENTS;

--○ 컬럼 레벨의 커멘트 정보 확인
SELECT *
FROM USER_COL_COMMENTS;
--==>>
/*
EMPCOPY4	    HIREDATE	
BONUS	        SAL	
EMP	            JOB	
SALGRADE	    HISAL	
EMPCOPY4	    ENAME	
TBL_EMP	        COMM	
SALGRADE	    GRADE	
EMPCOPY4	    SAL	
EMP	            EMPNO	
TBL_EXAMPLE1	NO	
TBL_EXAMPLE2	NO	
EMP	            DEPTNO	
TBL_EMP	        MGR	
TBL_EMP	        EMPNO	
BONUS	        COMM	
EMP	            ENAME	
BONUS	        ENAME	
TBL_EXAMPLE2	NAME	
TBL_EXAMPLE2	ADDR	
TBL_EMP	        DEPTNO	
TBL_DEPT	    DEPTNO	
EMP	            MGR	
TBL_EMP	        JOB	
TBL_EMP	        ENAME	
DEPT	        DNAME	
EMPCOPY4	    COMM	
SALGRADE	    LOSAL	
EMP	            HIREDATE	
DEPT	        LOC	
EMPCOPY4	    DEPTNO	
TBL_EMP	        SAL	
EMPCOPY4	    EMPNO	
TBL_EXAMPLE1	ADDR	
EMPCOPY4	    JOB	
TBL_EMP	        HIREDATE	
TBL_DEPT	    LOC	
EMPCOPY4	    MGR	
BONUS	        JOB	
DEPT	        DEPTNO	
EMP	            COMM	
EMP	            SAL	
TBL_EXAMPLE1	NAME	
TBL_DEPT	    DNAME	
*/

--○ 컬럼 레벨의 커멘트 정보 확인
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME='TBL_DEPT';
--==>>
/*
TBL_DEPT	DEPTNO	
TBL_DEPT	DNAME	
TBL_DEPT	LOC	
*/

--○ 테이블에 소속된(포함된) 칼럼 레벨의 커멘트 정보 입력(설정)
COMMENT ON COLUMN TBL_DEPT.DEPTNO IS '부서번호';
--==>> Comment이(가) 생성되었습니다.

COMMENT ON COLUMN TBL_DEPT.DNAME IS '부서명';
--==>> Comment이(가) 생성되었습니다.

COMMENT ON COLUMN TBL_DEPT.LOC IS '부서위치';
--==>> Comment이(가) 생성되었습니다.



--○ 커멘드 데이터가 입력된 테이블의 컬럼 레벨의 정보 확인
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'TBL_DEPT';
--==>>
/*
TBL_DEPT	DEPTNO	부서번호
TBL_DEPT	DNAME	부서명
TBL_DEPT	LOC	부서위치
*/

DESC TBL_EMP;

--○ TBL_EMP 테이블에 소속된(포함된)
--   컬럼에 대한 커멘드 정보를 입력(설정)한다.
COMMENT ON COLUMN TBL_EMP.EMPNO IS '사원번호';
COMMENT ON COLUMN TBL_EMP.ENAME IS '사원명';
COMMENT ON COLUMN TBL_EMP.JOB IS '직종명';
COMMENT ON COLUMN TBL_EMP.MGR IS '관리자사원번호';
COMMENT ON COLUMN TBL_EMP.HIREDATE IS '고용일';
COMMENT ON COLUMN TBL_EMP.SAL IS '급여';
COMMENT ON COLUMN TBL_EMP.COMM IS '커미션';
COMMENT ON COLUMN TBL_EMP.DEPTNO IS '부서번호';
--==>> Comment이(가) 생성되었습니다. * 8

--○ 확인
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'TBL_EMP';
--==>>
/*
TBL_EMP	EMPNO	    사원번호
TBL_EMP	ENAME	    사원명
TBL_EMP	JOB	        직종명
TBL_EMP	MGR	        관리자사원번호
TBL_EMP	HIREDATE	고용일
TBL_EMP	SAL	        급여
TBL_EMP	COMM	    커미션
TBL_EMP	DEPTNO	    부서번호
*/

--■■■ 컬럼 구조의 추가 및 제거 ■■■--

SELECT *
FROM TBL_EMP;

--○ TBL_EMP 테이블에 주민등록번호 정보를 담을 수 있는 컬럼 추가
ALTER TABLE TBL_EMP
ADD SSN CHAR(13); -- ADD 뒤에 별도로 무엇을 추가할건지 기재하지 않으면 COLUMN으로 추가가 됨
--==>> Table TBL_EMP이(가) 변경되었습니다.
--※ 맨 앞에 0이 들어올 가능성이 있는 숫자가 조합된 데이터라면
--   숫자형이 아닌 문자형으로 데이터타입을 처리해야 한다.~!!!

SELECT 0012123
FROM DUAL;
--==>> 12123

SELECT '0012123'
FROM DUAL;
--==>> 0012123

--○ 확인
SELECT *
FROM TBL_EMP;


DESC TBL_EMP;
--> SSL 컬럼이 정상적으로 추가된 상황임을 확인

SELECT EMPNO, ENAME, SSN, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO
FROM TBL_EMP;
--> 테이블 내에서 컬럼의 순서는 구조적으로 의미 없음


--○ TBL_EMP 테이블에서 추가한 SSN(주민등록번호) 컬럼 제거
ALTER TABLE TBL_EMP
DROP COLUMN SSN;
--==>> Table TBL_EMP이(가) 변경되었습니다.

--○ 확인
SELECT *
FROM TBL_EMP;

DESC TBL_EMP;
--> SSN(주민등록번호) 컬럼이 정상적으로 제거되었음을 확인


DELETE
FROM TBL_EMP
WHERE EMPNO=7369;

SELECT *
FROM TBL_EMP;

DELETE
FROM TBL_EMP
WHERE EMPNO=7654;

DELETE
FROM TBL_EMP
WHERE DEPTNO=20;

DELETE TBL_EMP;     -- 권장하지 않음

DELETE
FROM TBL_EMP;       -- 권장

--○ 확인
SELECT *
FROM TBL_EMP;
--==>> 조회 결과 없음
--> 테이블의 구조는 그대로 남아있는 상태에서
--  데이터 모두 소실(삭제)된 상황임을 확인


--○ 테이블을 구조적으로 제거
DROP TABLE TBL_EMP;
--==>> Table TBL_EMP이(가) 삭제되었습니다.

--○ 확인
SELECT *
FROM TBL_EMP;
--==>>
/*
ORA-00942: table or view does not exist
00942. 00000 -  "table or view does not exist"
*Cause:    
*Action:
672행, 6열에서 오류 발생
*/

--○ 테이블 다시 생성(복사)
CREATE TABLE TBL_EMP
AS
SELECT *
FROM EMP;
--==>> Table TBL_EMP이(가) 생성되었습니다.

--------------------------------------------------------------------------------

--■■■ NULL 의 처리 ■■■--
SELECT 2, 10+2, 10-2, 10*2, 10/2
FROM DUAL;
--==>> 2	12	8	20	5

SELECT NULL, NULL+2, NULL-2, NULL*2, NULL/2, 10+NULL, 10-NULL, 10*NULL, 10/NULL
FROM DUAL;
--==>> (null) (null) (null) (null) (null) (null) (null) (null) (null)

--※ 관찰 결과
--   NULL 은 상태의 값을 의미하며, 실제 존재하지 않는 값이기 때문에
--   이러한 NULL 이 연산에 포함될 경우... 그 결과는 무조건 NULL 이다.
SELECT *
FROM TBL_EMP;


--○ TBL_EMP 테이블에서 커미션(COMM, 수당)이 NULL 인 직원의
--   사원명, 직종명, 급여, 커미션 항목을 조회한다.
SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션"
FROM TBL_EMP
WHERE COMM = NULL;
--==>> 조회 결과 없음


SELECT ENAME, JOB, SAL, COMM
FROM TBL_EMP
WHERE COMM IS NULL;
--==>>
/*
SMITH	CLERK	    800	
JONES	MANAGER	    2975	
BLAKE	MANAGER	    2850	
CLARK	MANAGER	    2450	
SCOTT	ANALYST	    3000	
KING	PRESIDENT	5000	
ADAMS	CLERK	    1100	
JAMES	CLERK	    950	
FORD	ANALYST	    3000	
MILLER	CLERK	    1300	
*/

DESC TBL_EMP;
--==>>
/*
        : 
COMM        NUMBER(7,2)  
        :
*/
--> COMM 컬럼은 숫자형 데이터 타입을 취하고 있음을 확인

--※ NULL 은 실제 존재하지 않는 값이기 때문에 일반적인 연산자를 활용하여 비교할 수 없다.
--   즉, 산술적인 비교 연산을 수행할 수 없다는 의미이다.
--   NULL 을 대상으로 사용할 수 없는 연산자들...
--   >=, <=, >, <, =, !=, ^=, <> 
SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션"
FROM TBL_EMP
WHERE COMM IS NULL;
--==>>
/*
SMITH	CLERK	800	
JONES	MANAGER	2975	
BLAKE	MANAGER	2850	
CLARK	MANAGER	2450	
SCOTT	ANALYST	3000	
KING	PRESIDENT	5000	
ADAMS	CLERK	1100	
JAMES	CLERK	950	
FORD	ANALYST	3000	
MILLER	CLERK	1300	
*/

--○ TBL_EMP 테이블에서 20번 부서에 근무하지 않는 직원들의
--   사원명, 직종명, 부서번호 항목을 조회한다.
SELECT ENAME "사원명", JOB "직종명", DEPTNO "부서번호"
FROM TBL_EMP
WHERE DEPTNO != 20;

SELECT ENAME "사원명", JOB "직종명", DEPTNO "부서번호"
FROM TBL_EMP
WHERE DEPTNO ^= 20;

SELECT ENAME "사원명", JOB "직종명", DEPTNO "부서번호"
FROM TBL_EMP
WHERE DEPTNO <> 20;
--==>>
/*
ALLEN	SALESMAN	30
WARD	SALESMAN	30
MARTIN	SALESMAN	30
BLAKE	MANAGER	    30
CLARK	MANAGER	    10
KING	PRESIDENT	10
TURNER	SALESMAN	30
JAMES	CLERK	    30
MILLER	CLERK	    10
*/

--○ TBL_EMP 테이블에서 커미션이 NULL 이 아닌 직원들의
--   사원명, 직종명, 급여, 커미션 항목을 조회한다.
SELECT ENAME "사원명", JOB "직종명", SAL "급여", COMM "커미션"
FROM TBL_EMP
WHERE COMM IS NOT NULL;
--==>>
/*
ALLEN	SALESMAN	1600	300
WARD	SALESMAN	1250	500
MARTIN	SALESMAN	1250	1400
TURNER	SALESMAN	1500	0
*/


--○ TBL_EMP 테이블에서 모든 사원들의
--   사원명, 사원번호, 급여, 커미션, 연봉 항목을 조회한다. 
--   단, 급여(SAL)는 매월 지급한다.
--   또한, 수당(COMM)은 매년 지급한다.

SELECT ENAME "사원명", EMPNO "사원번호", SAL "급여", COMM "커미션", SAL*12+COMM "연봉"
FROM TBL_EMP;


--○ NVL()
SELECT NULL "ⓐ", NVL(NULL, 10) "ⓑ", NVL(10, 20) "ⓒ"
FROM DUAL;
--==>> (null) 10	10
--> 첫 번째 파라미터 값이 NULL 이면, 두 번째 파라미터 값을 반환한다.
--  첫 번째 파라미터 값이 NULL 이 아니면, 그 값(첫 번째 파라미터)을 그대로 반환한다.

SELECT COMM "ⓐ", NVL(COMM, 0) "ⓑ"
FROM TBL_EMP
WHERE EMPNO=7499;
--==>> (null) 	0

SELECT ENAME "사원명", EMPNO "사원번호", SAL "급여", COMM "커미션", SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP;
--==>>
/*
SMITH	7369	800		        9600
ALLEN	7499	1600	300	    19500
WARD	7521	1250	500	    15500
JONES	7566	2975		    35700
MARTIN	7654	1250	1400	16400
BLAKE	7698	2850		    34200
CLARK	7782	2450		    29400
SCOTT	7788	3000		    36000
KING	7839	5000		    60000
TURNER	7844	1500	0	    18000
ADAMS	7876	1100		    13200
JAMES	7900	950		        11400
FORD	7902	3000		    36000
MILLER	7934	1300		    15600
*/



--○ NVL2()                       . .
--> 첫 번째 파라미터 값이 NULL 이 아닌 경우, 두 번째 파라미터 값을 반환하고,
--  첫 번째 파라미터 값이 NULL 인 경우, 세 번째 파라미터 값을 반환한다.
SELECT ENAME, COMM, NVL2(COMM, '청기올려', '백기올려') "확인"
FROM TBL_EMP;


SELECT ENAME "사원명", EMPNO "사원번호", SAL "급여", COMM "커미션", NVL2(COMM, SAL*12+COMM, SAL*12) "연봉"
FROM TBL_EMP;
--==>>
/*
SMITH	7369	800		        9600
ALLEN	7499	1600	300	    19500
WARD	7521	1250	500	    15500
JONES	7566	2975		    35700
MARTIN	7654	1250	1400	16400
BLAKE	7698	2850		    34200
CLARK	7782	2450		    29400
SCOTT	7788	3000		    36000
KING	7839	5000		    60000
TURNER	7844	1500	0	    18000
ADAMS	7876	1100		    13200
JAMES	7900	950		        11400
FORD	7902	3000		    36000
MILLER	7934	1300		    15600
*/


--○ COALESCE()
--> 매개변수 제한이 없는 형태로 인지하고 활용한다.
--  맨 앞에 있는 매개변수부터 차례로 NULL 인지 아닌지 확인하여
--  NULL 이 아닐 경우 적용(반환, 처리) 하고
--  NULL 인 경우에는 그 다음 매개변수 값으로 적용(반환, 처리) 한다.
--  NVL() 나 NVL2() 와 비교하여... 모~~ 든 경우의 수를 고려할 수 있는 특징을 갖고 있다.

SELECT NULL "기본확인"
     , COALESCE(NULL, NULL, NULL, 30) "함수 확인1"
     , COALESCE(NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100) "함수 확인2"
     , COALESCE(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100) "함수 확인3"
     , COALESCE(NULL, NULL, 20, NULL, NULL, NULL, NULL, NULL, NULL, 100) "함수 확인4"
FROM DUAL;
--==>> (null)	30	100	100	20


--○ 실습을 위한 데이터 입력
INSERT INTO TBL_EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, DEPTNO)
VALUES(8000, '정주니', 'SALESMAN', 7839, SYSDATE, 10);
--==>> 1 행 이(가) 삽입되었습니다.

INSERT INTO TBL_EMP(EMPNO, ENAME, JOB, MGR, HIREDATE, COMM, DEPTNO)
VALUES(8001, '유리미', 'SALESMAN', 7839, SYSDATE, 100, 10);
--==>> 1 행 이(가) 삽입되었습니다.

--○ 확인
SELECT *
FROM TBL_EMP;

--○ 커밋
COMMIT;
--==>> 커밋 완료.

SELECT ENAME "사원명", EMPNO "사원번호", SAL "급여", COMM "커미션", SAL*12+NVL(COMM,0) "연봉"
FROM TBL_EMP;

SELECT ENAME "사원명", EMPNO "사원번호", SAL "급여", COMM "커미션", NVL2(COMM, SAL*12+COMM, SAL*12) "연봉"
FROM TBL_EMP;

SELECT ENAME "사원명", EMPNO "사원번호", SAL "급여", COMM "커미션"
    , COALESCE((SAL*12+COMM), (SAL*12), COMM, 0) "연봉"
FROM TBL_EMP;
--==>> 
/*
SMITH	7369	800		         9600
ALLEN	7499	1600	 300	19500
WARD	7521	1250	 500	15500
JONES	7566	2975		    35700
MARTIN	7654	1250	1400	16400
BLAKE	7698	2850		    34200
CLARK	7782	2450		    29400
SCOTT	7788	3000		    36000
KING	7839	5000		    60000
TURNER	7844	1500	   0	18000
ADAMS	7876	1100		    13200
JAMES	7900	950		        11400
FORD	7902	3000		    36000
MILLER	7934	1300		    15600
정주니	8000			   0
유리미	8001		     100	  100
*/





