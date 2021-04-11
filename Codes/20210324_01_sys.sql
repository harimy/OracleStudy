--○ 현재 오라클 서버에 접속한 자신의 계정 조회
SELECT USER
FROM DUAL;
--==>> SYS

--1줄 주석문 처리(단일행 주석문 처리)

/*
여러줄
(다중행)
주석문
처리
*/

SHOW USER
--==>> USER이(가) "SYS"입니다.

SELECT USER
FROM DUAL;
--==>> SYS

SELECT 1+2
FROM DUAL;
--==>> 3

select 1+2
from dual;
--==>> 3

SELECT 1 + 2
FROM DUAL;
--==>> 3

SELECT '쌍용강북센터F강의장'
FROM DUAL;
--==>> 쌍용강북센터F강의장

SELECT '아직은 지루한 오라클 수업';
--==>> 
/*
ORA-00923: FROM keyword not found where expected
00923. 00000 -  "FROM keyword not found where expected"
*Cause:    
*Action:
38행, 23열에서 오류 발생
*/

SELECT 3.14 + 1.36
FROM DUAL;
--==>> 4.5

SELECT 1.2345 + 2.3456
FROM DUAL;
--==>> 3.5801

SELECT 10 * 5
FROM DUAL;
--==>> 50

SELECT 1000/23
FROM DUAL;
--==>> 43.47826086956521739130434782608695652174


SELECT 100 - 23
FROM DUAL;
--==>> 77

SELECT '김아별' + '정주희'
FROM DUAL;
--==>> 에러 발생
/*
ORA-01722: invalid number
01722. 00000 -  "invalid number"
*Cause:    The specified number was invalid.
*Action:   Specify a valid number.
*/

--○ 오라클 서버에 존재하는 사용자 계정 상태 정보 조회

SELECT USERNAME, ACCOUNT_STATUS
FROM DBA_USERS;
--==>>
/*
SYS	                OPEN
SYSTEM	            OPEN
ANONYMOUS	        OPEN
HR	                OPEN
APEX_PUBLIC_USER    	LOCKED
FLOWS_FILES	        LOCKED
APEX_040000	        LOCKED
OUTLN	            EXPIRED & LOCKED
DIP	                EXPIRED & LOCKED
ORACLE_OCM	        EXPIRED & LOCKED
XS$NULL	            EXPIRED & LOCKED
MDSYS	            EXPIRED & LOCKED
CTXSYS	            EXPIRED & LOCKED
DBSNMP	            EXPIRED & LOCKED
XDB	                EXPIRED & LOCKED
APPQOSSYS	        EXPIRED & LOCKED
*/


SELECT USERNAME, USER_ID, ACCOUNT_STATUS, PASSWORD, LOCK_DATE
FROM DBA_USERS;
--==>> 질의 결과
/*
SYS	                  0	    OPEN		
SYSTEM	              5	    OPEN		
ANONYMOUS	         35	    OPEN		
HR	                 43	    OPEN		
APEX_PUBLIC_USER	     45	    LOCKED		        14/05/29
FLOWS_FILES	         44	    LOCKED		        14/05/29
APEX_040000	         47	    LOCKED		        14/05/29
OUTLN	              9	    EXPIRED & LOCKED		21/03/24
DIP	                 14 	EXPIRED & LOCKED		14/05/29
ORACLE_OCM	         21	    EXPIRED & LOCKED		14/05/29
XS$NULL	     2147483638	    EXPIRED & LOCKED		14/05/29
MDSYS	             42     	EXPIRED & LOCKED		14/05/29
CTXSYS	             32	    EXPIRED & LOCKED		21/03/24
DBSNMP	             29	    EXPIRED & LOCKED		14/05/29
*/


SELECT *
FROM DBA_USERS;
-- DBA_USERS 테이블에 있는 모든 내용 조회

SELECT USERNAME, USER_ID
FROM DBA_USERS;
--> 『DBA_』로 시작하는 Oracle Data Dictionary View 는
--  오로지 관리자 권한으로 접속했을 경우에만 조회가 가능하다.
--  아직은 데이터 딕셔너리 개념을 잡지 못해도 상관없다.

--○ 『hr』사용자 계정을 잠금 상태로 설정
ALTER USER HR ACCOUNT LOCK;
--==>> User HR이(가) 변경되었습니다.

--○ 다시 사용자 계정 정보 조회
SELECT USERNAME, ACCOUNT_STATUS
FROM DBA_USERS;
/*
        :
    HR	LOCKED
        :
*/

--○ 『hr』사용자 계정을 잠금 해제 상태로 설정
ALTER USER HR ACCOUNT UNLOCK;
--==>> User HR이(가) 변경되었습니다.

--○ 다시 사용자 계정 정보 조회
SELECT USERNAME, ACCOUNT_STATUS
FROM DBA_USERS;
/*
        :
    HR	OPEN
        :
*/

--○ TABLESPACE 생성

