SELECT USER
FROM DUAL;
--==>> HR

--○ EMPLOYESS 테이블의 직원들 SALARY 를 10% 인상한다.
--   단, 부서명이 'IT'인 경우로 한정한다.
--   (변경된 결과를 확인 후 ROLLBACK)
SELECT *
FROM DEPARTMENTS;
--==>>
/*
DEPARTMENT_ID	DEPARTMENT_NAME	    MANAGER_ID	LOCATION_ID
10	            Administration	    200	        1700
20	            Marketing	        201	        1800
30	            Purchasing	        114	        1700
40	            Human Resources	    203	        2400
50	            Shipping	        121	        1500
60	            IT	                103	        1400
70	            Public Relations	204	        2700
80	            Sales	            145	        2500
90	            Executive	        100	        1700
100	            Finance	            108	        1700
110	            Accounting	        205	        1700
120	            Treasury		                1700
130	            Corporate Tax		            1700
140	            Control And Credit		        1700
150	            Shareholder Services	        1700
160	            Benefits		                1700
170	            Manufacturing		            1700
180	            Construction		            1700
190	            Contracting		                1700
200	            Operations		                1700
210	            IT Support		                1700
220	            NOC		                        1700
230	            IT Helpdesk		                1700
240	            Government Sales		        1700
250	            Retail Sales		            1700
260	            Recruiting		                1700
270	            Payroll		                    1700
*/

-- 내가 풀이한 내용

-- (변경 대상 확인)
SELECT EMPLOYEE_ID, DEPARTMENT_ID, SALARY                      
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 60;
--==>>
/*
103	60	9000
104	60	6000
105	60	4800
106	60	4800
107	60	4200
*/

-- (업데이트 수행)
UPDATE EMPLOYEES
SET SALARY = SALARY * 1.1
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');
--==>> 5개 행 이(가) 업데이트되었습니다.

-- (변경 결과 확인)
SELECT EMPLOYEE_ID, DEPARTMENT_ID, SALARY                      
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');
--==>>
/*
103	60	9900
104	60	6600
105	60	5280
106	60	5280
107	60	4620
*/

-- (결과 확인 후 롤백)
ROLLBACK;


-- 함께 풀이한 내용
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, SALARY*1.1
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (DEPARTMENTS 테이블에서 IT 부서의 부서ID);

-- (업데이트 전 변경 대상 확인)
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID, SALARY*1.1
FROM EMPLOYEES
WHERE DEPARTMENT_ID = ( SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME = 'IT');
--==>>
/*
Alexander	Hunold	9000	60	9900
Bruce	Ernst	6000	60	6600
David	Austin	4800	60	5280
Valli	Pataballa	4800	60	5280
Diana	Lorentz	4200	60	4620
*/

-- (UPDATE)
UPDATE EMPLOYEES
SET SALARY = SALARY * 1.1
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');
--==>> 5개 행 이(가) 업데이트되었습니다.

-- (업데이트 후 다시 확인) 
SELECT FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID = ( SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME = 'IT');
--==>>
/*
Alexander	Hunold	    9900	60
Bruce	    Ernst	    6600	60
David	    Austin	    5280	60
Valli	    Pataballa	5280	60
Diana	    Lorentz	    4620	60
*/

ROLLBACK;
--==>> 롤백 완료.


--○ EMPLOYEES 테이블에서 JOB TITLE 이 『Sales Manager』인 사원들의
--   SALARY 를 해당 직무(직종)의 최고 급여(MAX_SALARY)로 수정한다.
--   단, 입사일이 2006년 이전(해당 년도 제외) 입사자에 한하여
--   적용할 수 있도록 처리한다.
--   (쿼리문 작성하여 결과 확인 후 ROLLBACK)

-- 내가 풀이한 내용
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

SELECT *
FROM JOBS;
-- JOB_ID로 연결
SELECT *
FROM EMPLOYEES;

-- (업데이트 대상 확인)
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE HIRE_DATE < TO_DATE('2006-01-01', 'YYYY-MM-DD')
  AND JOB_ID = (SELECT JOB_ID
                FROM JOBS
                WHERE JOB_TITLE = 'Sales Manager');
--==>>
/*
145	John	Russell	    14000
146	Karen	Partners	13500
147	Alberto	Errazuriz	12000
*/

