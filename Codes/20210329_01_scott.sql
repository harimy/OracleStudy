SELECT USER
FROM DUAL;
--==>> SCOTT

--○ TBL_SAWON 테이블에서 성별이 남성인 사원만
--   사원번호, 사원명, 주민번호, 급여 항목을 조회한다.
--   단, SUBSTR() 함수를 사용할 수 있도록 하며,
--   급여 기준으로 내림차순 정렬을 수행할 수 있도록 한다.

-- 내가 풀이한 내용
DESC TBL_SAWON;

SELECT SANO "사원번호", SANAME "사원명", JUBUN "주민번호", SAL "급여"
FROM TBL_SAWON
WHERE SUBSTR(JUBUN, 7, 1) IN ('1', '3')
ORDER BY SAL DESC;
--==>>
/*
1009	정준이	9804251234567	4000
1011	선동열	7505071234567	3000
1016	남이		7012121234567	2000
1014	남주혁	0203043234567	2000
1015	남궁선	0512123234567	1000
*/


-- 함께 풀이한 내용
SELECT SANO, SANAME, JUBUN, SAL
FROM TBL_SAWON
WHERE SUBSTR(JUBUN, 7, 1) = '1'
   OR SUBSTR(JUBUN, 7, 1) = '3'
ORDER BY SAL DESC;
--==>>
/*
1009	정준이	9804251234567	4000
1011	선동열	7505071234567	3000
1016	남이		7012121234567	2000
1014	남주혁	0203043234567	2000
1015	남궁선	0512123234567	1000
*/



-- LENGTH() / LENGTHB()
SELECT ENAME "1"
     , LENGTH(ENAME) "2"
	 , LENGTHB(ENAME) "3"
FROM TBL_EMP;
--> LENGTH() 는 글자 수를 반환, LENGTHB()는 바이트 수를 반환
--==>>
/*
SMITH	5	5
ALLEN	5	5
WARD	4	4
JONES	5	5
MARTIN	6	6
BLAKE	5	5
CLARK	5	5
SCOTT	5	5
KING	4	4
TURNER	6	6
ADAMS	5	5
JAMES	5	5
FORD	4	4
MILLER	6	6
*/

SELECT LENGTH('한글') "1"
     , LENGTHB('한글') "2"
FROM DUAL;

--○ 확인
SELECT *
FROM NLS_DATABASE_PARAMETERS;
--==>>
/*
NLS_LANGUAGE		AMERICAN
NLS_TERRITORY		AMERICA
NLS_CURRENCY		$
NLS_ISO_CURRENCY	AMERICA
NLS_NUMERIC_CHARACTERS	.,
NLS_CHARACTERSET	AL32UTF8
NLS_CALENDAR	GREGORIAN
NLS_DATE_FORMAT	DD-MON-RR
NLS_DATE_LANGUAGE	AMERICAN
NLS_SORT	BINARY
NLS_TIME_FORMAT	HH.MI.SSXFF AM
NLS_TIMESTAMP_FORMAT	DD-MON-RR HH.MI.SSXFF AM
NLS_TIME_TZ_FORMAT	HH.MI.SSXFF AM TZR
NLS_TIMESTAMP_TZ_FORMAT	DD-MON-RR HH.MI.SSXFF AM TZR
NLS_DUAL_CURRENCY	$
NLS_COMP	BINARY
NLS_LENGTH_SEMANTICS	BYTE
NLS_NCHAR_CONV_EXCP	FALSE
NLS_NCHAR_CHARACTERSET	AL16UTF16
NLS_RDBMS_VERSION	11.2.0.2.0
*/

--※ 한글 데이터를 처리할 경우
--   바이트 기반으로 처리해야만 하는 상황이라면
--   항상 인코딩 방식을 잘 체크하고 사용해야 한다.

--○ INSTR()
SELECT 'ORACLE ORAHOME BIORA' "1"
	 , INSTR('ORACLE ORAHOME BIORA', 'ORA', 1, 1) "2"
	 , INSTR('ORACLE ORAHOME BIORA', 'ORA', 1, 2) "3"
	 , INSTR('ORACLE ORAHOME BIORA', 'ORA', 2, 1) "4"
	 , INSTR('ORACLE ORAHOME BIORA', 'ORA', 2) "5"
	 , INSTR('ORACLE ORAHOME BIORA', 'ORA', 2, 2) "6"
FROM DUAL;
--==>> ORACLE ORAHOME BIORA	1	8	8	8	18
--> 첫 번째 파라미터 값에 해당하는 문자열에서... (대상 문자열)
--  두 번째 파라미터 값을 통해 넘겨준 문자열이 등장하는 위치를 찾아라.
--  세 번째 파라미터 값은 찾기 시작하는(스캔을 시작하는) 위치
--  네 번째 파라미터 값은 몇 번재 등장하는 값을 찾을 것인지에 대한 설정(1은 생략 가능)

