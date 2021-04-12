SELECT USER
FROM DUAL;
--==>> SCOTT

--○ TBL_STUDENTS 테이블에서
--   전화번호와 주소 데이터를 수정하는(변경하는) 프로시저를 작성한다.
--   단, ID 와 PW 가 일치하는 경우에만 수정을 진행할 수 있도록 한다.
--   프로시저명 : PRC_STUDENTS_UPDATE
/*
실행 예)
EXEC PRC_STUDENTS_UPDATE('superman', 'java006$', '010-9999-9999', '경기 일산');

프로시저 호출로 처리된 결과)
superman	박정준	010-9999-9999	경기 일산
*/

-- 함께 풀이한 결과
CREATE OR REPLACE PROCEDURE PRC_STUDENTS_UPDATE
( V_ID      IN TBL_IDPW.ID%TYPE
, V_PW      IN TBL_IDPW.PW%TYPE
, V_TEL     IN TBL_STUDENTS.TEL%TYPE
, V_ADDR    IN TBL_STUDENTS.ADDR%TYPE
)
IS
BEGIN
    -- UPDATE 쿼리문 구성
    /*
    UPDATE (SELECT I.ID, I.PW, S.TEL, S.ADDR
            FROM TBL_IDPW I JOIN TBL_STUDENTS S
            ON I.ID=S.ID) T
    SET T.TEL = 입력받은전화번호, T.ADDR = 입력받은주소
    WHERE T.ID = 입력받은아이디 AND T.PW = 입력받은패스워드;
    */
    
    UPDATE (SELECT I.ID, I.PW, S.TEL, S.ADDR
            FROM TBL_IDPW I JOIN TBL_STUDENTS S
            ON I.ID=S.ID) T
    SET T.TEL = V_TEL, T.ADDR = V_ADDR
    WHERE T.ID = V_ID AND T.PW = V_PW;
    
    -- 커밋
    COMMIT;
END;
--==>> Procedure PRC_STUDENTS_UPDATE이(가) 컴파일되었습니다.


--○ TBL_INSA 테이블을 대상으로 신규 데이터 입력 프로시저를 작성한다.
--   NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG
--   구조를 갖고 있는 대상 테이블에 데이터 입력 시
--   NUM 항목(사원번호)의 값은
--   기존 부여된 사원번호 마지막 번호의 그 다음 번호를
--   자동으로 입력 처리할 수 있는 프로시저로 구성한다.
--   프로시저명 : PRC_INSA_INSERT(NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG)
/*
EXEC PRC_INSA_INSERT('한혜림', '971006-2234567', SYSDATE, '서울', '010-5555-5555'
                    , '영업부', '대리', 5000000, 500000)
                    
프로시저 호출로 처리된 결과)
1061  한혜림  971006-2234567  2021-04-09  서울  010-5555-5555 영업부  대리  5000000  500000
*/
-- 내가 풀이한 내용
CREATE OR REPLACE PROCEDURE PRC_INSA_INSERT
( V_NAME        IN TBL_INSA.NAME%TYPE
, V_SSN         IN TBL_INSA.SSN%TYPE
, V_IBSADATE    IN TBL_INSA.IBSADATE%TYPE
, V_CITY        IN TBL_INSA.CITY%TYPE
, V_TEL         IN TBL_INSA.TEL%TYPE
, V_BUSEO       IN TBL_INSA.BUSEO%TYPE
, V_JIKWI       IN TBL_INSA.JIKWI%TYPE
, V_BASICPAY    IN TBL_INSA.BASICPAY%TYPE
, V_SUDANG      IN TBL_INSA.SUDANG%TYPE
)
IS
    V_NUM       TBL_INSA.NUM%TYPE;
    N           NUMBER;
BEGIN
    -- 방법1
    SELECT NUM + 1 INTO V_NUM
    FROM TBL_INSA
    WHERE ROWNUM = 1
    ORDER BY NUM DESC;

    -- 방법2
    /*
    SELECT MAX(NUM)+1 INTO V_NUM
    FROM TBL_INSA;
    */

    INSERT INTO TBL_INSA(NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG)
    VALUES (V_NUM, V_NAME, V_SSN, V_IBSADATE, V_CITY, V_TEL, V_BUSEO, V_JIKWI, V_BASICPAY, V_SUDANG);
END;
--==>> Procedure PRC_INSA_INSERT이(가) 컴파일되었습니다.

