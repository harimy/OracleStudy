--○ 접속된 사용자 조회
SELECT USER
FROM DUAL;
--==>> SYS

--○ 오라클 사용자 계정 생성(SCOTT)
CREATE USER SCOTT
IDENTIFIED BY tiger;
--==>> User SCOTT이(가) 생성되었습니다.


--○ 생성된 오라클 사용자(SCOTT)에게 권한 부여
GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO SCOTT;
--==>> Grant을(를) 성공했습니다.


--○ 생성된 오라클 사용자(SCOTT)에게 기본 테이블스페이스 설정
ALTER USER SCOTT DEFAULT TABLESPACE USERS;
--==>> User SCOTT이(가) 변경되었습니다.

--○ 생성된 오라클 사용자(SCOTT)에게 임시 테이블스페이스 설정
ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;
--==>> User SCOTT이(가) 변경되었습니다.




















