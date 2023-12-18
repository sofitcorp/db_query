alter table order_detail
    add settled_at datetime null comment '정산날짜' after coupon_issuance_id;