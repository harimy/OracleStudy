SELECT USER
FROM DUAL;
--==>> HR

--------------------------------------------------------------------------------
--■■■ 정규화(Nomalization) ■■■--

--○ 정규화란?
--   한 마디로 데이터베이스 서버의 메모리 낭비를 막기 위해
--   어떤 하나의 테이블을... 식별자를 가지는 여러 개의 테이블로
--   나누는 과정을 말한다.


-- ex) 유림이가... 옥장판을 판매한다.
--     고객리스트 → 거래처직원 명단이 적혀있는 수첩의 정보를
--     데이터베이스화 하려고 한다.

-- 테이블명 : 거래처직원
/*
  10Byte     10Byte     10Byte        10Byte    10Byte 10Byte  10Byte
--------------------------------------------------------------------------------
거래처회사명 회사주소   회사전화      거래처직원명 직급 이메일   휴대폰
--------------------------------------------------------------------------------
    LG      서울여의도  02-3456-6789  선혜연       부장 shy@na.. 010-...
    LG      서울여의도  02-3456-6789  박민지       과장 pmj@na.. 010-...
    LG      서울여의도  02-3456-6789  김아별       대리 kab@na.. 010-...
    LG      서울여의도  02-3456-6789  안정미       부장 ajm@na.. 010-...
    SK      서울소공동  02-1234-4567  이하림       부장 lhr@na.. 010-...
    LG      부산동래구  051-9999-9999 이새롬       대리 lsr@da.. 010-...
                                    :
                                    :
--------------------------------------------------------------------------------
*/

/*
가정) 서울 여의도 LG 라는 회사에 근무하는 거래처 직원 명단이
      총 100만 명이라고 가정한다.
      
      어느 날... 『서울여의도』에 위치한 『LG』 본사가
      『경기분당』으로 사옥을 이전하게 되었다.
      이로인해...
      회사 주소는 『경기분당』으로 바뀌고
      회사 전화는 『031-1111-2222』로 바뀌게 되었다.
      
      그러면... 100만 명의 회사주소와 회사전화를 변경해야 한다.
      
      - 이 때 수행되어야 할 쿼리문 → UPDATE 구문
      
      UPDATE 거래처직원
      WHERE 거래처회사명 = 'LG'
        AND 회사주소 = '서울여의도';
        
      --> 100만 개 행을 하드디스크상에서 읽어다가
          메모리에 로드시켜주어야 한다.
          즉, 100만 * 70Byte 를 모두
          하드디스크상에서 읽어다가 메모리에 로드시켜 주어야 한다는 말이다.
          
          --> 이는 테이블의 설계가 잘못되었으므로
              DB 서버는 조만간 메모리의 고갈로 인해 DOWN 될 것이다.
              
              --> 그러므로 정규화 과정을 수행해야 한다.
*/

--○ 제 1 정규화
--> 어떤 하나의 테이블에 반복되어 컬럼 값들이 존재한다면
--  값들이 반복되어 나오는 컬럼을 분리하여 
--  새로운 테이블을 만들어준다.

--> 제 1 정규화를 수행하는 과정에서 분리된 테이블은
--  반드시 부모 테이블과 자식 테이블의 관계를 갖게 된다.

--> 부모 테이블 → 참조받는 컬럼 → PRIMARY KEY (제약조건) 
--> 자식 테이블 → 참조하는 컬럼 → FOREIGN KEY (제약조건)

--> 참조받는 컬럼이 갖는 특징(부모 테이블)
--  - 반드시 고유한 값(데이터)이 들어와야 한다.
--    즉, 중복된 값(데이터)이 없어야 한다.
--  - NULL 이 있어서는 안된다. (비어있어서는 안된다.)
--  - 즉, NOT NULL 이어야 한다.

--> 제 1 정규화를 수행하는 과정에서
--  부모 테이블의 PRIMARY KEY 는
--  항상 자식테이블의 FOREIGN KEY 로 전이된다.


/*
-- 테이블명 : 회사 → 부모 테이블

  10Byte     10Byte     10Byte        10Byte 
--------------------------------------------------
   회사ID  거래처회사명 회사주소      회사전화    
   ------
   (참조받는 컬럼 → PRIMARY KEY)
--------------------------------------------------
     10         LG      서울여의도  02-3456-6789  
     20         SK      서울소공동  02-1234-4567 
     30         LG      부산동래구  051-9999-9999 
--------------------------------------------------
*/

/*
-- 테이블명 : 직원 → 자식 테이블 

  10Byte    10Byte 10Byte  10Byte    10Byte
---------------------------------------------
 거래처직원명 직급 이메일   휴대폰    회사ID
                                     ------
                                     (참조하는 컬럼 → FOREIGN KEY)
---------------------------------------------
   선혜연     부장 shy@na.. 010-...    10
   박민지     과장 pmj@na.. 010-...    10
   김아별     대리 kab@na.. 010-...    10
   안정미     부장 ajm@na.. 010-...    10
   이하림     부장 lhr@na.. 010-...    20
   이새롬     대리 lsr@da.. 010-...    30
                :
                :
---------------------------------------------
*/


--------------------------------------------------------------------------------



--※ 테이블이 분할(분리)되기 이전 상태로 조회
SELECT A.거래처회사명, A.회사주소, A.회사전화
     , B.거래처직원명, B.직급, B.이메일, B.휴대폰
