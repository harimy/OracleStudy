--○ TBL_상품, TBL_입고, TBL_출고 의 관계에서
--   입고수량, 재고수량의 트랜잭션 처리가 이루어질 수 있도록
--   TRG_IBGO 트리거를 수정한다.
--   프로시저처럼 예외처리까지는 하지 않고, 수량 처리만 제대로 할 수 있도록 작성.
CREATE OR REPLACE TRIGGER TRG_IBGO
        AFTER
        INSERT OR UPDATE OR DELETE ON TBL_입고
        FOR EACH ROW
BEGIN
    IF (INSERTING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 + :NEW.입고수량
             WHERE 상품코드 = :NEW.상품코드;
    ELSIF (UPDATING)
        THEN UPDATE TBL_상품
             SET 재고수량 = (재고수량 - :OLD.입고수량) + :NEW.입고수량
             WHERE 상품코드 = :NEW.상품코드;
    ELSIF (DELETING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 - :OLD.입고수량
             WHERE 상품코드 = :OLD.상품코드;
    END IF;
END;
--==>> Trigger TRG_IBGO이(가) 컴파일되었습니다.



--○ 작성한 트리거(TRG_IBGO) 테스트
-- 입고 테이블에 업데이트 이벤트 발생
UPDATE TBL_입고
SET 입고수량 = 50
WHERE 입고번호 = 1;
--==>> 1 행 이(가) 업데이트되었습니다.

SELECT *
FROM TBL_입고;
--==>> 1	H001	2021-04-12 17:16:29	50	1000

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	50

-- 입고 테이블에 삭제 이벤트 발생
DELETE
FROM TBL_입고
WHERE 입고번호 = 1;
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_입고;
--==>> 조회 결과 없음

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0
