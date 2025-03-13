-- SINGLE LINE COMMENT
/*
 * MULTI LINE COMMENT
 */

/*
 * 비교연산의 종류
 * =, !=, >, >=, <, <=, IN, LIKE, BETWEEN, ISNULL, NOT
 * NOT 연산자는 굉장히 특이하다
 * NOT 연산자는 IN, LIKE, BETWEEN, IS NULL 과 함께 사용될 수 있다. 
 * COLUMN IN (V1, V2, V3) [컬럼의 값을 V1, V2, V3의 값을 가져 와라] => COLUMN NOT IN (V1, V2, V3) [컬럼의 값을 V1, V2, V3의 값을 제외하고 다 가져 와라]
 * COLUMN LIKE '%A%' [컬럼의 값을 A글자가 포함된 것을 가져 와라] => COLUMN NOT LIKE '%A%' [컬럼의 값을 A글자가 포함된 것을 제외하고 다 가져 와라]
 * COLUMN BETWEEN A AND B [A와 B 사이에 있는 것을 다 가져와라] => COLUMN NOT BETWEEN A AND B [A와 B 사이에 있는 것 제외하고 나머지 다 가져와라]
 * COLUMN IS NULL [컬럼의 값이 NULL 인 것을 가져 와라] => COLUMN IS NOT NULL [컬럼의 값이 NULL 이 아닌 것을 가져 와라]
 */ 

-- VIEW를 만드는 방법 - [2025-02-28]
/*
 * 1. Physical View - EMP_DETAILS_VIEW (create view) - 물리적인 뷰, 삭제되지 않는 뷰
 * 2. Inline View - 임시 뷰 - 한 번 사용 후 삭제되는 뷰 (FROM ~ (SUB QUERY) A where A.~~ = ) 
 * 3. With View - 임시 뷰 - 한 번 사용 후 삭제되는 뷰 (SELECT 위에 생성)
 * ORACLE 전용 START WITH CONNECT BY ~
 * MYSQL, MARIADB
 * WITH RECURSIVE EMPS AS()
 * ORACLE에서는 WITH가 많이 쓰이지는 않음
 */

-- () 안에 VIEW로 관리할 쿼리 문장을 적어줌 - [2025-02-28]
WITH EMP_DEPT AS (SELECT E.EMPLOYEE_ID
                       , D.DEPARTMENT_NAME
        			FROM EMPLOYEES E
       			   INNER JOIN DEPARTMENTS D
          			  ON E.DEPARTMENT_ID = D.DEPARTMENT_ID) 
SELECT *
  FROM EMP_DEPT
;  

-- [2025-02-24]
-- 추가문제1 - 직무 아이디가 'IT_PROG', 'FI_ACCOUNT'가 아닌 모든 사원들의 직무아이디, 사원번호를 조회한다. 
SELECT EMPLOYEE_ID
	 , JOB_ID 
  FROM EMPLOYEES
 WHERE JOB_ID NOT IN ('IT_PROG', 'FI_ACCOUNT') 
;

-- 추가문제2 - 연봉이 7000 ~ 12000 사이인 사원을 제외한 나머지 사원들의 연봉, 사원번호를 조회한다.
SELECT SALARY
	 , EMPLOYEE_ID
  FROM EMPLOYEES
 WHERE SALARY NOT BETWEEN 7000 AND 12000
;

-- 추가문제3 - 이름의 길이가 5자리가 아닌 모든 사원들의 이름을 조회한다.
SELECT FIRST_NAME 
  FROM EMPLOYEES
 WHERE FIRST_NAME
  NOT LIKE '_____'
;
-- 추가문제4 - 성에 'Z'가 포함되지 않은 사원들의 이름과 성을 조회한다.
SELECT FIRST_NAME
	 , LAST_NAME 
  FROM EMPLOYEES
 WHERE LAST_NAME 
  NOT LIKE '%Z%'
;

-- 추가문제5 - 이름이 "A"로 시작하는 5자리 이름을 제외한 나머지 모든 사원들의 이름을 조회한다. 
SELECT FIRST_NAME
  FROM EMPLOYEES
 WHERE FIRST_NAME 
   NOT LIKE 'A____'
;


-- 1. [2025-02-24] 현재 시간을 조회한다. (엄청나게 많이 쓰인다!!!!!)
-- 현재시간을 가지고 있는 테이블은 없다.
-- 대신, 현재시간을 알 수 있는 함수는 존재한다. ==> SYSDATE
-- SYSDATE가 어디 있는지 모른다. 어딘가에 속해잇는 데이터가 아니다.
-- 어디에서 뽑나?(조회하나?) - row가 하나밖에 없는 임시 테이블(더미테이블) == DUAL 을 이용한다. 
-- 윈도우는 잘 맞지만 맥은 잘 맞지않는다. 맥은 표준시로 되어있어서 9시간 느리다.
SELECT SYSDATE
  FROM DUAL
;

-- EMPLOYEES 도 되긴 한다. SYSDATE 자체가 어딘가에 속해있지 않기 때문에. 
-- 다만 조회를 하면 EMPLOYEES 가 가지고 있는 ROWS 가 다 나오기 때문에 107개가 나온다. 
SELECT SYSDATE
  FROM EMPLOYEES
;
-- DUAL 은 ROW가 하나기 때문에 시간을 구하기 위해서 DUAL을 사용한다. 

-------------------------------------------------------------------------------

-- 2. [2025-02-24] 현재 시간을 "연-월-일" 포멧으로 조회(문자열)한다. 지금은 문자열이 아닌 Date 타입이다. (엄청나게 많이 쓰인다!!!!)
-- 오라클은 문자를 표현할때 큰따옴표는 절대 사용하지 않고 반드시 작은 따옴표를 사용한다. 큰 따옴표사용시 에러
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') -- 날짜를 문자형태로 변환시키는 함수
  FROM DUAL
;

-- 3. [2025-02-24] 한 시간 전 시간을 "시:분:초" 포멧으로 조회한다. (엄청나게 많이 쓰인다!!!!)
SELECT TO_CHAR(SYSDATE, 'HH:MI:SS') -- 12 시간 기준의 시간으로 표현. 오후 한시라면 (01)
	 , TO_CHAR(SYSDATE, 'HH24:MI:SS') -- 24시간 기준의 시간으로 표현. 오후 한시라면 (13)
	 , SYSDATE -- 현재 날짜
	 , SYSDATE - 1 -- 현재 시간에서 하루를 빼고 조회.
	 , SYSDATE - 1 / 24 -- 현재 시간에서 한시간을 빼고 조회 (하루: 1, 한시간: 1/24)
	 , SYSDATE - 1 / 24 / 60 -- 현재 시간에서 1분을 빼고 조회. (하루: 1, 1시간: 1/24, 1분: 1 / 24/ 60)
	 , TO_CHAR(SYSDATE - 1 / 24, 'HH24:MI:SS') -- 이렇게 하면 시간을 문자로 가지고 올 수 있다.
	 , TO_CHAR(SYSDATE - 5 / 24/ 60, 'MI') -- 현재 시간에서 5분을 뺀 시간의 
  FROM DUAL
;

-- 4. [2025-02-24] EMPLOYEES 테이블의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID 
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
;

-- 5. [2025-02-24] DEPARTMENTS 테이블의 모든 정보를 조회한다.
SELECT DEPARTMENT_ID 
	 , DEPARTMENT_NAME 
	 , MANAGER_ID 
	 , LOCATION_ID 
  FROM DEPARTMENTS
;

-- 6. [2025-02-24] JOBS 테이블의 모든 정보를 조회한다.
SELECT JOB_ID 
	 , JOB_TITLE
	 , MIN_SALARY
	 , MAX_SALARY 
  FROM JOBS
;

-- 7. [2025-02-24] LOCATIONS 테이블의 모든 정보를 조회한다.
SELECT LOCATION_ID
	 , STREET_ADDRESS
	 , POSTAL_CODE
	 , CITY
	 , STATE_PROVINCE
	 , COUNTRY_ID 
  FROM LOCATIONS
;

-- 8. [2025-02-24] COUNTRIES 테이블의 모든 정보를 조회한다.
SELECT COUNTRY_ID
	 , COUNTRY_NAME 
	 , REGION_ID 
  FROM COUNTRIES
;

-- 9. [2025-02-24] REGIONS 테이블의 모든 정보를 조회한다.
SELECT REGION_ID
	 , REGION_NAME 
  FROM REGIONS
;

-- 10. [2025-02-24] JOB_HISTORY 테이블의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID 
	 , START_DATE 
	 , END_DATE 
	 , JOB_ID 
	 , DEPARTMENT_ID 
  FROM JOB_HISTORY
;

---------------------------------------------------------
-- 11. [2025-02-24] 90번 부서에서 근무하는 사원들의 모든 정보를 조회한다.
-- employees 테이블에서 부서번호 (departmet_id) 가 90 인 row 만 조회한다. (모든 컬럼)
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 90
;

-- 12. [2025-02-24] 90번, 100번 부서에서 근무하는 사원들의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 90 
 	OR DEPARTMENT_ID = 100
;

-- 13. [2025-02-24] 100번 상사의 직속 부하직원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE MANAGER_ID  = 100
;

-- 14. [2025-02-24] 직무 아이디가 AD_VP 인 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE JOB_ID = 'AD_VP'
;

-- 15. [2025-02-24] 연봉이 7000 이상인 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE SALARY >= 7000
;