FROM 회사 A, 직원 B
WHERE A.회사ID = B.회사ID;
--==>> 원래의 상태로 조회하는데 이상 없음


/*
가정) 서울 여의도 LG 라는 회사에 근무하는 거래처 직원 명단이
      총 100만 명이라고 가정한다.
      
      어느 날... 『서울여의도』에 위치한 『LG』 본사가
      『경기분당』으로 사옥을 이전하게 되었다.
      이로인해...
      회사 주소는 『경기분당』으로 바뀌고
      회사 전화는 『031-1111-2222』로 바뀌게 되었다.
      
      그러면... 회사 테이블에서 1건의 회사주소와 회사전화를 변경해야 한다.
      
      - 이 때 수행되어야 할 쿼리문 → UPDATE 구문
      
      UPDATE 회사
      SET 회사주소 = '경기분당', 회사전화 = '031-1111-2222'
      WHERE 회사ID = 10;
        
      --> 1개 행을 하드디스크상에서 읽어다가
          메모리에 로드시켜주어야 한다.
          즉, 1 * 40Byte 를 모두
          하드디스크상에서 읽어다가 메모리에 로드시켜 주어야 한다는 말이다.
          
          --> 이는 테이블의 설계가 잘 된 상황이다.
             
              --> 정규화를 수행하기 이전에는 100만 건을 처리해야 할 업무에서
                  1건만 처리하면 되는 업무로 바뀐 상황이기 때문에
                  DB 서버는 메모리 고갈 없이 아주 빠르게 처리될 것이다.
*/


/*
-- A. 거래처회사명, 회사전화
SELECT 거래처회사명, 회사전화 | SELECT 거래처회사명, 회사전화
FROM 회사                     | FROM 거래처직원
--> 3 * 40Byte                | --> 200만 * 70Byte

-- B. 거래처직원명, 직급
SELECT 거래처직원명, 직급   | SELECT 거래처직원명, 직급
FROM 직원                   | FROM 거래처직원
--> 200만 * 50Byte          | --> 200만 * 70Byte

-- C. 거래처회사명, 거래처직원명
SELECT 회사.거래처회사명, 직원.거래처직원명 | SELECT 거래처회사명, 거래처직원명
FROM 회사 JOIN 직원                         | FROM 거래처직원
ON 회사.회사ID = 직원.회사ID                | --> 200만 * 70Byte
--> (회사) + (직원)                         |
--> (3 * 40Byte) + (200만 * 50Byte)         |
*/

/*
- 테이블명 : 주문
-------------------------------------------------------------------
  고객ID            제품코드             주문일자          주문수량
  ++++++++++++++++++++++++++++++++++++++++++++++++++++
                     (P.K)
-------------------------------------------------------------------
 PNH1227(박나현)   SWK123(새우깡)  2021-02-04 11:11:11       50
 HHR7733(한혜림)   YPR234(양파링)  2021-02-04 13:40:50       30
 LHJ3361(이희주)   CPI110(초파이)  2021-02-05 10:22:30       20
 LHJ3361(이희주)   SWK123(새우깡)  2021-02-06 17:00:20       20
 LSH7654(이희주)   CPI110(초파이)  2021-02-07 05:00:13       20
                            :
                            :
-------------------------------------------------------------------
*/

/*
--※ 하나의 테이블에 존재하는 PRIMARY KEY 의 최대 개수는 1개이다.
--   하지만, PRIMARY KEY 를 이루는(구성하는) 컬럼의 개수는 
--   복수(다수, 여러개)인 것이 가능하다.
--   컬럼 1개로만 (단일 컬럼) 구성된 PRIMARY KEY를 
--   Single Primary Key 라고 부른다.
--   (단일 프라이머리 키)
--   두 개 이상의 컬럼으로 구성된 PRIMARY KEY를 
--   Composite Primary Key 라고 부른다.
--   (복합 프라이머리 키)
*/



--○ 제 2 정규화
--> 제 1 정규화를 마친 결과물에서 PRIMARY KEY 가 SINGLE COLUMN 이라면
--  제 2 정규화는 수행하지 않는다. 
--  하지만, PRIMARY KEY 가 COMPOSITE COLUMN 이라면
--  반.드.시. 제 2 정규화를 수행해야 한다. 


--> 식별자가 아닌 컬럼은 식별자 전체 컬럼에 대해 의존적이어야 하는데
--  식별자 전체 컬럼이 아닌 일부 식별자 컬럼에 대해서만 의존적이라면
--  이를 분리하여 새로운 테이블을 생성해준다

/*
- 테이블명 : 과목
--------------------------------------------------------------------------------
 과목번호  과목명    교수자번호  교수자명  강의실코드  강의실설명
 ++++++++           ++++++++++
     (    P   .   K    )
--------------------------------------------------------------------------------
 JAVA101   자바기초     21       장영실      A403     전산실습관 3층 30석 규모 
 JAVA102   자바중급     22       테슬라      T502     전자공학관 5층 20석 규모 
 DB102     오라클중급   22       테슬라      A201     전산실습관 2층 50석 규모
 DB102     오라클중급   22       장영실      T502     전자공학관 2층 50석 규모
 DB103     오라클고급   22       에디슨      K101     인문사회관 1층 80석 규모
 JSP105    JSP심화      21       장영실      K101     인문사회관 1층 80석 규모
                                :
                                :
--------------------------------------------------------------------------------

테이블명 : 점수
--------------------------------------------------
 과목번호 교수자번호  학번     학생명    점수
 ==================
      (F.K)
--------------------------------------------------
 DB102       21     2102110   장서현     80
 DB102       21     2102127   안정미     76
                    :
                    :
--------------------------------------------------
*/



