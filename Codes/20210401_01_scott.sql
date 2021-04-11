SELECT USER
FROM DUAL;
--==>> SCOTT


--■■■ JOIN(조인) ■■■--

-- 1. SQL 1992 CODE

SELECT *
FROM EMP, DEPT;
--> 수학에서 말하는 데카르트 곱(Catersian Product)
--  두 테이블을 합친(결합한) 모든 경우의 수

-- Equi Join : 서로 정확히 일치하는 데이터들끼리 연결시키는 결합
SELECT *
FROM EMP, DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO;


SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO;


-- Non Equi Join : 범위 안에 적합한 데이터들끼리 연결시키는 결합
SELECT *
FROM SALGRADE;

SELECT *
FROM EMP;

SELECT *
FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;


-- Equi Join 시 『+』 를 활용한 결합 방법

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO;
--> 총 14건의 데이터가 결합되어 조회된 상황
--  즉, 부서번호를 갖지 못한 사원들(5인)은 모두 누락~!!!

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO = D.DEPTNO(+);
--> 총 19건의 데이터가 결합되어 조회된 상황
--  즉, 부서번호를 갖지 못한 사원들(5인)도 모두 조회된 상황~!!!

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO;
--> 총, 16건의 데이터가 결합되어 조회된 상황
--  즉, 부서에 소속된 사원이 아무도 없는 부서도 모두 조회된 상황~!!!


--※ (+)가 없는 쪽 테이블의 데이터를 모두 메모리에 적재한 후
--   (+)가 있는 쪽 테이블의 데이터를 하나하나 확인하여 결합시키는 형태로 JOIN.

SELECT *
FROM TBL_EMP E, TBL_DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO(+);
--> 위와 같은 이유로 이러한 형식의 JOIN 구문은 존재하지 않는다.


-- 2. SQL 1999 CODE → 『JOIN』 키워드 등장 → JOIN 유형 명시
--                     결합 조건은 『WHERE』 대신 『ON』

-- CROSS JOIN
SELECT *
FROM EMP CROSS JOIN DEPT;


-- INNER JOIN

SELECT *
FROM EMP E INNER JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

--※ INNER JOIN 시 INNER 는 생략 가능
SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM EMP E JOIN SALGRADE S
ON E.SAL BETWEEN S.LOSAL AND S.HISAL;

-- OUTER JOIN

SELECT *
FROM TBL_EMP E LEFT OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

--※ 방향이 지정된 쪽 테이블(→ LEFT)의 데이터를 모두 메모리에 적재한 후
--   방향이 지정되지 않은 쪽 테이블들의 데이터를 각각 확인하여 결합시키는 형태로 JOIN.

SELECT *
FROM TBL_EMP E RIGHT OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E FULL OUTER JOIN TBL_DEPT D
ON E.DEPTNO = D.DEPTNO;

--※ OUTER JOIN 에서 OUTER 는 생략 가능

SELECT *
FROM TBL_EMP E LEFT JOIN TBL_DEPT D         -- OUTER JOIN
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E RIGHT JOIN TBL_DEPT D        -- OUTER JOIN
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E FULL JOIN TBL_DEPT D         -- OUTER JOIN
ON E.DEPTNO = D.DEPTNO;

SELECT *
FROM TBL_EMP E JOIN TBL_DEPT D              -- INNER JOIN
ON E.DEPTNO = D.DEPTNO;

--------------------------------------------------------------------------------

SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
-- 이 결과에서... 직종이 CLERK 인 사원만 조회

SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
AND JOB = 'CLERK';
-- 이렇게 쿼리문을 구성해도 조회하는데는 문제가 없다.

SELECT *
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE JOB = 'CLERK';
-- 하지만, 이와 같이 구성하여 조회할 수 있도록 권장한다.

SELECT *
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
  AND JOB = 'CLERK';

--------------------------------------------------------------------------------

--○ EMP 테이블과 DEPT 테이블을 대상으로
--   직종이 MANAGER 와 CLERK 인 사원들만
--   부서번호, 부서명, 사원명, 직종명, 급여 항목을 조회한다.
--   --------  ------  ------  ------  ----
--    DEPTNO   DNAME   ENAME    JOB    SAL
--   --------  -----   -----   -----   ---
--     E, D      D       E       E      E

-- 내가 풀이한 내용 
SELECT D.DEPTNO "부서번호", D.DNAME "부서명", E.ENAME "사원명", E.JOB "직종명", E.SAL "급여" 
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE JOB IN ('MANAGER', 'CLERK');
--==>>
/*
부서번호  부서명	사원명	직종명	급여
10	    ACCOUNTING	CLARK	MANAGER	2450
10	    ACCOUNTING	MILLER	CLERK	1300
20	    RESEARCH	ADAMS	CLERK	1100
20	    RESEARCH	JONES	MANAGER	2975
20	    RESEARCH	SMITH	CLERK	 800
30	    SALES	    BLAKE	MANAGER	2850
30	    SALES	    JAMES	CLERK	 950
*/

SELECT D.DEPTNO "부서번호", D.DNAME "부서명", E.ENAME "사원명", E.JOB "직종명", E.SAL "급여" 
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO
  AND JOB IN ('MANAGER', 'CLERK');


-- 함께 풀이한 내용

SELECT DEPTNO "부서번호", DNAME "부서명", ENAME "사원명", JOB "직종명", SAL "급여" 
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
--==>> 에러 발생
/*
ORA-00918: column ambiguously defined
00918. 00000 -  "column ambiguously defined"
*Cause:    
*Action:
185행, 8열에서 오류 발생
*/
--> 두 테이블 간 중복되는 컬럼에 대한 소속 테이블을 
--  정해줘야 (명시해줘야) 한다

