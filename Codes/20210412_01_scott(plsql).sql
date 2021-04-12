SELECT USER
FROM DUAL;
--==>> SCOTT

--○ TBL_출고 테이블에서 출고 수량을 변경(수정)하는 프로시저를 작성한다.
--   프로시저명 : PRC_출고_UPDATE(출고번호, 변경할 수량);
-- 함께 풀이한 내용
CREATE OR REPLACE PROCEDURE PRC_출고_UPDATE
( 
    --① 매개변수 구성
    V_출고번호  IN TBL_출고.출고번호%TYPE
,   V_출고수량  IN TBL_출고.출고수량%TYPE
)
IS
    --③ 주요 변수 선언
    V_상품코드  TBL_상품.상품코드%TYPE;
    
    --⑤ 주요 변수 추가 선언
    V_이전출고수량    TBL_출고.출고수량%TYPE;
    
    --⑧ 주요 변수 추가 선언
    V_재고수량  TBL_상품.재고수량%TYPE;
    
    --⑩ 주요 변수(사용자 정의 예외) 추가 선언
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    --④ 상품코드 파악 / ⑥ 이전출고수량 파악 → 변경 이전의 출고 내역 확인
    SELECT 상품코드, 출고수량 INTO V_상품코드, V_이전출고수량
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    --⑦ 출고를 정상적으로 수행해야 하는지의 여부 판단 필요
    --   변경 이전의 출고수량 및 현재의 재고수량 확인
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    --⑨ 파악한 재고수량에 따라 데이터 변경 실시 여부 판단
    --   (『재고수량+이전출고수량 < 현재출고수량』)
    IF (V_재고수량 + V_이전출고수량 < V_출고수량)
        --THEN 예외 발생;
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    --② 수행된 쿼리문 체크(UPDATE→TBL_출고 / UPDATE→TBL_상품)
    UPDATE TBL_출고
    SET 출고수량 = V_출고수량
    WHERE 출고번호 = V_출고번호;
    
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_이전출고수량 - V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    --⑪ 커밋
    COMMIT;
    
    --⑫ 예외 처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '재고 부족~!!!');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_출고_UPDATE이(가) 컴파일되었습니다.


--○ TBL_입고 테이블에서 입고수량을 수정(변경)하는 프로시저를 작성한다.
--   프로시저명 : PRC_입고_UPDATE(입고번호, 변경할 입고수량);
--   출고 신경 X
-- 내가 풀이한 내용
CREATE OR REPLACE PROCEDURE PRC_입고_UPDATE
( V_입고번호  IN TBL_입고.입고번호%TYPE
, V_변경수량  IN TBL_입고.입고수량%TYPE
)
IS
    V_상품코드  TBL_상품.상품코드%TYPE;
    V_입고수량  TBL_입고.입고수량%TYPE; 
    V_재고수량  TBL_상품.재고수량%TYPE;
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    SELECT 상품코드, 입고수량 INTO V_상품코드, V_입고수량
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    -- 예외발생
    -- 재고랑 변경수량을 합친 것 보다 기존입고수량이 더 크다면 
    -- 재고부족으로 수량 변경 불가
    IF (V_재고수량 + V_변경수량 < V_입고수량 )
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- TBL_입고 UPDATE 쿼리문 작성
    UPDATE TBL_입고
    SET 입고수량 = V_변경수량
    WHERE 입고번호 = V_입고번호;
    
    -- TBL_상품 UPDATE 쿼리문 작성
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_변경수량 - V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 커밋
    COMMIT;
    
    -- 예외처리
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '재고 부족~!!!');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK; 
END;
--==>> Procedure PRC_입고_UPDATE이(가) 컴파일되었습니다.


--○ TBL_출고 테이블에서 출고수량을 삭제하는 프로시저를 작성한다.
--   프로시저명 : PRC_출고_DELETE(출고번호);
--   입고 신경 X
CREATE OR REPLACE PROCEDURE PRC_출고_DELETE
(
    V_출고번호  IN TBL_출고.출고번호%TYPE
)
IS
    V_출고수량 TBL_출고.출고수량%TYPE;
    V_상품코드 TBL_상품.상품코드%TYPE;
BEGIN
    -- 기존 출고수량을 V_출고수량 변수에 대입
    SELECT 출고수량, 상품코드 INTO V_출고수량, V_상품코드
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;

    -- TBL_출고 DELETE 쿼리문 작성
    DELETE
    FROM TBL_출고
    WHERE 출고번호 = V_출고번호;
    
    -- TBL_상품 UPDATE 쿼리문 작성
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 + V_출고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 커밋
    -- COMMIT;
