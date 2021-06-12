SELECT USER
FROM DUAL;
--==>> SCOTT

--■■■ 작성한 암호화/복호화 패키지 테스트 ■■■--

--○ 실습 테이블 생성
CREATE TABLE TBL_EXAM
( ID    NUMBER
, PW    VARCHAR2(30)
);
--==>> Table TBL_EXAM이(가) 생성되었습니다.

--○ 데이터 입력
INSERT INTO TBL_EXAM(ID, PW) VALUES(1, '0611');
--==>> 1 행 이(가) 삽입되었습니다.

--○ 확인
SELECT *
FROM TBL_EXAM;
--==>> 1	0611

--○ 롤백
ROLLBACK;
--==>> 롤백 완료.

--○ 암호화/복호화 패키지의 암호화 함수를 활용한 데이터 입력
INSERT INTO TBL_EXAM(ID, PW) VALUES(1, CRYPTPACK.ENCRYPT('0611', 'SUPERMAN'));
--==>> 1 행 이(가) 삽입되었습니다.

--○ 확인
SELECT *
FROM TBL_EXAM;
--==>> 1	x��@+

--○ 커밋
COMMIT;
--==>> 커밋 완료.

--○ 암호화/복호화 패키지의 복호화 함수를 활용한 데이터 조회
SELECT ID, CRYPTPACK.DECRYPT(PW, 'BATMAN') AS PW
FROM TBL_EXAM;
--==>> 1	�Q~�

SELECT ID, CRYPTPACK.DECRYPT(PW, 'SUPERMAN') AS PW
FROM TBL_EXAM;
--==>> 1	0611