-- 16. [2025-02-24] 2005년 09월에 입사한 사원들의 모든 정보를 조회한다.
-- 입사일이 2005년 9월 1일 00시 00분 00초 ~ 2005년 9월 30일 23시 59분 59초에 입사한 모든 사원들.
-- '2005-09-01 00:00:00' -> DATE 로 변경해야 됨.
SELECT '2005-09-01 00:00:00'
	 , TO_DATE('2005-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
  FROM DUAL
;

-- BETWEEN 사용 X
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE HIRE_DATE >= TO_DATE('2005-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS')
   AND HIRE_DATE <= TO_DATE('2005-09-30 23:59:59', 'YYYY-MM-DD HH24:MI:SS')
; 

-- BETWEEN 사용 O
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE HIRE_DATE BETWEEN TO_DATE('2005-09-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AND TO_DATE('2005-09-30 23:59:59', 'YYYY-MM-DD HH24:MI:SS')
; 

-- 17.[2025-02-24] 111번 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 111
;

-- 18. [2025-02-24] 인센티브를 안받는 사원들의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NULL
;

-- 19. [2025-02-24] 인센티브를 받는 사원들의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
-- WHERE COMMISSION_PCT IS NOT NULL
 WHERE COMMISSION_PCT > 0 -- IS NOT NULL 과 같은 의미.
;

---------------------- LIKE 문제 --------------------------
-- 20. [2025-02-24] 이름의 첫 글자가 'D' 인 사원들의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE FIRST_NAME LIKE 'D%'
;

-- 21. [2025-02-24] 성의 마지막 글자가 'a' 인 사원들의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE LAST_NAME  LIKE '%a'
;

-- 22. [2025-02-24] 전화번호에 '.124.'이 포함된 사원들의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE PHONE_NUMBER   LIKE '%.124.%'
;

--------------------------------------------------------------

-- 23. [2025-02-24] 직무 아이디가 'PU_CLERK'인 사원 중 연봉이 3000 이상인 사원들의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE JOB_ID = 'PU_CLERK'
    AND SALARY >= 3000 
;

-- [2025-02-24]
-- 추가문제 1 - 부서번호가 70이고 직무아이디가 IT_PROG 이면서 연봉이 4000 이상인 사원의
--			  이름, 성, 사원번호, 부서번호, 직무아이디, 연봉을 조회한다.
-- 추가 문제 1 번은 아무것도 조회되지 않는게 맞다. 
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , JOB_ID 
	 , SALARY 
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 70 
   AND JOB_ID = 'IT_PROG'
   AND SALARY >= 4000 
;

-- 추가문제 2 - 부서번호가 70 혹은 90 이면서 연봉이 5000 이상인 사원의
--			  이름, 성, 사원번호, 부서번호, 연봉을 연봉 오름차순으로 정렬하여 조회한다.
SELECT FIRST_NAME 
	 , LAST_NAME
	 , EMPLOYEE_ID
	 , DEPARTMENT_ID 
	 , SALARY 
  FROM EMPLOYEES
 WHERE (DEPARTMENT_ID = 70 
   OR DEPARTMENT_ID = 90)
   AND SALARY >= 5000 
 ORDER BY SALARY ASC 
;

-------------- OR 이 여러개 일 경우 사용하는 2가지 경우 ---------------------------
SELECT FIRST_NAME 
	 , LAST_NAME
	 , EMPLOYEE_ID
	 , DEPARTMENT_ID 
	 , SALARY 
  FROM EMPLOYEES
 WHERE (DEPARTMENT_ID = 60 
   OR DEPARTMENT_ID = 70 
   OR DEPARTMENT_ID = 90)
   AND SALARY >= 5000 
 ORDER BY SALARY ASC 
;

SELECT FIRST_NAME 
	 , LAST_NAME
	 , EMPLOYEE_ID
	 , DEPARTMENT_ID 
	 , SALARY 
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IN (60, 70, 90) -- 제한: IN의 파라미터(비굣값)은 1000개 이하로 제한.
   AND SALARY >= 5000 
 ORDER BY SALARY ASC 
;
-----------------------------------------------------------------

-- 추가문제 3 - 상사의 사원번호가 100 이면서 연봉이 9000 미만인 사원의
--			  부서번호, 이름, 연봉을 이름 내림차순으로 정렬하여 조회한다.
SELECT DEPARTMENT_ID 
	 , FIRST_NAME 
	 , SALARY 
  FROM EMPLOYEES
 WHERE MANAGER_ID  = 100 
   AND SALARY < 9000
 ORDER BY FIRST_NAME DESC
;

-- 추가문제 4 - 도시의 이름이 "Seattle"인 지역의 번호, 우편번호, 도로명 주소를 조회한다.
SELECT LOCATION_ID
	 , POSTAL_CODE
	 , STREET_ADDRESS 
  FROM LOCATIONS
 WHERE CITY = 'Seattle'
;

-- 추가문제 5 - 지역의 번호가 1700인 부서의 이름과 부서의 번호를 부서의 이름으로 오름차순 정렬하려 조회한다.
SELECT DEPARTMENT_ID
	 , DEPARTMENT_NAME 
  FROM DEPARTMENTS
 WHERE LOCATION_ID = 1700
 ORDER BY DEPARTMENT_NAME ASC
;

-- 24. [2025-02-25 - SUB QUERY] 평균 연봉보다 많이 받는 사원들의 사원번호, 이름, 성, 연봉을 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , SALARY
  FROM EMPLOYEES
 WHERE SALARY > (SELECT AVG(SALARY)
                  FROM EMPLOYEES)
;

-- 25. [2025-02-25 - SUB QUERY] 평균 연봉보다 적게 받는 사원들의 사원번호, 연봉, 부서번호를 조회한다.
SELECT EMPLOYEE_ID
     , SALARY
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE SALARY < (SELECT AVG(SALARY)
                   FROM EMPLOYEES)
;

-- 26. [2025-02-25 - SUB QUERY] 가장 많은 연봉을 받는 사원의 사원번호, 이름, 연봉을 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , SALARY
  FROM EMPLOYEES
 WHERE SALARY = (SELECT MAX(SALARY)
  				   FROM EMPLOYEES)
;

-- 27. [2025-02-24] 이름이 4글자인 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY 
	 , COMMISSION_PCT 
	 , MANAGER_ID
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE FIRST_NAME    LIKE '____'
;

-- 28. [2025-02-25] 'SA_REP' 직무인 직원 중 가장 높은 연봉과 가장 낮은 연봉을 조회한다.
SELECT MAX(SALARY)
	 , MIN(SALARY)
  FROM EMPLOYEES
 WHERE JOB_ID = 'SA_REP'
;

-- [2025-02-25]
-- 추가문제1: 'SA_REP' 직무인 사원의 평균 연봉을 조회한다.
SELECT AVG(SALARY)
  FROM EMPLOYEES
  WHERE JOB_ID = 'SA_REP'
;

-- 추가문제2: 'SA_REP' 직무인 사원의 수를 조회한다.
SELECT COUNT(SALARY)
  FROM EMPLOYEES
  WHERE JOB_ID = 'SA_REP'
;

-- 추가문제3: 'SA_REP' 직무인 사원의 총 연봉의 합을 조회한다.
SELECT SUM(SALARY)
  FROM EMPLOYEES
  WHERE JOB_ID = 'SA_REP'
;

-- 추가문제4: 전체 사원의 수, 최대 연봉, 최저 연봉, 평균 연봉, 총 연봉의 합을 조회한다.
SELECT COUNT(EMPLOYEE_ID)
     , MAX(SALARY)
     , MIN(SALARY)
     , AVG(SALARY)
     , SUM(SALARY)
FROM EMPLOYEES
;

-- 추가문제5: 전체 사원 중에서 가장 먼저 입사한 날짜를 조회한다.
SELECT MIN(HIRE_DATE)
  FROM EMPLOYEES
;

-- 추가문제6: 전체 사원 중에서 가장 늦게 입사한 날짜를 조회한다.
SELECT MAX(HIRE_DATE)
  FROM EMPLOYEES
;

-- 29. [2025-02-25] 직원의 입사일자를 '연-월-일' 형태로 조회한다.
SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD')
  FROM EMPLOYEES
;
  
-- 30. [2025-02-25 - SUB QUERY] 가장 늦게 입사한 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE HIRE_DATE = (SELECT MAX(HIRE_DATE)
                      FROM EMPLOYEES)
;

-- 31. [2025-02-25 - SUB QUERY] 가장 일찍 입사한 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE HIRE_DATE = (SELECT MIN(HIRE_DATE)
                      FROM EMPLOYEES)
;

-- 32. [2025-02-25 - SUB QUERY] 자신의 상사보다 더 많은 연봉을 받는 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES EACH_EMP
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEES
                  WHERE EMPLOYEE_ID = EACH_EMP.MANAGER_ID)	
;

-- 33. [2025-02-25 - SUB QUERY] 자신의 상사보다 더 일찍 입사한 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES EACH_EMP
 WHERE HIRE_DATE < (SELECT HIRE_DATE
                      FROM EMPLOYEES
                     WHERE EMPLOYEE_ID = EACH_EMP.MANAGER_ID)	         
;

-- 34. [2025-02-25] 부서아이디별 평균 연봉을 조회한다.
/*
 * 1. EMPLOYEES 테이블에서 DEPARTMENT_ID를 기준으로 데이터를 쪼갠다.
 * 2. 쪼개진 데이터에서 평균 연봉을 집계한다.
 * 3. 쪼개진 데이터를 하나의 테이블로 다시 만든다. - FETCH - SELECT 할 때 자동으로 수행
 */
SELECT DEPARTMENT_ID -- <== GROUP BY에 작성된 컬럼만 SELECT에 사용 가능!
--   , EMPLOYEE_ID -- ora-00970: GROUP BY 표현식이 아닙니다.
     , AVG(SALARY)
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
;

-- 추가문제1: 부서번호별, 직무아이디별 사원들의 평균연봉과 최대 연봉 그리고 최소 연봉을 조회한다.
SELECT DEPARTMENT_ID
     , JOB_ID
     , AVG(SALARY)
     , MAX(SALARY)
     , MIN(SALARY)
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IS NOT NULL
 GROUP BY DEPARTMENT_ID
     , JOB_ID
;

-- 35. [2025-02-25] 직무아이디별 평균 연봉, 최고연봉, 최저연봉을 조회한다.
SELECT JOB_ID
	 , AVG(SALARY)
	 , MAX(SALARY)
	 , MIN(SALARY)
  FROM EMPLOYEES
 GROUP BY JOB_ID
;

-- 36. [2025-02-25 - SUB QUERY] 가장 많은 인센티브를 받는 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE COMMISSION_PCT = (SELECT MAX(COMMISSION_PCT)
                           FROM EMPLOYEES)
;

-- 37. [2025-02-25 - SUB QUERY] 가장 적은 인센티브를 받는 사원의 연봉과 인센티브를 조회한다.
SELECT SALARY
     , COMMISSION_PCT
  FROM EMPLOYEES
 WHERE COMMISSION_PCT = (SELECT MIN(COMMISSION_PCT)
                           FROM EMPLOYEES)
;

-- 38. [2025-02-25] 직무아이디별 사원의 수를 조회한다.
SELECT JOB_ID
     , COUNT(EMPLOYEE_ID)
  FROM EMPLOYEES
 GROUP BY JOB_ID
;

-- 39. [2025-02-25] 상사아이디별 부하직원의 수를 조회한다. 단, 부하직원이 2명 이하인 경우는 제외한다.
SELECT MANAGER_ID
     , COUNT(EMPLOYEE_ID)
  FROM EMPLOYEES
 GROUP BY MANAGER_ID
HAVING COUNT(EMPLOYEE_ID) > 2
;

-- 40. [2025-02-25 - SUB QUERY] 사원이 속한 부서의 평균연봉보다 적게 받는 사원의 모든 정보를 조회한다.
-- 알고싶은 것
-- 내가 소속되어 있는 부서의 평균 연봉이 얼마냐?
-- 만약, 내가 소속된 부서의 번호가 60번일 경우 60번 부서의 평균 연봉은 얼마냐?
SELECT AVG(SALARY) -- 5760
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 60
;
-- 		내가 소속된 부서의 번호가 80번일 경우 80번 부서의 평균 연봉은 얼마냐?
SELECT AVG(SALARY) -- 8955.882352941176470588235294117647058824
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID = 80
;
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES EACH_EMP
 WHERE SALARY > (SELECT AVG(SALARY)
 				   FROM EMPLOYEES ALL_EMP
 				  WHERE ALL_EMP.DEPARTMENT_ID = EACH_EMP.DEPARTMENT_ID )
;

-- 41. [2025-02-26] 사원이 근무하는 부서명, 이름, 성을 조회한다.
-- 근무 관계란?
--	하나의 부서에는 여러명의 사원들이 근무한다.
-- 	한명의 사원은 하나의 부서에서 근무한다.
--	1 부서에는 N 사원이 근무중이다. -> 사원과 부서의 관계 1:N
-- 사원 + 부서 (부서번호로 연결)
SELECT D.DEPARTMENT_NAME
     , E.FIRST_NAME
     , E.LAST_NAME
     , D.DEPARTMENT_ID
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
;

-- Asia 대륙에서 근무하는 모든 사원의 사원 번호, 이름, 성, 연봉, 부서명, 도시명, 국가명, 대륙명, 직무명을 조회해라.
-- 사원번호, 이름, 성, 연봉 - EMPLOYEES
-- 부서명 - DEPARTMENTS
-- 도시명 - LOCATIONS
-- 국가명 - COUNTRIES
-- 대륙명 - REGIONS
-- 직무명 - JOBS
-- 근무 -> Asia에 존재하는 부서에서 근무하는 사원들
SELECT EMPLOYEE_ID
     , E.FIRST_NAME
     , E.LAST_NAME
     , E.SALARY
     , D.DEPARTMENT_NAME
     , L.CITY
     , C.COUNTRY_NAME
     , R.REGION_NAME
     , J.JOB_TITLE
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID -- 사원 + 부서
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID -- 사원 + 부서 + 지역
 INNER JOIN COUNTRIES C
    ON L.COUNTRY_ID = C.COUNTRY_ID -- 사원 + 부서 + 지역 + 국가
 INNER JOIN REGIONS R
    ON C.REGION_ID = R.REGION_ID -- 사원 + 부서 + 지역 + 국가 + 대륙
 INNER JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID -- 사원 + 부서 + 지역 + 국가 + 대륙 + 직무
 WHERE R.REGION_NAME = 'Asia'
;

-- 42. [2025-02-26] 가장 적은 연봉을 받는 사원의 부서명, 이름, 성, 연봉, 부서장사원번호를 조회한다.
-- 두가지 방법
-- 1. 이너조인
-- 2. 서브쿼리
-- 두개 테이블
-- 부서명, 부서장사원번호 - 부서정보
-- 이름, 성, 연봉 - 사원정보
-- 사원 + 부서 (근무관계)
SELECT D.DEPARTMENT_NAME
     , D.MANAGER_ID
     , E.FIRST_NAME
     , E.LAST_NAME
     , E.SALARY
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID -- 사원 + 부서 
 WHERE E.SALARY = (SELECT MIN(SALARY) -- 2100
                     FROM EMPLOYEES)
;

-- 가장 적은 연봉은 얼마냐?
SELECT MIN(SALARY) -- 2100
  FROM EMPLOYEES
;  

-- 43. [2025-02-25] 상사사원번호를 중복없이 조회한다.
-- DISTINCT COLUMN - SELECT에서 단 한 번 사용 가능한 키워드.
--			중복값을 제거하는 것이 아니라, 중복 Row를 제거한다.
SELECT DISTINCT MANAGER_ID
  FROM EMPLOYEES
;

-- 44. [2025-02-25 - SUB QUERY] 50번 부서의 부서장의 이름, 성, 연봉을 조회한다.
-- 50번 부서의 부서장 사원번호는 무엇인가? => 모른다
SELECT MANAGER_ID -- 부서장의 사원 번호 : 121
  FROM DEPARTMENTS
 WHERE DEPARTMENT_ID = 50 
;  
-- 50번 부서의 부서장 사원번호만 안다면 부서장의 모든 정보를 조회할 수 있다.
SELECT FIRST_NAME
     , LAST_NAME
     , SALARY
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 121
 ;

SELECT FIRST_NAME
     , LAST_NAME
     , SALARY
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID = (SELECT MANAGER_ID
  						FROM DEPARTMENTS
 					   WHERE DEPARTMENT_ID = 50) 
 ;
 
-- 45. [2025-02-27] 부서명별 사원의 수를 조회한다. (GROUP BY)
SELECT D.DEPARTMENT_NAME 
     , COUNT(E.EMPLOYEE_ID)
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 GROUP BY D.DEPARTMENT_NAME 
;

-- 46. [2025-02-28 HW] 사원의 수가 가장 많은 부서명, 사원의 수를 조회한다. (INLINE VIEW)
SELECT DEPARTMENT_NAME
     , EMP_CNT
  FROM (SELECT D.DEPARTMENT_NAME
             , COUNT(E.EMPLOYEE_ID) AS EMP_CNT
          FROM EMPLOYEES E
         INNER JOIN DEPARTMENTS D
            ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
         GROUP BY D.DEPARTMENT_NAME 
         ORDER BY EMP_CNT DESC)
 WHERE ROWNUM = 1
;

-- [2025-02-28] LEFT OUTER JOIN 추가 문제 (LEFT OUTER JOIN, GROUP BY)
-- 부서명 별 사원의 수를 조회한다. 사원이 없는 부서일 경우 0으로 표시된다.
SELECT D.DEPARTMENT_NAME
     , COUNT(E.EMPLOYEE_ID) AS EMP_CNT
  FROM DEPARTMENTS D 
  LEFT OUTER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID 
 GROUP BY D.DEPARTMENT_NAME
 ORDER BY EMP_CNT DESC
;    

-- 직무명 별 사원의 수를 조회한다. 아무도 수행하지 않는 직무는 0으로 표시한다.
SELECT J.JOB_TITLE
     , COUNT(E.EMPLOYEE_ID) AS EMP_CNT
  FROM JOBS J 
  LEFT OUTER JOIN EMPLOYEES E
    ON J.JOB_ID = E.JOB_ID 
 GROUP BY J.JOB_TITLE
 ORDER BY EMP_CNT DESC
;   

-- 47. [2025-02-28] 사원이 없는 부서명을 조회한다. (LEFT OUTER JOIN)
-- SUB QUERY
-- 부서 기준으로 사원이 없는 부서만 조회한다.
-- 부서명만 조회하기 때문에 SUB QUERY로 푸는 것이 맞음
SELECT DEPARTMENT_NAME
  FROM DEPARTMENTS
 WHERE DEPARTMENT_ID NOT IN (SELECT DEPARTMENT_ID
                               FROM EMPLOYEES
                              WHERE DEPARTMENT_ID IS NOT NULL)
;                               

-- LEFT OUTER JOIN
-- 부서 기준으로 사원이 없는 부서만 조회한다.
SELECT D.DEPARTMENT_NAME 
     , D.DEPARTMENT_ID
     , E.EMPLOYEE_ID 
     , E.DEPARTMENT_ID AS E_DEPARTMENT_ID
  FROM DEPARTMENTS D 
  LEFT OUTER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID -- 근무관계만 명시해줌
 WHERE E.EMPLOYEE_ID IS NULL
;    

-- 48. [2025-02-25 - SUB QUERY] 직무가 변경된 사원의 모든 정보를 조회한다.
-- 직무가 변경된 적이 있는 사원의 번호는 무엇인가?
SELECT DISTINCT EMPLOYEE_ID
  FROM JOB_HISTORY
;

SELECT EMPLOYEE_ID
	 , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID IN (SELECT DISTINCT EMPLOYEE_ID
 		  				 FROM JOB_HISTORY)
;
 
-- 49. [2025-02-25 - SUB QUERY] 직무가 변경된적 없는 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES
  WHERE EMPLOYEE_ID NOT IN (SELECT DISTINCT EMPLOYEE_ID
 		  				      FROM JOB_HISTORY)
;

-- 50. [2025-02-28 HW] 직무가 변경된 사원의 과거 직무명과 현재 직무명을 조회한다.
SELECT E.EMPLOYEE_ID
     , J_PREV.JOB_TITLE AS PREVIOUS_JOB_TITLE
     , J_CUR.JOB_TITLE AS CURRENT_JOB_TITLE
  FROM EMPLOYEES E
 INNER JOIN JOB_HISTORY JH
    ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID
 INNER JOIN JOBS J_PREV
    ON JH.JOB_ID = J_PREV.JOB_ID -- 과거 직무
 INNER JOIN JOBS J_CUR
    ON E.JOB_ID = J_CUR.JOB_ID -- 현재 직무
;

-- 51. [2025-02-28 HW] 직무가 가장 많이 변경된 부서의 이름을 조회한다.
SELECT DEPARTMENT_NAME
     , CHANGE_COUNT
  FROM (SELECT D.DEPARTMENT_NAME
             , COUNT(JH.JOB_ID) AS CHANGE_COUNT
          FROM JOB_HISTORY JH
         INNER JOIN DEPARTMENTS D
            ON JH.DEPARTMENT_ID = D.DEPARTMENT_ID 
         GROUP BY D.DEPARTMENT_NAME)
 WHERE CHANGE_COUNT = (SELECT MAX(CHANGE_COUNT)
                         FROM (SELECT COUNT(JH.JOB_ID) AS CHANGE_COUNT
                                 FROM JOB_HISTORY JH
                                INNER JOIN DEPARTMENTS D
                                   ON JH.DEPARTMENT_ID = D.DEPARTMENT_ID 
                                GROUP BY D.DEPARTMENT_NAME))
;    

-- 52. [2025-02-28 HW] 'Seattle' 에서 근무중인 사원의 이름, 성, 연봉, 부서명 을 조회한다.
SELECT E.FIRST_NAME 
     , E.LAST_NAME
     , E.SALARY
     , D.DEPARTMENT_NAME
     , L.CITY
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
 WHERE L.CITY = 'Seattle'
;

-- 53. [2025-02-28 HW] 'Seattle' 에서 근무하지 않는 모든 사원의 이름, 성, 연봉, 부서명, 도시를 조회한다.
SELECT E.FIRST_NAME 
     , E.LAST_NAME
     , E.SALARY
     , D.DEPARTMENT_NAME
     , L.CITY
  FROM EMPLOYEES E
  LEFT OUTER JOIN DEPARTMENTS D -- 부서 정보가 없는 사원도 조회하기 위해 LEFT OUTER JOIN 사용
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
  LEFT OUTER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
 WHERE L.CITY != 'Seattle' OR L.CITY IS NULL
;
 
-- 54. [2025-02-28 HW] 근무중인 사원이 가장 많은 도시와 사원의 수를 조회한다. 
SELECT CITY
     , EMP_COUNT
  FROM (SELECT L.CITY
             , COUNT(EMPLOYEE_ID) AS EMP_COUNT
          FROM EMPLOYEES E
         INNER JOIN DEPARTMENTS D
            ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
         INNER JOIN LOCATIONS L
            ON D.LOCATION_ID = L.LOCATION_ID
         GROUP BY L.CITY)
 WHERE EMP_COUNT = (SELECT MAX(EMP_COUNT)
          			  FROM (SELECT COUNT(EMPLOYEE_ID) AS EMP_COUNT
         					  FROM EMPLOYEES E
         					 INNER JOIN DEPARTMENTS D
                                ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
                             INNER JOIN LOCATIONS L
                                ON D.LOCATION_ID = L.LOCATION_ID
                             GROUP BY L.CITY))
;            

-- 출력하려는 정보가 없으면 INNER JOIN을 하면 안 됨
SELECT L.CITY
     , LOCATION_EMP.EMP_CNT
  FROM LOCATIONS L
 INNER JOIN (SELECT LOCATION_ID
                  , EMP_CNT
               FROM (SELECT D.LOCATION_ID
                          , COUNT(E.EMPLOYEE_ID) AS EMP_CNT
                       FROM EMPLOYEES E
                      INNER JOIN DEPARTMENTS D
                         ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
                      GROUP BY D.LOCATION_ID
                      ORDER BY EMP_CNT DESC) 
              WHERE ROWNUM = 1) LOCATION_EMP
    ON L.LOCATION_ID = LOCATION_EMP.LOCATION_ID
;

-- 55. [2025-02-28 HW] 근무중인 사원이 없는 도시를 조회한다.
SELECT DISTINCT L.CITY
  FROM LOCATIONS L
  LEFT OUTER JOIN DEPARTMENTS D
    ON L.LOCATION_ID = D.LOCATION_ID
  LEFT OUTER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
 WHERE E.EMPLOYEE_ID IS NULL
; 
-- SUBQUERY로 풀어야 함 결과 16개

-- 56. [2025-02-26] 연봉이 7000 에서 12000 사이인 사원이 근무중인 도시를 조회한다.
SELECT DISTINCT L.CITY
  FROM LOCATIONS L
 INNER JOIN DEPARTMENTS D
    ON L.LOCATION_ID = D.LOCATION_ID
 INNER JOIN EMPLOYEES E
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
 WHERE SALARY BETWEEN 7000 AND 12000
;

-- [2025-02-24]
-- 추가문제1 - -- 56. 연봉이 7000 에서 12000 사이인 사원번호, 이름, 연봉을 조회한다.
-- BETWEEN 을 사용하지 않은 경우
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , SALARY 
  FROM EMPLOYEES
 WHERE SALARY >= 7000
   AND SALARY <= 12000
; 

-- BETWEEN 을 사용한 경우
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , SALARY 
  FROM EMPLOYEES
 WHERE SALARY BETWEEN 7000 AND 12000
; 

-- 57. [2025-02-26] 'Seattle' 에서 근무중인 사원의 직무명을 중복없이 조회한다.
SELECT DISTINCT J.JOB_TITLE
  FROM JOBS J
 INNER JOIN EMPLOYEES E
    ON J.JOB_ID = E.JOB_ID
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
 WHERE L.CITY = 'Seattle'
;

-- 58. [2025-02-25] 사내의 최고연봉과 최저연봉의 차이를 조회한다.
SELECT MAX(SALARY)
     , MIN(SALARY)
     , MAX(SALARY) - MIN(SALARY)
  FROM EMPLOYEES
;

-- 59. [2025-02-25 - SUB QUERY] 이름이 'Renske' 인 사원의 연봉과 같은 연봉을 받는 사원의 모든 정보를 조회한다. 단, 'Renske' 사원은 조회에서 제외한다.
-- 알고싶은 것 Renske의 연봉
-- Renske의 연봉과 같은 연봉을 받는 사원의 모든 정보를 조회
SELECT SALARY -- 3600
  FROM EMPLOYEES
 WHERE FIRsT_NAME = 'Renske'
; 

SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE SALARY = 3600
   AND FIRST_NAME != 'Renske'
;

SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE SALARY = (SELECT SALARY
                   FROM EMPLOYEES
                  WHERE FIRST_NAME = 'Renske')
   AND FIRST_NAME != 'Renske'
;

-- 60. [2025-02-25 - SUB QUERY] 회사 전체의 평균 연봉보다 많이 받는 사원들 중 이름에 'u' 가 포함된 사원과 동일한 부서에서 근무중인 사원들의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE SALARY > (SELECT AVG(SALARY) 
                  FROM EMPLOYEES)
   AND DEPARTMENT_ID IN ( SELECT DISTINCT DEPARTMENT_ID
                            FROM EMPLOYEES
                           WHERE FIRST_NAME LIKE '%u%')
;

-- 61. [2025-02-25 - SUB QUERY] 부서가 없는 국가명을 조회한다.
SELECT COUNTRY_NAME
  FROM COUNTRIES
 WHERE COUNTRY_ID NOT IN (SELECT DISTINCT COUNTRY_ID
                            FROM LOCATIONS
                           WHERE LOCATION_ID IN (SELECT DISTINCT LOCATION_ID
                                                   FROM DEPARTMENTS))
;

-- 62. [2025-02-25 - SUB QUERY] 'Europe' 에서 근무중인 사원들의 모든 정보를 조회한다.
 SELECT REGION_ID -- 1
  FROM REGIONS
 WHERE REGION_NAME = 'Europe'
;

SELECT COUNTRY_ID
  FROM COUNTRIES
 WHERE REGION_ID = (SELECT REGION_ID
                      FROM REGIONS
                     WHERE REGION_NAME = 'Europe')
;
 
SELECT LOCATION_ID
  FROM LOCATIONS
 WHERE COUNTRY_ID IN (SELECT COUNTRY_ID
                       FROM COUNTRIES
                      WHERE REGION_ID = (SELECT REGION_ID
                                           FROM REGIONS
                                          WHERE REGION_NAME = 'Europe'))
;

SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
 WHERE LOCATION_ID IN (SELECT LOCATION_ID
                         FROM LOCATIONS
                        WHERE COUNTRY_ID IN (SELECT COUNTRY_ID
                                               FROM COUNTRIES
                                              WHERE REGION_ID = (SELECT REGION_ID
                                                                   FROM REGIONS
                                                                 WHERE REGION_NAME = 'Europe')))
;

SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                           FROM DEPARTMENTS
                          WHERE LOCATION_ID IN (SELECT LOCATION_ID
                                                  FROM LOCATIONS
                                                 WHERE COUNTRY_ID IN (SELECT COUNTRY_ID
                                                                        FROM COUNTRIES
                                                                       WHERE REGION_ID = (SELECT REGION_ID
                                                                                            FROM REGIONS
                                                                                           WHERE REGION_NAME = 'Europe'))))
