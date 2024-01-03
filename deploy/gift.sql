alter table order_detail
    add gift varchar(255) null comment '사은품 정보' after settled_at;