SELECT DNAME, ENAME, JOB, SAL
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
--==>> 
/*
DNAME	    ENAME	JOB	        SAL
ACCOUNTING	CLARK	MANAGER	    2450
ACCOUNTING	KING	PRESIDENT	5000
ACCOUNTING	MILLER	CLERK	    1300
RESEARCH	JONES	MANAGER	    2975
RESEARCH	FORD	ANALYST	    3000
RESEARCH	ADAMS	CLERK	    1100
RESEARCH	SMITH	CLERK	     800
RESEARCH	SCOTT	ANALYST	    3000
SALES	    WARD	SALESMAN	1250
SALES	    TURNER	SALESMAN    1500
SALES	    ALLEN	SALESMAN	1600
SALES	    JAMES	CLERK	     950
SALES	    BLAKE	MANAGER	    2850
SALES	    MARTIN	SALESMAN	1250
*/
--> 두 테이블 간 중복되는 컬럼이 존재하지 않는 조회 구문은
--  에러 발생하지 않는다.

SELECT D.DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;
--> 두 테이블 간 중복되는 컬럼에 대해 소속 테이블을 명시하는 경우
--  부서(DEPT), 사원(EMP) 중 어떤 테이블을 지정해도
--  쿼리문 수행에 대한 결과 반환에 문제가 없다.

--※ 하지만...
--   두 테이블 간 중복되는 컬럼에 대해 소속 테이블을 명시하는 경우
--   부모 테이블의 컬럼을 참조할 수 있도록 해야한다..

SELECT *
FROM DEPT;  -- 부모 테이블

SELECT *
FROM EMP;   -- 자식 테이블

-- ※ 부모 자식 테이블 관계를 명확히 정리할 수 있도록 한다.

--      DEPTNO
-- EMP -------- DEPT


SELECT D.DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E LEFT JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT E.DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E LEFT JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT D.DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E RIGHT JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;

SELECT E.DEPTNO, DNAME, ENAME, JOB, SAL
FROM EMP E RIGHT JOIN DEPT D
ON E.DEPTNO = D.DEPTNO;


-- 최종 쿼리
SELECT D.DEPTNO, D.DNAME, E.ENAME, E.JOB, E.SAL
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.JOB IN ('MANAGER', 'CLERK');
--> 두 테이블 간 중복된 컬럼이 아니더라도...
--  소속 테이블을 명시할 수 있도록 권장한다.


--○ SELF JOIN (자기 조인)
--  EMP 테이블의 정보를 다음과 같이 조회할 수 있도록 한다.
-----------------------------------------------------------------
--  사원번호  사원명  직종명  관리자번호  관리자명  관리자직종명
-----------------------------------------------------------------
--    7369	  SMITH	  CLERK	     7902       FORD	  ANALYST

-- 내가 풀이한 내용
SELECT *
FROM EMP;

SELECT E1.EMPNO "사원번호", E1.ENAME "사원명", E1.JOB "직종명", E2.EMPNO "관리자번호", E2.ENAME "관리자명", E2.JOB "관리자직종명"
FROM EMP E1 LEFT JOIN EMP E2
ON E1.MGR = E2.EMPNO;
--==>> 
/*
사원번호	사원명	직종명	관리자번호	관리자명	관리자직종명
7902	    FORD	ANALYST	    7566	JONES	    MANAGER
7788	    SCOTT	ANALYST	    7566	JONES	    MANAGER
7844	    TURNER	SALESMAN	7698	BLAKE	    MANAGER
7499	    ALLEN	SALESMAN	7698	BLAKE	    MANAGER
7521	    WARD	SALESMAN	7698	BLAKE	    MANAGER
7900	    JAMES	CLERK	    7698	BLAKE	    MANAGER
7654	    MARTIN	SALESMAN	7698	BLAKE	    MANAGER
7934	    MILLER	CLERK	    7782	CLARK	    MANAGER
7876	    ADAMS	CLERK	    7788	SCOTT	    ANALYST
7698	    BLAKE	MANAGER	    7839	KING	    PRESIDENT
7566	    JONES	MANAGER	    7839	KING	    PRESIDENT
7782	    CLARK	MANAGER	    7839	KING	    PRESIDENT
7369	    SMITH	CLERK	    7902	FORD	    ANALYST
7839	    KING	PRESIDENT			
*/

-- 함께 풀이한 내용
--   E       E      E      E       E      E
-- EMPNO   ENAME   JOB    MGR                  -- ① → E1
--                       EMPNO   ENAME   JOB   -- ② → E2

SELECT EMPNO, ENAME, JOB, MGR
FROM EMP;

SELECT E1.EMPNO "사원번호", E1.ENAME "사원명", E1.JOB "직종명"
     , E2.EMPNO "관리자번호", E2.ENAME "관리자명", E2.JOB "관리자직종명"
FROM EMP E1 JOIN EMP E2
ON E1.MGR = E2.EMPNO;
-- INNER JOIN 사용
-- 관리자가 없는 사원은 누락

SELECT E1.EMPNO "사원번호", E1.ENAME "사원명", E1.JOB "직종명"
     , E2.EMPNO "관리자번호", E2.ENAME "관리자명", E2.JOB "관리자직종명"
FROM EMP E1 LEFT JOIN EMP E2
ON E1.MGR = E2.EMPNO;
-- OUTER JOIN 사용
-- E1을 주인공으로 조회하였기 때문에 관리자가 없는 사원 KING 도 정상적으로 조회.
