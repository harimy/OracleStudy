--○ TBL_상품, TBL_입고, TBL_출고 의 관계에서
--   출고수량, 재고수량의 트랜잭션 처리가 이루어질 수 있도록
--   TRG_CHULGO 트리거를 작성한다.
CREATE OR REPLACE TRIGGER TRG_CHULGO
        AFTER
        INSERT OR UPDATE OR DELETE ON TBL_출고
        FOR EACH ROW
BEGIN
    IF (INSERTING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 - :NEW.출고수량
             WHERE 상품코드 = :NEW.상품코드;
    ELSIF (UPDATING)
        THEN UPDATE TBL_상품
             SET 재고수량 = (재고수량 + :OLD.출고수량) - :NEW.출고수량
             WHERE 상품코드 = :NEW.상품코드;
    ELSIF (DELETING)
        THEN UPDATE TBL_상품
             SET 재고수량 = 재고수량 + :OLD.출고수량 
             WHERE 상품코드 = :OLD.상품코드;
    END IF;
END;
--==>> Trigger TRG_CHULGO이(가) 컴파일되었습니다.



--○ 작성한 트리거(TRG_CHULGO) 테스트
-- 테스트 전 데이터
SELECT *
FROM TBL_출고;
--==>> 조회 결과 없음

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	100


-- 출고 테이블에 출고 이벤트 발생
INSERT INTO TBL_출고(출고번호, 상품코드, 출고일자, 출고수량, 출고단가)
VALUES(1, 'H001', SYSDATE, 100, 1000);
--==>> 1 행 이(가) 삽입되었습니다.

SELECT *
FROM TBL_출고;
--==>> 1	H001	2021-04-12 18:00:14	100	1000

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0
--> 홈런볼 100개에서 0개로 재고 반영됨


-- 출고 테이블에 업데이트 이벤트 발생
UPDATE TBL_출고
SET 출고수량 = 50
WHERE 출고번호 = 1;
--==>> 1 행 이(가) 업데이트되었습니다.

SELECT *
FROM TBL_출고;
--==>> 1	H001	2021-04-12 18:00:14	50	1000
--> 출고 수량이 100개에서 50개로 변경됨

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	50
--> 재고수량이 0개에서 50개로 변경됨 


-- 출고 테이블에 삭제 이벤트 발생
DELETE
FROM TBL_출고
WHERE 출고번호 = 1;
--==>> 1 행 이(가) 삭제되었습니다.

SELECT *
FROM TBL_출고;
--==>> 조회 결과 없음
--> 출고 내역이 정상적으로 삭제됨

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	100
--> 재고가 기존 개수(100개)로 돌아옴 
