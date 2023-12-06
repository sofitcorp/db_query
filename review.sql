# 리뷰 누락 개수 확인
select count(*)
from order_detail od
         left join review as r on od.id = r.order_detail_id
where od.status = 'CONFIRMED'
  and r.id is null;


# 리뷰 누락 수동 생성
# insert into review (created_at, product_id, status, user_id, user_name, order_detail_id)
#     (select now(), od.product_id, 'EMPTY', u.id, u.name, od.id
#      from order_detail od
#               left join review as r on od.id = r.order_detail_id
#               join user u on u.id = od.user_id
#      where od.status = 'CONFIRMED'
#        and r.id is null);