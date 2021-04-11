SELECT USER
FROM DUAL;
--==>> HR

--○ 세 개 이상의 테이블 조인(JOIN)

-- 형식1 (SQL 1992 CODE)

SELECT 테이블명1.컬럼명, 테이블명2.컬럼명, 테이블명3.컬럼명
FROM 테이블명1, 테이블명2, 테이블명3
WHERE 테이블명1.컬럼명1 = 테이블명2.컬럼명1
  AND 테이블명2.컬럼명2 = 테이블명3.컬럼명2;


-- 형식2 (SQL 1999 CODE)

SELECT 테이블명1.컬럼명, 테이블명2.컬럼명, 테이블명3.컬럼명
FROM 테이블명1 JOIN 테이블명2
ON 테이블명1.컬럼명1 = 테이블명2.컬럼명1
        JOIN 테이블명3
        ON 테이블명2.컬럼명2 = 테이블명3.컬럼명2;


--○ HR 계정 소유의 테이블 또는 뷰 목록 조회
SELECT *
FROM TAB;
--==>>
/*
TNAME	            TABTYPE	    CLUSTERID
COUNTRIES	        TABLE
DEPARTMENTS	        TABLE	
EMPLOYEES	        TABLE	
EMP_DETAILS_VIEW	VIEW	
JOBS	            TABLE	
JOB_HISTORY	        TABLE	
LOCATIONS	        TABLE	
REGIONS	            TABLE	
*/

--○ HR.JOBS, HR.EMPLOYEES, HR.DEPARTMENTS 테이블을 대상으로
--   직원들의 FIRST_NAME, LAST_NAME, JOB_TITLE, DEPARTMENT_NAME
--   항목을 조회한다. 

-- 내가 풀이한 내용
SELECT *
FROM JOBS;
--==>>
/*
JOB_ID	    JOB_TITLE	                    MIN_SALARY	MAX_SALARY
AD_PRES	    President	                    20080	    40000
AD_VP	    Administration Vice President	15000	    30000
AD_ASST	    Administration Assistant	    3000	    6000
FI_MGR	    Finance Manager	                8200	    16000
FI_ACCOUNT	Accountant	                    4200	    9000
AC_MGR	    Accounting Manager	            8200	    16000
AC_ACCOUNT	Public Accountant	            4200	    9000
SA_MAN	    Sales Manager	                10000	    20080
SA_REP	    Sales Representative	        6000	    12008
PU_MAN	    Purchasing Manager	            8000	    15000
PU_CLERK	Purchasing Clerk	            2500	    5500
ST_MAN	    Stock Manager	                5500	    8500
ST_CLERK	Stock Clerk	                    2008	    5000
*/

SELECT *
FROM EMPLOYEES;
--==>>
/*
EMPLOYEE_ID	FIRST_NAME	LAST_NAME	EMAIL	    PHONE_NUMBER	HIRE_DATE	JOB_ID	    SALARY	COMMISSION_PCT	MANAGER_ID	DEPARTMENT_ID
100	        Steven	    King	    SKING	    515.123.4567	03/06/17	AD_PRES	    24000			                        90
101	        Neena	    Kochhar	    NKOCHHAR	515.123.4568	05/09/21	AD_VP	    17000		                100	        90
102	        Lex     	De Haan	    LDEHAAN	    515.123.4569	01/01/13	AD_VP	    17000		                100	        90
103	        Alexander	Hunold	    AHUNOLD	    590.423.4567	06/01/03	IT_PROG	    9000		                102	        60
104	        Bruce	    Ernst	    BERNST	    590.423.4568	07/05/21	IT_PROG	    6000		                103	        60
105	        David	    Austin	    DAUSTIN	    590.423.4569	05/06/25	IT_PROG	    4800		                103	        60
106	        Valli	    Pataballa	VPATABAL	590.423.4560	06/02/05	IT_PROG	    4800		                103	        60
107	        Diana	    Lorentz	    DLORENTZ	590.423.5567	07/02/07	IT_PROG	    4200		                103	        60
108	        Nancy	    Greenberg	NGREENBE	515.124.4569	02/08/17	FI_MGR	    12008		                101	        100
109	        Daniel	    Faviet	    DFAVIET	    515.124.4169	02/08/16	FI_ACCOUNT	9000		                108	        100
110	        John	    Chen	    JCHEN	    515.124.4269	05/09/28	FI_ACCOUNT	8200		                108	        100
111	        Ismael	    Sciarra	    ISCIARRA	515.124.4369	05/09/30	FI_ACCOUNT	7700		                108	        100
112     	Jose Manuel	Urman	    JMURMAN	    515.124.4469	06/03/07	FI_ACCOUNT	7800		                108	        100
113	        Luis	    Popp	    LPOPP	    515.124.4567	07/12/07	FI_ACCOUNT	6900		                108	        100
114	        Den	        Raphaely	DRAPHEAL	515.127.4561	02/12/07	PU_MAN	    11000		                100	        30
115	        Alexander	Khoo	    AKHOO	    515.127.4562	03/05/18	PU_CLERK	3100		                114	        30

                                                    :
                                                    :
*/