-- 함께 풀이한 내용
CREATE OR REPLACE PROCEDURE PRC_INSA_INSERT
( V_NAME        IN TBL_INSA.NAME%TYPE
, V_SSN         IN TBL_INSA.SSN%TYPE
, V_IBSADATE    IN TBL_INSA.IBSADATE%TYPE
, V_CITY        IN TBL_INSA.CITY%TYPE
, V_TEL         IN TBL_INSA.TEL%TYPE
, V_BUSEO       IN TBL_INSA.BUSEO%TYPE
, V_JIKWI       IN TBL_INSA.JIKWI%TYPE
, V_BASICPAY    IN TBL_INSA.BASICPAY%TYPE
, V_SUDANG      IN TBL_INSA.SUDANG%TYPE
)
IS
    -- INSERT 쿼리문 수행에 필요한 변수 추가 선언
    -- → V_NUM
    V_NUM   TBL_INSA.NUM%TYPE;
BEGIN
    SELECT MAX(NUM)+1 INTO V_NUM
    FROM TBL_INSA;
    
    -- INSERT 쿼리문 구성
    INSERT INTO TBL_INSA(NUM, NAME, SSN, IBSADATE, CITY, TEL, BUSEO, JIKWI, BASICPAY, SUDANG)
    VALUES (V_NUM, V_NAME, V_SSN, V_IBSADATE, V_CITY, V_TEL, V_BUSEO, V_JIKWI, V_BASICPAY, V_SUDANG);
END;
--==>> Procedure PRC_INSA_INSERT이(가) 컴파일되었습니다.



--○ TBL_상품, TBL_입고 테이블을 대상으로...
--   TBL_입고 테이블에 데이터 입력 시(즉, 입고 이벤트 발생 시)
--   TBL_상품 테이블의 재고수량이 함께 변동될 수 있는 기능을 가진
--   프로시저를 작성한다.
--   단, 이 과정에서 입고번호는 자동 증가 처리한다. (시퀀스 사용 X)
--   TBL_입고 테이블 구성 컬럼
--   → 입고번호, 상품코드, 입고일자, 입고수량, 입고단가
--   프로시저명 : PRC_입고_INSERT(상품코드, 입고수량, 입고단가)

-- 내가 풀이한 내용 
CREATE OR REPLACE PROCEDURE PRC_입고_INSERT
( V_상품코드  IN TBL_입고.상품코드%TYPE
, V_입고수량  IN TBL_입고.입고수량%TYPE
, V_입고단가  IN TBL_입고.입고단가%TYPE
)
IS
    V_입고번호  TBL_입고.입고번호%TYPE;