--○ 제 3 정규화
-->  식별자가 아닌 컬럼이 식별자가 아닌 컬럼에 의존적인 상황이라면
--   이를 분리하여 새로운 테이블을 생성해 주어야 한다. 

--※ 관계(Relation)의 종류

-- 1 : 1

-- 1 : 다(Many)
--> 제 1 정규화를 마친 결과물에서 대표적으로 나타나는 바람직한 관계.
--  관계형 데이터베이스를 활용하는 과정에서 추구해야 하는 관계.

-- 다(Many) : 다(Many)
--> 논리적인 모델링에서는 존재할 수 있지만
--  실세 물리적인 모델링에서는 존재할 수 없는 관계



/*
테이블명 : 고객 (다)              테이블명 : 제품 (다)
----------------------------     ---------------------------------
고객번호  고객명  이메일 ...      제품코드  제품명  제품단가 ...
----------------------------     ---------------------------------
  1100    소서현  SSH@...         SWK123   새우깡   1500
  1101    조은선  CES@...         GGK      감자깡    800
  1102    심혜진  SHJ@...         GGC      자갈치    700
            :                               :
            
                테이블명 : 주문등록(접수)
                -----------------------------------------
                고객번호  제품코드  주문일자  주문수량 ...
                ========  ========
                -----------------------------------------
                1100      SWK123    2021...     30  ...
                1100      SWK123    2021...     20  ...
                1101      SWK123    2021...     20  ...
*/

--○ 제 4 정규화
-->  위에서 확인한 내용과 같이 『다:다』 관계를 『1:다』 관계로 깨뜨리는 과정이
--   제 4 정규화의 수행과정이다.
--   → 일반적으로 파생 테이블 생성
--      → 『다:다』 관계를 『1:다』 관계로 깨뜨리는 역할 수행


--○ 역정규화(비정규화)
/*
-- A 경우 → 역정규화를 수행하지 않는 것이 바람직한 경우

테이블명 : 부서           테이블명 : 사원
   10      10    10         10      10   10   10    10      10          10
--------------------     ----------------------------------------     ---------
부서번호 부서명 주소      사원번호 사원명 직급 급여 입사일 부서번호  +   부서명
++++++++                 ++++++++                        ========  
--------------------     ----------------------------------------     ---------
     10개 행                         1,000,000개 행
--------------------     ----------------------------------------     ---------

>> 업무 분석 상 조회 결과물
-----------------------
부서명 사원명 직급 급여
-----------------------

→ 『부서』테이블과 『사원』테이블을 JOIN 했을 때의 크기
    (10 * 30Byte) + (1000000 * 60Byte) = 300 + 60000000 = 60,000,300Byte

→ 『사원』테이블을 역정규화 수행한 후 이 테이블만 읽어올 때의 크기
   (즉, 부서 테이블의 부서명 컬럼을 사원 테이블에 추가한 경우)
    1000000 * 70Byte = 70,000,000Byte


-- B 경우 → 역정규화를 수행하는 것이 바람직한 경우

테이블명 : 부서           테이블명 : 사원
   10      10    10         10      10   10   10    10      10          10
--------------------     ----------------------------------------     ---------
부서번호 부서명 주소      사원번호 사원명 직급 급여 입사일 부서번호  +   부서명
++++++++                 ++++++++                        ========  
--------------------     ----------------------------------------     ---------
   500,000개 행                      1,000,000개 행
--------------------     ----------------------------------------     ---------

>> 업무 분석 상 조회 결과물
-----------------------
부서명 사원명 직급 급여
-----------------------

→ 『부서』테이블과 『사원』테이블을 JOIN 했을 때의 크기
    (500000 * 30Byte) + (1000000 * 60Byte) = 15000000 + 60000000 = 75,000,000Byte

→ 『사원』테이블을 역정규화 수행한 후 이 테이블만 읽어올 때의 크기
   (즉, 부서 테이블의 부서명 컬럼을 사원 테이블에 추가한 경우)
    1000000 * 70Byte = 70,000,000Byte

--> 역정규화를 할까 말까 고민하기 위해서는
--  업무에 대한 분석 및 파악이 정확하게 되어 있어야 한다.

*/


/*
테이블명 : 사원 → 부모 테이블
-------------------------------------------------------
 사원번호  사원명  주민번호  입사일    급여  직급
 ++++++++
-------------------------------------------------------
   7369   박정준   9XXXXX.. 2010-X..  XXXX  부장
   7370   김가영   9XXXXX.. 2011-X..  XXXX  차장
   7371   김서현   9XXXXX.. 2010-X..  XXXX  과장
   7372   김아별   9XXXXX.. 2010-X..  XXXX  대리
                    :
-------------------------------------------------------

테이블명 : 사원가족 → 자식 테이블                테이블 : 가족관계
----------------------------------------         ---------------------
주민번호  사원번호  관계  성명                    관계내용   관계코드
++++++++  =======                                 
----------------------------------------         ---------------------
9XXXXX..   7369    아내  아이유                   배우자       1
9XXXXX..   7370    남편  강동원                   자식         2
9XXXXX..   7370    아들  남주혁                          :
9XXXXX..   7371    남편  이제훈
                :
----------------------------------------

*/