;                                                                                           

-- 63. [2025-02-28 HW] 'Europe' 에서 가장 많은 사원들이 있는 부서명을 조회한다.
SELECT DEPARTMENT_NAME
     , EMP_COUNT
  FROM (SELECT D.DEPARTMENT_NAME
             , COUNT(E.EMPLOYEE_ID) AS EMP_COUNT
          FROM EMPLOYEES E
 		 INNER JOIN DEPARTMENTS D
            ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
         INNER JOIN LOCATIONS L
            ON D.LOCATION_ID = L.LOCATION_ID
 		 INNER JOIN COUNTRIES C
            ON L.COUNTRY_ID = C.COUNTRY_ID
 		 INNER JOIN REGIONS R
            ON C.REGION_ID = R.REGION_ID
 		 WHERE R.REGION_NAME = 'Europe'
     	 GROUP BY D.DEPARTMENT_NAME 
     	 ORDER BY EMP_COUNT DESC)
WHERE ROWNUM = 1
; 
-- 54번 문제처럼 건수를 줄여서 풀여야 함

-- 64. [2025-02-28 HW] 대륙 별 사원의 수를 조회한다.
SELECT R.REGION_NAME
     , COUNT(E.EMPLOYEE_ID)
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
 INNER JOIN COUNTRIES C
    ON L.COUNTRY_ID = C.COUNTRY_ID
 INNER JOIN REGIONS R
    ON C.REGION_ID = R.REGION_ID
 GROUP BY R.REGION_NAME
