# 콩 필라테스 공구상품 주문 전체 조회
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
where product_id in (2338, 1933, 4897, 4320, 2341)
  and created_at > '2023-11-29 23:30:30'
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
where product_id = 1933
  and product_option_ids = '120585,123341'
  and created_at > '2023-11-29 23:30:30'
order by created_at desc;

# 콩 필라테스 재고 차감 주문 // TODO: 전체주문 조회로 바꾸고, 조인해서 같은결과내기, with엿나? 그쿼리 해보기
select product_id,
       p.code,
       product_option_ids,
       product_options,
       count(product_option_ids) p_cnt,
       sum(count) c_cnt
from order_detail od
         inner join product p on p.id = od.product_id
where product_id in (2338, 1933, 4897, 4320, 2341)
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
       sum(count) c_cnt
from order_detail od
         inner join product p on p.id = od.product_id
where product_id in (2338, 1933, 4897, 4320, 2341)
  and od.created_at > '2023-11-29 23:30:30'
  and (history like '%CLEARED%' or history like 'FAILED')
group by product_id, product_option_ids
order by product_id, product_option_ids;

# 콩 필라테스 총 결제 금액
select sum(t.s)
from (select sum(price - order_detail.coupon_discount_price) s
      from order_detail
      where product_id in (2338, 1933, 4897, 4320, 2341)
        and created_at > '2023-11-29 23:30:30'
        and history not like '%CLEARED%'
        and history not like 'FAILED'
      group by product_id,
               product_option_ids) t;
