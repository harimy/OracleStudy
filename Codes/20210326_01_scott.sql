SELECT USER
FROM DUAL;
--==>> SCOTT

--※ 날짜와 시간에 대한 세션 환경 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.


--○ 현재 날짜 및 시간을 반환하는 함수
SELECT SYSDATE, CURRENT_DATE, LOCALTIMESTAMP
FROM DUAL;
--==>> 
/*
2021-03-26 09:12:51
2021-03-26 09:12:51	
21/03/26 09:12:51.000000000
*/

--※ 날짜와 시간에 대한 세션 환경 설정 다시 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

--○ 현재 날짜 및 시간을 반환하는 함수
SELECT SYSDATE, CURRENT_DATE, LOCALTIMESTAMP
FROM DUAL;
--==>>
/*
2021-03-26	
2021-03-26	
21/03/26 09:15:44.000000000
*/

--○ 컬럼과 컬럼의 연결(결합)
--   문자 타입과 문자 타입의 연결
--   『+』 연산자를 통한 결합 수행은 불가능 → 『||』
--   서로 다른 타입의 데이터도 결합 가능함

SELECT 1+1
FROM DUAL;
--==>> 2

SELECT '김가영' + '전혜림'
FROM DUAL;
--==>> 에러 발생
/*
ORA-01722: invalid number
01722. 00000 -  "invalid number"
*Cause:    The specified number was invalid.
*Action:   Specify a valid number.
*/


SELECT '김가영', '전혜림'
FROM DUAL;
--==>> 김가영	전혜림


SELECT '김가영' || '전혜림'
FROM DUAL;
--==>> 김가영전혜림

DESCRIBE TBL_EMP;
--==>>
/*
EMPNO       NUMBER(4)       → 숫자 타입
ENAME       VARCHAR2(10)    → 문자 타입
        :
        :
*/


SELECT EMPNO, ENAME
FROM TBL_EMP;

--     _____    _____
SELECT EMPNO || ENAME
FROM TBL_EMP;
--==>> 
/*
7369SMITH
7499ALLEN
7521WARD
7566JONES
7654MARTIN
7698BLAKE
7782CLARK
7788SCOTT
7839KING
7844TURNER
7876ADAMS
7900JAMES
7902FORD
7934MILLER
8000정주니
8001유리미
*/


--      문자타입   날짜타입 문자타입 숫자타입   문자타입
--      --------   -------  --------  -----  ------------
SELECT '정준이는', SYSDATE, '에 연봉', 500, '억을 원한다.'
FROM DUAL;
--==>> 정준이는	2021-03-26	에 연봉	500	억을 원한다.
--> 각 컬럼에 데이터가 따로따로 담겨있음


--      문자타입     날짜타입   문자타입   숫자타입   문자타입
--      --------     -------    --------    -----   -------------
SELECT '정준이는' || SYSDATE || '에 연봉' || 500 || '억을 원한다.'
FROM DUAL;
--==>> 정준이는2021-03-26에 연봉500억을 원한다.
--> 『||』 로 결합시 하나의 컬럼에 합쳐져서 나옴

--※ 오라클에서는 문자 타이의 형태로 형 변환하는 별도의 과정 없이
--   위에서  처리한 내용처럼 『||』만 삽입해주면 간단히 컬럼과 컬럼을
--   (서로 다른 종류의 데이터) 결합하는 것이 가능하다.
--   MS-SQL 에서는 모든 데이터를 문자 타입으로 CONVERT 해야 한다.


--○ TBL_EMP 테이블의 데이터를 활용하여
--   모든 직원들의 데이터에 대해서
--   다음과 같은 결과를 얻을 수 있도록 쿼리문을 구성한다.

--   SMITH 의 현재 연봉은 9600인데 희망 연봉은 19200이다.
--   ALLEN 의 현재 연봉은 19500인데 희망 연봉은 39000이다.

--※ 문제를 해결하기 전에 정주니 사원과 유리미 사원 삭제
SELECT *
FROM TBL_EMP;

DELETE
FROM TBL_EMP
WHERE EMPNO=8000 OR EMPNO=8001;

DELETE
FROM TBL_EMP
WHERE EMPNO IN (8000, 8001);

SELECT *
FROM TBL_EMP;
--> 원하는 데이터가 제대로 제거되었음을 확인

-- 커밋
COMMIT;
--==>> 커밋 완료.

-- 내가 풀이한 내용
-- 1
SELECT ENAME || ' 의 현재 현봉은 ' || NVL2(COMM, (SAL*12)+COMM, SAL*12) || '인데 희망 연봉은 ' || NVL2(COMM, (SAL*12+COMM)*2, (SAL*12)*2)  || '이다.'
FROM TBL_EMP;

--2
SELECT ENAME || ' 의 현재 현봉은 ' || NVL((SAL*12)+COMM, SAL*12) || '인데 희망 연봉은 ' || NVL((SAL*12+COMM)*2, (SAL*12)*2)  || '이다.'
FROM TBL_EMP;
--==>>
/*
SMITH 의 현재 현봉은 9600인데 희망 연봉은 19200이다.
ALLEN 의 현재 현봉은 19500인데 희망 연봉은 39000이다.
WARD 의 현재 현봉은 15500인데 희망 연봉은 31000이다.
JONES 의 현재 현봉은 35700인데 희망 연봉은 71400이다.
MARTIN 의 현재 현봉은 16400인데 희망 연봉은 32800이다.
BLAKE 의 현재 현봉은 34200인데 희망 연봉은 68400이다.
CLARK 의 현재 현봉은 29400인데 희망 연봉은 58800이다.
SCOTT 의 현재 현봉은 36000인데 희망 연봉은 72000이다.
KING 의 현재 현봉은 60000인데 희망 연봉은 120000이다.
TURNER 의 현재 현봉은 18000인데 희망 연봉은 36000이다.
ADAMS 의 현재 현봉은 13200인데 희망 연봉은 26400이다.
JAMES 의 현재 현봉은 11400인데 희망 연봉은 22800이다.
FORD 의 현재 현봉은 36000인데 희망 연봉은 72000이다.
MILLER 의 현재 현봉은 15600인데 희망 연봉은 31200이다.
*/


-- 함께 풀이한 내용
-- 방식1
SELECT ENAME || ' 의 현재 연봉은 ' || NVL(SAL*12+COMM, SAL*12) || '인데 희망 연봉은 ' || NVL(SAL*12+COMM, SAL*12)*2 || '이다.'
FROM TBL_EMP;

-- 방식2
SELECT ENAME || ' 의 현재 연봉은 ' || NVL2(COMM, SAL*12+COMM, SAL*12) || '인데 희망 연봉은 ' || NVL2(COMM, SAL*12+COMM, SAL*12)*2 || '이다.'
FROM TBL_EMP;

-- 방식3
SELECT ENAME || ' 의 현재 연봉은 ' || COALESCE(SAL*12+COMM, SAL*12, COMM, 0) || '인데 희망 연봉은 ' || COALESCE(SAL*12+COMM, SAL*12, COMM, 0)*2 || '이다.'
FROM TBL_EMP;


