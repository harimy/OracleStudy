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


