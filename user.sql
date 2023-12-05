# 중복이메일 가입 회원 조회
select email,
       name
from user
where user.valid_yn is true
group by email
having count(email) > 1;