-- SMITH's 입사일은 1980-12-17 이다. 그리고 급여는 800 이다.
-- ALLEN's 입사일은 1981-02-20 이다. 그리고 급여는 1600 이다.

SELECT *
FROM TBL_EMP;

SELECT ENAME || '''s 입사일은'  || HIREDATE || '이다. 그리고 급여는 ' || SAL || '이다.'
FROM TBL_EMP;
--==>>
/*
SMITH's 입사일은1980-12-17이다. 그리고 급여는 800이다.
ALLEN's 입사일은1981-02-20이다. 그리고 급여는 1600이다.
WARD's 입사일은1981-02-22이다. 그리고 급여는 1250이다.
JONES's 입사일은1981-04-02이다. 그리고 급여는 2975이다.
MARTIN's 입사일은1981-09-28이다. 그리고 급여는 1250이다.
BLAKE's 입사일은1981-05-01이다. 그리고 급여는 2850이다.
CLARK's 입사일은1981-06-09이다. 그리고 급여는 2450이다.
SCOTT's 입사일은1987-07-13이다. 그리고 급여는 3000이다.
KING's 입사일은1981-11-17이다. 그리고 급여는 5000이다.
TURNER's 입사일은1981-09-08이다. 그리고 급여는 1500이다.
ADAMS's 입사일은1987-07-13이다. 그리고 급여는 1100이다.
JAMES's 입사일은1981-12-03이다. 그리고 급여는 950이다.
FORD's 입사일은1981-12-03이다. 그리고 급여는 3000이다.
MILLER's 입사일은1982-01-23이다. 그리고 급여는 1300이다.
*/

--※ 문자열을 나타내는 홑따옴표 사이에서(시작과 끝)
--   홑따옴표 두 개가 홑따옴표 하나(어퍼스트로피)를 의미한다.
--   홑따옴표 『'』하나는 문자열의 시작을 나타내고
--   홑따옴표 『''』 두 개는 문자열 영역 안에서 어퍼스트로피를 나타내며
--   다시 등장하는 홑따옴표 『'』 하나가 문자열 영역의 종료를 의미하게 되는 것이다.


--------------------------------------------------------------------------------
SELECT *
FROM EMP
WHERE JOB = 'salesman';
--==>> 조회 결과 없음

--○ UPPER(), LOWER(), INITCAP()
SELECT 'oRaCLe' "1", UPPER('oRaCLe') "2", LOWER('oRaCLe') "3", INITCAP('oRaCLe') "4"
FROM DUAL;
--==>> oRaCLe	ORACLE	oracle	Oracle
-- UPPER() 는 모두 대문자로 변환하여 반환
-- LOWER() 는 모두 소문자로 변환하여 반환
-- INITCAP() 는 첫 글자만 대문자로 하고 나머지는 모두 소문자로 변환하여 반환


--○ 'SalEsmAn'으로 EMP 테이블에서 SALESMAN 직종을 검색할 수 있는 쿼리문 작성
SELECT *
FROM TBL_EMP
WHERE JOB = UPPER('SalEsmAn');
--==>>
/*
7499	ALLEN	SALESMAN	7698	1981-02-20	1600	 300	30
7521	WARD	SALESMAN	7698	1981-02-22	1250	 500	30
7654	MARTIN	SALESMAN	7698	1981-09-28	1250	1400	30
7844	TURNER	SALESMAN	7698	1981-09-08	1500	   0	30
*/

INSERT INTO TBL_EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(8000, '안정미', 'salesMAN', 7698, SYSDATE, 2000, 200, 30);
INSERT INTO TBL_EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(8001, '심혜진', 'SalesMan', 7698, SYSDATE, 2000, 200, 30);
INSERT INTO TBL_EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(8002, '박정준', 'salesman', 7698, SYSDATE, 2000, 200, 30);
INSERT INTO TBL_EMP (EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(8003, '전혜림', 'SALESman', 7698, SYSDATE, 2000, 200, 30);
--==>> 1 행 이(가) 삽입되었습니다. * 4


SELECT *
FROM TBL_EMP;
--==>>
/*
7369	SMITH	CLERK	    7902	1980-12-17	800		20
7499	ALLEN	SALESMAN	7698	1981-02-20	1600	300	    30
7521	WARD	SALESMAN	7698	1981-02-22	1250	500	    30
7566	JONES	MANAGER	    7839	1981-04-02	2975		    20
7654	MARTIN	SALESMAN	7698	1981-09-28	1250	1400	30
7698	BLAKE	MANAGER	    7839	1981-05-01	2850		    30
7782	CLARK	MANAGER	    7839	1981-06-09	2450		    10
7788	SCOTT	ANALYST	    7566	1987-07-13	3000		    20
7839	KING	PRESIDENT		    1981-11-17	5000		    10
7844	TURNER	SALESMAN	7698	1981-09-08	1500	0	    30
7876	ADAMS	CLERK	    7788	1987-07-13	1100		    20
7900	JAMES	CLERK	    7698	1981-12-03	950		        30
7902	FORD	ANALYST	    7566	1981-12-03	3000		    20
7934	MILLER	CLERK	    7782	1982-01-23	1300		    10
8000	안정미	salesMAN	7698	2021-03-26	2000	200	    30
8001	심혜진	SalesMan	7698	2021-03-26	2000	200	    30
8002	박정준	salesman	7698	2021-03-26	2000	200	    30
8003	전혜림	SALESman	7698	2021-03-26	2000	200	    30
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.


--○ TBL_EMP 테이블에서 대소문자 구분없이 세일즈맨 직종인 사원의
--   사원번호, 사원명, 직종, 입사일, 부서번호 항목을 조회한다.

-- 내가 풀이한 내용
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종", HIREDATE "입사일", DEPTNO "부서번호"
FROM TBL_EMP
WHERE UPPER(JOB) = UPPER('SALESMAN'); 
--==>>
/*
7499	ALLEN	SALESMAN	1981-02-20	30
7521	WARD	SALESMAN	1981-02-22	30
7654	MARTIN	SALESMAN	1981-09-28	30
7844	TURNER	SALESMAN	1981-09-08	30
8000	안정미	salesMAN	2021-03-26	30
8001	심혜진	SalesMan	2021-03-26	30
8002	박정준	salesman	2021-03-26	30
8003	전혜림	SALESman	2021-03-26	30
*/

-- 함께 풀이한 내용
-- 방법 1 (문제에서 요구한 방식은 아님)
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종", HIREDATE "입사일", DEPTNO "부서번호"
FROM TBL_EMP
WHERE JOB IN ('SALESMAN', 'salesMAN', 'SalesMan', 'salesman', 'SALESman'); 
--==>>
/*
7499	ALLEN	SALESMAN	1981-02-20	30
7521	WARD	SALESMAN	1981-02-22	30
7654	MARTIN	SALESMAN	1981-09-28	30
7844	TURNER	SALESMAN	1981-09-08	30
8000	안정미	salesMAN	2021-03-26	30
8001	심혜진	SalesMan	2021-03-26	30
8002	박정준	salesman	2021-03-26	30
8003	전혜림	SALESman	2021-03-26	30
*/

-- 방법 2 → 사용자 입력 값이 바뀌면 쿼리문도 바꿔줘야하는 번거로움 발생
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종", HIREDATE "입사일", DEPTNO "부서번호"
FROM TBL_EMP
WHERE UPPER(JOB) = 'SALESMAN'; 

-- 방법 3 → UPPER(), LOWER(), INITCAP() 을 양쪽에 통일해서 씌워준다.
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종", HIREDATE "입사일", DEPTNO "부서번호"
FROM TBL_EMP
WHERE UPPER(JOB) = UPPER('SALESMAN');



--○ TBL_EMP 테이블에서 입사일이 1981년 9월 28일 입사한 직원의
--   사원명, 직종명, 입사일 항목을 조회한다.

-- 내가 풀이한 내용
SELECT ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE = '1981-09-28';
--==>>
/*
MARTIN	SALESMAN	1981-09-28
*/


-- 함께 풀이한 내용
SELECT ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE = '1981-09-28';
--==>> MARTIN	SALESMAN	1981-09-28
--> 엄밀히 말하면 틀린 쿼리문이다. 날짜타입과 문자타입을 비교하고 있기 때문
--  오라클이 날짜형식을 갖고있는 문자타입을 자동으로 형변환 해준 것.
--  오라클의 형변환은 자바의 형변환처럼 믿을만한 존재가 아님.
--  오라클의 형변환을 신뢰하지 말 것. 명시적 형변환을 사용해야함.

DESC TBL_EMP;

--○ TO_DATE()

SELECT '2021-03-26' "1", TO_DATE('2021-03-26', 'YYYY-MM-DD') "2"
FROM DUAL;
--==>> 2021-03-26	2021-03-26
--     ----------   ----------
--      문자타입     날짜타입

-- 올바른 쿼리문
SELECT ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE = TO_DATE('1981-09-28', 'YYYY-MM-DD');
--==>> MARTIN	SALESMAN	1981-09-28
-- TO_DATE() 함수는 매개변수를 넘겨받으면서 날짜에 대한 유효성 검사를 수행한다.

SELECT TO_DATE('2021-02-30', 'YYYY-MM-DD') "결과확인"
FROM DUAL;
--==>> 에러 발생
/*
ORA-01839: date not valid for month specified
01839. 00000 -  "date not valid for month specified"
*Cause:    
*Action:
*/
--> 2월 30일, 13월 등 유효하지 않은 날짜를 입력 시 에러를 발생시킴


--○ TBL_EMP 테이블에서 입사일이 1981년 9월 28일 이후(해당일 포함)로
--   입사한 직원의 사원명, 직종명, 입사일 항목을 조회한다.

-- 내가 풀이한 내용
SELECT ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE >= TO_DATE('1981-09-28', 'YYYY-MM-DD');
--==>>
/*
MARTIN	SALESMAN	1981-09-28
SCOTT	ANALYST	    1987-07-13
KING	PRESIDENT	1981-11-17
ADAMS	CLERK	    1987-07-13
JAMES	CLERK	    1981-12-03
FORD	ANALYST	    1981-12-03
MILLER	CLERK	    1982-01-23
안정미	salesMAN	2021-03-26
심혜진	SalesMan	2021-03-26
박정준	salesman	2021-03-26
전혜림	SALESman	2021-03-26
*/

-- 함께 풀이한 내용
SELECT ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE >= TO_DATE('1981-09-28', 'YYYY-MM-DD');
--==>>
/*
MARTIN	SALESMAN	1981-09-28
SCOTT	ANALYST	1987-07-13
KING	PRESIDENT	1981-11-17
ADAMS	CLERK	1987-07-13
JAMES	CLERK	1981-12-03
FORD	ANALYST	1981-12-03
MILLER	CLERK	1982-01-23
안정미	salesMAN	2021-03-26
심혜진	SalesMan	2021-03-26
박정준	salesman	2021-03-26
전혜림	SALESman	2021-03-26
*/


--※ 오라클에서는 날짜 데이터의 크기 비교가 가능하다.
--   오라클에서 날짜 데이터에 대한 크기 비교 시
--   과거보다 미래를 더 큰 값으로 간주하여 처리된다.

--○ TBL_EMP 테이블에서 입사일이 1981년 4월 2일 부터
--   1981년 9월 28일 사이에 입사한 직원들의
--   사원번호, 사원명, 직종명, 입사일 항목을 조회한다. (해당일 포함)

-- 내가 풀이한 내용
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE >= TO_DATE('1981-04-02','YYYY-MM-DD') AND HIREDATE <= TO_DATE('1981-09-28', 'YYYY-MM-DD'); 
--==>>
/*
7566	JONES	MANAGER	    1981-04-02
7654	MARTIN	SALESMAN	1981-09-28
7698	BLAKE	MANAGER	    1981-05-01
7782	CLARK	MANAGER	    1981-06-09
7844	TURNER	SALESMAN	1981-09-08
*/


-- 함께 풀이한 내용
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE >= TO_DATE('1981-04-02', 'YYYY-MM-DD') 
  AND HIREDATE <= TO_DATE('1981-09-28', 'YYYY-MM-DD');
--==>> 
/*
7566	JONES	MANAGER	    1981-04-02
7654	MARTIN	SALESMAN	1981-09-28
7698	BLAKE	MANAGER	    1981-05-01
7782	CLARK	MANAGER	    1981-06-09
7844	TURNER	SALESMAN	1981-09-08
*/

--○ BETWEEN ⓐ AND ⓑ → 날짜를 대상으로 적용
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", HIREDATE "입사일"
FROM TBL_EMP
WHERE HIREDATE BETWEEN TO_DATE('1981-04-02', 'YYYY-MM-DD') 
                   AND TO_DATE('1981-09-28', 'YYYY-MM-DD');
--==>>
/*
7566	JONES	MANAGER	    1981-04-02
7654	MARTIN	SALESMAN	1981-09-28
7698	BLAKE	MANAGER	    1981-05-01
7782	CLARK	MANAGER	    1981-06-09
7844	TURNER	SALESMAN	1981-09-08
*/


--○ BETWEEN ⓐ AND ⓑ → 숫자를 대상으로 적용
SELECT EMPNO, ENAME, SAL
FROM TBL_EMP
WHERE SAL BETWEEN 1600 AND 3000;
--==>>
/*
7499	ALLEN	1600
7566	JONES	2975
7698	BLAKE	2850
7782	CLARK	2450
7788	SCOTT	3000
7902	FORD	3000
8000	안정미	2000
8001	심혜진	2000
8002	박정준	2000
8003	전혜림	2000
*/


--○ BETWEEN ⓐ AND ⓑ → 문자를 대상으로 적용
SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE ENAME BETWEEN 'C' AND 'S';
--==>>
/*
7566	JONES	MANAGER	    2975
7654	MARTIN	SALESMAN	1250
7782	CLARK	MANAGER	    2450
7839	KING	PRESIDENT	5000
7900	JAMES	CLERK	     950
7902	FORD	ANALYST	    3000
7934	MILLER	CLERK	    1300
*/
-- S를 포함하지 않는 것이 아니라 딱 'S' 까지만 나오기 때문에
-- SA~~, SC~~ 같은 문자는 안나온 것. 

SELECT EMPNO, ENAME, JOB, SAL
FROM TBL_EMP
WHERE ENAME BETWEEN 'C' AND 'S';


--※ BETWEEN ⓐ AND ⓑ 는 날짜형, 숫자형, 문자형 데이터 모두에 적용된다.
--   단, 문자형일 경우 아스키코드 순서를 따르기 때문에
--   대문자가 앞쪽에 위치하고, 소문자가 뒤쪽에 위치한다.
--   또한, BETWEEN ⓐ AND ⓑ 는 쿼리문이 수행되는 시점에서
--   오라클 내부적으로는 부등호 연산자의 형태로 바뀌어 연산이 처리된다. 

--○ ASCII()
SELECT ASCII('A') "1", ASCII('B') "2", ASCII('a') "3", ASCII('b') "4"
FROM DUAL;


DELETE
FROM TBL_EMP
WHERE EMPNO BETWEEN 8000 AND 8003;
--==>> 4개 행 이(가) 삭제되었습니다.

COMMIT;
--==>> 커밋 완료.

--○ TBL_EMP 테이블에서 직종이 SALESMAN 과 CLERK 인 사원의
--   사원번호, 사원명, 직종명, 급여 항목을 조회한다.

-- 내가 풀이한 내용
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여"
FROM TBL_EMP
WHERE UPPER(JOB) IN (UPPER('SALESMAN'), UPPER('CLERK')); 
--==>>
/*
7369	SMITH	CLERK	800
7499	ALLEN	SALESMAN	1600
7521	WARD	SALESMAN	1250
7654	MARTIN	SALESMAN	1250
7844	TURNER	SALESMAN	1500
7876	ADAMS	CLERK	1100
7900	JAMES	CLERK	950
7934	MILLER	CLERK	1300
*/

-- 함께 풀이한 내용
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여"
FROM TBL_EMP
WHERE JOB = 'SALESMAN' 
   OR JOB = 'CLERK'; 
   
SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여"
FROM TBL_EMP
WHERE JOB IN ('SALESMAN', 'CLERK'); 


SELECT EMPNO "사원번호", ENAME "사원명", JOB "직종명", SAL "급여"
FROM TBL_EMP
WHERE JOB =ANY ('SALESMAN', 'CLERK'); 
--==>>
/*
7369	SMITH	CLERK	     800
7499	ALLEN	SALESMAN	1600
7521	WARD	SALESMAN	1250
7654	MARTIN	SALESMAN	1250
7844	TURNER	SALESMAN	1500
7876	ADAMS	CLERK	    1100
7900	JAMES	CLERK	     950
7934	MILLER	CLERK	    1300
*/
--> 『=ANY』 아무거나랑 같으면
--> 『=ALL』 이거랑도 같고 저거랑도 같고 그거랑도 같을 때

--※ 위의 3가지 유형의 쿼리문은 모두 같은 결과를 반환한다.
--   하지만, 맨 위의 쿼리문이 가장 빠르게 처리된다.
--   물론, 메모리에 대한 내용이 아니라 CPU에 대한 내용이므로
--   이 부분까지 감안해서 쿼리문의 내용을 구분하여 구성하는 일은 많지 않다.
--   → 『IN』과 『=ANY』 는 같은 연산자 효과를 가진다.
--      모두 내부적으로는 『OR』 구조로 변경되어 연산 처리된다.


--------------------------------------------------------------------------------

--○ 추가 실습 테이블 구성(TBL_SAWON)
CREATE TABLE TBL_SAWON
( SANO      NUMBER(4)
, SANAME    VARCHAR2(30)
, JUBUN     CHAR(13)
, HIREDATE  DATE        DEFAULT SYSDATE
, SAL       NUMBER(10)
);
--==>> Table TBL_SAWON이(가) 생성되었습니다.

SELECT *
FROM TBL_SAWON;


DESC TBL_SAWON;
--==>>
/*
이름       널? 유형           
-------- -- ------------ 
SANO        NUMBER(4)    
SANAME      VARCHAR2(30) 
JUBUN       CHAR(13)     
HIREDATE    DATE         
SAL         NUMBER(10)   
*/


--○ 데이터 입력
INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1001, '김가영', '9402252234567', TO_DATE('2001-01-03', 'YYYY-MM-DD'), 3000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1002, '김서현', '9412272234567', TO_DATE('2010-11-05', 'YYYY-MM-DD'), 2000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1003, '김아별', '9303082234567', TO_DATE('1999-08-16', 'YYYY-MM-DD'), 5000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1004, '이유림', '9609142234567', TO_DATE('2008-02-02', 'YYYY-MM-DD'), 4000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1005, '정주희', '9712242234567', TO_DATE('2009-07-15', 'YYYY-MM-DD'), 2000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1006, '한혜림', '9710062234567', TO_DATE('2009-07-15', 'YYYY-MM-DD'), 2000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1007, '이하이', '0405064234567', TO_DATE('2010-06-05', 'YYYY-MM-DD'), 1000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1008, '아이유', '0103254234567', TO_DATE('2012-07-13', 'YYYY-MM-DD'), 3000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1009, '정준이', '9804251234567', TO_DATE('2007-07-08', 'YYYY-MM-DD'), 4000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1010, '이이제', '0204254234567', TO_DATE('2008-12-10', 'YYYY-MM-DD'), 2000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1011, '선동열', '7505071234567', TO_DATE('1990-10-10', 'YYYY-MM-DD'), 3000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1012, '선우선', '9912122234567', TO_DATE('2002-10-10', 'YYYY-MM-DD'), 2000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1013, '선우용녀', '7101092234567', TO_DATE('1991-11-11', 'YYYY-MM-DD'), 1000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1014, '남주혁', '0203043234567', TO_DATE('2010-05-05', 'YYYY-MM-DD'), 2000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1015, '남궁선', '0512123234567', TO_DATE('2012-08-14', 'YYYY-MM-DD'), 1000);

INSERT INTO TBL_SAWON(SANO, SANAME, JUBUN, HIREDATE, SAL)
VALUES(1016, '남이', '7012121234567', TO_DATE('1990-08-14', 'YYYY-MM-DD'), 2000);
--==>> 1 행 이(가) 삽입되었습니다. * 16


--○ 확인
SELECT *
FROM TBL_SAWON;
--==>>
/*
1001	김가영	    9402252234567	2001-01-03	3000
1002	김서현	    9412272234567	2010-11-05	2000
1003	김아별	    9303082234567	1999-08-16	5000
1004	이유림	    9609142234567	2008-02-02	4000
1005	정주희	    9712242234567	2009-07-15	2000
1006	한혜림	    9710062234567	2009-07-15	2000
1007	이하이	    0405064234567	2010-06-05	1000
1008	아이유	    0103254234567	2012-07-13	3000
1009	정준이	    9804251234567	2007-07-08	4000
1010	이이제	    0204254234567	2008-12-10	2000
1011	선동열	    7505071234567	1990-10-10	3000
1012	선우선	    9912122234567	2002-10-10	2000
1013	선우용녀	7101092234567	1991-11-11	1000
1014	남주혁	    0203043234567	2010-05-05	2000
1015	남궁선	    0512123234567	2012-08-14	1000
1016	남이	    7012121234567	1990-08-14	2000
*/


--○ 커밋
COMMIT;
--==>> 커밋 완료.

--○ TBL_SAWON 테이블에서 김가영 사원의 정보를 모두 조회한다.
SELECT *
FROM TBL_SAWON
WHERE SANAME = '김가영';
--==>> 1001	김가영	9402252234567	2001-01-03	3000


SELECT *
FROM TBL_SAWON
WHERE SANAME LIKE '김가영';
--==>> 1001	김가영	9402252234567	2001-01-03	3000


--※ LIKE : 동사 → 좋아하다
--        : 부사 → ~와 같이, ~처럼     CHECK~!!!

--※ WILD CARD(CHARACTER) → 『%』
--   『LIKE』와 함께 사용되는 『%』는 모든 글자를 의미한다.
--   『LIKE』와 함께 사용되는 『_』는 아무 글자 1개를 의미한다.


--○ TBL_SAWON 테이블에서 성씨가 『이』씨인 사원의
--   사원명, 주민번호, 급여 항목을 조회한다.
SELECT SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE SANAME = '이';
--==>> 조회 결과 없음

SELECT SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE SANAME = '이__';
--==>> 조회 결과 없음

SELECT SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '이__';
--==>> 
/*
이유림	9609142234567	4000
이하이	0405064234567	1000
이이제	0204254234567	2000
*/

SELECT SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '이_';
--==>> 조회 결과 없음

SELECT SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '이%';
--==>>
/*
이유림	9609142234567	4000
이하이	0405064234567	1000
이이제	0204254234567	2000
*/


--○ TBL_SAWON 테이블에서 이름의 마지막 글자가 『림』으로
--   끝나는 사원의 사원명, 주민번호, 입사일, 급여 항목을 조회한다.

-- 내가 풀이한 내용
-- 방법 1
SELECT SANAME "사원명", JUBUN "주민번호", HIREDATE "입사일", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '%림';
--==>>
/*
이유림	9609142234567	2008-02-02	4000
한혜림	9710062234567	2009-07-15	2000
*/
-- 『%림』 은 '림' 한 글자만 있어도 찾아진다. 

-- 방법 2
SELECT SANAME "사원명", JUBUN "주민번호", HIREDATE "입사일", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '__림';
--==>> 
/*
이유림	9609142234567	2008-02-02	4000
한혜림	9710062234567	2009-07-15	2000
*/


--○ TBL_SAWON 테이블에서 이름의 두 번째 글자가 『이』인 사원의
--   사원명, 주민번호, 입사일, 급여 항목을 조회한다.
SELECT SANAME "사원명", JUBUN "주민번호", HIREDATE "입사일", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '_이%';
--==>> 
/*
아이유	0103254234567	2012-07-13	3000
이이제	0204254234567	2008-12-10	2000
남이	7012121234567	1990-08-14	2000
*/

--○ TBL_SAWON 테이블에서 이름에 『이』라는 글자가
--   하나라도 포함되어 있으면 그 사원의
--   사원명, 주민번호, 입사일, 급여 항목을 조회한다.
SELECT SANAME "사원명", JUBUN "주민번호", HIREDATE "입사일", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '%이%';
--==>>
/*
이유림	9609142234567	2008-02-02	4000
이하이	0405064234567	2010-06-05	1000
아이유	0103254234567	2012-07-13	3000
정준이	9804251234567	2007-07-08	4000
이이제	0204254234567	2008-12-10	2000
남이	7012121234567	1990-08-14	2000
*/


--○ TBL_SAWON 테이블에서 이름에 『이』라는 글자가
--   연속으로 두 번 포함되어 있으면 그 사원의
--   사원명, 주민번호, 입사일, 급여 항목을 조회한다.
SELECT SANAME "사원명", JUBUN "주민번호", HIREDATE "입사일", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '%이이%';
--==>> 이이제	0204254234567	2008-12-10	2000



--○ TBL_SAWON 테이블에서 이름에 『이』라는 글자가
--   두 번 포함되어 있으면 그 사원의
--   사원명, 주민번호, 입사일, 급여 항목을 조회한다.
SELECT SANAME "사원명", JUBUN "주민번호", HIREDATE "입사일", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '%이%이%';
--==>> 
/*
1007	이하이	0405064234567	2010-06-05	1000
1010	이이제	0204254234567	2008-12-10	2000
*/


--○ TBL_SAWON 테이블에서 성씨가 남씨인 사원의
--   사원명, 주민번호, 급여 항목을 조회한다.
SELECT SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE SANAME LIKE '남%';
--==>>
/*
남주혁	0203043234567	2000
남궁선	0512123234567	1000
남이	7012121234567	2000
*/


--○ TBL_SAWON 테이블에서 성씨가 남씨인 사원의
--   사원명, 주민번호, 급여 항목을 조회한다.

--○ TBL_SAWON 테이블에서 성씨가 선씨인 사원의
--   사원명, 주민번호, 급여 항목을 조회한다.

--※ 데이터베이스 설계 시 성과 이름을 분리해서 처리해야 할
--  업무 계획이 있다면 (지금 당장은 아니더라도)
--  테이블에서 성 컬럼과 이름 컬럼을 분리하여 구성해야 한다. 


--○ TBL_SAWON 테이블에서 여직원들의 사원명, 주민번호, 급여 항목을 조회한다.
SELECT SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE JUBUN LIKE '______2______' 
   OR JUBUN LIKE '______4______'; 
--==>>
/*
김가영	    9402252234567	3000
김서현	    9412272234567	2000
김아별	    9303082234567	5000
이유림	    9609142234567	4000
정주희	    9712242234567	2000
한혜림	    9710062234567	2000
이하이	    0405064234567	1000
아이유	    0103254234567	3000
이이제	    0204254234567	2000
선우선	    9912122234567	2000
선우용녀	7101092234567	1000
*/

SELECT SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE JUBUN LIKE '______2%' 
   OR JUBUN LIKE '______4%'; 
--==>>
/*
김가영	    9402252234567	3000
김서현	    9412272234567	2000
김아별	    9303082234567	5000
이유림	    9609142234567	4000
정주희	    9712242234567	2000
한혜림	    9710062234567	2000
이하이	    0405064234567	1000
아이유	    0103254234567	3000
이이제	    0204254234567	2000
선우선	    9912122234567	2000
선우용녀	7101092234567	1000
*/

--○ 실습 테이블 생성(TBL_WATCH)
CREATE TABLE TBL_WATCH
( WATCH_NAME    VARCHAR2(20)
, BIGO          VARCHAR2(100)
);
--==>> Table TBL_WATCH이(가) 생성되었습니다.


--○ 데이터 입력
INSERT INTO TBL_WATCH(WATCH_NAME, BIGO)
VALUES('금시계', '순금 99.99% 함유된 최고급 시계');
INSERT INTO TBL_WATCH(WATCH_NAME, BIGO)
VALUES('은시계', '고객 만족도 99.99점을 획득한 시계');
--==>> 1 행 이(가) 삽입되었습니다. * 2


--○ 확인
SELECT *
FROM TBL_WATCH;
--==>>
/*
금시계	순금 99.99% 함유된 최고급 시계
은시계	고객 만족도 99.99점을 획득한 시계
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.


--○ TBL_WATCH 테이블의 BIGO 컬럼에
--   『99.99%』 라는 글자가 들어있는 행(레코드)의 정보를 조회한다.

-- 내가 풀이한 내용
SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '%99.99%__________';
--==>> 금시계	순금 99.99% 함유된 최고급 시계


-- 함께 풀이한 내용
SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '99.99%';
--==>> 조회 결과 없음

SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '%99.99%%';
--==>>
/*
금시계	순금 99.99% 함유된 최고급 시계
은시계	고객 만족도 99.99점을 획득한 시계
*/

SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '%99.99\%%' ESCAPE '\';
--==>> 금시계	순금 99.99% 함유된 최고급 시계


SELECT *
FROM TBL_WATCH
WHERE BIGO LIKE '%99.99$%%' ESCAPE '$';
--==>> 금시계	순금 99.99% 함유된 최고급 시계


--※ ESCAPE 로 정한 문자의 다음 한 글자는 와일드카드(캐릭터)에서 탈출시켜라...
--   『ESCAPE '\'』
--   일반적으로 키워드가 아닌, 연산자도 아닌, 사용빈도가 낮은 특수문자(특수기호)를 사용한다.


--------------------------------------------------------------------------------

--■■■ COMMIT / ROLLBACK ■■■--

SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/


--○ 데이터 입력
INSERT INTO TBL_DEPT VALUES(50, '개발부', '서울');
--==>> 1 행 이(가) 삽입되었습니다.
-- 50번... 개발부... 서울...
-- 이 데이터는 TBL_DEPT 테이블이 저장되어 있는
-- 하드디스크상에 물리적으로 적용되어 저장된 것이 아니라
-- 메모리(RAM) 상에 입력된 것이다.

--○ 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
50	개발부	    서울
*/

--○ 롤백
ROLLBACK;
--==>> 롤백 완료.

SELECT *
FROM TBL_DEPT;
--==>> 
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/
--> 50번... 개발부... 서울...
--  에 대한 데이터가 소실되었음을 확인(존재하지 않음)

--○ 다시 입력
INSERT INTO TBL_DEPT VALUES(50, '개발부', '서울');
--==>> 1 행 이(가) 삽입되었습니다.
--> 메모리상에 입력된 이 데이터를 실제 하드디스크상에 물리적으로 저장하기 위해서는
--  COMMIT 을 수행해야 한다.

--○ 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
50	개발부	    서울
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.

--○ 커밋 이후 다시 확인
SELECT *
FROM TBL_DEPT;
--==>> 
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
50	개발부	    서울
*/

--○ 롤백
ROLLBACK;
--==>> 롤백 완료.

--○ 롤백 이후 다시 확인
SELECT *
FROM TBL_DEPT;
--==>> 
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
50	개발부	    서울
*/
--> 롤백(ROLLBACK)을 수행했음에도 불구하고
--  50번 개발부 서울...의 데이터는 소실되지 않았음을 확인

--※ COMMIT을 실행한 이후로 DML 구문(INSERT, UPDATE, DELETE 등)을 통해
--   변경된 데이터만 취소할 수 있는 것일 뿐...
--   DML(INSERT, UPDATE, DELETE 등) 명령을 사용한 후 COMMIT 하고나서 ROLLBACK 을 실행해봐야
--   이전 상태로 되돌릴 수 없다. (아무런 소용이 없다.)
--   Q. 롤백은 가장 최근의 커밋 상태로 만드는 것이라고 봐도 되는가?
--   A. 맞긴 하지만, 이것도 오토커밋을 하는 구문이 있어서 애매하다고 볼 수 있음. 나중에 정리해줄 것임.


--○ 데이터 수정(TBL_DEPT)
-- 업데이트 시킬 수 있는 대상은 기본적으로 TABLE임
UPDATE TBL_DEPT
SET DNAME = '연구부', LOC = '경기'
WHERE DEPTNO = 50;
--==>> 1 행 이(가) 업데이트되었습니다.

--○ 확인
SELECT *
FROM TBL_DEPT;
--==>> 
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
50	연구부	경기
*/

--○ 롤백
ROLLBACK;
--==>> 롤백 완료.


--○ 확인
SELECT *
FROM TBL_DEPT;
--==>> 
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
50	개발부	서울
*/
--> 수정(UPDATE)을 수행하기 이전 상태로 복원되었음을 확인


--○ 데이터 삭제(TBL_DEPT)
SELECT *
FROM TBL_DEPT
WHERE DEPTNO = 50;
--==>> 50	개발부	서울

DELETE
FROM TBL_DEPT
WHERE DEPTNO = 50;
--==>> 1 행 이(가) 삭제되었습니다.

--○ 확인
SELECT *
FROM TBL_DEPT;
--==>>
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
*/

--○ 롤백
ROLLBACK;
--==>> 롤백 완료.

--○ 롤백 이후 다시 확인
SELECT *
FROM TBL_DEPT;
--==>> 
/*
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	    CHICAGO
40	OPERATIONS	BOSTON
50	개발부	    서울
*/
--> 삭제(DELETE) 구문을 수행하기 이전 상태로 복원되었음을 확인.
--> Transaction Control Language(TCL) : COMMIT, ROLLBACK


--------------------------------------------------------------------------------

--■■■ 정렬(ORDER BY) 절 ■■■--

-- 정렬은 리소스 소모가 심하다, 부하가 심하다.

SELECT ENAME "사원명", DEPTNO "부서번호", JOB "직종", SAL "급여"
     , SAL*12+NVL(COMM, 0) "연봉"
FROM TBL_EMP;
--==>>
/*
SMITH	20	CLERK	     800	9600
ALLEN	30	SALESMAN	1600	19500
WARD	30	SALESMAN	1250	15500
JONES	20	MANAGER	    2975	35700
MARTIN	30	SALESMAN	1250	16400
BLAKE	30	MANAGER	    2850	34200
CLARK	10	MANAGER	    2450	29400
SCOTT	20	ANALYST	    3000	36000
KING	10	PRESIDENT	5000	60000
TURNER	30	SALESMAN	1500	18000
ADAMS	20	CLERK	    1100	13200
JAMES	30	CLERK	     950	11400
*/

SELECT ENAME "사원명", DEPTNO "부서번호", JOB "직종", SAL "급여"
     , SAL*12+NVL(COMM, 0) "연봉"
FROM TBL_EMP
ORDER BY DEPTNO ASC;        -- DEPTNO → 부서번호 기준 정렬
                            -- ASC    → 오름차순 정렬
--==>>
/*
CLARK	10	MANAGER	    2450	29400
KING	10	PRESIDENT	5000	60000
MILLER	10	CLERK	    1300	15600
JONES	20	MANAGER	    2975	35700
FORD	20	ANALYST	    3000	36000
ADAMS	20	CLERK	    1100	13200
SMITH	20	CLERK	     800	 9600
SCOTT	20	ANALYST	    3000	36000
WARD	30	SALESMAN	1250	15500
TURNER	30	SALESMAN	1500	18000
ALLEN	30	SALESMAN	1600	19500
JAMES	30	CLERK	     950	11400
BLAKE	30	MANAGER	    2850	34200
MARTIN	30	SALESMAN	1250	16400
*/


SELECT ENAME "사원명", DEPTNO "부서번호", JOB "직종", SAL "급여"
     , SAL*12+NVL(COMM, 0) "연봉"
FROM TBL_EMP
ORDER BY DEPTNO;        -- ASC → 오름차순 정렬 → 생략 가능~!!!


SELECT ENAME "사원명", DEPTNO "부서번호", JOB "직종", SAL "급여"
     , SAL*12+NVL(COMM, 0) "연봉"
FROM TBL_EMP
ORDER BY DEPTNO DESC;    -- DEPTNO → 부서번호 기준 정렬
                         -- ASC    → 내림차순 정렬       → 생략 불가~!!!             
-- 오라클은 키워드보다 이 키워드가 어느 위치에 있는지를 훨씬 더 중요하게 생각함.
-- Ex. DESC 는 DESCENDING, DESCRIBE 둘 다 사용


--○ 급여 기준 내림차순 정렬
SELECT ENAME "사원명", DEPTNO "부서번호", JOB "직종", SAL "급여"
     , SAL*12+NVL(COMM, 0) "연봉"
FROM TBL_EMP
ORDER BY SAL DESC;
--==>> 
/*
KING	10	PRESIDENT	5000	60000
FORD	20	ANALYST	    3000	36000
SCOTT	20	ANALYST	    3000	36000
JONES	20	MANAGER	    2975	35700
BLAKE	30	MANAGER	    2850	34200
CLARK	10	MANAGER	    2450	29400
ALLEN	30	SALESMAN	1600	19500
TURNER	30	SALESMAN	1500	18000
MILLER	10	CLERK	    1300	15600
WARD	30	SALESMAN	1250	15500
MARTIN	30	SALESMAN	1250	16400
ADAMS	20	CLERK	    1100	13200
*/


--○ 연봉 기준 내림차순 정렬
SELECT ENAME "사원명", DEPTNO "부서번호", JOB "직종", SAL "급여"
     , SAL*12+NVL(COMM, 0) "연봉"
FROM TBL_EMP
ORDER BY "연봉" DESC;
--==>>
/*
KING	10	PRESIDENT	5000	60000
FORD	20	ANALYST	    3000	36000
SCOTT	20	ANALYST	    3000	36000
JONES	20	MANAGER	    2975	35700
BLAKE	30	MANAGER	    2850	34200
CLARK	10	MANAGER	    2450	29400
ALLEN	30	SALESMAN	1600	19500
TURNER	30	SALESMAN	1500	18000
MARTIN	30	SALESMAN	1250	16400
MILLER	10	CLERK	    1300	15600
WARD	30	SALESMAN	1250	15500
ADAMS	20	CLERK	    1100	13200
JAMES	30	CLERK	     950	11400
SMITH	20	CLERK	     800	 9600
*/
--> SELECT문의 파싱순서에서 ORDER BY보다 SELECT 절이 먼저 처리되기 때문에
--  ORDER BY 절에서 컬럼명 대신 SELECT에서 사용한 ALIAS(별칭)를 사용할 수 있다.
--  반대로 말하면, WHERE이나 GROUP BY, HAVING 절에서는 ALIAS를 사용할 수 없다.

SELECT ENAME "사원명", DEPTNO "부서 번호", JOB "직종", SAL "급여"
     , SAL*12+NVL(COMM, 0) "연봉"
FROM TBL_EMP
ORDER BY 부서 번호 DESC;
--==>> 에러 발생

SELECT ENAME "사원명", DEPTNO "부서 번호", JOB "직종", SAL "급여"
     , SAL*12+NVL(COMM, 0) "연봉"
FROM TBL_EMP
ORDER BY "부서 번호" DESC;
--==>>
/*
BLAKE	30	MANAGER	    2850	34200
TURNER	30	SALESMAN	1500	18000
ALLEN	30	SALESMAN	1600	19500
MARTIN	30	SALESMAN	1250	16400
WARD	30	SALESMAN	1250	15500
JAMES	30	CLERK	     950	11400
SCOTT	20	ANALYST	    3000	36000
JONES	20	MANAGER	    2975	35700
SMITH	20	CLERK	     800	 9600
ADAMS	20	CLERK	    1100	13200
FORD	20	ANALYST	    3000	36000
KING	10	PRESIDENT	5000	60000
MILLER	10	CLERK	    1300	15600
CLARK	10	MANAGER	    2450	29400
*/


SELECT ENAME "사원명", DEPTNO "부서 번호", JOB "직종", SAL "급여"
     , SAL*12+NVL(COMM, 0) "연봉"
FROM TBL_EMP
ORDER BY 2;     -- 두번째 컬럼 오름차순(SELECT 절에서 언급한 순서를 기준으로 두번째 컬럼)
                -- 이것도 ORDER BY 의 파싱순서가 SELECT 보다 뒤라서 가능
--==>>
/*
CLARK	10	MANAGER	    2450	29400
KING	10	PRESIDENT	5000	60000
MILLER	10	CLERK	    1300	15600
JONES	20	MANAGER	    2975	35700
FORD	20	ANALYST	    3000	36000
ADAMS	20	CLERK	    1100	13200
SMITH	20	CLERK	     800	 9600
SCOTT	20	ANALYST	    3000	36000
WARD	30	SALESMAN	1250	15500
TURNER	30	SALESMAN	1500	18000
ALLEN	30	SALESMAN	1600	19500
JAMES	30	CLERK	     950	11400
BLAKE	30	MANAGER	    2850	34200
MARTIN	30	SALESMAN	1250	16400
*/
--> TBL_EMP 테이블이 갖고 있는 테이블의 고유한 컬럼 순서가 아니라
--  SELECT 처리 되는 두 번재 컬럼(즉, DEPTNO)을 기준으로 정렬되는 것을 확인
--  ASC 생략된 상태 → 오름차순 정렬되는 것을 확인

SELECT ENAME, DEPTNO, JOB, SAL
FROM TBL_EMP
ORDER BY 2, 4;      -- DEPTNO 기준 1차 정렬 후 SAL 기준으로 2차 정렬
--==>> 
/*
MILLER	10	CLERK	    1300
CLARK	10	MANAGER	    2450
KING	10	PRESIDENT	5000
SMITH	20	CLERK	     800
ADAMS	20	CLERK	    1100
JONES	20	MANAGER	    2975
SCOTT	20	ANALYST	    3000
FORD	20	ANALYST	    3000
JAMES	30	CLERK	     950
MARTIN	30	SALESMAN	1250
WARD	30	SALESMAN	1250
TURNER	30	SALESMAN	1500
ALLEN	30	SALESMAN	1600
BLAKE	30	MANAGER	    2850
*/

SELECT ENAME, DEPTNO, JOB, SAL
FROM TBL_EMP
ORDER BY 2, 3, 4 DESC;
--> ① DEPTNO(부서번호) 기준 오름차순 정렬
--  ② JOB(직종명) 기준 오름차순 정렬
--  ③ SAL(급여) 기준 내림차순 정렬
--  (3차 정렬 수행)
--==>>
/*
MILLER	10	CLERK	    1300
CLARK	10	MANAGER	    2450
KING	10	PRESIDENT	5000
SCOTT	20	ANALYST	    3000
FORD	20	ANALYST	    3000
ADAMS	20	CLERK	    1100
SMITH	20	CLERK	     800
JONES	20	MANAGER	    2975
JAMES	30	CLERK	     950
BLAKE	30	MANAGER	    2850
ALLEN	30	SALESMAN	1600
TURNER	30	SALESMAN	1500
MARTIN	30	SALESMAN	1250
WARD	30	SALESMAN	1250
*/

--------------------------------------------------------------------------------

--○ CONCAT() → 문자열 결합 함수
SELECT '소서현' || '조은선' "1"
     , CONCAT('소서현', '조은선') "2"
FROM DUAL;
--==>> 소서현조은선	소서현조은선


SELECT ENAME || JOB "1"
     , CONCAT(ENAME, JOB) "2"
FROM TBL_EMP;
--==>> 
/*
SMITHCLERK	    SMITHCLERK
ALLENSALESMAN	ALLENSALESMAN
WARDSALESMAN	WARDSALESMAN
JONESMANAGER	JONESMANAGER
MARTINSALESMAN	MARTINSALESMAN
BLAKEMANAGER	BLAKEMANAGER
CLARKMANAGER	CLARKMANAGER
SCOTTANALYST	SCOTTANALYST
KINGPRESIDENT	KINGPRESIDENT
TURNERSALESMAN	TURNERSALESMAN
ADAMSCLERK	    ADAMSCLERK
JAMESCLERK	    JAMESCLERK
FORDANALYST	    FORDANALYST
MILLERCLERK	    MILLERCLERK
*/

SELECT ENAME || JOB || DEPTNO "1"
     , CONCAT(ENAME, JOB, DEPTNO) "2"
FROM TBL_EMP;
--==>> 에러 발생
--> 2개의 문자열을 결합시켜주는 기능을 가진 함수.
--  오로지 2개만 결합시킬 수 있다.

SELECT ENAME || JOB || DEPTNO "1"
     , CONCAT(CONCAT(ENAME, JOB), DEPTNO) "2"
FROM TBL_EMP;
--==>>
/*
SMITHCLERK20	    SMITHCLERK20
ALLENSALESMAN30	    ALLENSALESMAN30
WARDSALESMAN30	    WARDSALESMAN30
JONESMANAGER20	    JONESMANAGER20
MARTINSALESMAN30	MARTINSALESMAN30
BLAKEMANAGER30	    BLAKEMANAGER30
CLARKMANAGER10	    CLARKMANAGER10
SCOTTANALYST20	    SCOTTANALYST20
KINGPRESIDENT10	    KINGPRESIDENT10
TURNERSALESMAN30	TURNERSALESMAN30
ADAMSCLERK20	    ADAMSCLERK20
*/

--> 내부적인 형 변환이 일어나며 결합을 수행하게 된다.
--  CONCAT() 은 문자열과 문자열을 대상으로 결합을 수행하는 함수이지만
--  내부적으로는 숫자나 날짜를 문자 타입으로 바꾸어 주는 과정이 포함되어 있다.


--※ JAVA 의 String.subString()
/*
obj.subString()
---
 ↓
 문자열.subString(n, m); → 문자열 추출
                 ------
                 n 부터 m-1 까지 (0부터 시작하는 인덱스 적용)

*/

--○ SUBSTR() 개수 기반 / SUBSTRB() 바이트 기반 → 문자열 추출 함수
SELECT ENAME "1"
     , SUBSTR(ENAME, 1, 2) "2"
     , SUBSTR(ENAME, 2, 2) "3"
     , SUBSTR(ENAME, 3, 2) "4"
     , SUBSTR(ENAME, 2) "5"
FROM TBL_EMP;
--> 문자열을 추출하는 기능을 가진 함수
--  첫 번째 파라미터 값은 대상 문자열(추출의 대상)
--  두 번째 파라미터 값은 추출을 시작하는 위치(단, 인덱스는 1부터 시작)
--  세 번째 파라미터 값은 추출할 문자열의 개수(생략 시, 시작위치 부터 끝까지)
--==>> 
/*
SMITH	SM	MI	IT	MITH
ALLEN	AL	LL	LE	LLEN
WARD	WA	AR	RD	ARD
JONES	JO	ON	NE	ONES
MARTIN	MA	AR	RT	ARTIN
BLAKE	BL	LA	AK	LAKE
CLARK	CL	LA	AR	LARK
SCOTT	SC	CO	OT	COTT
KING	KI	IN	NG	ING
TURNER	TU	UR	RN	URNER
ADAMS	AD	DA	AM	DAMS
JAMES	JA	AM	ME	AMES
FORD	FO	OR	RD	ORD
MILLER	MI	IL	LL	ILLER
*/
--> 주의할 점 
--  ① 인덱스가 0부터 시작하는 것이 아니라 1부터 시작한다.
--  ② 3번째 매개변수로 넘겨주는 값은 인덱스가 아니라 개수이다. 
--  ③ 3번째 매개변수 생략하면 끝까지.


--○ TBL_SAWON 테이블에서 성별이 남성인 사원만
--   사원번호, 사원명, 주민번호, 급여 항목을 조회한다.
--   단, SUBSTR() 함수를 사용할 수 있도록 하며,
--   급여 기준으로 내림차순 정렬을 수행할 수 있도록 한다.

SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE SUBSTR(JUBUN, 7, 1) IN (1, 3)
ORDER BY SAL DESC;
--==>>
/*
1009	정준이	9804251234567	4000
1011	선동열	7505071234567	3000
1016	남이	7012121234567	2000
1014	남주혁	0203043234567	2000
1015	남궁선	0512123234567	1000
*/

DESC TBL_SAWON;

SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE SUBSTR(JUBUN, 7, 1) IN ('1', '3')
ORDER BY SAL DESC;
--==>>
/*
1009	정준이	9804251234567	4000
1011	선동열	7505071234567	3000
1016	남이	7012121234567	2000
1014	남주혁	0203043234567	2000
1015	남궁선	0512123234567	1000
*/