;    

SELECT R.REGION_NAME
     , CON_EMP.EMP_CNT
  FROM (SELECT C.REGION_ID 
             , SUM(LOC_EMP.EMP_CNT) AS EMP_CNT
          FROM (SELECT L.COUNTRY_ID
                     , SUM(DEPT_EMP.EMP_CNT) AS EMP_CNT
                  FROM (SELECT D.LOCATION_ID
                             , COUNT(E.EMPLOYEE_ID) AS EMP_CNT
                          FROM EMPLOYEES E
                         INNER JOIN DEPARTMENTS D
                            ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
                         GROUP BY D.LOCATION_ID) DEPT_EMP
                 INNER JOIN LOCATIONS L
                    ON L.LOCATION_ID = DEPT_EMP.LOCATION_ID
                 GROUP BY L.COUNTRY_ID) LOC_EMP
        INNER JOIN COUNTRIES C
          ON LOC_EMP.COUNTRY_ID = C.COUNTRY_ID
       GROUP BY C.REGION_ID) CON_EMP
 INNER JOIN REGIONS R
    ON CON_EMP.REGION_ID = R.REGION_ID
;    

-- 65. [2025-02-28 HW] 연봉이 2500, 3500, 7000 이 아니며 직업이 SA_REP 이나 ST_CLERK 인 사람들을 조회한다.
SELECT FIRST_NAME
     , LAST_NAME
     , JOB_ID
     , SALARY
  FROM EMPLOYEES
 WHERE SALARY NOT IN (2500, 3500, 7000)
   AND JOB_ID IN ('SA_REP', 'ST_CLERK')
;    

-- 66. [2025-02-28 HW] 사원의 사원번호, 이름, 성, 상사의 사원번호, 상사의 이름, 상사의 성을 조회한다.
SELECT E.EMPLOYEE_ID
     , E.FIRST_NAME
     , E.LAST_NAME
     , M.EMPLOYEE_ID AS MANAGER_ID
     , M.FIRST_NAME AS MANAGER_FIRST_NAME
     , M.LAST_NAME AS MANAGER_LAST_NAME
  FROM EMPLOYEES E
  LEFT OUTER JOIN EMPLOYEES M
    ON E.MANAGER_ID = M.EMPLOYEE_ID
; 

-- 67. [2025-02-28 HW] 101번 사원의 모든 부하직원 들의 이름, 성, 상사사원번호, 상사사원명을 조회한다.
SELECT E.FIRST_NAME
     , E.LAST_NAME
     , E.MANAGER_ID
     , M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
  FROM EMPLOYEES E
 INNER JOIN EMPLOYEES M
    ON E.MANAGER_ID = M.EMPLOYEE_ID 
 WHERE E.MANAGER_ID = 101
;

SELECT E.FIRST_NAME
     , E.LAST_NAME
     , E.MANAGER_ID
  FROM EMPLOYEES E
 START WITH EMPLOYEE_ID = 101
CONNECT BY PRIOR E.EMPLOYEE_ID = E.MANAGER_ID
 ORDER BY E.EMPLOYEE_ID
; 

-- 68. [2025-02-28 HW] 114번 직원의 모든 상사들의 이름, 성, 상사사원번호, 상사사원명을 조회한다.
 SELECT EMPLOYEE_ID 
      , FIRST_NAME
      , LAST_NAME
   FROM EMPLOYEES
  WHERE EMPLOYEE_ID != 114
  START WITH EMPLOYEE_ID = 114
CONNECT BY PRIOR MANAGER_ID = EMPLOYEE_ID
; 

-- 69. [2025-02-28 HW] 114번 직원의 모든 상사들의 이름, 성, 상사사원번호, 상사사원명을 조회한다. 단, 역순으로 조회한다.
 SELECT EMPLOYEE_ID 
      , FIRST_NAME
      , LAST_NAME
   FROM EMPLOYEES
  WHERE EMPLOYEE_ID != 114
  START WITH EMPLOYEE_ID = 114
CONNECT BY PRIOR MANAGER_ID = EMPLOYEE_ID
  ORDER BY LEVEL DESC
; 

-------------------------------------------------------------------------------------
-- 70. [2025-02-24] 모든 사원들을 연봉 오름차순 정렬하여 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY
	 , COMMISSION_PCT 
	 , MANAGER_ID 
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 ORDER BY SALARY 
;

-- 71. [2025-02-24] 모든 사원들을 이름 내림차순 정렬하여 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY
	 , COMMISSION_PCT 
	 , MANAGER_ID 
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 ORDER BY FIRST_NAME DESC 
;


-- 72. [2025-02-26] 모든 사원들의 이름, 성, 연봉, 부서명을 부서번호로 내림차순 정렬하여 조회한다.
SELECT D.DEPARTMENT_ID 
     , D.DEPARTMENT_NAME
     , E.FIRST_NAME
     , E.LAST_NAME
     , E.SALARY
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 ORDER BY D.DEPARTMENT_ID DESC
;

-- [2025-02-24]
-- 추가문제. 모든 사원들의 이름, 성, 연봉, 부서번호, 직무아이디를 부서번호로 내림차순 정렬하여 조회한다.
SELECT FIRST_NAME
	 , LAST_NAME
	 , SALARY
	 , DEPARTMENT_ID 
	 , JOB_ID 
  FROM EMPLOYEES
 ORDER BY DEPARTMENT_ID DESC
;

-- 추가문제2. 모든 사원들의 이름, 성, 연봉, 부서번호, 직무아이디를 부서번호로 내림차순, 이름으로 오름차순 정렬하여 조회한다. (2차 정렬)
SELECT FIRST_NAME
	 , LAST_NAME
	 , SALARY
	 , DEPARTMENT_ID 
	 , JOB_ID 
  FROM EMPLOYEES
 ORDER BY DEPARTMENT_ID DESC -- 1차 정렬
 	 , FIRST_NAME ASC -- 2차 정렬 부서번호로 정렬된 데이터 중에서 이름으로 다시 정렬시킨다.
;

-- 73. [2025-02-28 HW] 부서명별 연봉의 합을 내림차순 정렬하여 조회한다.
SELECT D.DEPARTMENT_NAME
     , SUM(E.SALARY) AS SALARY_SUM
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 GROUP BY D.DEPARTMENT_NAME 
 ORDER BY SALARY_SUM DESC
;

-- 74. [2025-02-28 HW] 직무명별 사원의 수를 오름차순 정렬하여 조회한다.
SELECT J.JOB_TITLE
     , COUNT(E.EMPLOYEE_ID) AS EMP_COUNT
  FROM EMPLOYEES E
 INNER JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID
 GROUP BY J.JOB_TITLE 
 ORDER BY EMP_COUNT
;

-------------------------------------------------------------------------------------
-- 75. [2025-02-28 HW] 모든 사원들의 모든 정보를 조회한다. 단, 인센티브를 받는 사원은 "인센티브여부" 컬럼에 "Y"를, 아닌 경우 "N"으로 조회한다.
SELECT E.EMPLOYEE_ID
     , E.FIRST_NAME
     , E.LAST_NAME
     , E.EMAIL
     , E.PHONE_NUMBER
     , E.HIRE_DATE
     , E.JOB_ID
     , E.SALARY
     , E.COMMISSION_PCT
     , E.MANAGER_ID
     , E.DEPARTMENT_ID
     , CASE 
        WHEN E.COMMISSION_PCT IS NOT NULL THEN 'Y'
        ELSE 'N'
       END AS 인센티브여부
  FROM EMPLOYEES E 
;

-- 76. [2025-02-28 HW] 모든 사원들의 이름을 10자리로 맞추어 조회한다.
SELECT FIRST_NAME
     , CASE
	    WHEN LENGTH(FIRST_NAME) >= 10 THEN SUBSTR(FIRST_NAME, 1, 10)
	    ELSE LPAD(FIRST_NAME, 10, '-')
	   END AS LPAD_FIRST_NAME
  FROM EMPLOYEES 	   
;

-- 77. [2025-02-26] 2007년에 직무가 변경된 사원들의 현재 직무명, 부서명, 사원번호, 이름, 성을 조회한다.
-- START_DATE 부터 직무가 시작되었다는(변경된 직무 시작) 의미
-- END_DATE 까지 해당 직무를 수행했다는 의미
-- END_DATE + 1 부터 또 다른 직무로 변경되었다는 의미
SELECT DISTINCT J.JOB_TITLE
     , D.DEPARTMENT_NAME
     , E.EMPLOYEE_ID
     , E.FIRST_NAME
     , E.LAST_NAME
  FROM EMPLOYEES E
 INNER JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID -- 사원 + 직무
 INNER JOIN DEPARTMENTS D
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID -- 시원 + 직무 + 부서
 INNER JOIN JOB_HISTORY JH
    ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID -- 사원 + 직무변경이력 => 사원 + 직무 + 부서 + 직무변경이력
 WHERE (JH.START_DATE >= TO_DATE('2007-01-01', 'YYYY-MM-DD')
   AND JH.START_DATE < TO_DATE('2008-01-01', 'YYYY-MM-DD'))
    OR (JH.END_DATE =  TO_DATE('2006-12-31', 'YYYY-MM-DD')
   AND JH.END_DATE < TO_DATE('2008-01-01', 'YYYY-MM-DD'))