-- (UPDATE)
UPDATE EMPLOYEES
SET SALARY = (SELECT MAX_SALARY
              FROM JOBS
              WHERE JOB_TITLE = 'Sales Manager')
WHERE HIRE_DATE < TO_DATE('2006-01-01', 'YYYY-MM-DD')
  AND JOB_ID = (SELECT JOB_ID
                FROM JOBS
                WHERE JOB_TITLE = 'Sales Manager');
--==>> 3개 행 이(가) 업데이트되었습니다.
                
-- (업데이트 후 결과 확인)
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEES
WHERE HIRE_DATE < TO_DATE('2006-01-01', 'YYYY-MM-DD')
  AND JOB_ID = (SELECT JOB_ID
                FROM JOBS
                WHERE JOB_TITLE = 'Sales Manager');
--==>>
/*
145	John	Russell	    20080
146	Karen	Partners	20080
147	Alberto	Errazuriz	20080
*/

ROLLBACK;
--==>> 롤백 완료.


-- 함께 풀이한 내용

SELECT *
FROM JOBS;
SELECT *
FROM EMPLOYEES;

UPDATE EMPLOYEES
SET SALARY = (Sales Manager의 MAX_SALARY)
WHERE JOB_ID = (Sales Manager의 JOB_ID)
      TO_NUMBER(TO_CHAR(HIRE_DATE, 'YYYY')) < 2006;

-- (Sales Manager의 MAX_SALARY)
SELECT MAX_SALARY
FROM JOBS
WHERE JOB_TITLE = 'Sales Manager';
--==>> 20080

-- (Sales Manager의 JOB_ID)
SELECT JOB_ID
FROM JOBS
WHERE JOB_TITLE = 'Sales Manager';
--==>> SA_MAN

UPDATE EMPLOYEES
SET SALARY = (SELECT MAX_SALARY
              FROM JOBS
              WHERE JOB_TITLE = 'Sales Manager')
WHERE JOB_ID = (SELECT JOB_ID
                FROM JOBS
                WHERE JOB_TITLE = 'Sales Manager')
  AND TO_NUMBER(TO_CHAR(HIRE_DATE, 'YYYY')) < 2006;
--==>> 3개 행 이(가) 업데이트되었습니다.

SELECT FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID
                FROM JOBS
                WHERE JOB_TITLE = 'Sales Manager')
  AND TO_NUMBER(TO_CHAR(HIRE_DATE, 'YYYY')) < 2006;
--==>>
/*
John	20080
Karen	20080
Alberto	20080
*/

ROLLBACK;
--==>> 롤백 완료.


--○ EMPLOYEES 테이블에서 SALARY 를
--   각 부서의 이름별로 다른 인상률을 적용하여 수정할 수 있도록 한다.
--   Finance → 10%
--   Executive → 15% 
--   Accounting → 20%
--   (쿼리문 작성하여 결과 확인 후 ROLLBACK)

-- 내가 풀이한 내용

-- (업데이트 전 확인)
SELECT FIRST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME IN ('Accounting', 'Executive', 'Finance'));
--==>>
/*
Steven	    90	24000
Neena	    90	17000
Lex	        90	17000
Nancy	    100	12008
Daniel	    100	9000
John	    100	8200
Ismael	    100	7700
Jose Manuel	100	7800
Luis	    100	6900
Shelley	    110	12008
William	    110	8300
*/

-- (각 부서별 부서아이디 확인)
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Finance';

SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Executive';

SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Accounting';

-- (UPDATE) 
UPDATE EMPLOYEES 
SET SALARY = ( CASE WHEN DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                                           FROM DEPARTMENTS
                                           WHERE DEPARTMENT_NAME = 'Finance') 
                    THEN SALARY * 1.1
                    WHEN DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                                           FROM DEPARTMENTS
                                           WHERE DEPARTMENT_NAME = 'Executive') 
                    THEN SALARY * 1.15
                    WHEN DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                                           FROM DEPARTMENTS
                                           WHERE DEPARTMENT_NAME = 'Accounting') 
                    THEN SALARY * 1.2
                    ELSE SALARY
                END )
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME IN ('Accounting', 'Executive', 'Finance'));
--==>> 11개 행 이(가) 업데이트되었습니다.
               
ROLLBACK;