BEGIN
    /*
    SELECT NVL(MAX(입고번호) + 1, 1) INTO V_입고번호
    FROM TBL_입고;
    */
    
    SELECT COUNT(*)+1 INTO V_입고번호
    FROM TBL_입고;
    
    INSERT INTO TBL_입고(입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
    VALUES(V_입고번호, V_상품코드, SYSDATE, V_입고수량, V_입고단가);
    
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    --커밋
    COMMIT;
END;
--==>> Procedure PRC_입고_INSERT이(가) 컴파일되었습니다.

-- 함께 풀이한 내용
--※ TBL_입고 테이블에 입고 이벤트 발생 시...
--   관련 테이블에서 수행되어야 하는 내용
--   ① INSERT → TBL_입고
--      INSERT INTO TBL_입고(입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
--      VALUES(1, 'H001', SYSDATE, 20, 900);
--   ② UPDATE → TBL_상품
--      UPDATE TBL_상품
--      SET 재고수량 = 입고수량
--      WHERE 상품코드 = 'H001';

CREATE OR REPLACE PROCEDURE PRC_입고_INSERT
( V_상품코드  IN TBL_상품.상품코드%TYPE    -- 상품코드는 두 테이블에 다 있지만 TBL_상품이 부모테이블임 
, V_입고수량  IN TBL_입고.입고수량%TYPE
, V_입고단가  IN TBL_입고.입고단가%TYPE
)
IS
    -- 아래의 쿼리문을 수행하기 위해 필요한 데이터를 변수로 선언
    V_입고번호  TBL_입고.입고번호%TYPE;
BEGIN
    -- 선언한 변수(V_입고번호)에 값 담아내기
    SELECT NVL(MAX(입고번호), 0) INTO V_입고번호
    FROM TBL_입고;
    
    -- 쿼리문 구성
    -- ① INSERT → TBL_입고
    INSERT INTO TBL_입고(입고번호, 상품코드, 입고수량, 입고단가) -- 입고일자는 DEFAULT 처리가 되어있어서 안써줘도 됨
    VALUES((V_입고번호+1), V_상품코드, V_입고수량, V_입고단가);
    
    -- ② UPDATE → TBL_상품
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 커밋
    COMMIT;
    
    -- 예외 처리 
    EXCEPTION
        WHEN OTHERS THEN ROLLBACK;
END;
--==>> Procedure PRC_입고_INSERT이(가) 컴파일되었습니다.
--> 트랜잭션 처리(은행 예시 기억, 나현이가 가영이한테 100만원을 빌림~!)


--■■■ 프로시저 내에서의 예외 처리 ■■■--

--○ 테이블 생성(TBL_MEMBER) → 20210409_02_scott.sql 파일 참조

--○ TBL_MEMBER 테이블에 데이터를 입력하는 프로시저를 생성
--   단, 이 프로시저를 통해 데이터를 입력할 경우
--   CITY(지역) 항목에 '서울', '경기', '인천' 만 입력이 가능하도록 구성한다.
--   이 지역 외의 지역을 프로시저 호출을 통해 입력하려는 경우
--   예외 처리를 하려고 한다.
--   프로시저명 : PRC_MEMBER_INSERT(이름, 전화번호, 지역)

CREATE OR REPLACE PROCEDURE PRC_MEMBER_INSERT
( V_NAME    IN TBL_MEMBER.NAME%TYPE
, V_TEL     IN TBL_MEMBER.TEL%TYPE
, V_CITY    IN TBL_MEMBER.CITY%TYPE
)
IS -- 오라클의 IS영역은 순차적으로 수행됨

    -- 실행 영역의 쿼리문 수행을 위해 필요한 데이터 변수 선언
    V_NUM   TBL_MEMBER.NUM%TYPE;
    
    -- 사용자 정의 예외에 대한 변수 선언~!!!  CHECK~!!!
    USER_DEFINE_ERROR EXCEPTION;
    
BEGIN -- 오라클의 BEGIN영역은 순차적으로 수행됨

    -- 프로시저를 통해 입력 처리를 정상적으로 진행해야 할 데이터인지
    -- 아닌지의 여부를 가장 먼저 확인할 수 있도록 코드 구성
    
    IF(V_CITY NOT IN ('서울', '경기','인천'))     -- '서울', '경기', '인천' 중 하나가 들어있지 않다면
        -- 예외 발생~!!! CHECK~!!!
        THEN RAISE USER_DEFINE_ERROR;            -- 자바의 Throw~ 예외 발생 구문과 같은 기능
    END IF;                                      -- 예외 발생되면 하던거 멈추고 EXCEPTION 찾아감
    
    -- 선언한 변수에 값 담아내기
    SELECT NVL(MAX(NUM), 0) INTO V_NUM  -- 0 OR 최대값
    FROM TBL_MEMBER;

    -- 쿼리문 구성(INSERT)
    INSERT INTO TBL_MEMBER(NUM, NAME, TEL, CITY)
    VALUES((V_NUM+1), V_NAME, V_TEL, V_CITY);
    
    -- 커밋
    COMMIT;
    
    -- 예외 처리
    /*
    EXCEPTION
        WHEN 이런 예외라면
            THEN 이렇게 처리하고,
        WHEN 저런 예외라면
            THEN 저렇게 처리해라
   
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-에러코드, 에러내용기술);
            -- 에러코드 20000번까지는 오라클이 선점해서 쓰고 있는 에러코드이기 때문에 
            -- 20000번 이후부터 자유롭게 사용
        WHEN 저런 예외라면
            THEN 저렇게 처리해라 
    */
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '서울,인천,경기만 입력 가능합니다.'); 
            ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;   
END;
--==>> Procedure PRC_MEMBER_INSERT이(가) 컴파일되었습니다.


--○ TBL_출고 테이블에 데이터 입력 시(즉, 출고 이벤트 발생 시)
--   TBL_상품 테이블의 재고수량이 변동되는 프로시저를 작성한다.
--   단, 출고번호는 입고번호와 마찬가지로 자동 증가.
--   또한, 출고 수량이 재고 수량보다 많은 경우...
--   출고 액션을 취소할 수 있도록 처리한다. (출고가 이루어지지 않도록)
--   프로시저명 : PRC_출고_INSERT(상품코드, 출고수량, 출고단가)

-- 내가 풀이한 내용
CREATE OR REPLACE PROCEDURE PRC_출고_INSERT
( V_상품코드    IN TBL_출고.상품코드%TYPE
, V_출고수량    IN TBL_출고.출고수량%TYPE
, V_출고단가    IN TBL_출고.출고단가%TYPE
)
IS
    V_출고번호         TBL_출고.출고번호%TYPE;
    V_재고수량         TBL_상품.재고수량%TYPE;    
    USER_DEFINE_ERROR EXCEPTION;
BEGIN
    -- 특정 상품의 재고를 V_재고수량 변수에 담기
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;

    -- 출고수량이 재고수량보다 많은 경우 예외를 발생시키는 구문
    IF (V_출고수량 > V_재고수량)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    -- 출고번호 자동 증가 구문
    SELECT NVL(MAX(출고번호), 0) + 1 INTO V_출고번호
    FROM TBL_출고;
    
    -- 출고 성공 시 TBL_출고 테이블에 데이터 입력
    INSERT INTO TBL_출고(출고번호, 상품코드, 출고수량, 출고단가) -- 출고일자는 DEFAULT SYSDATE라 생략
    VALUES (V_출고번호, V_상품코드, V_출고수량, V_출고단가);
    
    -- 출고 성공 시 TBL_상품 테이블에서 데이터 수정
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 커밋
    COMMIT;
    
    -- 예외처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '출고수량이 재고수량보다 많습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_출고_INSERT이(가) 컴파일되었습니다.


-- 함께 풀이한 내용
CREATE OR REPLACE PROCEDURE PRC_출고_INSERT
( V_상품코드    IN TBL_출고.상품코드%TYPE
, V_출고수량    IN TBL_출고.출고수량%TYPE
, V_출고단가    IN TBL_출고.출고단가%TYPE
)
IS
    -- 주요 변수 선언
    V_출고번호  TBL_출고.출고번호%TYPE;
    V_재고수량  TBL_상품.재고수량%TYPE;
    
    USER_DEFINE_ERROR EXCEPTION;       -- 사용자 정의 예외
    
BEGIN
    -- 쿼리문 수행 이전에 수행 여부 확인 → 기존 재고 확인 → 출고 수량과 비교
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    -- 출고를 정상적으로 진행해 줄 것인지에 대한 여부 확인
    -- (파악한 재고수량보다 출고수량이 많으면, 예외발생)
    IF(V_출고수량 > V_재고수량)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- 선언한 변수에 값 담아내기
    SELECT NVL(MAX(출고번호), 0) INTO V_출고번호
    FROM TBL_출고;

    -- 쿼리문 구성(INSERT → TBL_출고)
    INSERT INTO TBL_출고(출고번호, 상품코드, 출고수량, 출고단가)
    VALUES((V_출고번호+1), V_상품코드, V_출고수량, V_출고단가);
    
    -- 쿼리문 구성(UPDATE → TBL_상품)
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 커밋
    COMMIT;
    
    -- 예외 처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '재고 부족~!!!');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_출고_INSERT이(가) 컴파일되었습니다.

