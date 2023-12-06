# 공구상품 주문 전체 조회
select created_at,
       count,
       history,
       status,
       product_id,
       product_option_ids,
       product_options,
       user_id,
       price,
       coupon_discount_price,
       coupon_id
from order_detail
where product_id in (7301, 4278, 6847, 2337, 7258, 7185)
  and created_at > '2023-11-29 23:30:30'
order by created_at desc;

select created_at,
       count,
       history,
       status,
       product_id,
       product_option_ids,
       product_options,
       user_id,
       price,
       coupon_discount_price,
       coupon_id
from order_detail
where product_id in (7301, 4278, 6847, 2337, 7258, 7185)
  and created_at > '2023-11-29 23:30:30'
  and status = 'INITIAL' or status = 'READY'
order by created_at desc;

select count(id)
from order_detail
where product_id in (7301, 4278, 6847, 2337, 7258, 7185)
  and created_at > '2023-11-29 23:30:30'
  and status = 'INITIAL' or status = 'READY'
order by created_at desc;

# 콩 필라테스 공구상품 주문 부분 조회
select created_at,
       count,
       history,
       status,
       product_id,
       product_option_ids,
       product_options,
       user_id,
       price,
       coupon_discount_price,
       coupon_id
from order_detail
where product_id in (7301, 4278, 6847, 2337, 7258, 7185)
  and product_option_ids = '121202,121217'
  and created_at > '2023-11-29 23:30:30'
order by created_at desc;

# 콩 필라테스 재고 차감 주문 // TODO: 전체주문 조회로 바꾸고, 조인해서 같은결과내기, with엿나? 그쿼리 해보기
select product_id,
       product_name,
       p.code,
       product_option_ids,
       product_options,
       count(product_option_ids) p_cnt,
       sum(count)                c_cnt
from order_detail od
         inner join product p on p.id = od.product_id
where product_id in (7301, 4278, 6847, 2337, 7258, 7185)
  and od.created_at > '2023-11-29 23:30:30'
  and history not like '%CLEARED%'
  and history not like 'FAILED'
group by product_id,
         product_option_ids
order by product_id, product_option_ids;

# 콩 필라테스 재고 회복 주문
select product_id,
       p.code,
       product_option_ids,
       product_options,
       count(product_option_ids) p_cnt,
       sum(count)                c_cnt
from order_detail od
         inner join product p on p.id = od.product_id
where product_id in (7301, 4278, 6847, 2337, 7258, 7185)
  and od.created_at > '2023-11-29 23:30:30'
  and (history like '%CLEARED%' or history like 'FAILED')
group by product_id, product_option_ids
order by product_id, product_option_ids;

# 총 결제 금액
select sum(t.s)
from (select sum(price - order_detail.coupon_discount_price) s
      from order_detail
      where product_id in (7301, 4278, 6847, 2337, 7258, 7185)
        and created_at > '2023-11-29 23:30:30'
        and history not like '%CLEARED%'
        and history not like '%FAILED%'
        and history not like '%CANCELING1%'
        and history not like '%REFUNDED1%'
        and history not like '%EXCHANGING1%'
        and history not like '%PARTIAL_CANCELING1%'
        and history not like '%PARTIAL_REFUNDING1%'
        and status != 'INITIAL'
        and status != 'READY'
      group by product_id,
               product_option_ids) t;


select * from order_detail
where product_option_ids = '121207,121214';

select hour(created_at) hh, count(created_at) from order_detail
where product_id in (7301, 4278, 6847, 2337, 7258, 7185) and
      (created_at between '2023-12-05 00:00:00' and '2023-12-05 23:59:59') and
      history like '%PAID%'
group by hh
order by hh;