-- (업데이트 후 확인)
SELECT FIRST_NAME, DEPARTMENT_ID, SALARY
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME IN ('Accounting', 'Executive', 'Finance'));
--==>>
/*
Steven	    90	27600
Neena	    90	19550
Lex	        90	19550
Nancy	    100	13208.8
Daniel	    100	9900
John	    100	9020
Ismael	    100	8470
Jose Manuel	100	8580
Luis	    100	7590
Shelley	    110	14409.6
William	    110	9960
*/


-- 함께 풀이한 내용 
UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID WHEN ('Finance'의 부서아이디) 
                                THEN SALARY * 1.1 
                                WHEN ('Executive'의 부서아이디) 
                                THEN SALARY * 1.15 
                                WHEN ('Accounting'의 부서아이디) 
                                THEN SALARY * 1.15 
                                ELSE SALARY
             END;

-- ('Finance'의 부서아이디) 
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Finance';
--==>> 100

-- ('Executive'의 부서아이디) 
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Executive';
--==>> 90

-- ('Accounting'의 부서아이디) 
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'Accounting';
--==>> 110

UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID WHEN (SELECT DEPARTMENT_ID
                                      FROM DEPARTMENTS
                                      WHERE DEPARTMENT_NAME = 'Finance') 
                                THEN SALARY * 1.1 
                                WHEN (SELECT DEPARTMENT_ID
                                      FROM DEPARTMENTS
                                      WHERE DEPARTMENT_NAME = 'Executive') 
                                THEN SALARY * 1.15 
                                WHEN (SELECT DEPARTMENT_ID
                                      FROM DEPARTMENTS
                                      WHERE DEPARTMENT_NAME = 'Accounting') 
                                THEN SALARY * 1.15 
                                ELSE SALARY
             END;
--==>> 107개 행 이(가) 업데이트되었습니다.

ROLLBACK;
--==>> 롤백 완료.


UPDATE EMPLOYEES
SET SALARY = CASE DEPARTMENT_ID WHEN (SELECT DEPARTMENT_ID
                                      FROM DEPARTMENTS
                                      WHERE DEPARTMENT_NAME = 'Finance') 
                                THEN SALARY * 1.1 
                                WHEN (SELECT DEPARTMENT_ID
                                      FROM DEPARTMENTS
                                      WHERE DEPARTMENT_NAME = 'Executive') 
                                THEN SALARY * 1.15 
                                WHEN (SELECT DEPARTMENT_ID
                                      FROM DEPARTMENTS
                                      WHERE DEPARTMENT_NAME = 'Accounting') 
                                THEN SALARY * 1.15 
                                ELSE SALARY
             END
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME IN ('Accounting', 'Executive', 'Finance'));
--> WHERE 절로 

ROLLBACK;
--==>> 롤백 완료.


--■■■ DELETE ■■■--

-- 1. 테이블에서 지정된 행(레코드)을 삭제하는 데 사용하는 구문.
 
-- 2. 형식 및 구조
-- DELETE [FROM] 테이블명
-- [WHERE 조건절];

SELECT *
FROM EMPLOYEES
WHERE EMPLOYEE_ID=198;
--> 반드시 삭제 전에 SELECT 문으로 확인하고 삭제할 것

DELETE
FROM EMPLOYEES
WHERE EMPLOYEE_ID=198;
--==>> 1 행 이(가) 삭제되었습니다.

ROLLBACK;
--==>> 롤백 완료.

--○ EMPLOYEES 테이블에서 직원들의 정보를 삭제한다.
--   단, 부서명이 'IT'인 경우로 한정한다.

--※ 실제로는 EMPLOYEES 테이블의 데이터가(삭제하고자 하는 대상)
--   다른 테이블(혹은 자기 자신 테이블)에 의해 참조당하고 있는 경우
--   삭제되지 않을 수도 있다는 사실을 염두해야 하며...
--   그에 대한 이유도 알아야 한다.

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');
--==>>
/*
103	Alexander	Hunold	AHUNOLD	590.423.4567	2006-01-03	IT_PROG	9000		102	60
104	Bruce	Ernst	BERNST	590.423.4568	2007-05-21	IT_PROG	6000		103	60
105	David	Austin	DAUSTIN	590.423.4569	2005-06-25	IT_PROG	4800		103	60
106	Valli	Pataballa	VPATABAL	590.423.4560	2006-02-05	IT_PROG	4800		103	60
107	Diana	Lorentz	DLORENTZ	590.423.5567	2007-02-07	IT_PROG	4200		103	60
*/