SELECT *
FROM DEPARTMENTS;
--==>>
/*
DEPARTMENT_ID	DEPARTMENT_NAME	        MANAGER_ID	LOCATION_ID
10	            Administration	        200	            1700
20	            Marketing	            201	            1800
30	            Purchasing	            114	            1700
40	            Human Resources	        203	            2400
50	            Shipping	            121	            1500
60	            IT	                    103	            1400
70	            Public Relations	    204	            2700
80	            Sales	                145	            2500
90	            Executive	            100	            1700
100	            Finance	                108	            1700
110	            Accounting	            205	            1700
120	            Treasury		                        1700
130	            Corporate Tax		                    1700
140	            Control And Credit		                1700
150	            Shareholder Services		            1700
160	            Benefits		                        1700
170	            Manufacturing		                    1700
180	            Construction		                    1700
190	            Contracting		                        1700
*/

-- SQL 1992 CODE
SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME
FROM JOBS J, EMPLOYEES E, DEPARTMENTS D
WHERE E.JOB_ID = J.JOB_ID
  AND E.DEPARTMENT_ID = D.DEPARTMENT_ID(+);

-- SQL 1999 CODE
SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME
FROM EMPLOYEES E LEFT JOIN JOBS J
ON E.JOB_ID = J.JOB_ID
    LEFT JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
--==>>
/*
FIRST_NAME	LAST_NAME	JOB_TITLE	                    DEPARTMENT_NAME
Jennifer	Whalen	    Administration Assistant	    Administration
Pat	        Fay	        Marketing Representative	    Marketing
Michael	    Hartstein	Marketing Manager	            Marketing
Alexander	Khoo	    Purchasing Clerk	            Purchasing
Shelli	    Baida	    Purchasing Clerk	            Purchasing
Sigal	    Tobias	    Purchasing Clerk	            Purchasing
Guy	        Himuro	    Purchasing Clerk	            Purchasing
Karen	    Colmenares	Purchasing Clerk	            Purchasing
Den	        Raphaely	Purchasing Manager	            Purchasing
Susan	    Mavris	    Human Resources Representative	Human Resources
Winston	    Taylor	    Shipping Clerk	                Shipping
                :   
                :
Steven	    King	    President	                    Executive
Daniel	    Faviet	    Accountant	                    Finance
John	    Chen	    Accountant	                    Finance
Ismael	    Sciarra	    Accountant	                    Finance
Jose Manuel	Urman	    Accountant	                    Finance
Luis	    Popp	    Accountant	                    Finance
Nancy	    Greenberg	Finance Manager	                Finance
William	    Gietz	    Public Accountant	            Accounting
Shelley	    Higgins	    Accounting Manager	            Accounting
Kimberely	Grant	    Sales Representative	        (null)
*/

--○ EMPLOYEES, DEPARTMENTS, JOBS, LOCATIONS, COUNTRIES, REGIONS 테이블을 대상으로
--   직원들의 데이터를 다음과 같이 조회한다.
--   FIRST_NAME, LAST_NAME, JOB_TITLE, DEPARTMENT_NAME, CITY, COUNTRY_NAME, REGION_NAME

-- 내가 풀이한 내용

SELECT *
FROM LOCATIONS;

SELECT *
FROM COUNTRIES;

SELECT *
FROM REGIONS;

-- SQL 1992 CODE
SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME, L.CITY, C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E, DEPARTMENTS D, JOBS J, LOCATIONS L, COUNTRIES C, REGIONS R
WHERE E.JOB_ID = J.JOB_ID
  AND E.DEPARTMENT_ID = D.DEPARTMENT_ID(+)
  AND D.LOCATION_ID = L.LOCATION_ID(+)
  AND L.COUNTRY_ID = C.COUNTRY_ID(+)
  AND C.REGION_ID = R.REGION_ID(+);

-- SQL 1999 CODE
SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME, L.CITY, C.COUNTRY_NAME, R.REGION_NAME
FROM EMPLOYEES E LEFT JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID
        LEFT JOIN LOCATIONS L
        ON D.LOCATION_ID = L.LOCATION_ID
            LEFT JOIN COUNTRIES C
            ON L.COUNTRY_ID = C.COUNTRY_ID
                LEFT JOIN REGIONS R
                ON C.REGION_ID = R.REGION_ID;





