--※ TABLESPACE 란?
--   세그먼트(테이블, 인덱스, ...)를 담아두는(저장해두는)
--   오라클의 논리적인 저장 구조를 의미한다.

CREATE TABLESPACE TBS_EDUA                  -- CREATE 유형 개체명    → 생성
DATAFILE 'C:\TESTORADATA\TBS_EDUA01.DEF'    -- 물리적으로 연결되는 데이터 파일
SIZE 4M                                     -- 물리적 데이터 파일의 용량
EXTENT MANAGEMENT LOCAL                     -- 오라클 서버가 세그먼트를 알아서 관리
SEGMENT SPACE MANAGEMENT AUTO;

--※ 테이블스페이스 생성 구문을 생성하기 전에
--   물리적인 경로에 디렉터리(C:\TESTORADATA\) 생성할 것.

--○ 생성된 테이블스페이스(TBS_EDUA) 조회
SELECT *
FROM DBA_TABLESPACES;
--==>>
/*
SYSTEM	8192	65536		1	2147483645	2147483645		65536	ONLINE	PERMANENT	LOGGING	NO	LOCAL	SYSTEM	NO	MANUAL
SYSAUX	8192	65536		1	2147483645	2147483645		65536	ONLINE	PERMANENT	LOGGING	NO	LOCAL	SYSTEM	NO	AUTO
UNDOTBS1	8192	65536		1	2147483645	2147483645		65536	ONLINE	UNDO	LOGGING	NO	LOCAL	SYSTEM	NO	MANUAL
TEMP	8192	1048576	1048576	1		2147483645	0	1048576	ONLINE	TEMPORARY	NOLOGGING	NO	LOCAL	UNIFORM	NO	MANUAL
USERS	8192	65536		1	2147483645	2147483645		65536	ONLINE	PERMANENT	LOGGING	NO	LOCAL	SYSTEM	NO	AUTO
TBS_EDUA	8192	65536		1	2147483645	2147483645		65536	ONLINE	PERMANENT	LOGGING	NO	LOCAL	SYSTEM	NO	AUTO
*/

SELECT *
FROM DBA_DATA_FILES;
--==>>
/*
C:\TESTORADATA\TBS_EDUA01.DEF	5	TBS_EDUA	4194304	512	AVAILABLE	5	NO	0	0	0	3145728	384
*/


--○ 오라클 사용자 계정 생성
CREATE USER lhr IDENTIFIED BY java006$
DEFAULT TABLESPACE TBS_EDUA;
--> lhr 이라는 사용자를 만들겠다. (생성하겠다.)
--  패스워드는 java006$ 로 하겠다.
--  이 계정을 통해 생성하는 오라클 객체는(세그먼트 들은)
--  기본적으로 (default) TBS_EDUA 라는 테이블스페이스에 생성할 수 있도록 하겠다.
--==>> User LHR이(가) 생성되었습니다.


--※ 생성된 오라클 사용자 계정(lhr)을 통해
--   접속을 시도해보았으나 접속 불가.
--   → 『CREATE SESSION』권한이 없기 때문에...

--○ 생성된 오라클 사용자 계정(lhr)에
--   서버 접속이 가능할 수 있도록 CREATE SESSION 권한 부여 → SYS 가...
GRANT CREATE SESSION TO LHR;
--==>> Grant을(를) 성공했습니다.


--○ 생성된 오라클 사용자 계정(lhr)의
--   DEFAULT TABLESPACE 조회
SELECT USERNAME, DEFAULT_TABLESPACE
FROM DBA_USERS;
--==>>
/*
SYS	                SYSTEM
SYSTEM	            SYSTEM
ANONYMOUS	        SYSAUX
HR	                USERS
LHR	                TBS_EDUA
APEX_PUBLIC_USER	SYSTEM
FLOWS_FILES	        SYSAUX
APEX_040000	        SYSAUX
OUTLN	            SYSTEM
DIP	                SYSTEM
ORACLE_OCM	        SYSTEM
XS$NULL	            SYSTEM
MDSYS	            SYSAUX
CTXSYS	            SYSAUX
DBSNMP	            SYSAUX
*/

--○ 생성된 오라클 사용자 계정(lhr)의
--   시스템 관련 권한 조회
SELECT *
FROM DBA_SYS_PRIVS;
--==>>
/*
            :
LHR	CREATE TABLE	NO
            :
*/

--○ 생성된 오라클 사용자 계정(LHR)에
--   테이블 생성이 가능할 수 있도록 CREATE TABLE 권한 부여
GRANT CREATE TABLE TO LHR;
--==>> Grant을(를) 성공했습니다.

--○ 생성된 오라클 사용자 계정(lhr)에
--   테이블스페이스(TBS_EDUA)에서 사용할 수 있는 공간(할당량)
--   의 크기를 무제한으로 지정.
ALTER USER lhr
QUOTA UNLIMITED ON TBS_EDUA;
--==>> User LHR이(가) 변경되었습니다.






