;

-- 78. [2025-02-25 - SUB QUERY] 직무별 최대연봉보다 더 많은 연봉을 받는 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
     , FIRST_NAME
     , LAST_NAME
     , EMAIL
     , PHONE_NUMBER
     , HIRE_DATE
     , JOB_ID
     , SALARY
     , COMMISSION_PCT
     , MANAGER_ID
     , DEPARTMENT_ID
  FROM EMPLOYEES EACH_EMP
 WHERE SALARY > (SELECT MAX_SALARY
 				   FROM JOBS
 				  WHERE JOBS.JOB_ID = EACH_EMP.JOB_ID)
; 

-- 79. [2025-02-28 HW] 사원들의 입사일자 중 이름, 성, 연도만 조회한다. (TO_CHAR)
SELECT FIRST_NAME 
     , LAST_NAME
     , TO_CHAR(HIRE_DATE, 'YYYY') AS HIRE_YEAR
  FROM EMPLOYEES
;

-- 80. [2025-02-28 HW] 사원들의 입사일자 중 이름, 성, 연도, 월 만 조회한다. (TO_CHAR)
SELECT FIRST_NAME 
     , LAST_NAME
     , TO_CHAR(HIRE_DATE, 'YYYY') AS HIRE_YEAR
     , TO_CHAR(HIRE_DATE, 'MM') AS HIRE_MONTH
  FROM EMPLOYEES
;

-- 81. [2025-02-28 HW] 100번 사원의 모든 부하직원을 계층조회한다. 단, LEVEL이 4인 사원은 제외한다. (CONNECT BY)
SELECT EMPLOYEE_ID
      , FIRST_NAME
      , LAST_NAME
      , MANAGER_ID
      , LEVEL
   FROM EMPLOYEES
  START WITH EMPLOYEE_ID = 100
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
    AND LEVEL != 4
;  

-- 82. [2025-02-27] 많은 연봉을 받는 10명을 조회한다. (INLINE VIEW - PAGINATION)
-- 연봉순으로 내림차순 정렬한다.
-- 정렬된 데이터에서 10개만 가져온다.
SELECT EMPLOYEE_ID
     , SALARY
  FROM (SELECT EMPLOYEE_ID
             , SALARY
          FROM EMPLOYEES
         ORDER BY SALARY DESC)
 WHERE ROWNUM <= 10
;

-- 83. [2025-02-28 HW] 가장 적은 연봉을 받는 사원의 상사명, 부서명을 조회한다. (SUB QUERY - JOIN)
SELECT M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
     , D.DEPARTMENT_NAME
     , E.SALARY
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN EMPLOYEES M
    ON E.MANAGER_ID = M.EMPLOYEE_ID
 WHERE E.SALARY = (SELECT MIN(SALARY) 
                     FROM EMPLOYEES)
;    

-- 더 좋은 코드
SELECT M.FIRST_NAME
     , D.DEPARTMENT_NAME
  FROM EMPLOYEES M
 INNER JOIN DEPARTMENTS D
    ON M.DEPARTMENT_ID = D.DEPARTMENT_ID
 WHERE M.EMPLOYEE_ID = (SELECT MANAGER_ID
                          FROM EMPLOYEES
                         WHERE SALARY = (SELECT MIN(SALARY)
                                           FROM EMPLOYEES))
;

-- 실무에서는 건수를 줄이는 것이 중요함
SELECT M.FIRST_NAME
     , D.DEPARTMENT_NAME
  FROM EMPLOYEES M
 INNER JOIN DEPARTMENTS D
    ON M.DEPARTMENT_ID = D.DEPARTMENT_ID
   AND M.EMPLOYEE_ID = (SELECT MANAGER_ID
                          FROM EMPLOYEES
                         WHERE SALARY = (SELECT MIN(SALARY)
                                           FROM EMPLOYEES))
;

-- 84. [2025-02-27] 많은 연봉을 받는 사원 중 11번 째 부터 20번째를 조회한다. (INLINE VIEW- PAGINATION)
 /*
 * ROWNUM이 만들어지는 조건
 * SELECT ~ FROM ~ WHERE ~ ...
 * FETCH 과정을 거쳐야 ROWNUM이 만들어진다.
 */

SELECT EMPLOYEE_ID
     , SALARY
  FROM (SELECT EMPLOYEE_ID
             , SALARY
          FROM EMPLOYEES
         ORDER BY SALARY DESC)
 WHERE ROWNUM <= 20
;

-- 맞는 코드
SELECT EMPLOYEE_ID
     , SALARY
  FROM (SELECT EMPLOYEE_ID
             , SALARY
             , ROWNUM AS RNUM
           FROM (SELECT EMPLOYEE_ID
                      , SALARY
                   FROM EMPLOYEES
                  ORDER BY SALARY)
          WHERE ROWNUM <= 20)
 WHERE RNUM > 10
;

SELECT EMPLOYEE_ID
     , SALARY
  FROM (SELECT EMPLOYEE_ID
             , SALARY
             , ROWNUM AS RNUM
           FROM (SELECT EMPLOYEE_ID
                      , SALARY
                   FROM EMPLOYEES
                  ORDER BY SALARY)
          WHERE ROWNUM <= 20) X
 WHERE X.RNUM > 10
;

-- 맞는 코드, 정렬되기 전에 출력 됨
SELECT EMPLOYEE_ID
     , SALARY
  FROM (SELECT EMPLOYEE_ID
             , SALARY
             , ROWNUM AS RNUM
          FROM EMPLOYEES
         ORDER BY SALARY DESC)
 WHERE RNUM > 10
   AND RNUM <= 20
;

-- 틀린 코드
SELECT EMPLOYEE_ID
     , SALARY
  FROM (SELECT EMPLOYEE_ID
             , SALARY
          FROM EMPLOYEES
         ORDER BY SALARY DESC)
 WHERE ROWNUM > 10
   AND ROWNUM <= 20
;

-- 85. [2025-02-27]가장 적은 연봉을 받는 중 90번 째 부터 100번째를 조회한다. (INLINE VIEW - PAGINATION)
SELECT EMPLOYEE_ID
     , SALARY
     , RNUM
  FROM (SELECT EMPLOYEE_ID 
             , SALARY
             , ROWNUM AS RNUM
          FROM (SELECT EMPLOYEE_ID
                     , SALARY
                  FROM EMPLOYEES
                 ORDER BY SALARY
                     , EMPLOYEE_ID)
 		 WHERE ROWNUM <= 100) 
 WHERE RNUM >= 90
;

-- INLINE VIEW를 한 번 쓰는 방법
SELECT EMPLOYEE_ID
     , SALARY
     , RNUM
  FROM (SELECT -- ROWNUM을 SALARY를 기준으로 미리 생성한다.
               ROW_NUMBER() OVER(ORDER BY SALARY ASC) AS RNUM
             , EMPLOYEE_ID
             , SALARY
          FROM EMPLOYEES)
 WHERE RNUM >= 90
   AND RNUM <= 100
;

-- 86. [2025-02-27] 'PU_CLERK' 직무인 2번째 부터 5번째 사원의 부서명, 직무명을 조회한다. (INLINE VIEW - PAGINATION)
SELECT RNUM
     , DEPARTMENT_NAME
     , JOB_TITLE
  FROM (SELECT DEPARTMENT_NAME
             , JOB_TITLE
             , ROWNUM AS RNUM
          FROM (SELECT DEPARTMENT_NAME
                     , JOB_TITLE
                  FROM EMPLOYEES E
                 INNER JOIN DEPARTMENTS D
                    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
                 INNER JOIN JOBS J
                    ON E.JOB_iD = J. JOB_ID
                 WHERE E.JOB_ID = 'PU_CLERK'
                 ORDER BY E.EMPLOYEE_ID) 
         WHERE ROWNUM <= 5)
 WHERE RNUM >= 2;
; 

-- 87. [2025-02-25] 모든 사원의 정보를 직무 오름차순, 연봉 내림차순으로 조회한다.
SELECT *
  FROM EMPLOYEES
  ORTHER BY JOB_ID
  ,SALARY DESC
;

-- 88. [2025-02-25] 직무별 평균연봉을 평균연봉순으로 오름차순 정렬하여 조회한다.
SELECT JOB_ID 
     , AVG(SALARY) AS AVG_SALARY
  FROM EMPLOYEES
 GROUP BY JOB_ID
 ORDER BY AVG_SALARY ASC
;

-- 89. [2025-02-25] 부서번호별 평균연봉을 내림차순 정렬하여 조회한다.
SELECT DEPARTMENT_ID
     , AVG(SALARY) AS AVG_SALARY
  FROM EMPLOYEES
 GROUP BY DEPARTMENT_ID
 ORTHER BY AVG_SALARY DESC
;

-- 90. [2025-02-28 HW] 이름의 첫 번째 글자별 평균연봉을 조회한다. (SUBSTR, INLINEVIEW, GROUP BY)
SELECT FIRST_NAME_LETTER
     , AVG(SALARY) AS AVG_SALARY
  FROM (SELECT SUBSTR(FIRST_NAME, 1, 1) AS FIRST_NAME_LETTER
             , SALARY
         FROM EMPLOYEES)
 GROUP BY FIRST_NAME_LETTER 
;

-- 91. [2025-02-27] 입사연도별 최소연봉을 조회한다. (INLINE VIEW, TO_CHAR, GROUP BY)
SELECT TO_CHAR(HIRE_DATE, 'YYYY')
     , MIN(SALARY)
  FROM EMPLOYEES
 GROUP BY TO_CHAR(HIRE_DATE, 'YYYY')
;

-- INLINE VIEW
SELECT HIRE_YEAR
     , MIN(SALARY)
  FROM (SELECT TO_CHAR(HIRE_DATE, 'YYYY') AS HIRE_YEAR -- 입사 연도만 가지고 있음
             , SALARY
          FROM EMPLOYEES)
 GROUP BY HIRE_YEAR 
;

-- 92. [2025-02-28 HW] 월별 최대연봉 중 2번째 부터 4번째 데이터만 조회한다. (INLINE VIEW, TO_CHAR, PAGINATION)
SELECT HIRE_MONTH
     , MAX_SALARY
  FROM (SELECT HIRE_MONTH 
             , MAX_SALARY
             , ROWNUM AS RNUM
          FROM (SELECT TO_CHAR(HIRE_DATE, 'MM') AS HIRE_MONTH
                     , MAX(SALARY) AS MAX_SALARY
                  FROM EMPLOYEES
                 GROUP BY TO_CHAR(HIRE_DATE, 'MM')
                 ORDER BY MAX_SALARY DESC)
          WHERE ROWNUM <= 4)
 WHERE RNUM >= 2
;          

SELECT HIRE_MONTH
     , MAX_SALARY
  FROM (SELECT HIRE_MONTH 
             , MAX_SALARY
             , ROWNUM AS RNUM
          FROM (SELECT HIRE_MONTH
                     , MAX(SALARY) AS MAX_SALARY
                  FROM (SELECT TO_CHAR(HIRE_DATE, 'MM') HIRE_MONTH
                             , SALARY
                          FROM EMPLOYEES)
                 GROUP BY HIRE_MONTH 
                 ORDER BY MAX_SALARY DESC)
          WHERE ROWNUM <= 4)
 WHERE RNUM >= 2
;

-- 93. [2025-02-28 HW] 직무명별 최소연봉을 조회한다. (GROUP BY)
SELECT J.JOB_TITLE
     , MIN(E.SALARY) AS MIN_SALARY
  FROM EMPLOYEES E
 INNER JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID
 GROUP BY JOB_TITLE
 ;   

-- 94. [2025-02-28 HW] 부서명별 최대연봉을 조회한다. (GROUP BY)
SELECT D.DEPARTMENT_NAME
     , MAX(E.SALARY) AS MAX_SALARY
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 GROUP BY DEPARTMENT_NAME
;   

-- 95. [2025-02-27] 직무명, 부서명 별 사원 수, 평균연봉을 조회한다. (GROUP BY)
SELECT J.JOB_TITLE
     , D.DEPARTMENT_NAME
     , COUNT(E.EMPLOYEE_ID)
     , AVG(E.SALARY)
  FROM JOBS J
 INNER JOIN EMPLOYEES E
    ON J.JOB_ID = E.JOB_ID
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID  = D.DEPARTMENT_ID
 GROUP BY J.JOB_TITLE
     , D.DEPARTMENT_NAME