-- SELECT 재고수량 한 것을 변수에 담아서 변수에 담긴 내용과 비교를 해야함
-- PL/SQL에서 SELECT 문과 바로 비교할 수는 없음 


--○ TBL_출고 테이블에서 출고 수량을 변경(수정)하는 프로시저를 작성한다.
--   프로시저명 : PRC_출고_UPDATE(출고번호, 변경할 수량);
CREATE OR REPLACE PROCEDURE PRC_출고_UPDATE
( V_출고번호    IN TBL_출고.출고번호%TYPE
, V_변경수량    IN TBL_출고.출고수량%TYPE
)
IS
    V_재고수량  TBL_상품.재고수량%TYPE;
    V_출고수량  TBL_출고.출고수량%TYPE;
    
    USER_DEFINE_ERROR  EXCEPTION;
BEGIN
    -- 출고 테이블의 출고수량을 V_출고수량 변수에 담기
    SELECT 출고수량 INTO V_출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    -- 상품 테이블의 재고수량을 V_재고수량 변수에 담기
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = ( SELECT 상품코드
                       FROM TBL_출고
                       WHERE 출고번호 = V_출고번호 );

    -- 변경수량이 (재고수량 + 출고수량) 보다 크면 출고를 진행할 수 없음 → 예외 발생
    IF(V_변경수량 > (V_재고수량 + V_출고수량))
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    -- 재고수량 변경하는 UPDATE 쿼리
    UPDATE TBL_상품
    SET 재고수량 = (V_재고수량 + V_출고수량) - V_변경수량
    WHERE 상품코드 = ( SELECT 상품코드
                       FROM TBL_출고
                       WHERE 출고번호 = V_출고번호 );
    
    -- 출고수량 변경하는 UPDATE 쿼리
    -- 재고수량 변경시 출고수량을 사용하기 때문에 출고수량을 나중에 업데이트 하도록 구성
    UPDATE TBL_출고
    SET 출고수량 = V_변경수량
    WHERE 출고번호 = V_출고번호;
    
    -- 커밋
    COMMIT;
    
    -- 예외 처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20003, '변경할 수량이 재고수량보다 많습니다.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;   
END;
--==>> Procedure PRC_출고_UPDATE이(가) 컴파일되었습니다.
--> 테스트 할 때도 커밋을 넣고 작성하는게 바람직하다
--  결과를 확인 후 데이터를 이전상태로 복구해두는게 맞음.

























