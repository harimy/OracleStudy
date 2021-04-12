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





--○ 생성된 프로시저(PRC_입고_DELETE) 정상 작동 여부 확인
-- 내가 풀이한 내용

SELECT *
FROM TBL_상품;
--==>> H001	홈런볼	1500	0

SELECT *
FROM TBL_입고;
--==>> 1	H001	21/04/09	20	400

--   → 프로시저 호출 
--   『입고20 / 재고0』인 홈런볼 출고내역 삭제
EXEC PRC_입고_DELETE(1);
--==>> 에러 발생
/*
ORA-20002: 재고 부족~!!!
*/
--> 재고가 0인 상태에서 입고20 만큼을 삭제하려고 하면
--  남은 재고가 -20인 음수값으로 떨어지기 때문에 에러가 발생함

--   → 프로시저 호출 
--   『재고20 / 입고20』인 차카니 입고내역 삭제
EXEC PRC_입고_DELETE(21);
--==>> PL/SQL 프로시저가 성공적으로 완료되었습니다.

SELECT *
FROM TBL_상품;
--==>> E007	차카니	900	0

SELECT *
FROM TBL_입고;
--==>> 
/*
1	H001	21/04/09	20	400
2	H002	21/04/09	30	500
3	H003	21/04/09	40	600
4	H004	21/04/09	50	700
5	H005	21/04/09	60	800
6	H006	21/04/09	70	900
7	H007	21/04/09	80	1000
8	C001	21/04/09	30	800
9	C002	21/04/09	40	900
10	C003	21/04/09	50	1000
11	C004	21/04/09	60	1100
12	C005	21/04/09	70	1200
13	C006	21/04/09	80	1300
14	C007	21/04/09	90	1400
15	E001	21/04/09	80	990
16	E002	21/04/09	70	880
17	E003	21/04/09	60	770
18	E004	21/04/09	50	660
19	E005	21/04/09	40	550
20	E006	21/04/09	30	440
*/
--> 입고번호가 21번인 차카니에 대한 입고 내역이 삭제되었음 