DELETE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');
--==>> 에러 발생
/*
명령의 445 행에서 시작하는 중 오류 발생 -
DELETE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT')
오류 보고 -
ORA-02292: integrity constraint (HR.DEPT_MGR_FK) violated - child record found
*/
--> DEPARTMENTS 테이블의 MANAGER_ID 컬럼이 외래키라서 
-- 다른 테이블을 참조하고 있기 때문에 발생하는 오류
-- 따라서, IT 부서의 MANAGER_ID 를 NULL 인 상태로 변경 후 삭제를 진행해야 한다.

-- (제약조건 확인)
SELECT *
FROM VIEW_CONSTCHECK;

-- (IT 부서의 MANAGER_ID 를 NULL 로 변경)
UPDATE DEPARTMENTS
SET MANAGER_ID = NULL
WHERE DEPARTMENT_NAME = 'IT';
--==>> 1 행 이(가) 업데이트되었습니다.

-- (다시 데이터 삭제 시도)
DELETE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');
--==>> 5개 행 이(가) 삭제되었습니다.

-- (롤백)
ROLLBACK;
--==>> 롤백 완료.


-- 함께 풀이한 내용 

SELECT *
FROM DEPARTMENTS;

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = ('IT'의 부서번호);

--('IT'의 부서번호)
SELECT DEPARTMENT_ID
FROM DEPARTMENTS
WHERE DEPARTMENT_NAME = 'IT';
--==>> 60

SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');

DELETE
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');
--==>> 에러 발생
/*
ORA-02292: integrity constraint (HR.DEPT_MGR_FK) violated - child record found
*/

--■■■ 뷰(VIEW) ■■■--

-- 1. 뷰(VIEW)란 이미 특정한 데이터베이스 내에 존재하는
--    하나 이상의 테이블에서 사용자가 얻기 원하는 데이터들만을
--    정확하고 편하게 가져오기 위하여 사전에 원하는 컬럼들만 모아서
--    만들어놓은 가상의 테이블로 편의성 및 보안에 목적이 있다.
--   
--    가상의 테이블이란 뷰가 실제로 존재하는 테이블(객체)이 아니라
--    하나 이상의 테이블에서 파생된 또 다른 정보를 볼 수 있는 방법이며
--    그 정보를 추출해내는 SQL문장이라고 볼 수 있다.

-- 2. 형식 및 구조
-- CREATE [OR REPLACE] VIEW 테이블
-- [(ALIAS[, ALIAS, ...])]
-- AS
-- 서브쿼리(SUBQUERY)
-- [WITH CHECK OPTION]
-- [WITH READ ONLY];

--○ 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VIEW_EMPLOYEES
AS
SELECT E.FIRST_NAME, E.LAST_NAME
     , D.DEPARTMENT_NAME, L.CITY
     , C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
  AND D.LOCATION_ID = L.LOCATION_ID(+)
  AND L.COUNTRY_ID = C.COUNTRY_ID(+)
  AND C.REGION_ID = R.REGION_ID(+);
--==>> View VIEW_EMPLOYEES이(가) 생성되었습니다.

--○ 뷰(VIEW) 조회
SELECT *
FROM VIEW_EMPLOYEES;

--○ 뷰(VIEW) 구조 확인
DESC VIEW_EMPLOYEES;
--==>>
/*
이름              널?       유형           
--------------- -------- ------------ 
FIRST_NAME               VARCHAR2(20) 
LAST_NAME       NOT NULL VARCHAR2(25) 
DEPARTMENT_NAME          VARCHAR2(30) 
CITY                     VARCHAR2(30) 
COUNTRY_NAME             VARCHAR2(40) 
REGION_NAME              VARCHAR2(25)
*/

--○ 뷰(VIEW) 소스 확인          -- CHECK~!!!
SELECT VIEW_NAME, TEXT          -- TEXT
FROM USER_VIEWS                 -- USER_VIEWS
WHERE VIEW_NAME = 'VIEW_EMPLOYEES';
--==>>
/*
VIEW_EMPLOYEES
"SELECT E.FIRST_NAME, E.LAST_NAME
     , D.DEPARTMENT_NAME, L.CITY
     , C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
  AND D.LOCATION_ID = L.LOCATION_ID(+)
  AND L.COUNTRY_ID = C.COUNTRY_ID(+)
  AND C.REGION_ID = R.REGION_ID(+)"
*/