END;
--==>> Procedure PRC_출고_DELETE이(가) 컴파일되었습니다.


--○ TBL_입고 테이블에서 입고수량을 삭제하는 프로시저를 작성한다.
--   프로시저명 : PRC_입고_DELECT(입고번호);
CREATE OR REPLACE PROCEDURE PRC_입고_DELETE
(
    V_입고번호  IN TBL_입고.입고번호%TYPE
)
IS
    V_상품코드  TBL_상품.상품코드%TYPE;
    V_입고수량  TBL_입고.입고수량%TYPE;
    V_재고수량  TBL_상품.재고수량%TYPE;
    
    USER_DEFINE_ERROR   EXCEPTION;
BEGIN
    SELECT 상품코드, 입고수량 INTO V_상품코드, V_입고수량
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    SELECT 재고수량 INTO V_재고수량
    FROM TBL_상품
    WHERE 상품코드 = V_상품코드;
    
    IF (V_입고수량 > V_재고수량)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    -- TBL_입고 DELETE 쿼리문 작성
    DELETE
    FROM TBL_입고
    WHERE 입고번호 = V_입고번호;
    
    -- TBL_상품 UPDATE 쿼리문 작성
    UPDATE TBL_상품
    SET 재고수량 = 재고수량 - V_입고수량
    WHERE 상품코드 = V_상품코드;
    
    -- 커밋
    -- COMMIT;
    
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '재고 부족~!!!');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_입고_DELETE이(가) 컴파일되었습니다.


--------------------------------------------------------------------------------

--■■■ CURSOR(커서) ■■■--

-- 1. 오라클에서 하나의 레코드가 아닌 여러 레코드로 구성된
--    작업 영역에서 SQL 문을 실행하고 그 과정에서 발생한 정보를
--    저장하기 위하여 커서(CURSOR)를 사용하며,
--    커서에는 암시적 커서와 명시적 커서가 있다.


-- 2. 암시적 커서는 모든 SQL 문에 존재하며,
--    SQL 실행 후 오직 하나의 행(ROW)만 출력하게 된다.
--    그러나 SQL 문을 실행한 결과물(RESULT SET)이
--    여러 행(ROW)으로 구성된 경우
--    커서(CURSOR)를 명시적으로 선언해야 여러 행을 다룰 수 있다.


--○ 커서 이용 전 상황(단일 행 접근 시)
SET SERVEROUTPUT ON;

DECLARE 
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
BEGIN
    SELECT NAME, TEL INTO V_NAME, V_TEL
    FROM TBL_INSA
    WHERE NUM=1001;
    
    DBMS_OUTPUT.PUT_LINE(V_NAME || ', ' || V_TEL);
END;
--==>> 홍길동, 011-2356-4528

--○ 커서 이용 전 상황(다중 행 접근 시)
DECLARE 
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
BEGIN
    SELECT NAME, TEL INTO V_NAME, V_TEL
    FROM TBL_INSA;
    
    DBMS_OUTPUT.PUT_LINE(V_NAME || ', ' || V_TEL);
END;
--==>> 에러 발생
/*
01422. 00000 -  "exact fetch returns more than requested number of rows"
*/

--○ 커서 이용 전 상황(다중 행 접근 시 - 반복문을 활용하는 경우)
DECLARE
    V_NAME  TBL_INSA.NAME%TYPE;
    V_TEL   TBL_INSA.TEL%TYPE;
    V_NUM   TBL_INSA.NUM%TYPE := 1001;
BEGIN
    LOOP
        SELECT NAME, TEL INTO V_NAME, V_TEL
        FROM TBL_INSA
        WHERE NUM = V_NUM;
        
        DBMS_OUTPUT.PUT_LINE(V_NAME || ', ' || V_TEL);
        V_NUM := V_NUM + 1;
        
        EXIT WHEN V_NUM >= 1061;
    END LOOP;