;

-- 96. [2025-02-27] 도시별 사원 수를 조회한다. (GROUP BY - INLINE VIEW)
-- 지역 아이디별 사원의 수 (DEPARTMENTS, EMPLOYEES)
-- 지역 - 지역 아이디별 사원의 수 조인 합계
--	도시명 별
SELECT L.CITY
     , D_E_CNT.EMP_CNT
  FROM LOCATIONS L
 INNER JOIN(SELECT D.LOCATION_ID
                 , COUNT(E.EMPLOYEE_ID) AS EMP_CNT
              FROM DEPARTMENTS D
             INNER JOIN EMPLOYEES E
                ON D.DEPARTMENT_ID = E.DEPARTMENT_ID 
             GROUP BY D.LOCATION_ID) D_E_CNT
    ON L.LOCATION_ID  = D_E_CNT.LOCATION_ID
;

-- 97. [2025-02-27] 국가별 사원 수, 최대연봉, 최소연봉을 조회한다. (GROUP BY - INLINE VIEW)
-- 1. 지역아이디별 사원의 수, 최대 연봉, 최소 연봉을 구한다. (DEPARTMENTS, EMPLOYEES) -> 뷰 이름: DEPT_EMP
-- 2. 국가아이디별 사원의 수, 최대 연봉, 최소 연봉을 구한다. (LOCATIONS, DEPT_EMP) -> 뷰 이름: DEPT_LOC
-- 3. 국가명 별 사원의 수, 최대 연봉, 최소 연봉을 구한다. (COUNTRIES, DEPT_LOC) -> 결과
SELECT C.COUNTRY_NAME
     , DEPT_LOC.EMP_CNT
     , DEPT_LOC.MAX_SAL
     , DEPT_LOC.MIN_SAL
  FROM COUNTRIES C
 INNER JOIN (SELECT L.COUNTRY_ID
     			  , SUM(DEPT_EMP.EMP_CNT) AS EMP_CNT
     			  , MAX(DEPT_EMP.MAX_SAL) AS MAX_SAL
   				  , MIN(DEPT_EMP.MIN_SAL) AS MIN_SAL
  			   FROM LOCATIONS L
 		      INNER JOIN(SELECT D.LOCATION_ID
     			 			  , COUNT(E.EMPLOYEE_ID) AS EMP_CNT
     			 			  , MAX(E.SALARY) AS MAX_SAL
     			 			  , MIN(E.SALARY) AS MIN_SAL
     		  			   FROM DEPARTMENTS D
 			 			  INNER JOIN EMPLOYEES E
    						 ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
 			 			  GROUP BY D.LOCATION_ID) DEPT_EMP
    			ON L.LOCATION_ID = DEPT_EMP.LOCATION_ID
 			 GROUP BY L.COUNTRY_ID) DEPT_LOC
    ON C.COUNTRY_ID = DEPT_LOC.COUNTRY_ID
;

-- 98. [2025-02-28 HW] 대륙별 사원 수를 대륙명으로 오름차순 정렬하여 조회한다. (GROUP BY - INLINE VIEW)
SELECT REGION_NAME
     , EMP_CNT
  FROM (SELECT R.REGION_NAME
             , COUNT(E.EMPLOYEE_ID) AS EMP_CNT
          FROM EMPLOYEES E
         INNER JOIN DEPARTMENTS D
            ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
         INNER JOIN LOCATIONS L
            ON D.LOCATION_ID = L.LOCATION_ID 
         INNER JOIN COUNTRIES C
            ON L.COUNTRY_ID = C.COUNTRY_ID 
         INNER JOIN REGIONS R
            ON C.REGION_ID = R.REGION_ID 
         GROUP BY R.REGION_NAME)
  ORDER BY REGION_NAME
;   

-- 99. [2025-02-24] 이름이나 성에 'A' 혹은 'a' 가 포함된 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY
	 , COMMISSION_PCT 
	 , MANAGER_ID 
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
  WHERE FIRST_NAME LIKE '%A%'
  	 OR FIRST_NAME LIKE '%a%'
  	 OR	LAST_NAME  LIKE '%A%'
  	 OR LAST_NAME  LIKE '%a%'
;

-- 100. [2025-02-28 HW] 국가별로 연봉이 5000 이상인 사원의 수를 조회한다.
SELECT C.COUNTRY_NAME
     , COUNT(E.EMPLOYEE_ID) AS EMP_CNT
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
 INNER JOIN COUNTRIES C
    ON L.COUNTRY_ID = C.COUNTRY_ID
 WHERE E.SALARY >= 5000
 GROUP BY C.COUNTRY_NAME  
;

-- 101. [2025-02-25 - SUB QUERY]인센티브를 안받는 사원이 근무하는 도시를 조회한다.
SELECT DISTINCT DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE COMMISSION_PCT IS NULL
;

SELECT LOCATION_ID
  FROM DEPARTMENTS
 WHERE DEPARTMENT_ID IN (SELECT DISTINCT DEPARTMENT_ID
                           FROM EMPLOYEES
                          WHERE COMMISSION_PCT IS NULL)
;

-- 인센티브를 받지 않는 사원이 속한 부서 ID -> 찾은 부서 ID에 해당하는 부서 위치 -> 해당 위치의 도시 조회
SELECT CITY
  FROM LOCATIONS
 WHERE LOCATION_ID IN (SELECT LOCATION_ID
                         FROM DEPARTMENTS
                        WHERE DEPARTMENT_ID IN (SELECT DISTINCT DEPARTMENT_ID
                                                  FROM EMPLOYEES
                                                 WHERE COMMISSION_PCT IS NULL))
;

-- 102. 인센티브를 포함한 연봉이 10000 이상인 사원의 모든 정보를 조회한다.
-- 103. 가장 많은 부서가 있는 도시를 조회한다.
-- 104. 가장 많은 사원이 있는 부서의 국가명을 조회한다.

-- 105. [2025-02-26] 우편번호가 5자리인 도시에서 근무하는 사원명, 부서명, 도시명, 우편번호를 조회한다.
SELECT E.FIRST_NAME
     , D.DEPARTMENT_NAME 
     , L.CITY
     , L.POSTAL_CODE
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
 WHERE L.POSTAL_CODE LIKE '_____'
;

-- 106. [2025-02-26] 우편번호에 공백이 없는 도시에서 근무하는 사원의 이름, 부서명, 우편번호를 조회한다.
SELECT E.FIRST_NAME
     , D.DEPARTMENT_NAME
     , L.POSTAL_CODE
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
  WHERE L.POSTAL_CODE NOT LIKE '% %'
;

-- 107. [2025-02-26] "주"가 없는 도시에서 근무하는 사원의 이름, 도시를 조회한다.
SELECT E.FIRST_NAME
     , L.CITY
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
 WHERE STATE_PROVINCE IS NULL 
;

-- 108. [2025-02-24] 국가명이 6자리인 국가의 모든 정보를 조회한다.
SELECT COUNTRY_ID
	 , COUNTRY_NAME
	 , REGION_ID 
  FROM COUNTRIES
 WHERE COUNTRY_NAME
  LIKE '______'
;

-- 109. [2025-02-28]사원의 이름과 성을 이용해 EMAIL과 같은 값으로 만들어 조회한다.
/*
 * FIRST_NAME + LAST_NAME을 7자리까지 잘라 대문자로 바꾸고 공백을 제거한 글자 
 */
SELECT FIRST_NAME || LAST_NAME 
     , CONCAT(FIRST_NAME, LAST_NAME)
     , SUBSTR(FIRST_NAME, 1, 1)
     , SUBSTR(LAST_NAME, 1, 7)
     , REPLACE(LAST_NAME, ' ', '')
     , SUBSTR(REPLACE(LAST_NAME, ' ', ''), 1, 7)
     , UPPER(SUBSTR(REPLACE(LAST_NAME, ' ', ''), 1, 7))
     , SUBSTR(FIRST_NAME, 1, 1) || UPPER(SUBSTR(REPLACE(LAST_NAME, ' ', ''), 1, 7))
  FROM EMPLOYEES
 ORDER BY EMPLOYEE_ID
;

-- 110. [2025-02-28]모든 사원들의 이름을 10자리로 변환해 조회한다. 예> 이름 => "        이름"
SELECT FIRST_NAME
     , LENGTH(FIRST_NAME)
     , LPAD(FIRST_NAME, 10, '_') -- PK값 만들 때 사용, LPAD(), ||, TO_CHAR() 등이 사용됨
     , LENGTH(LPAD(FIRST_NAME, 10, '_'))
  FROM EMPLOYEES
 ORDER BY EMPLOYEE_ID
;

-- 111. 모든 사원들의 성을 10자리로 변환해 조회한다. 예> 성 => "성         "

-- 112. [2025-02-25 - SUB QUERY] 109번 사원의 입사일 부터 1년 내에 입사한 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID -- 02.08.16
	 , HIRE_DATE 
  FROM EMPLOYEES 
 WHERE EMPLOYEE_ID = 109 
;

SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY
	 , COMMISSION_PCT 
	 , MANAGER_ID 
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE HIRE_DATE >= (SELECT HIRE_DATE
                             FROM EMPLOYEES
                            WHERE EMPLOYEE_ID = 109)
   AND HIRE_DATE < (SELECT HIRE_DATE 
                      FROM EMPLOYEES
                     WHERE  EMPLOYEE_ID = 109) + 365
;

-- 113. [2025-02-25 - SUB QUERY] 가장 먼저 입사한 사원의 입사일로부터 2년 내에 입사한사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY
	 , COMMISSION_PCT 
	 , MANAGER_ID 
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE HIRE_DATE >= (SELECT MIN(HIRE_DATE)
                      FROM EMPLOYEES) 
  AND HIRE_DATE < (SELECT MIN(HIRE_DATE) + 730
 FROM EMPLOYEES) 
;

-- 114. [2025-02-25 - SUB QUERY] 가장 늦게 입사한 사원의 입사일 보다 1년 앞서 입사한 사원의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY
	 , COMMISSION_PCT 
	 , MANAGER_ID 
	 , DEPARTMENT_ID 
  FROM EMPLOYEES
 WHERE HIRE_DATE <= (SELECT MAX(HIRE_DATE)
                      FROM EMPLOYEES) 
   AND HIRE_DATE > (SELECT MAX(HIRE_DATE) - 365
  FROM EMPLOYEES) 
;

-- 115. [2025-02-26]  도시명에 띄어쓰기 " " 가 포함된 도시에서 근무중인 사원들의 부서명, 도시명, 사원명을 조회한다.
SELECT E.FIRST_NAME
     , D.DEPARTMENT_NAME
     , L.CITY
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
 WHERE L.CITY LIKE '% %'
;

-- 116. [2025-02-28]MOD 함수를 통해 사원번호가 홀수면 남자, 짝수면 여자 로 구분해 조회한다. MOD(값, 나눌값) (CASE WHEN ELSE END, DECODE)
SELECT CASE 
        WHEN 1 = 1 THEN '홀수 입니다.'
        ELSE '짝수 입니다.'
       END
  FROM DUAL 
;

SELECT EMPLOYEE_ID
     , MOD(EMPLOYEE_ID, 2) -- 오라클 함수
     , CASE MOD(EMPLOYEE_ID, 2)
        WHEN 1 THEN '남'
        WHEN 0 THEN '여'
       END -- CASE WHEN THEN END - ANSI SQL(표준 SQL)
     , DECODE(  MOD(EMPLOYEE_ID, 2), 1, '남', 0, '여' ) -- 오라클 함수
  FROM EMPLOYEES
;

-- 117. '20230222' 문자 데이터를 날짜로 변환해 조회한다.(DUAL)
-- 118. '20230222' 문자 데이터를 'YYYY-MM' 으로 변환해 조회한다.(DUAL)
-- 119. '20230222130140' 문자 데이터를 'YYYY-MM-DD HH24:MI:SS' 으로 변환해 조회한다. (DUAL)
-- 120. '20230222' 날짜의 열흘 후의 날짜를 'YYYY-MM-DD' 으로 변환해 조회한다. (DUAL)
-- 121. 사원 이름의 글자수 별 사원의 수를 조회한다.
-- 122. 사원 성의 글자수 별 사원의 수를 조회한다.

