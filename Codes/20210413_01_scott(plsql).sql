SELECT USER
FROM DUAL;
--==>> SCOTT

--■■■ PACKAGE(패키지) ■■■--

-- 1. PL/SQL 의 패키지는 관계되는 타입, 프로그램 객체,
--    서브 프로그램(PROCEDURE, FUNCTION 등)을
--    논리적으로 묶어놓은 것으로
--    오라클에서 제공하는 패키지 중 하나가 바로 『DBMS_OUTPUT』이다.

-- 2. 패키지는 서로 유사한 업무에 사용되는 여러 개의 프로시저와 함수를
--    하나의 패키지로 만들어 관리함으로써 향후 유지보수가 편리하고
--    전체 프로그램을 모듈화 할 수 있는 장점이 있다.

-- 3. 패키지는 명세부(PACKAGE SPECIFICATION)와
--    몸체부(PACKAGE BODY)로 구성되어 있으며,
--    명세 부분에는 TYPE, CONSTRAINT, VARIABLE, EXCEPTION, CURSOR, SUBPROGRAM 이 선언되고
--    몸체 부분에는 이들의 실제 내용이 존재하게 된다.
--    그리고 호출할 때에는 『패키지명.프로시저명』형식의 참조를 이용해야 한다.

-- 4. 형식 및 구조(명세부)
/*
CREATE [OR REPLACE] PACKGAGE 패키지명
IS
    전역변수 선언;
    커서 선언;
    예외 선언;
    함수 선언;
    프로시저 선언;
        :
END 패키지명;
*/

-- 5. 형식 및 구조(몸체부)
/*
CREATE [OR REPLACE] PACKAGE BODY 패키지명
IS
    FUNCTION 함수명[(인수, ...)]
    RETURN 자료형
    IS
        변수 선언;
    BEGIN
        함수 몸체 구성 코드;
        RETURN값;
    END;
    
    PROCEDURE 프로시저명[(인수, ...)]
    IS
        변수 선언;
    BEGIN
        프로시저 몸체 구성 코드;
    END;
    
END 패키지명;
*/
-- 같은 패키지라면 명세부와 몸체부의 패키지명이 같아야 한다. 


--○ 주민번호 입력 시 성별을 반환하는 함수
--   이 함수를 구성요소로 취하는 패키지 작성

-- 함수 준비
CREATE OR REPLACE FUNCTION FN_GENDER(V_SSN VARCHAR2)
RETURN VARCHAR2
IS
    V_RESULT VARCHAR2(20);
BEGIN
    IF (SUBSTR(V_SSN, 8, 1) IN ('1', '3'))
        THEN V_RESULT := '남자';
    ELSIF (SUBSTR(V_SSN, 8, 1) IN ('2', '4'))
        THEN V_RESULT := '여자';
    ELSE 
        V_RESULT := '확인불가';
    END IF;
    
    RETURN V_RESULT;
END;
--==>> Function FN_GENDER이(가) 컴파일되었습니다.


-- 패키지 등록

-- 1. 명세부 작성
CREATE OR REPLACE PACKAGE INSA_PACK
IS
    FUNCTION FN_GENDER(V_SSN VARCHAR2)
    RETURN VARCHAR2;
    
END INSA_PACK;
--==>> Package INSA_PACK이(가) 컴파일되었습니다.


-- 2. 몸체부 작성
CREATE OR REPLACE PACKAGE BODY INSA_PACK
IS
    -- 생성해둔 함수 붙여넣음(CREATE OR REPLACE 제외)
    FUNCTION FN_GENDER(V_SSN VARCHAR2)
    RETURN VARCHAR2
    IS
        V_RESULT VARCHAR2(20);
    BEGIN
        IF (SUBSTR(V_SSN, 8, 1) IN ('1', '3'))
            THEN V_RESULT := '남자';
        ELSIF (SUBSTR(V_SSN, 8, 1) IN ('2', '4'))
            THEN V_RESULT := '여자';
        ELSE 
            V_RESULT := '확인불가';
        END IF;
        
        RETURN V_RESULT;
    END;
    
END INSA_PACK;
--==>> Package Body INSA_PACK이(가) 컴파일되었습니다.