-- 1. 예측 가능한 데이터가 입력되는 상황이라면... → 코드화
-- 2. 기존 컬럼을 통해 얻어낼 수 있는 데이터라면... → 컬럼으로 구성하지 않는다. 


--------------------------------------------------------------------------------
/*
--※ 참고

1. 관계(relationship, relation)
   - 모든 엔트리(entry)는 단일값을 가진다.
   - 각 열(column)은 유일한 이름을 가지며 순서는 무의미하다.
   - 테이블의 모든 행(row = 튜플 = tuple)은 동일하지 않으며 순서는 무의미하다.
   
2. 속성(attribute)
   - 테이블의 열(column)을 나타낸다.
   - 자료의 이름을 가진 최소 논리적 단위 : 객체의 성질, 상태 기술
   - 일반 파일(file)의 항목(아이템 = item = 필드 = field)에 해당한다.
   - 엔티티(entity)의 특성과 상태를 기술
   - 속성(attribute)의 이름은 모두 달라야 한다.
   
3. 튜플 = tuple = 엔티티 = entity
   - 테이블의 행(row)
   - 연관된 몇 개의 속성(attribute)으로 구성
   - 개념 정보 단위
   - 일반 파일(file)의 레코드(record)에 해당한다.
   - 튜플 변수(tuple variable)
     : 튜플(tuple)을 가리키는 변수, 모든 튜플 집합을 도메인으로 하는 변수

4. 도메인(domain)
   - 각 속성(attribute)이 가질 수 있도록 허용된 값들의 집합
   - 속성 명과 도메인 명이 반드시 동일할 필요는 없음
   - 모든 릴레이션에서 모든 속성들의 도메인은 원자적(atomic)이어야 함.
   - 원자적 도메인
     : 도메인의 원소가 더 이상 나누어질 수 없는 단일체를 의미
     
5. 릴레이션(relation)
   - 파일 시스템에서 파일과 같은 개념
   - 중복된 튜플(tuple = entity = 엔티티)을 포함하지 않는다.
     → 모두 상이함(튜플의 유일성)
   - 릴레이션 = 튜플(엔티티 = entity)의 집합. 따라서 튜플의 순서는 무의미하다.
   - 속성(attribute)간에는 순서가 없다. 

*/


--------------------------------------------------------------------------------
--■■■ 무결성(Integrity) ■■■--
/*
1. 무결성에는 개체 무결성(Entity Integrity)
              참조 무결성(Relational Integrity)
              도메인 무결성(Domain Integrity) 이 있다.
              
2. 개체 무결성
   개체 무결성은 릴레이션에서 저장되는 튜플(tuple)의 유일성을 보장하기 위한 제약조건이다.
   
3. 참조 무결성
   참조 무결성은 릴레이션 간의 데이터 일관성을 보장하기 위한 제약조건이다.

4. 도메인 무결성
   도메인 무결성은 허용 가능한 값의 범위를 지정하기 위한 제약조건이다.

5. 제약조건의 종류
   
   - PRIMARY KEY(PK:P) → 부모 테이블의 참조받는 컬럼 → 기본키, 식별자
     해당 컬럼의 값은 반드시 존재해야 하며, 유일해야 한다.
     (UNIQUE 와 NOT NULL 이 결합된 형태)
     
   - FOREIGN KEY(FK:F:R) → 자식 테이블의 참조하는 컬럼 → 외래키, 외부키, 참조키 
     해당 컬럼의 값은 참조되는 테이블의 컬럼 데이터들 중 하나와 일치하거나 NULL 을 가진다.
    
   - UNIQUE(UK:U)
     테이블 내에서 해당 컬럼의 값은 항상 유일해야 한다.
     
   - NOT NULL(NN:CK:C)
     해당 컬럼은 NULL 을 포함할 수 없다. (비어있어서는 안된다.)
     
   - CHECK(CK:C)
     해당 컬럼에서 저장 가능한 데이터의 값의 범위나 조건을 지정한다.
     
*/

--------------------------------------------------------------------------------

--■■■ PRIMARY KEY ■■■--

-- 1. 테이블에 대한 기본 키를 생성한다.

-- 2. 테이블에서 각 행을 유일하게 식별하는 컬럼 또는 컬럼의 집합이다.
--    기본 키는 테이블 당 최대 하나만 존재한다.
--    그러나 반드시 하나의 컬럼으로만 구성되는 것은 아니다.
--    NULL 일 수 없고, 이미 테이블에 존재하고 있는 데이터를
--    다시 입력할 수 없도록 처리된다.
--    UNIQUE INDEX 가 자동으로 생성된다.
--    (오라클이 자체적으로 만든다.)

-- 3. 형식 및 구조
-- ① 컬럼 레벨의 형식
-- 컬럼명 데이터타입 [CONSTRAINT CONSTRAINT명] PRIMARY KEY[(컬럼명, ...)]