SELECT '나의오라클 집으로오라 합니다' "1"
	 , INSTR('나의오라클 집으로오라 합니다', '오라', 1) "2"
	 , INSTR('나의오라클 집으로오라 합니다', '오라', 2) "3"
	 , INSTR('나의오라클 집으로오라 합니다', '오라', 10) "4"
	 , INSTR('나의오라클 집으로오라 합니다', '오라', 11) "5"
FROM DUAL;
--> 마지막 파라미터(네 번째 파라미터) 값을 생략한 형태로 사용 → 1
--==>> 나의오라클 집으로오라 합니다	3	3	10	0

--○ REVERSE()
SELECT 'ORACLE' "1"
     , REVERSE('ORACLE') "2"
	 , REVERSE('오라클') "3"
FROM DUAL;
--> 대상 문자열(매개변수)을 거꾸로 반환한다. (단, 한글은 제외)
--==>> ORACLE	ELCARO	���


--○ 실습 대상 테이블 생성(TBL_FILES)
CREATE TABLE TBL_FILES
( FILENO	NUMBER(3)
, FILENAME  VARCHAR2(100)
);
--==>> Table TBL_FILES이(가) 생성되었습니다.

--○ 실습 데이터 입력
INSERT INTO TBL_FILES VALUES(1, 'C:\AAA\BBB\CCC\SALES.DOC');
INSERT INTO TBL_FILES VALUES(2, 'C:\AAA\PANMAE.XXLS');
INSERT INTO TBL_FILES VALUES(3, 'D:\RESEARCH.PPT');
INSERT INTO TBL_FILES VALUES(4, 'C:\DOCUMENTS\STUDY.HWP');
INSERT INTO TBL_FILES VALUES(5, 'C:\DOCUMENTS\TEMP\SQL.TXT');
INSERT INTO TBL_FILES VALUES(6, 'D:\SHARE\F\TEST.PNG');
INSERT INTO TBL_FILES VALUES(7, 'C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG');
INSERT INTO TBL_FILES VALUES(8, 'C:\ORACLESTUDY\20210329_01_SCOTT.SQL');
--==>> 1 행 이(가) 삽입되었습니다. * 8

SELECT *
FROM TBL_FILES;
--==>>
/*
1	C:\AAA\BBB\CCC\SALES.DOC
2	C:\AAA\PANMAE.XXLS
3	D:\RESEARCH.PPT
4	C:\DOCUMENTS\STUDY.HWP
5	C:\DOCUMENTS\TEMP\SQL.TXT
6	D:\SHARE\F\TEST.PNG
7	C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG
8	C:\ORACLESTUDY\20210329_01_SCOTT.SQL
*/

--○ 커밋
COMMIT;
--==>> 커밋 완료.

SELECT FILENO "파일번호", FILENAME "파일명"
FROM TBL_FILES;
--==>>
/*
  파일번호  파일명
---------- ----------------------------------
		1	C:\AAA\BBB\CCC\SALES.DOC
		2	C:\AAA\PANMAE.XXLS
		3	D:\RESEARCH.PPT
		4	C:\DOCUMENTS\STUDY.HWP
		5	C:\DOCUMENTS\TEMP\SQL.TXT
		6	D:\SHARE\F\TEST.PNG
		7	C:\USER\GUILDONG\PICTURE\PHOTO\SPRING.JPG
		8	C:\ORACLESTUDY\20210329_01_SCOTT.SQL
*/

/*
  파일번호  파일명
---------- ----------------------------------
		1	SALES.DOC
		2	PANMAE.XXLS
		3	RESEARCH.PPT
		4	STUDY.HWP
		5	SQL.TXT
		6	TEST.PNG
		7	SPRING.JPG
		8	20210329_01_SCOTT.SQL
*/

--○ TBL_FILES 테이블을 대상으로 위와 같이 조회될 수 있도록(파일명.확장자)
--   쿼리문을 구성한다.

