SELECT USER
FROM DUAL;
--==>> SCOTT

SET SERVEROUTPUT ON;
--==>> 작업이 완료되었습니다.

--○ 함수 정의 과제

--○ TBL_INSA 테이블의 급여 계산 전용 함수를 정의한다.
--   급여는 (기본급*12)+수당 기반으로 연산을 수행한다.
--   함수명 : FN_PAY(기본급, 수당)
CREATE OR REPLACE FUNCTION FN_PAY
( V_BASICPAY IN TBL_INSA.BASICPAY%TYPE
, V_SUDANG IN TBL_INSA.SUDANG%TYPE
)
RETURN NUMBER
IS
    VRESULT NUMBER;
BEGIN
    VRESULT := (V_BASICPAY * 12) + V_SUDANG;
    RETURN VRESULT;
END;
--==>> Function FN_PAY이(가) 컴파일되었습니다.
   

--○ TBL_INSA 테이블의 입사일을 기준으로 
--   현재까지의 근무년수를 반환하는 함수를 정의한다.
--   단, 근무년수는 소수점 이하 한자리까지 계산한다.
--   함수명 : FN_WORKYEAR(입사일)
CREATE OR REPLACE FUNCTION FN_WORKYEAR
( V_IBSADATE IN TBL_INSA.IBSADATE%TYPE
)
RETURN NUMBER
IS
    VRESULT NUMBER(4,1);
BEGIN
    VRESULT := TRUNC(MONTHS_BETWEEN(SYSDATE, V_IBSADATE)/12, 1);
    RETURN VRESULT;
END;
--==>> Function FN_WORKYEAR이(가) 컴파일되었습니다.