-- 123. [2025-02-28] 사원의 연봉이 5000 이하이면 "사원", 7000 이하이면 "대리", 9000 이하이면 "과장", 그 외에는 임원 으로 조회한다. (CASE WHEN ELSE END)
SELECT SALARY
     , CASE
        WHEN SALARY <= 5000 THEN '사원'
        WHEN SALARY <= 7000 THEN '대리'
        WHEN SALARY <= 9000 THEN '과장'
        ELSE '임원'
       END AS POSITION
  FROM EMPLOYEES
 ORDER BY SALARY DESC
;

-- 124. 부서별 사원의 수를 조인을 이용해 다음과 같이 조회한다."부서명 (사원의 수)"

-- 125. [2025-02-28] 부서별 사원의 수를 스칼라쿼리를 이용해 다음과 같이 조회한다. "부서명 (사원의 수)"
/*
 * SELECT ( SELECT FROM WHERE ) -- SCALA QUERY (규칙! 결과가 반드시 단일 행 + 단일 열로만 나와야 함)
 * FROM ( SELECT FROM WHERE ) -- INLINE VIEW
 * WHERE COL = ( SELECT FROM WHERE ) -- SUB QUERY
 */
SELECT DEPARTMENT_NAME || '(' || (SELECT COUNT(EMPLOYEE_ID)
                                    FROM EMPLOYEES E
                                   WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID ) || ')'
  FROM DEPARTMENTS D
 ORDER BY DEPARTMENT_ID
;

-- 126. 사원의 정보를 다음과 같이 조회한다. "사원번호 번 사원의 이름은 성이름 입니다."
-- 127. 사원의 정보를 스칼라쿼리를 이용해 다음과 같이 조회한다. "사원번호 번 사원의 상사명은 상사명 입니다."
-- 128. 사원의 정보를 조인을 이용해 다음고 같이 조회한다. "사원명 (직무명)"
-- 129. 사원의 정보를 스칼라쿼리를 이용해 다음과 같이 조회한다. "사원명 (직무명)"
-- 130. 부서별 연봉 차이(최고연봉 - 최저연봉)가 가장 큰 부서명을 조회한다.
-- 131. 부서별 연봉 차이(최고연봉 - 최저연봉)가 가장 큰 부서에서 근무하는 사원들의 직무명을 중복없이 조회한다.
-- 132. 부서장이 없는 부서명 중 첫 글자가 'C' 로 시작하는 부서명을 조회한다.
-- 133. 부서장이 있는 부서명 중 첫 글자가 'S' 로 시작하는 부서에서 근무중인 사원의 이름과 직무명, 부서명을 조회한다.
-- 134. 지역변호가 1000 ~ 1999 사이인 지역내 부서의 모든 정보를 조회한다.

-- 135. [2025-02-26] 90, 60, 100번 부서에서 근무중인 사원의 이름, 성, 부서명을 조회한다.
SELECT E.FIRST_NAME
     , E.LAST_NAME
     , D.DEPARTMENT_NAME
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 WHERE D.DEPARTMENT_ID IN (90, 60, 100)
;

-- 136. [2025-02-26] 부서명이 5글자 미만인 부서에서 근무중인 사원의 이름, 부서명을 조회한다.
SELECT E.FIRST_NAME
     , D.DEPARTMENT_NAME
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 WHERE D.DEPARTMENT_NAME LIKE '____'
    OR D.DEPARTMENT_NAME LIKE '___'
    OR D.DEPARTMENT_NAME LIKE '__'
    OR D.DEPARTMENT_NAME LIKE '_'
;    

-- 137. [2025-02-27] 국가 아이디가 'C'로 시작하는 국가의 지역을 모두 조회한다. (SUBSTR, LIKE)
-- 모든 국가의 아이디 중 첫 번째 글자만 조회한다.
SELECT COUNTRY_ID
     , SUBSTR(COUNTRY_ID, 1, 1) -- COUNTRY_ID에서 첫 번째 부터 한개만 가져와라
     , SUBSTR(COUNTRY_ID, 2, 1) -- COUNTRY_ID에서 두 번째 부터 한개만 가져와라
     , SUBSTR(COUNTRY_ID, 1, 2) -- COUNTRY_ID에서 첫 번째 부터 두개만 가져와라
  FROM COUNTRIES
;

SELECT COUNTRY_ID
     , COUNTRY_NAME
     , REGION_ID
  FROM COUNTRIES
 WHERE SUBSTR(COUNTRY_ID, 1, 1) = 'C' -- INDEX(FULL SCAN) - CPU 15,871
;

SELECT COUNTRY_ID
     , COUNTRY_NAME
     , REGION_ID
  FROM COUNTRIES
 WHERE COUNTRY_ID LIKE 'C%' -- INDEX(RANGE SCAN) - CPU 7,521
;

SELECT COUNTRY_ID
      , COUNTRY_NAME
      , REGION_ID
   FROM COUNTRIES
  WHERE COUNTRY_ID = 'C' -- INDEX(UNIQUE SCAN) - CPU 1,050
;  

SELECT COUNTRY_ID
     , COUNTRY_NAME
     , REGION_ID
     , F_C_I
  FROM (SELECT COUNTRY_ID
             , COUNTRY_NAME
             , REGION_ID
             , SUBSTR(COUNTRY_ID, 1, 1) AS F_C_I
          FROM COUNTRIES)
 WHERE F_C_I = 'C'
;

-- 138. [2025-02-27] 국가 아이디의 첫 글자와 국가명의 첫 글자가 다른 모든 국가를 조회한다. (SUBSTR, INLINE VIEW)
SELECT COUNTRY_ID
     , COUNTRY_NAME
     , REGION_ID
     , F_C_I
     , F_C_N
  FROM (SELECT COUNTRY_ID
             , COUNTRY_NAME
             , REGION_ID
             , SUBSTR(COUNTRY_ID, 1, 1) AS F_C_I
             , SUBSTR(COUNTRY_NAME, 1, 1) AS F_C_N
          FROM COUNTRIES)
 WHERE F_C_I != F_C_N 
;

-- 139. 사원 모든 정보 중 이메일만 모두 소문자로 변경하여 조회한다.
-- 140. 사원의 연봉을 TRUNC(소수점 버림) 함수를 사용해 100 단위는 버린채 다음과 같이 조회한다. 예> 3700 -> 3000, 12700 -> 12000
-- 141. 100단위를 버린 사원의 연봉 별 사원의 수를 조회한다.
-- 142. 현재 시간으로부터 20년 전 보다 일찍 입사한 사원의 모든 정보를 조회한다.
-- 143. 부서번호별 현재 시간으로부터 15년 전 보다 일찍 입사한 사원의 수를 조회한다.
-- 144. 부서명, 직무명 별 평균 연봉을 조회한다.
-- 145. 도시명, 지역명 별 사원의 수를 조회한다.
-- 146. 부서명, 직무명 별 평균 연봉 중 가장 작은 평균연봉을 받는 부서명, 직무명을 조회한다.
-- 147. 102번 직원의 모든 부하직원의 수를 조회한다. (INLINE VIEW - START WITH CONNECT BY PRIOR)
-- 148. 113번 직원의 모든 부하직원의 수를 조회한다. (INLINE VIEW - START WITH CONNECT BY PRIOR)
-- 149. 부하직원이 없는 사원의 모든 정보를 조회한다. (SUBQUERY)

-- 150. [2025-02-28] 사원번호가 100번인 사원의 사원번호, 이름과 사원번호로 내림차순 정렬된 사원의 사원번호, 이름 조회한다. (UNION ALL)
--		(UNION ALL) - RESULT(SELECT ~)와 REUSLT(SELECT ~)간의 합집합
SELECT EMPLOYEE_ID -- NUMBER(6,0)
     , FIRST_NAME -- VARCHAR2(20)
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID = 100
 UNION ALL
SELECT EMPLOYEE_ID -- NUMBER(6,0)
     , FIRST_NAME -- VARCHAR2(20) 순서가 안맞으면 "대응하는 식과 같은 데이터 유형이어야 합니다" 에러 발생!
  FROM (SELECT EMPLOYEE_ID
             , FIRST_NAME
  		  FROM EMPLOYEES
 		 WHERE EMPLOYEE_ID != 100
 		 ORDER BY EMPLOYEE_ID DESC) 
;

/*조회 예
--------------------
100    Steven
206    William
205    Shelley
204    Hermann
203    Susan
202    Pat
201    Michael
200    Jennifer
199    Douglas
198    Donald
197    Kevin
196    Alana
...
*/

-- 151. 모든 사원의 모든 정보를 조회한다.
-- 152. 부서가 없는 사원의 모든 정보를 조회한다.
-- 153. 직무가 없는 사원의 모든 정보를 조회한다.
-- 154. 부서와 직무가 모두 있는 사원의 모든 정보를 조회한다.
-- 155. 부서장이 없는 모든 부서의 모든 정보를 조회한다.
-- 156. 부서장이 있는 모든 부서의 모든 정보를 조회한다.
-- 157. 부서장의 모든 사원 정보를 조회한다.
-- 158. 사원의 이름만 조회한다.
-- 159. 사원의 이름이 7자리인 사원의 모든 정보를 조회한다.
-- 160. 사원의 이메일이 6자리인 사원의 모든 정보를 조회한다.
-- 161. 모든 지역의 모든 정보를 조회한다.
-- 162. 지역이 없는 모든 부서의 정보를 조회한다.
-- 163. 지역이 있는 모든 부서의 정보와 도시 정보를 조회한다.
-- 164. 모든 사원의 모든 정보와 부서명을 조회한다.

-- 165. [2025-02-26] 111번 사원의 모든 정보와 부서명을 조회한다.
SELECT E.EMPLOYEE_ID
	 , E.FIRST_NAME 
	 , E.LAST_NAME 
	 , E.EMAIL 
	 , E.PHONE_NUMBER 
	 , E.HIRE_DATE 
	 , E.JOB_ID 
	 , E.SALARY
	 , E.COMMISSION_PCT 
	 , E.MANAGER_ID 
	 , E.DEPARTMENT_ID
	 , D.DEPARTMENT_NAME
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 WHERE E.EMPLOYEE_ID = 111
;

-- 166. [2025-02-26] 115번의 사원의 모든 정보와 부서명, 직무명을 조회한다.
SELECT E.EMPLOYEE_ID
	 , E.FIRST_NAME 
	 , E.LAST_NAME 
	 , E.EMAIL 
	 , E.PHONE_NUMBER 
	 , E.HIRE_DATE 
	 , E.JOB_ID 
	 , E.SALARY
	 , E.COMMISSION_PCT 
	 , E.MANAGER_ID 
	 , E.DEPARTMENT_ID
	 , D.DEPARTMENT_NAME
	 , J.JOB_TITLE
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID
 WHERE E.EMPLOYEE_ID = 115
;

-- 167. [2025-02-26] 100번 사원의 모든 정보와 부서명, 직무명, 도시명을 조회한다.
SELECT E.EMPLOYEE_ID
	 , E.FIRST_NAME 
	 , E.LAST_NAME 
	 , E.EMAIL 
	 , E.PHONE_NUMBER 
	 , E.HIRE_DATE 
	 , E.JOB_ID 
	 , E.SALARY
	 , E.COMMISSION_PCT 
	 , E.MANAGER_ID 
	 , E.DEPARTMENT_ID
	 , D.DEPARTMENT_NAME
	 , J.JOB_TITLE
	 , L.CITY
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
 INNER JOIN LOCATIONS L
    ON D.LOCATION_ID = L.LOCATION_ID
 INNER JOIN JOBS J
    ON E.JOB_ID = J.JOB_ID
 WHERE E.EMPLOYEE_ID = 100
;

-- 168. 부서아이디별 사원의 평균연봉을 조회한다.
-- 169. 직무아이디별 사원의 최고연봉을 조회한다.
-- 170. 부서명별 사원의 수를 조회한다.
-- 171. 직무명별 사원의 평균연봉을 조회한다.
-- 172. 부서명, 직무명별 사원의 수와 평균연봉을 조회한다.
-- 173. 인센티브를 안받는 사원의 모든 정보를 조회한다.
-- 174. 인센티브를 받는 사원의 부서아이디를 중복없이 조회한다.
-- 175. 인센티브를 받는 사원의 직무아이디를 중복없이 조회한다.
-- 176. 사원이 있는 부서의 지역아이디를 조회한다.
-- 177. 사원이 없는 부서의 부서명을 조회한다.
-- 178. 지역별 부서의 수를 조회한다. (부서가 없으면 부서의 수는 0으로 조회한다.)
-- 179. 지역별 사원의 평균연봉을 조회한다. (사원이 없으면 평균연봉은 0으로 조회한다.)

