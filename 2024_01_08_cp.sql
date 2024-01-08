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
       coupon_id,
       gift
from order_detail
where product_id in (6847, 2366, 6676, 6673, 2368, 4314, 4317)
  and created_at >= '2024-01-08 00:00:00'
order by created_at desc;