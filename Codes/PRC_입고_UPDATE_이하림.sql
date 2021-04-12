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





--○ 생성된 프로시저(PRC_입고_UPDATE) 정상 작동 여부 확인

-- 내가 풀이한 내용
--   → 프로시저 호출 
--   『입고20 / 재고0』인 홈런볼 출고내역 변경
EXEC PRC_입고_UPDATE(1, 1);
--==>> 에러 발생
/*
ORA-20002: 재고 부족~!!!
*/

--   → 프로시저 호출 
--   『입고20 / 재고0』인 홈런볼 입고내역 변경
EXEC PRC_입고_UPDATE(1, 25);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	5

SELECT *
FROM TBL_입고;
--==>> 1	H001	21/04/09	25	400

-- 입고는 20 → 25 로 변경되었고,
-- 재고는 0 → 5 로 변경되었다.

--   → 프로시저 호출 
--   테스트 전 상태로 데이터 되돌림
EXEC PRC_입고_UPDATE(1, 20);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0

SELECT *
FROM TBL_입고;
--==>> 1	H001	21/04/09	20	400