-- 180. [2025-02-25 - SUB QUERY] Seattle의 부서 아이디를 조회한다.
SELECT LOCATION_ID
  FROM LOCATIONS
 WHERE CITY = 'Seattle'
; 

SELECT DEPARTMENT_ID
  FROM DEPARTMENTS
 WHERE LOCATION_ID IN (SELECT LOCATION_ID
                         FROM LOCATIONS
                        WHERE CITY = 'Seattle')
; 

-- 181. [2025-02-25 - SUB QUERY] Seattle에서 근무중인 사원의 모든 직무명을 중복없이 조회한다.
-- 1. Seattle의 지역번호가 무엇인가?
SELECT LOCATION_ID -- 1700
  FROM LOCATIONS
 WHERE CITY = 'Seattle'
;
-- 2. 지역번호가 1700번인 부서의 번호는 무엇인가?
SELECT DEPARTMENT_ID -- 10, 30, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270
  FROM DEPARTMENTS
 WHERE LOCATION_ID = 1700
;
-- 3. 10, 30, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270
--	  이 부서에서 일을 하는 사원들의 직무 아이디는 무엇인가?
SELECT DISTINCT JOB_ID -- 'AD_PRES', 'AD_VP', 'FI_MGR', 'FI_ACCOUNT', 'PU_MAN', 'PU_CLERK', 'AD_ASST', 'AC_MGR', 'AC_ACCOUNT'
  FROM EMPLOYEES
 WHERE DEPARTMENT_ID IN (10, 30, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270) 
; 
-- 4. 'AD_PRES', 'AD_VP', 'FI_MGR', 'FI_ACCOUNT', 'PU_MAN', 'PU_CLERK', 'AD_ASST', 'AC_MGR', 'AC_ACCOUNT'
--    이 직무 아이디들의 직무 명은 무엇인가?
SELECT JOB_TITLE
  FROM JOBS
 WHERE JOB_ID IN ('AD_PRES', 'AD_VP', 'FI_MGR', 'FI_ACCOUNT', 'PU_MAN', 'PU_CLERK', 'AD_ASST', 'AC_MGR', 'AC_ACCOUNT')
; 
-- 하나의 QUERY로 만들기 --> 역순으로 조립하기
SELECT JOB_TITLE
  FROM JOBS
 WHERE JOB_ID IN (SELECT DISTINCT JOB_ID
  					FROM EMPLOYEES
				   WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
  											 FROM DEPARTMENTS
											WHERE LOCATION_ID = (SELECT LOCATION_ID
  																   FROM LOCATIONS
 																  WHERE CITY = 'Seattle')))
;

-- 182. 사원이 한명도 없는 도시를 조회한다.
-- 183. 사원이 한명이라도 있는 도시를 조회한다.
-- 184. 모든 사원의 정보를 연봉으로 오름차순 정렬하여 조회한다.
-- 185. 부서명별 평균연봉을 부서명으로 내림차순 정렬하여 조회한다.
-- 186. 부서명별 최고연봉을 최고연봉으로 오름차순 정렬하여 조회한다.
-- 187. 부서명이 가장 긴 부서에서 근무중인 사원의 모든 정보를 조회한다.
-- 188. 도시명 별 사원의 수를 도시명으로 오름차순 정렬하여 조회한다.
-- 189. 모든 사원의 사원번호, 이름, 성, 연봉, 인센티브를 포함한 연봉 정보를 조회한다.
-- 190. 매년 10%의 상여금을 받는다고 했을 때, 사원별로 현재까지 받은 상여금의 합과 사원번호, 연봉을 조회한다.

-- 191. [2025-02-25 - SUB QUERY] 직무가 변경되었던 사원들의 모든 정보를 조회한다.
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY
	 , COMMISSION_PCT 
	 , MANAGER_ID 
	 , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID IN (SELECT EMPLOYEE_ID
                         FROM JOB_HISTORY)
;

-- 192. 모든 사원들의 현재 직무명과 과거의 직무명을 조회한다. 만약 직무가 한번도 변경되지 않았다면, 과거의 직무명은 '없음' 으로 조회한다.

-- [2025-02-26] 변형문제
-- 직무가 변경되었던 사원들의 과거 직무명과 현재 직무명을 조회한다.
SELECT E.EMPLOYEE_ID 
     , JH.JOB_ID AS PAST_JOB_ID -- 과거 직무
     , E.JOB_ID AS PRESENT_JOB_ID -- 현재 직무
  FROM EMPLOYEES E
 INNER JOIN JOB_HISTORY JH
    ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID
; 

SELECT E.EMPLOYEE_ID 
     , JH.JOB_ID AS PAST_JOB_ID -- 과거 직무
     , E.JOB_ID AS PRESENT_JOB_ID -- 현재 직무
     , J.JOB_TITLE
  FROM EMPLOYEES E
 INNER JOIN JOB_HISTORY JH
    ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID
 INNER JOIN JOBS
    ON E.JOB_ID = J.JOB_ID
   AND JH.JOB_ID = J.JOB_ID
; 

SELECT E.EMPLOYEE_ID 
     , JH.JOB_ID AS PAST_JOB_ID -- 과거 직무
     , E.JOB_ID AS PRESENT_JOB_ID -- 현재 직무
     , PAST_J.JOB_TITLE AS PAST_JOB_TITLE -- 과거
     , PRESENT_J.JOB_TITLE AS PRESENT_JOB_TITLE -- 현재
  FROM EMPLOYEES E
 INNER JOIN JOB_HISTORY JH
    ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID
 INNER JOIN JOBS PAST_J
    ON E.JOB_ID = PAST_J.JOB_ID
 INNER JOIN JOBS PRESENT_J
    ON E.JOB_ID = PRESENT_J.JOB_ID
; 

-- 직무가 변경되었던 사원들의 과거 직무명과 현재 직무명을 조회한다.
SELECT E.EMPLOYEE_ID
     , E.DEPARTMENT_ID AS PRESENT_DEPARTMENT_ID
     , PRESENT_D.DEPARTMENT_NAME AS PRESENT_DEPARTMENT_NAME
     , JH.DEPARTMENT_ID AS PAST_DEPARTMENT_ID
     , PAST_D.DEPARTMENT_NAME AS PAST_DEPARTMENT_NAME
  FROM EMPLOYEES E
 INNER JOIN DEPARTMENTS PRESENT_D
    ON E.DEPARTMENT_ID = PRESENT_D.DEPARTMENT_ID
 INNER JOIN JOB_HISTORY JH
    ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID
 INNER JOIN DEPARTMENTS PAST_D
    ON PAST_D.DEPARTMENT_ID = JH.DEPARTMENT_ID
; 

-- 직무가 변경되었던 사원들의 과거 직무명, 과거 부서명과 현재 직무명, 현재 부서명을 조회한다. 
SELECT E.EMPLOYEE_ID 
     , E.JOB_ID
     , PRESENT_J.JOB_TITLE 
     , PRESENT_D.DEPARTMENT_NAME
     , JH.JOB_ID AS PAST_JOB_ID
     , PAST_J.JOB_TITLE AS PAST_JOB_TITLE
     , JH.DEPARTMENT_ID AS PAST_DEPARTMENT_ID
     , PAST_D.DEPARTMENT_NAME AS PAST_DEPARTMENT_NAME
  FROM EMPLOYEES E
 INNER JOIN JOBS PRESENT_J
    ON E.JOB_ID = PRESENT_J.JOB_ID
 INNER JOIN DEPARTMENTS PRESENT_D
    ON E.DEPARTMENT_ID = PRESENT_D.DEPARTMENT_ID
 INNER JOIN JOB_HISTORY JH
    ON E.EMPLOYEE_ID = JH.EMPLOYEE_ID
 INNER JOIN JOBS PAST_J
    ON JH.JOB_ID = PAST_J.JOB_ID
 INNER JOIN DEPARTMENTS PAST_D
    ON JH.DEPARTMENT_ID = PAST_D.DEPARTMENT_ID
;  

-- 193. 직무가 변경될 때마다 연봉이 15% 감소한다고 했을 때, 직무가 변경된 사원들의 감소된 연봉을 조회한다.
-- 194. 2003년에 입사한 사원은 몇 명인지 조회한다.
-- 195. 2002년부터 2006년까지 입사한 사원은 몇명인지 연도별로 조회한다.

-- 196. [2025-02-26] 113번 사원의 상사의 모든 정보를 조회한다.
-- JOIN
SELECT MANAGER_E.EMPLOYEE_ID AS MANAGER_EMPLOYEE_ID
	 , MANAGER_E.FIRST_NAME 
	 , MANAGER_E.LAST_NAME 
	 , MANAGER_E.EMAIL 
	 , MANAGER_E.PHONE_NUMBER 
	 , MANAGER_E.HIRE_DATE 
	 , MANAGER_E.JOB_ID 
	 , MANAGER_E.SALARY
	 , MANAGER_E.COMMISSION_PCT 
	 , MANAGER_E.MANAGER_ID 
	 , MANAGER_E.DEPARTMENT_ID
  FROM EMPLOYEES E
 INNER JOIN EMPLOYEES MANAGER_E
    ON E.MANAGER_ID = MANAGER_E.EMPLOYEE_ID
 WHERE E.EMPLOYEE_ID = 113 
;

-- SUB QUERY
SELECT EMPLOYEE_ID
	 , FIRST_NAME 
	 , LAST_NAME 
	 , EMAIL 
	 , PHONE_NUMBER 
	 , HIRE_DATE 
	 , JOB_ID 
	 , SALARY
	 , COMMISSION_PCT 
	 , MANAGER_ID 
	 , DEPARTMENT_ID
  FROM EMPLOYEES
 WHERE EMPLOYEE_ID = (SELECT MANAGER_ID
                        FROM EMPLOYEES
                       WHERE EMPLOYEE_ID = 113)
;

-- [2025-02-27] 계층형 쿼리 (위에서 아래로 흐르는 흐름)
-- ex) 쇼핑물의 카테고리, 메뉴, 댓글 표현, 조직도
 SELECT LEVEL 
      , EMPLOYEE_ID
      , MANAGER_ID
   FROM EMPLOYEES
  START WITH EMPLOYEE_ID = 206
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID 
;

-- 역계층 쿼리 (아래에서 위로 흐르는 흐름)
-- 206번의 모든 상사를 다 조회해라
 SELECT LEVEL
      , EMPLOYEE_ID
      , MANAGER_ID
   FROM EMPLOYEES
  START WITH EMPLOYEE_ID = 206
CONNECT BY PRIOR MANAGER_ID = EMPLOYEE_ID -- 206번의 상사번호는 누군가의 사원번호다.
  ORDER BY LEVEL DESC
  
-- 197. [2025-02-27]100번 사원의 모든 부하직원을 계층조회한다.
 SELECT LEVEL 
      , EMPLOYEE_ID 
	  , MANAGER_ID 
   FROM EMPLOYEES
  START WITH EMPLOYEE_ID = 100
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
;

-- 198. [2025-02-27] 113번 사원의 모든 상사를 계증조회한다.
 SELECT LEVEL 
      , EMPLOYEE_ID 
	  , MANAGER_ID 
   FROM EMPLOYEES
  START WITH EMPLOYEE_ID = 113
CONNECT BY PRIOR MANAGER_ID = EMPLOYEE_ID
  ORDER BY LEVEL DESC
;  

-- 199. [2025-02-27] IT 부서장의 모든 부하직원을 계층조회한다. START WITH에 SUB QUERY 이용
 SELECT LEVEL
      , E.*
   FROM EMPLOYEES E
  START WITH EMPLOYEE_ID IN (SELECT MANAGER_ID
                                  FROM DEPARTMENTS
                                 WHERE DEPARTMENT_NAME = 'IT')
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
;

-- 200. [2025-02-27] 모든 부서의 부서장들의 부하직원을 계층조회한다.
 SELECT LEVEL 
      , E.*
   FROM EMPLOYEES E
  START WITH DEPARTMENT_ID IN (SELECT MANAGER_ID
                                 FROM DEPARTMENTS
                                WHERE MANAGER_ID IS NOT NULL)
CONNECT BY PRIOR EMPLOYEE_ID = MANAGER_ID
;

SELECT D.DEPARTMENT_NAME
  FROM DEPARTMENTS D
 INNER JOIN EMPLOYEES E
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID 
 WHERE D.DEPARTMENT_ID NOT IN (SELECT DEPARTMENT_ID 
                                 FROM EMPLOYEES) 
;