-- 내가 풀이한 내용
SELECT FILENO "파일번호", SUBSTR(FILENAME, INSTR(FILENAME, '\', -1)+1) "파일명" 
FROM TBL_FILES;
--==>>
/*
1	SALES.DOC
2	PANMAE.XXLS
3	RESEARCH.PPT
4	STUDY.HWP
5	SQL.TXT
6	TEST.PNG
7	SPRING.JPG
8	20210329_01_SCOTT.SQL
*/

-- 함께 풀이한 내용

SELECT FILENO "파일번호"
	 , SUBSTR(REVERSE(FILENAME), 1) "거꾸로된파일명"
FROM TBL_FILES;

SELECT FILENO "파일번호"
	 , REVERSE(SUBSTR(REVERSE(FILENAME), 1, INSTR(REVERSE(FILENAME), '\', 1) -1)) "파일명"
FROM TBL_FILES;



--○ LPAD()
--> Byte 공간을 확보하여 왼쪽부터 문자로 채우는 기능을 가진 함수
SELECT 'ORACLE' "1"
     , LPAD('ORACLE', 10, '*') "2"
FROM DUAL;
--==>> ORACLE	****ORACLE
--> ① 10Byte 공간을 확보한다.					→ 두 번째 파라미터 값에 의해...
--> ② 확보한 공간에 'ORACLE' 문자열을 담는다.	→ 첫 번째 파라미터 값에 의해...
--> ③ 남아있는 Byte 공간(4Byte)을 왼쪽부터 세 번째 파라미터 값으로 채운다.
--> ④ 이렇게 구성된 최종 결과값을 반환한다.


--○ RPAD()
--> Byte 공간을 확보하여 오른쪽부터 문자로 채우는 기능을 가진 함수
SELECT 'ORACLE' "1"
     , RPAD('ORACLE', 10, '*') "2"
FROM DUAL;
--==>> ORACLE	ORACLE****
--> ① 10Byte 공간을 확보한다.					→ 두 번째 파라미터 값에 의해...
--> ② 확보한 공간에 'ORACLE' 문자열을 담는다.	→ 첫 번째 파라미터 값에 의해...
--> ③ 남아있는 Byte 공간(4Byte)을 오른쪽부터 세 번째 파라미터 값으로 채운다.
--> ④ 이렇게 구성된 최종 결과값을 반환한다.


--○ LTRIM()
SELECT 'ORAORAORACLEORACLE' "1" -- 오라 오라 오라클 오라클
	 , LTRIM('ORAORAORACLEORACLE', 'ORA') "2"
	 , LTRIM('AAAORAORAORACLEORACLE', 'ORA') "3"
	 , LTRIM('ORAoRAORACLEORACLE', 'ORA') "4"
	 , LTRIM('ORA  ORAORACLEORACLE', 'ORA') "5"
	 , LTRIM('  ORAORACLEORACLE', ' ') "6"
	 , LTRIM('           ORACLE') "7" -- 왼쪽 공백 제거 함수로 활용(두 번째 파라미터 생략)
FROM DUAL;
--==>>
/*
ORAORAORACLEORACLE	
CLEORACLE	
CLEORACLE	
oRAORACLEORACLE	
  ORAORACLEORACLE	
ORAORACLEORACLE	
ORACLE
*/
--> 첫 번째 파라미터 값에 해당하는 문자열을 대상으로
--  왼쪽부터 연속적으로 두 번째 파라미터 값에서 지정한 글자와 같은 글자가 등장할 경우
--  이를 제거한 결과값을 반환한다.
--  단, 완성형으로 처리되지 않는다.

--○ RTRIM()
SELECT 'ORAORAORACLEORACLE' "1" -- 오라 오라 오라클 오라클
	 , RTRIM('ORAORAORACLEORACLE', 'ORA') "2"
	 , RTRIM('AAAORAORAORACLEORACLE', 'ORA') "3"
	 , RTRIM('ORAoRAORACLEORACLE', 'ORA') "4"
	 , RTRIM('ORA  ORAORACLEORACLE', 'ORA') "5"
	 , RTRIM('  ORAORACLEORACLE', ' ') "6"
	 , RTRIM('           ORACLE') "7"
     , RTRIM('ORACLE           ') "8" -- 오른쪽 공백 제거 함수로 활용(두 번째 파라미터 생략)
FROM DUAL;
--==>>
/*
ORAORAORACLEORACLE	
ORAORAORACLEORACLE	
AAAORAORAORACLEORACLE	
ORAoRAORACLEORACLE	
ORA  ORAORACLEORACLE	  
ORAORACLEORACLE	
           ORACLE	
ORACLE
*/
--> 첫 번째 파라미터 값에 해당하는 문자열을 대상으로
--  오른쪽부터 연속적으로 두 번째 파라미터 값에서 지정한 글자와 같은 글자가 등장할 경우
--  이를 제거한 결과값을 반환한다.
--  단, 완성형으로 처리되지 않는다.

SELECT LTRIM('이김신이김신이이신신김이신이이김이김김이신박이김신', '이김신') "테스트"
FROM DUAL;
--==>> 박이김신

SELECT RTRIM('이김신이김신이이신신김이신이이김이김김이신박이김신', '이김신') "테스트"
FROM DUAL;
--==>> 이김신이김신이이신신김이신이이김이김김이신박


--○ TRANSLATE()
--> 1:1 로 바꿔준다.
SELECT TRANSLATE('MY ORACLE SERVER'
				, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
				, 'abcdefghijklmnopqrstuvwxyz') "테스트"
FROM DUAL;
--==>> my oracle server

SELECT TRANSLATE('010-4020-7429'
				, '0123456789'
				, '영일이삼사오육칠팔구') "테스트"
FROM DUAL;
--==>> 영일영-사영이영-칠사이구


--○ REPLACE()
SELECT REPLACE('MY ORACLE ORAHOME', 'ORA', '오라') "테스트"
FROM DUAL;
--==>> MY 오라CLE 오라HOME
--> 완성형으로 REPLACE


--------------------------------------------------------------------------------

--○ ROUND() 반올림을 처리해주는 함수

SELECT 48.678 "1"
	 , ROUND(48.678, 2) "2"		-- 소수점 이하 둘째자리까지 표현(셋째자리에서 반올림)
	 , ROUND(48.674, 2) "3"
	 , ROUND(48.674, 1) "4"
	 , ROUND(48.674, 0) "5"
	 , ROUND(48.674) "6"		-- 두 번째 파라미터 값이 0일 경우 생략 가능
	 , ROUND(48.674, -1) "7"	-- 10의 자리까지 유효한 표현
	 , ROUND(48.674, -2) "8"
	 , ROUND(48.674, -3) "9"
FROM DUAL;
--==>> 48.678	48.68	48.67	48.7	49	49	50	0	0

--○ TRUNC() 절삭을 처리해주는 함수 

SELECT 48.678 "1"
     , TRUNC(48.678, 2) "2"		-- 소수점 이하 둘째자리까지 표현 (셋째 자리에서 절삭)
	 , TRUNC(48.674, 2) "3"
	 , TRUNC(48.674, 1) "4"
	 , TRUNC(48.674, 0) "5"
	 , TRUNC(48.674) "6"		-- 두 번째 파라미터 값이 0일 경우 생략 가능
	 , TRUNC(48.674, -1) "7"	-- 10의 자리까지 유효한 표현
	 , TRUNC(48.674, -2) "8"
	 , TRUNC(48.674, -3) "9"
FROM DUAL;
--==>> 48.678	48.67	48.67	48.6	48	48	40	0	0


--○ MOD() 나머지를 반환하는 함수 
SELECT MOD(5, 2) "확인"
FROM DUAL;
--==>> 1
--> 5를 2로 나눈 나머지 결과값 반환

--○ POWER() 제곱의 결과를 반환하는 함수
SELECT POWER(5, 3) "확인"
FROM DUAL;
--==>> 125
--> 5의 3승을 결과값으로 반환


--○ SQRT() 루트 결과값을 반환하는 함수
SELECT SQRT(2) "확인"
FROM DUAL;
--==>> 1.41421356237309504880168872420969807857
--> 루트 2에 대한 결과값 반환

--○ LOG() 로그 함수
--   (※ 오라클은 상용로그만 지원하는 반면, MSSQL은 상용로그 자연로그 모두 지원한다.)
SELECT LOG(10, 100) "확인1", LOG(10, 20) "확인2"
FROM DUAL;
--==>> 2	1.30102999566398119521373889472449302677

--○ 삼각 함수
--   싸인, 코싸인, 탄젠트 결과값을 반환한다.
SELECT SIN(1), COS(1), TAN(1)
FROM DUAL;
--==>>
/*
0.8414709848078965066525023216302989996233	
0.5403023058681397174009366074429766037354	
1.55740772465490223050697480745836017308
*/

--○ 삼각함수의 역함수 (범위 : -1 ~ 1)
--   어싸인, 어코싸인, 어탄젠트 결과값을 반환한다.
SELECT ASIN(0.5), ACOS(0.5), ATAN(0.5)
FROM DUAL;
--==>>
/*
0.52359877559829887307710723054658381405	
1.04719755119659774615421446109316762805	
0.4636476090008061162142562314612144020295
*/

--○ SIGN() 		서명, 부호, 특징
--> 연산 결과값이 양수이면 1, 0이면 0, 음수이면 -1을 반환한다.
SELECT SIGN(5-2) "1", SIGN(5-5) "2", SIGN(5-7)
FROM DUAL;
--==>> 1	0	-1


--○ ASCII(), CHR() → 서로 상응하는 개념의 함수
SELECT ASCII('A'), CHR(65)
FROM DUAL;
--==>> 65	A
--> ASCII : 매개변수로 넘겨받은 문자의 아스키코드 값을 반환한다.
--> CHR   : 매개변수로 넘겨받은 숫자를 아스키코드 값으로 취하는 문자를 반환한다.

--------------------------------------------------------------------------------

--※ 날짜 관련 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.

--※ 날짜 연산의 기본 단위는 DAY(일수)이다. CHECK~!!!
SELECT SYSDATE, SYSDATE+1, SYSDATE-2, SYSDATE+3
FROM DUAL;
--==>>
/*
2021-03-29 12:04:23		-- 현재
2021-03-30 12:04:23	    -- 1일 후
2021-03-27 12:04:23	 	-- 2일 전
2021-04-01 12:04:23 	-- 3일 후
*/

--○ 시간 단위 연산
SELECT SYSDATE, SYSDATE + 1/24, SYSDATE - 2/24
FROM DUAL;
--==>> 
/*
2021-03-29 12:06:55		-- 현재
2021-03-29 13:06:55		-- 1시간 후
2021-03-29 10:06:55		-- 2시간 전
*/

--○ 현재 시간과... 현재 시간 기준 1일 2시간 3분 4초 후를 조회한다.
/*
------------------------------------------------------
		현재시간 				연산 후 시간
------------------------------------------------------
  2021-03-29  12:05:52      2021-03-30 14:08:56
------------------------------------------------------
*/

-- 내가 풀이한 내용
SELECT SYSDATE "현재시간", SYSDATE + 1 + 2/24 + 3/1440 + 4/86400 "연산 후 시간"
FROM DUAL;
--==>>
/*
------------------------------------------------------
		현재시간 				연산 후 시간
------------------------------------------------------
	2021-03-29 12:09:51	    2021-03-30 14:12:55
------------------------------------------------------
*/

-- 함께 풀이한 내용
SELECT SYSDATE "현재시간"
     , SYSDATE + 1 + (2/24) + (3/(24*60)) + (4/(24*60*60)) "연산 후 시간"
FROM DUAL;
--==>> 
/*
2021-03-29 12:20:32	
2021-03-30 14:23:36
*/


SELECT SYSDATE "현재시간" 
     , SYSDATE + ((24*60*60) + (2*60*60) + (3*60) + 4) / (24*60*60) "연산 후 시간"
FROM DUAL;
--==>>
/*
2021-03-29 12:22:15	
2021-03-30 14:25:19
*/


--○ 날짜 - 날짜 = 일수
-- ex) (2021-07-09) - (2021-03-29)
--        수료일         현재일
SELECT TO_DATE('2021-07-09', 'YYYY-MM-DD') - TO_DATE('2019-03-29', 'YYYY-MM-DD') "확인" 
FROM DUAL;
--==>> 833

SELECT TO_DATE('2021-07-09', 'YYYY-MM-DD') - TO_DATE('2021-03-29', 'YYYY-MM-DD') "확인"
FROM DUAL;
--==>> 102

TO_DATE('2021-07-09', 'YYYY-MM-DD') -- 날짜 형식으로 변환
FROM DUAL;

--==>> 에러 발생
/*
명령의 499 행에서 시작하는 중 오류 발생 -
FROM DUAL
오류 보고 -
알 수 없는 명령
*/

SELECT TO_DATE('2021-13-09', 'YYYY-MM-DD')
FROM DUAL;
--==>> 에러 발생
/*
ORA-01843: not a valid month
01843. 00000 -  "not a valid month"
*Cause:    
*Action:
*/
--※ TO_DATE() 함수를 통해 문자 타입을 날짜 타입으로 변환을 진행할 때
--   내부적으로 해당 날짜에 대한 유효성 검사가 이루어진다~!!!


--○ ADD_MONTHS() 개월 수를 더해주는 함수
SELECT SYSDATE "1"
     , ADD_MONTHS(SYSDATE, 2) "2"
	 , ADD_MONTHS(SYSDATE, 3) "3"
	 , ADD_MONTHS(SYSDATE, -2) "4"
	 , ADD_MONTHS(SYSDATE, -3) "5"
FROM DUAL;
--==>> 
/*
2021-03-29 12:28:45	
2021-05-29 12:28:45
2021-03-29 12:30:57	
2021-05-29 12:30:57	
2021-06-29 12:30:57	
2021-01-29 12:30:57	
2020-12-29 12:30:57
*/


--※ 날짜 세션 설정 변경
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

--○ MONTHS_BETWEEN()
-- 첫 번째 인자값에서 두 번째 인자값을 뺀 개월수를 반환
SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('2002-05-31', 'YYYY-MM-DD'))
FROM DUAL;
--==>> 225.952404047192353643966547192353643967
--> 개월 수의 차이를 반환하는 함수
--※ 결과 값의 부호가 『-』(음수)로 반환되었을 경우에는
--   첫 번째 인자값에 해당하는 날짜보다
--   두 번째 인자값에 해당하는 날짜가 『미래』라는 것을 알 수 있다.

SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('2021-07-09', 'YYYY-MM-DD'))
FROM DUAL;
--==>> -3.33787223715651135005973715651135005974


--○ NEXT_DAY()
--   첫 번째 인자값을 기준 날짜로 돌아오는 가장 빠른 요일 반환
SELECT NEXT_DAY(SYSDATE, '토'), NEXT_DAY(SYSDATE, '월')
FROM DUAL;
--==>> 2021-04-03	2021-04-05


--※ 추가 세션 설정 변경
ALTER SESSION SET NLS_DATE_LANGUAGE = 'ENGLISH';
--==>> Session이(가) 변경되었습니다.

--○ 세션 설정 변경한 이후 위의 쿼리문을 다시 한 번 조회
SELECT NEXT_DAY(SYSDATE, '토'),  NEXT_DAY(SYSDATE, '월')
FROM DUAL;
--==>> 에러 발생
/*
ORA-01846: not a valid day of the week
01846. 00000 -  "not a valid day of the week"
*Cause:    
*Action:
*/

SELECT NEXT_DAY(SYSDATE, 'SAT'),  NEXT_DAY(SYSDATE, 'MON')
FROM DUAL;
--==>> 2021-04-03	2021-04-05

--○ 추가 세션 설정 변경
ALTER SESSION SET NLS_DATE_LANGUAGE = 'KOREAN';
--==>> Session이(가) 변경되었습니다.

-- 커밋과 롤백의 대상은 INSERT, UPDATE, DELETE (+ MERGE) 
-- 하지만 ALTER는 오토커밋이 포함되어 있음


--○ LAST_DAY()
-- 해당 날짜가 포함되어 있는 그 달의 마지막 날을 반환한다.
SELECT LAST_DAY(SYSDATE)
FROM DUAL;
--==>> 2021-03-31


--○ 오늘부로... 정준이가 군대에 또 끌려간다...
--   복무기간은 22개월로 한다.

-- 1. 전역 일자를 구한다.

-- 2. 하루 꼬박꼬박 3끼 식사를 해야 한다고 가정하면
--    정준이가 몇 끼를 먹어야 집에 보내줄까.

SELECT ADD_MONTHS(SYSDATE, 22)
FROM DUAL;
--==>> 2023-01-29

-- 복무기간 * 3
-- ------------
-- (전역일자 - 현재일자)
--
-- (전역일자 - 현재일자) * 3

SELECT (ADD_MONTHS(SYSDATE, 22) - SYSDATE) *3
FROM DUAL;
--==>> 2013


--○ 현재 날짜 및 시각으로 부터
--   수료일(2021-07-09 18:00:00) 까지 남은 기간을...
--   다음과 같은 형태로 조회할 수 있도록 한다.
/*
----------------------------------------------------------------------
현재 시각	  		 | 수료일 				|  일  | 시간 | 분  | 초 |
----------------------------------------------------------------------
2021-03-29 14:34:27	 | 2021-07-09 18:00:00	| 110  |  3   | 15  | 33
----------------------------------------------------------------------
*/

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
--==>> Session이(가) 변경되었습니다.

-- 내가 풀이한 내용
SELECT TO_DATE(SYSDATE) "현재 시각"
	 , TO_DATE('2021-07-09 18:00:00') "수료일"
	 , TRUNC(TRUNC(TRUNC(((TO_DATE('2021-07-09 18:00:00') - TO_DATE(SYSDATE)) * 24 * 60 * 60)/60)/60)/24) "일"
	 , MOD(TRUNC(TRUNC(((TO_DATE('2021-07-09 18:00:00') - TO_DATE(SYSDATE)) * 24 * 60 * 60)/60)/60), 24) "시간"
	 , MOD(TRUNC(((TO_DATE('2021-07-09 18:00:00') - TO_DATE(SYSDATE)) * 24 * 60 * 60)/60), 60) "분"
	 , TRUNC(MOD((TO_DATE('2021-07-09 18:00:00') - TO_DATE(SYSDATE)) * 24 * 60 * 60, 60)) "초"
FROM DUAL;


-- 힌트
--『1일 2시간 3분 4초』를 『초』로 환산하면

SELECT (1일) + (2시간) + (3분) + (4초)
FROM DUAL;

SELECT (1*24*60*60) + (2*60*60) + (3*60) + (4)
FROM DUAL;
--==>> 93784

--『93784초』를 다시 『일, 시간, 분, 초』로 환산하면...
SELECT TRUNC(TRUNC(TRUNC(93784/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC(93784/60)/60), 24) "시간"
     , MOD(TRUNC(93784/60), 60) "분"
	 , MOD(93784, 60) "초"
FROM DUAL;


-- 함께 풀이한 내용
-- 수료일까지 남은 기간 확인(날짜 기준) → 단위 : 일수

SELECT 수료일자 - 현재일자
FROM DUAL;


-- 수료일자
SELECT TO_DATE('2021-07-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;
--==>> 2021-07-09 18:00:00

SELECT TO_DATE('2021-07-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE
FROM DUAL;
--==>> 102.079097222222222222222222222222222222
--> 수료일까지 남은 일수(단위 : 일)

-- 수료일까지 남은 기간 확인(날짜기준) → 단위 : 초
SELECT (수료일까지 남은 일수) * (하루를 구성하는 전체 초)
FROM DUAL;


SELECT (TO_DATE('2021-07-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS')- SYSDATE) * (24*60*60)
FROM DUAL;
--==>> 8819405.99999999999999999999999999999997

SELECT TO_DATE(SYSDATE) "현재 시각"
	 , TO_DATE('2021-07-09 18:00:00') "수료일"
	 , TRUNC(TRUNC(TRUNC((TO_DATE('2021-07-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS')- SYSDATE) * (24*60*60)/60)/60)/24) "일"
     , MOD(TRUNC(TRUNC((TO_DATE('2021-07-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS')- SYSDATE) * (24*60*60)/60)/60), 24) "시간"
     , MOD(TRUNC((TO_DATE('2021-07-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS')- SYSDATE) * (24*60*60)/60), 60) "분"
	 , TRUNC(MOD((TO_DATE('2021-07-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS')- SYSDATE) * (24*60*60), 60)) "초"
FROM DUAL;

--○ 과제
--   본인이 태어나서 현재까지
--   얼마만큼의 일, 시간, 분, 초를 살았는지...(살고있는지...)
--   조회하는 쿼리문을 구성한다.

/*
-----------------------------------------------------------------------
현재 시각	  		 | 태어난 시각 			|  일   | 시간 | 분  | 초 |
-----------------------------------------------------------------------
2021-03-29 14:34:27	 | 1997-10-22 19:10:00	| XXXXX |  XX  | XX  | XX
-----------------------------------------------------------------------
*/


ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

--※ 날짜 데이터를 대상으로 반올림, 절삭을 수행할 수 있다.

--○ 날짜 반올림
SELECT SYSDATE "1"					-- 2021-03-29  → 기본 현재 날짜
     , ROUND(SYSDATE, 'YEAR') "2"   -- 2021-01-01  → 년도까지 유효한 데이터(상반기, 하반기 기준)
	 , ROUND(SYSDATE, 'MONTH') "3"  -- 2021-04-01  → 월까지 유효한 데이터(15일 기준)
	 , ROUND(SYSDATE, 'DD') "4" 	-- 2021-03-30  → 날짜까지 유효한 데이터(정오 기준)
	 , ROUND(SYSDATE, 'DAY') "5" 	-- 2021-03-28  → 날짜까지 유요한 데이터(수요일 기준)
FROM DUAL;

--○ 날짜 절삭
SELECT SYSDATE "1"					-- 2021-03-29  → 기본 현재 날짜
     , TRUNC(SYSDATE, 'YEAR') "2"   -- 2021-01-01  → 년도까지 유효한 데이터
	 , TRUNC(SYSDATE, 'MONTH') "3"  -- 2021-03-01  → 월까지 유효한 데이터
	 , TRUNC(SYSDATE, 'DD') "4" 	-- 2021-03-29  → 날짜까지 유효한 데이터
	 , TRUNC(SYSDATE, 'DAY') "5" 	-- 2021-03-28  → 날짜까지 유요한 데이터 → 지난주 일요일
FROM DUAL;

--------------------------------------------------------------------------------

--■■■ 변환 함수 ■■■--

-- TO_CHAR() 	: 숫자나 날짜 데이터를 문자 타입으로 변환시켜주는 함수
-- TO_DATE()	: 문자 데이터(날짜 형식)를 날짜 타입으로 변환시켜주는 함수
-- TO_NUMBER() 	: 문자 데이터(숫자 형식)를 숫자 타입으로 변환시켜주는 함수

SELECT 10 "1", TO_CHAR(10) "2"
FROM DUAL;

--※ 날짜나 통화 형식이 맞지 않을 경우
--   세션 설정값을 통해 설정할 수 있도록 한다. 

ALTER SESSION SET NLS_DATE_LANGUAGE = 'KOREAN';
--==>> Session이(가) 변경되었습니다.

ALTER SESSION SET NLS_DATE_LANGUAGE = 'KOREAN';
--==>> Session이(가) 변경되었습니다.

ALTER SESSION SET NLS_CURRENCY = '\';	-- 화폐단위 : 원(￦) ㄹ
--==>> Session이(가) 변경되었습니다.

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
--==>> Session이(가) 변경되었습니다.

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD')   -- 2021-03-29
	 , TO_CHAR(SYSDATE, 'YYYY')			-- 2021
	 , TO_CHAR(SYSDATE, 'YEAR')			-- TWENTY TWENTY-ONE
	 , TO_CHAR(SYSDATE, 'MM')			-- 03
	 , TO_CHAR(SYSDATE, 'MONTH')		-- 3월
	 , TO_CHAR(SYSDATE, 'MON')			-- 3월
	 , TO_CHAR(SYSDATE, 'DD') 			-- 29
	 , TO_CHAR(SYSDATE, 'DAY')			-- 월요일
	 , TO_CHAR(SYSDATE, 'DY')			-- 월
	 , TO_CHAR(SYSDATE, 'HH24')			-- 16
	 , TO_CHAR(SYSDATE, 'HH')			-- 04
	 , TO_CHAR(SYSDATE, 'HH AM')		-- 04 오후
	 , TO_CHAR(SYSDATE, 'HH PM')	 	-- 04 오후
	 , TO_CHAR(SYSDATE, 'MI')			-- 43
	 , TO_CHAR(SYSDATE, 'SS')			-- 26
	 , TO_CHAR(SYSDATE, 'SSSSS')		-- 60268	→ 금일 흘러온 전체 초
	 , TO_CHAR(SYSDATE, 'Q')			-- 1		→ 분기
FROM DUAL;

SELECT '04' "1", TO_NUMBER('04') "2"
FROM DUAL;
--==>> 04	4


SELECT TO_CHAR(4) "1", '4' "2"
FROM DUAL;

SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) "확인"
FROM DUAL;
--==>> 2021

--○ EXTRACT()
SELECT TO_CHAR(SYSDATE, 'YYYY')		-- 2021 → 연도를 추출하여 문자 타입으로
	 , TO_CHAR(SYSDATE, 'MM')		-- 03   → 월을 추출하여 문자 타입으로
	 , TO_CHAR(SYSDATE, 'DD')		-- 29   → 일을 추출하여 문자 타입으로
	 , EXTRACT(YEAR FROM SYSDATE)	-- 2021 → 연도를 추출하여 숫자 타입으로
	 , EXTRACT(MONTH FROM SYSDATE)	-- 3    → 월을 추출하여 숫자 타입으로
	 , EXTRACT(DAY FROM SYSDATE)	-- 29 	→ 일을 추출하여 숫자 타입으로
FROM DUAL;
--> 년, 월, 일 이하 다른 것은 불가

--○ TO_CHAR() 활용 → 형식 맞춤 표기 결과값 반환
SELECT 60000 "1"
     , TO_CHAR(60000) "2"				-- 60000 문자타입으로
	 , TO_CHAR(60000, '99,999') "3"		-- 60,000
	 , TO_CHAR(60000, '$99,999') "4"	-- $60,000
	 , TO_CHAR(60000, 'L99,999') "5" 	--         ￦60,000
	 , LTRIM(TO_CHAR(60000, 'L99,999')) "6" -- ￦60,000
FROM DUAL;


--○ 현재 시간을 기준으로 1일 2시간 3분 4초 후를 조회한다.
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

SELECT SYSDATE "현재시간"
     , SYSDATE + 1 + (2/24) + (3/(24*60)) + (4/(24*60*60)) "1일2시간3분4초후"
FROM DUAL;
--==>>
/*
2021-03-29 17:18:20	
2021-03-30 19:21:24
*/


--○ 현재 시간을 기준으로 1년 2개월 3일 4시간 5분 6초 후를 조회
-- TO_YMINTERVAL(), TO_DSINTERVAL()
SELECT SYSDATE "현재 시간"
	 , SYSDATE + TO_YMINTERVAL('01-02') + TO_DSINTERVAL('003 04:05:06') "연산 결과"
FROM DUAL;


--------------------------------------------------------------------------------

--■■■ CASE 구문(조건문, 분기문) ■■■--
/*
CASE
WHEN
THEN
ELSE
END
*/

SELECT CASE 5+2 WHEN 7 THEN '5+2=7' ELSE '5+2는몰라요' END "결과확인"
FROM DUAL;
--==>> 5+2=7

SELECT CASE 5+2 WHEN 9 THEN '5+2=9' ELSE '5+2는몰라요' END "결과확인"
FROM DUAL;
--==>> 5+2는몰라요


SELECT CASE 1+1 WHEN 2 THEN '1+1=2'
				WHEN 3 THEN '1+1=3'
				WHEN 4 THEN '1+1=4'
				ELSE '몰라'
	   END "결과 확인"
FROM DUAL;
--==>> 1+1=2

--○ DECODE() 
SELECT DECODE(5-2, 1, '5-2=1', 2, '5-2=2', 3, '5-2=3', '5-2는 몰라') "결과 확인"
FROM DUAL;
--==>> 5-2=3


--○ CASE WHEN THEN ELSE END 구문 활용
SELECT CASE WHEN 5<2 THEN '5<2'
            WHEN 5>2 THEN '5>2'
			ELSE '5와 2는 비교불가'
	   END "결과 확인"
FROM DUAL;
--==>> 5>2

SELECT CASE WHEN 5<2 OR 3>1 AND 2=2 THEN '혜연만세'
	        WHEN 5>2 OR 2=3 THEN '새롬만세'
			ELSE '희주만세'
	   END "결과 확인"
FROM DUAL;
--==>> 혜연만세

SELECT CASE WHEN 3<1 AND 5<2 OR 3>1 AND 2=2 THEN '혜연만세'
		    WHEN 5<2 AND 2=2 THEN '새롬만세'
			ELSE '희주만세'
       END "결과 확인"
FROM DUAL;
--==>> 혜연만세

SELECT CASE WHEN 3<1 AND (5<2 OR 3>1) AND 2=2 THEN '혜연만세'
		    WHEN 5<2 AND 2=2 THEN '새롬만세'
			ELSE '희주만세'
       END "결과 확인"
FROM DUAL;
--==>> 희주만세
