END;
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.
/*
홍길동, 011-2356-4528
이순신, 010-4758-6532
이순애, 010-4231-1236
김정훈, 019-5236-4221
한석봉, 018-5211-3542
이기자, 010-3214-5357
장인철, 011-2345-2525
김영년, 016-2222-4444
나윤균, 019-1111-2222
김종서, 011-3214-5555
유관순, 010-8888-4422
정한국, 018-2222-4242
조미숙, 019-6666-4444
황진이, 010-3214-5467
이현숙, 016-2548-3365
이상헌, 010-4526-1234
엄용수, 010-3254-2542
이성길, 018-1333-3333
박문수, 017-4747-4848
유영희, 011-9595-8585
홍길남, 011-9999-7575
이영숙, 017-5214-5282
김인수, 
김말자, 011-5248-7789
우재옥, 010-4563-2587
김숙남, 010-2112-5225
김영길, 019-8523-1478
이남신, 016-1818-4848
김말숙, 016-3535-3636
정정해, 019-6564-6752
지재환, 019-5552-7511
심심해, 016-8888-7474
김미나, 011-2444-4444
이정석, 011-3697-7412
정영희, 
이재영, 011-9999-9999
최석규, 011-7777-7777
손인수, 010-6542-7412
고순정, 010-2587-7895
박세열, 016-4444-7777
문길수, 016-4444-5555
채정희, 011-5125-5511
양미옥, 016-8548-6547
지수환, 011-5555-7548
홍원신, 011-7777-7777
허경운, 017-3333-3333
산마루, 018-0505-0505
이기상, 
이미성, 010-6654-8854
이미인, 011-8585-5252
권영미, 011-5555-7548
권옥경, 010-3644-5577
김싱식, 011-7585-7474
정상호, 016-1919-4242
정한나, 016-2424-4242
전용재, 010-7549-8654
이미경, 016-6542-7546
김신제, 010-2415-5444
임수봉, 011-4151-4154
김신애, 011-4151-4444
*/


--○ 커서 이용 후 상황(다중 행 접근 시)
DECLARE
    V_NAME TBL_INSA.NAME%TYPE;
    V_TEL  TBL_INSA.TEL%TYPE;

    -- 커서 이용을 위한 커서 변수 선언(→ 커서 정의)
    CURSOR CUR_INSA_SELECT
    IS
    SELECT NAME, TEL
    FROM TBL_INSA;
BEGIN
    -- 커서 오픈
    OPEN CUR_INSA_SELECT;
    
    -- 커서 오픈 시 쏟아져나오는 데이터들 처리(잡아내기)
    LOOP
        -- 한 행 한 행 끄집어내어 가져오는 행위 → 『FETCH : 가져옴』 
        FETCH CUR_INSA_SELECT INTO V_NAME, V_TEL;
        
        EXIT WHEN CUR_INSA_SELECT%NOTFOUND;
        
        -- 출력 
        DBMS_OUTPUT.PUT_LINE(V_NAME || ', ' || V_TEL);
            
    END LOOP;
    
    -- 커서 클로즈
    CLOSE CUR_INSA_SELECT;
    
END;
--==>>
/*
한혜림, 010-5555-5555
박민지, 010-6666-6666
홍길동, 011-2356-4528
이순신, 010-4758-6532
이순애, 010-4231-1236
김정훈, 019-5236-4221
한석봉, 018-5211-3542
이기자, 010-3214-5357
장인철, 011-2345-2525
김영년, 016-2222-4444
나윤균, 019-1111-2222
김종서, 011-3214-5555
유관순, 010-8888-4422
정한국, 018-2222-4242
조미숙, 019-6666-4444
황진이, 010-3214-5467
이현숙, 016-2548-3365
이상헌, 010-4526-1234
엄용수, 010-3254-2542
이성길, 018-1333-3333
박문수, 017-4747-4848
유영희, 011-9595-8585
홍길남, 011-9999-7575
이영숙, 017-5214-5282
김인수, 
김말자, 011-5248-7789
우재옥, 010-4563-2587
김숙남, 010-2112-5225
김영길, 019-8523-1478
이남신, 016-1818-4848
김말숙, 016-3535-3636
정정해, 019-6564-6752
지재환, 019-5552-7511
심심해, 016-8888-7474
김미나, 011-2444-4444
이정석, 011-3697-7412
정영희, 
이재영, 011-9999-9999
최석규, 011-7777-7777
손인수, 010-6542-7412
고순정, 010-2587-7895
박세열, 016-4444-7777
문길수, 016-4444-5555
채정희, 011-5125-5511
양미옥, 016-8548-6547
지수환, 011-5555-7548
홍원신, 011-7777-7777
허경운, 017-3333-3333
산마루, 018-0505-0505
이기상, 
이미성, 010-6654-8854
이미인, 011-8585-5252
권영미, 011-5555-7548
권옥경, 010-3644-5577
김싱식, 011-7585-7474
정상호, 016-1919-4242
정한나, 016-2424-4242
전용재, 010-7549-8654
이미경, 016-6542-7546
김신제, 010-2415-5444
임수봉, 011-4151-4154
김신애, 011-4151-4444
*/
--> 데이터의 중간값들이 비어있으면 반복문으로만 출력하기엔 한계가 있음
--  하지만 커서는 그러한 문제가 발생하지 않음
--  DBA 가 주로 사용하며, 프로그램 개발자들은 많이 사용하지 않는다. 