-- ② 테이블 레벨의 형식
-- 컬럼명 데이터타입,
-- 컬럼명 데이터타입,
-- CONSTRAINT CONSTRAINT명 PRIMARY KEY(컬럼명[, ...])

-- 4. CONSTRAINT 추가 시 CONSTRAINT명을 생략하면
--    오라클 서버가 자동적으로 CONSTRAINT명을 부여하게 된다.
--    일반적으로 CONSTRAINT명은 『테이블명_컬럼명_CONSTRAINT약어』 
--    형식으로 기술한다.

--○ PK 지정 실습(① 컬럼 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST1
( COL1 NUMBER(5)        PRIMARY KEY
, COL2 VARCHAR2(30)
);
--==>> Table TBL_TEST1이(가) 생성되었습니다.


-- 데이터 입력
INSERT INTO TBL_TEST1(COL1, COL2) VALUES (1, 'TEST');
INSERT INTO TBL_TEST1(COL1, COL2) VALUES (2, 'ABCD');
INSERT INTO TBL_TEST1(COL1, COL2) VALUES (3, NULL);
INSERT INTO TBL_TEST1(COL1) VALUES (4);
INSERT INTO TBL_TEST1(COL1, COL2) VALUES (2, 'ABCD'); --> 에러 발생 
INSERT INTO TBL_TEST1(COL1, COL2) VALUES (2, 'KKKK'); --> 에러 발생 
INSERT INTO TBL_TEST1(COL1, COL2) VALUES (5, 'ABCD');
INSERT INTO TBL_TEST1(COL1, COL2) VALUES (NULL, NULL); --> 에러 발생 
INSERT INTO TBL_TEST1(COL1, COL2) VALUES (NULL, 'STUDY'); --> 에러 발생 
INSERT INTO TBL_TEST1(COL2) VALUES ('STUDY'); --> 에러 발생 

-- 커밋
COMMIT;
--==>> 커밋완료.

SELECT *
FROM TBL_TEST1;
--==>>
/*
1	TEST
2	ABCD
3	
4	
5	ABCD
*/

DESC TBL_TEST1;
--==>>
/*
이름   널?       유형           
---- -------- ------------ 
COL1 NOT NULL NUMBER(5)     → PK 제약조건 확인 불가
COL2          VARCHAR2(30)
*/

--○ 제약조건 확인
SELECT *
FROM USER_CONSTRAINTS;
--==>>
/*
OWNER	CONSTRAINT_NAME	CONSTRAINT_TYPE	TABLE_NAME	SEARCH_CONDITION	R_OWNER	R_CONSTRAINT_NAME	DELETE_RULE	STATUS	DEFERRABLE	DEFERRED	VALIDATED	GENERATED	BAD	RELY	LAST_CHANGE	INDEX_OWNER	INDEX_NAME	INVALID	VIEW_RELATED
HR	REGION_ID_NN	C	REGIONS	"REGION_ID" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	REG_ID_PK	P	REGIONS					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29	HR	REG_ID_PK		
HR	COUNTRY_ID_NN	C	COUNTRIES	"COUNTRY_ID" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	COUNTRY_C_ID_PK	P	COUNTRIES					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29	HR	COUNTRY_C_ID_PK		
HR	COUNTR_REG_FK	R	COUNTRIES		HR	REG_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	LOC_CITY_NN	C	LOCATIONS	"CITY" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	LOC_ID_PK	P	LOCATIONS					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29	HR	LOC_ID_PK		
HR	LOC_C_ID_FK	R	LOCATIONS		HR	COUNTRY_C_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	DEPT_NAME_NN	C	DEPARTMENTS	"DEPARTMENT_NAME" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	DEPT_ID_PK	P	DEPARTMENTS					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29	HR	DEPT_ID_PK		
HR	DEPT_LOC_FK	R	DEPARTMENTS		HR	LOC_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JOB_TITLE_NN	C	JOBS	"JOB_TITLE" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JOB_ID_PK	P	JOBS					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29	HR	JOB_ID_PK		
HR	EMP_LAST_NAME_NN	C	EMPLOYEES	"LAST_NAME" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	EMP_EMAIL_NN	C	EMPLOYEES	"EMAIL" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	EMP_HIRE_DATE_NN	C	EMPLOYEES	"HIRE_DATE" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	EMP_JOB_NN	C	EMPLOYEES	"JOB_ID" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	EMP_SALARY_MIN	C	EMPLOYEES	salary > 0				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	EMP_EMAIL_UK	U	EMPLOYEES					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29	HR	EMP_EMAIL_UK		
HR	EMP_EMP_ID_PK	P	EMPLOYEES					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29	HR	EMP_EMP_ID_PK		
HR	EMP_DEPT_FK	R	EMPLOYEES		HR	DEPT_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	EMP_JOB_FK	R	EMPLOYEES		HR	JOB_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	EMP_MANAGER_FK	R	EMPLOYEES		HR	EMP_EMP_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	DEPT_MGR_FK	R	DEPARTMENTS		HR	EMP_EMP_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JHIST_EMPLOYEE_NN	C	JOB_HISTORY	"EMPLOYEE_ID" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JHIST_START_DATE_NN	C	JOB_HISTORY	"START_DATE" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JHIST_END_DATE_NN	C	JOB_HISTORY	"END_DATE" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JHIST_JOB_NN	C	JOB_HISTORY	"JOB_ID" IS NOT NULL				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JHIST_DATE_INTERVAL	C	JOB_HISTORY	end_date > start_date				ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JHIST_EMP_ID_ST_DATE_PK	P	JOB_HISTORY					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29	HR	JHIST_EMP_ID_ST_DATE_PK		
HR	JHIST_JOB_FK	R	JOB_HISTORY		HR	JOB_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JHIST_EMP_FK	R	JOB_HISTORY		HR	EMP_EMP_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	JHIST_DEPT_FK	R	JOB_HISTORY		HR	DEPT_ID_PK	NO ACTION	ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	USER NAME			14/05/29				
HR	SYS_C004102	O	EMP_DETAILS_VIEW					ENABLED	NOT DEFERRABLE	IMMEDIATE	NOT VALIDATED	GENERATED NAME			14/05/29				
HR	SYS_C007107	P	TBL_TEST1					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	GENERATED NAME			21/04/05	HR	SYS_C007107		
*/

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TBL_TEST1';
--==>>
/*
HR	SYS_C007107	P	TBL_TEST1					ENABLED	NOT DEFERRABLE	IMMEDIATE	VALIDATED	GENERATED NAME			21/04/05	HR	SYS_C007107		
*/

--○ 제약조건이 지정된 컬럼 확인(조회)
SELECT *
FROM USER_CONS_COLUMNS;
--==>>
/*
HR	REGION_ID_NN	REGIONS	REGION_ID	
HR	REG_ID_PK	REGIONS	REGION_ID	1
HR	COUNTRY_ID_NN	COUNTRIES	COUNTRY_ID	
HR	COUNTRY_C_ID_PK	COUNTRIES	COUNTRY_ID	1
HR	COUNTR_REG_FK	COUNTRIES	REGION_ID	1
HR	LOC_ID_PK	LOCATIONS	LOCATION_ID	1
HR	LOC_CITY_NN	LOCATIONS	CITY	
HR	LOC_C_ID_FK	LOCATIONS	COUNTRY_ID	1
HR	DEPT_ID_PK	DEPARTMENTS	DEPARTMENT_ID	1
HR	DEPT_NAME_NN	DEPARTMENTS	DEPARTMENT_NAME	
HR	DEPT_MGR_FK	DEPARTMENTS	MANAGER_ID	1
HR	DEPT_LOC_FK	DEPARTMENTS	LOCATION_ID	1
HR	JOB_ID_PK	JOBS	JOB_ID	1
HR	JOB_TITLE_NN	JOBS	JOB_TITLE	
HR	EMP_EMP_ID_PK	EMPLOYEES	EMPLOYEE_ID	1
HR	EMP_LAST_NAME_NN	EMPLOYEES	LAST_NAME	
HR	EMP_EMAIL_NN	EMPLOYEES	EMAIL	
HR	EMP_EMAIL_UK	EMPLOYEES	EMAIL	1
HR	EMP_HIRE_DATE_NN	EMPLOYEES	HIRE_DATE	
HR	EMP_JOB_NN	EMPLOYEES	JOB_ID	
HR	EMP_JOB_FK	EMPLOYEES	JOB_ID	1
HR	EMP_SALARY_MIN	EMPLOYEES	SALARY	
HR	EMP_MANAGER_FK	EMPLOYEES	MANAGER_ID	1
HR	EMP_DEPT_FK	EMPLOYEES	DEPARTMENT_ID	1
HR	JHIST_EMPLOYEE_NN	JOB_HISTORY	EMPLOYEE_ID	
HR	JHIST_EMP_ID_ST_DATE_PK	JOB_HISTORY	EMPLOYEE_ID	1
HR	JHIST_EMP_FK	JOB_HISTORY	EMPLOYEE_ID	1
HR	JHIST_START_DATE_NN	JOB_HISTORY	START_DATE	
HR	JHIST_DATE_INTERVAL	JOB_HISTORY	START_DATE	
HR	JHIST_EMP_ID_ST_DATE_PK	JOB_HISTORY	START_DATE	2
HR	JHIST_END_DATE_NN	JOB_HISTORY	END_DATE	
HR	JHIST_DATE_INTERVAL	JOB_HISTORY	END_DATE	
HR	JHIST_JOB_NN	JOB_HISTORY	JOB_ID	
HR	JHIST_JOB_FK	JOB_HISTORY	JOB_ID	1
HR	JHIST_DEPT_FK	JOB_HISTORY	DEPARTMENT_ID	1
HR	SYS_C007107	TBL_TEST1	COL1	1
*/

SELECT *
FROM USER_CONS_COLUMNS
WHERE TABLE_NAME = 'TBL_TEST1';
--==>>
/*
HR	SYS_C007107	TBL_TEST1	COL1	1
*/


--○ 제약조건이 설정된 소유주, 제약명, 테이블명, 제약종류, 컬럼명 항목 조회

-- 내가 풀이한 코드
SELECT UC.OWNER, UC.CONSTRAINT_NAME, UC.TABLE_NAME, UC.CONSTRAINT_TYPE, UCC.COLUMN_NAME
FROM USER_CONSTRAINTS UC, USER_CONS_COLUMNS UCC
WHERE UC.OWNER = UCC.OWNER
  AND UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
  AND UC.TABLE_NAME = 'TBL_TEST1';
--==>>
/*
HR	SYS_C007107	TBL_TEST1	P	COL1
*/

-- 함께 풀이한 코드
SELECT UC.OWNER, UC.CONSTRAINT_NAME, UC.TABLE_NAME
     , UC.CONSTRAINT_TYPE, UCC.COLUMN_NAME
FROM USER_CONSTRAINTS UC, USER_CONS_COLUMNS UCC
WHERE UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
  AND UC.TABLE_NAME = 'TBL_TEST1';
--==>>
/*
HR	SYS_C007107	TBL_TEST1	P	COL1
    -----------
     오라클이 자동으로 붙여준 제약조건의 이름
*/


--○ PK 지정 실습(② 테이블 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST2
( COL1 NUMBER(5)       
, COL2 VARCHAR2(30)
, CONSTRAINT TEST2_COL1_PK PRIMARY KEY(COL1)
);
--==>> Table TBL_TEST2이(가) 생성되었습니다.

-- 데이터 입력
INSERT INTO TBL_TEST2(COL1, COL2) VALUES (1, 'TEST');
INSERT INTO TBL_TEST2(COL1, COL2) VALUES (2, 'ABCD');
INSERT INTO TBL_TEST2(COL1, COL2) VALUES (3, NULL);
INSERT INTO TBL_TEST2(COL1) VALUES (4);
INSERT INTO TBL_TEST2(COL1, COL2) VALUES (2, 'ABCD'); --> 에러 발생 
INSERT INTO TBL_TEST2(COL1, COL2) VALUES (2, 'KKKK'); --> 에러 발생 
INSERT INTO TBL_TEST2(COL1, COL2) VALUES (5, 'ABCD');
INSERT INTO TBL_TEST2(COL1, COL2) VALUES (NULL, NULL); --> 에러 발생 
INSERT INTO TBL_TEST2(COL1, COL2) VALUES (NULL, 'STUDY'); --> 에러 발생 
INSERT INTO TBL_TEST2(COL2) VALUES ('STUDY'); --> 에러 발생 

-- 커밋
COMMIT;
--==>> 커밋완료.

SELECT *
FROM TBL_TEST2;
--==>>
/*
1	TEST
2	ABCD
3	
4	
5	ABCD
*/

--○ 제약조건이 설정된 소유주, 제약명, 테이블명, 제약종류, 컬럼명 항목 조회
SELECT UC.OWNER, UC.CONSTRAINT_NAME, UC.TABLE_NAME
     , UC.CONSTRAINT_TYPE, UCC.COLUMN_NAME
FROM USER_CONSTRAINTS UC, USER_CONS_COLUMNS UCC
WHERE UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME
  AND UC.TABLE_NAME = 'TBL_TEST2';
--==>>
/*
HR	TEST2_COL1_PK	TBL_TEST2	P	COL1
*/

--○ PK 지정 실습(③ 다중 컬럼 PK 지정 → 복합 프라이머리 키)
CREATE TABLE TBL_TEST3
( COL1 NUMBER(5)
, COL2 VARCHAR2(30)
, CONSTRAINT TEST3_COL1_COL2_PK PRIMARY KEY(COL1, COL2)
);
--==>> Table TBL_TEST3이(가) 생성되었습니다.

--(X)
CREATE TABLE TBL_TEST3
( COL1 NUMBER(5)
, COL2 VARCHAR2(30)
, CONSTRAINT TEST3_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST3_COL2_PK PRIMARY KEY(COL2)
);


-- 데이터 입력
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (1, 'TEST');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (2, 'ABCD');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (3, NULL);       --> 에러 발생 
INSERT INTO TBL_TEST3(COL1) VALUES (4);                   --> 에러 발생 
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (2, 'ABCD');     --> 에러 발생 
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (3, 'ABCD');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (1, 'ABCD');
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (2, 'KKKK'); 
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (5, 'ABCD'); 
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (NULL, NULL);    --> 에러 발생 
INSERT INTO TBL_TEST3(COL1, COL2) VALUES (NULL, 'STUDY'); --> 에러 발생 
INSERT INTO TBL_TEST3(COL2) VALUES ('STUDY');             --> 에러 발생 

-- 커밋
COMMIT;
--==>> 커밋완료.

SELECT *
FROM TBL_TEST3;
--==>>
/*
1	ABCD
1	TEST
2	ABCD
2	KKKK
3	ABCD
5	ABCD
*/

--○ PK 지정 실습(④ 테이블 생성 이후 제약조건 추가 → PK 지정)
CREATE TABLE TBL_TEST4
( COL1 NUMBER(5)
, COL2 VARCHAR2(30)
);
--==>> Table TBL_TEST4이(가) 생성되었습니다.

--※ 이미 만들어져 있는 테이블에
--   부여하려는 제약조건을 위반한 데이터가 포함되어 있을 경우
--   해당 테이블에 제약조건을 추가하는 것은 불가능하다. 

-- 제약조건 추가
ALTER TABLE TBL_TEST4
ADD CONSTRAINT TEST4_COL1_PK PRIMARY KEY(COL1);
--==>> Table TBL_TEST4이(가) 변경되었습니다.

--※ 귀찮고 번거롭더라도 테이블 레벨로 제약조건 구성하기.

--※ 제약조건 확인 전용 뷰(VIEW) 생성
CREATE OR REPLACE VIEW VIEW_CONSTCHECK
AS
SELECT UC.OWNER "OWNER"
     , UC.CONSTRAINT_NAME "CONSTRAINT_NAME"
     , UC.TABLE_NAME "TABLE_NAME"
     , UC.CONSTRAINT_TYPE "CONSTRAINT_TYPE"
     , UCC.COLUMN_NAME "COLUMN_NAME"
     , UC.SEARCH_CONDITION "SEARCH_CONDITION"
     , UC.DELETE_RULE "DELETE_RULE"
FROM USER_CONSTRAINTS UC JOIN USER_CONS_COLUMNS UCC
ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME;
--==>> View VIEW_CONSTCHECK이(가) 생성되었습니다.

--○ 생성된 뷰(VIEW)를 통한 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST4';
--==>>
/*
HR	TEST4_COL1_PK	TBL_TEST4	P	COL1		
*/


--------------------------------------------------------------------------------

--■■■ UNIQUE(UK:U) ■■■--

--1. 테이블에서 지정한 컬럼의 데이터가 중복되지 않고
--   테이블 내에서 유일할 수 있도록 설정하는 제약
--   PRIMARY KEY 와 유사한 제약조건이지만, NULL 을 허용한다는 차이가 있다.
--   내부적으로 PRIMARY KEY 와 마찬가지로 UNIQUE INDEX 가 자동 생성된다.
--   하나의 테이블 내에서 UNIQUE 제약조건은 여러 번 설정하는 것이 가능하다.
--   즉, 하나의 테이블에 UNIQUE 제약조건을 여러 개 만드는 것이 가능하다는 것이다.

--2. 형식 및 구조
-- ① 컬럼 레벨의 형식
-- 컬럼명 데이터타입 [CONSTRAINT CONSTRAINT명] UNIQUE

-- ② 테이블 레벨의 형식
-- 컬럼명 데이터타입,
-- 컬럼명 데이터타입,
-- CONSTRAINT CONSTRAINT명 UNIQUE(컬럼명[, ...])

--○ UK 지정 실습(① 컬럼 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST5
( COL1 NUMBER(5)       PRIMARY KEY
, COL2 VARCHAR2(30)    UNIQUE
);
--==>> Table TBL_TEST5이(가) 생성되었습니다.


-- 제약조건 조회
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME='TBL_TEST5';
--==>>
/*
HR	SYS_C007111	TBL_TEST5	P	COL1		
HR	SYS_C007112	TBL_TEST5	U	COL2		
*/


-- 데이터 입력
INSERT INTO TBL_TEST5(COL1, COL2) VALUES (1, 'TEST');
INSERT INTO TBL_TEST5(COL1, COL2) VALUES (2, 'ABCD');
INSERT INTO TBL_TEST5(COL1, COL2) VALUES (3, NULL);       
INSERT INTO TBL_TEST5(COL1) VALUES (4);                   
INSERT INTO TBL_TEST5(COL1, COL2) VALUES (5, 'ABCD');     --> 에러 발생 
INSERT INTO TBL_TEST5(COL1, COL2) VALUES (5, NULL);
INSERT INTO TBL_TEST5(COL1, COL2) VALUES (6, NULL);

-- 커밋
COMMIT;
--==>> 커밋완료.

--○ UK 지정 실습(② 테이블 레벨의 형식)
-- 테이블 생성
CREATE TABLE TBL_TEST6
( COL1 NUMBER(5)
, COL2 VARCHAR2(30)
, CONSTRAINT TEST6_COL1_PK PRIMARY KEY(COL1)
, CONSTRAINT TEST6_COL2_UK UNIQUE(COL2)
);
--==>> Table TBL_TEST6이(가) 생성되었습니다.


-- 제약조건 확인
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST6';
--==>>
/*
HR	TEST6_COL1_PK	TBL_TEST6	P	COL1		
HR	TEST6_COL2_UK	TBL_TEST6	U	COL2		
*/

--○ UK 지정 실습(③ 테이블 생성 이후 제약조건 추가 → UK 제약조건 추가)
-- 테이블 생성
CREATE TABLE TBL_TEST7
( COL1 NUMBER(5)
, COL2 VARCHAR2(30)
);
--==>> Table TBL_TEST7이(가) 생성되었습니다.

-- 제약조건 확인(조회)
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST7';
--==>> 조회 결과 없음

-- 제약조건 추가
ALTER TABLE TBL_TEST7
ADD ( CONSTRAINT TEST7_COL1_PK PRIMARY KEY(COL1)
    , CONSTRAINT TEST7_COL2_UK UNIQUE(COL2) );
--==>> Table TBL_TEST7이(가) 변경되었습니다.

-- 제약조건 확인(조회)
SELECT *
FROM VIEW_CONSTCHECK
WHERE TABLE_NAME = 'TBL_TEST7';
--==>>
/*
HR	TEST7_COL1_PK	TBL_TEST7	P	COL1		
HR	TEST7_COL2_UK	TBL_TEST7	U	COL2		
*/


















































