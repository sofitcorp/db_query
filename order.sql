# 주문 조회
select created_at                            주문일시,
       count                                 수량,
       delivery_code                         송장번호,
       delivery_name                         택배사,
       replace(
               replace(
                       replace(
                               replace(
                                       replace(
                                               replace(
                                                       replace(
                                                               replace(
                                                                       replace(
                                                                               replace(
                                                                                       replace(
                                                                                               replace(
                                                                                                       replace(
                                                                                                               replace(
                                                                                                                       replace(
                                                                                                                               replace(
                                                                                                                                       replace(
                                                                                                                                               replace(
                                                                                                                                                       replace(
                                                                                                                                                               replace(
                                                                                                                                                                       replace(
                                                                                                                                                                               replace(
                                                                                                                                                                                       replace(
                                                                                                                                                                                               replace(
                                                                                                                                                                                                       replace(
                                                                                                                                                                                                               replace(history, 'INITIAL', '결제시작'),
                                                                                                                                                                                                               'READY',
                                                                                                                                                                                                               '결제진행중'),
                                                                                                                                                                                                       'FAILED',
                                                                                                                                                                                                       '결제실패'),
                                                                                                                                                                                               'CANCELLED',
                                                                                                                                                                                               '취소완료'),
                                                                                                                                                                                       'FORGERY',
                                                                                                                                                                                       '위조'),
                                                                                                                                                                               'CLEARED',
                                                                                                                                                                               '초기화'),
                                                                                                                                                                       'CONFIRMED',
                                                                                                                                                                       '구매확정'),
                                                                                                                                                               'PACKAGING',
                                                                                                                                                               '배송준비중'),
                                                                                                                                                       'TRANSIT',
                                                                                                                                                       '배송중'),
                                                                                                                                               'DELIVERED',
                                                                                                                                               '배송완료'),
                                                                                                                                       'CANCELING1',
                                                                                                                                       '취소요청'),
                                                                                                                               'CANCELING2',
                                                                                                                               '취소처리중'),
                                                                                                                       'PARTIAL_CANCELING1',
                                                                                                                       '부분취소요청'),
                                                                                                               'PARTIAL_CANCELING2',
                                                                                                               '부분취소처리중'),
                                                                                                       'PARTIAL_CANCELLED',
                                                                                                       '부분취소완료'),
                                                                                               'EXCHANGING1', '교환요청'),
                                                                                       'EXCHANGING2', '교환처리중'),
                                                                               'EXCHANGED', '교환완료'),
                                                                       'REFUNDING1', '환불요청'),
                                                               'REFUNDING2', '환불처리중'),
                                                       'REFUNDED', '환불완료'),
                                               'PARTIAL_REFUNDING1', '부분환불요청'),
                                       'PARTIAL_REFUNDING2', '부분환불처리중'),
                               'PARTIAL_REFUNDED', '부분환불완료'),
                       'CONFIRMING', '구매확정요청'),
               'PAID', '결제성공')               주문상태이력,
       market_name                           마켓명,
       order_detail_code                     주문상세코드,
       net_price                             정가,
       price                                 판매가,
       coupon_discount_price                 쿠폰할인가,
       price * count - coupon_discount_price 실결제가,
       product_name                          상품명,
       product_options                       옵션명,
       case
           when status = 'READY'
               then '입금대기중'
           when status = 'PAID'
               then '결제성공'
           when status = 'CANCELLED'
               then '취소완료'
           when status = 'CONFIRMED'
               then '구매확정'
           when status = 'PACKAGING'
               then '배송준비중'
           when status = 'TRANSIT'
               then '배송중'
           when status = 'DELIVERED'
               then '배송완료'
           when status = 'CANCELING1'
               then '취소요청'
           when status = 'CANCELING2'
               then '취소처리중'
           when status = 'PARTIAL_CANCELING1'
               then '부분취소요청'
           when status = 'PARTIAL_CANCELING2'
               then '부분취소처리중'
           when status = 'PARTIAL_CANCELLED'
               then '부분취소완료'
           when status = 'EXCHANGING1'
               then '교환요청'
           when status = 'EXCHANGING2'
               then '교환처리중'
           when status = 'EXCHANGED'
               then '교환완료'
           when status = 'REFUNDING1'
               then '환불요청'
           when status = 'REFUNDING2'
               then '환불처리중'
           when status = 'REFUNDED'
               then '환불완료'
           when status = 'PARTIAL_REFUNDING1'
               then '부분환불요청'
           when status = 'PARTIAL_REFUNDING2'
               then '부분환불처리중'
           when status = 'PARTIAL_REFUNDED'
               then '부분환불완료'
           when status = 'CONFIRMING'
               then '구매확정요청'
           end                               주문상태,
       eta,
       etd,
       detail_reason                         상세사유,
       reason                                사유,
       coupon_code                           쿠폰코드
from order_detail
where created_at >= '20231101'
  and created_at < '20240101'
  and market_id not in (1, 72)
  and status not in ('INITIAL', 'CLEARED', 'FAILED', 'FORGERY')
order by market_name, created_at;

select od.order_group_id                   as '전체주문ID',
       og.order_code                       as '전체주문코드',
       group_concat(od.order_detail_code)  as '상세주문코드s',
       count(od.id)                        as '상세주문ID수',
       grp.counts                          as '환불처리중_상세주문ID수',
       if(count(od.id) = grp.counts, 1, 0) as '비교',
       grp.details                         as '환불처리중_상세주문코드s'
from (select order_group_id,
             count(order_detail_code)        as counts,
             group_concat(order_detail_code) as details,
             group_concat(id)                as ids
      from order_detail
      where market_id = 72
        and created_at >= '20231101'
        and status in ('CANCELING2', 'REFUNDING2')
      group by order_group_id) as grp
         join order_detail od on grp.order_group_id = od.order_group_id
         join order_group og on od.order_group_id = og.id
group by od.order_group_id;

# Orders by order code
select *
from order_detail od
         join order_group og on od.order_group_id = og.id
where og.order_code = 'SF-OP-20231206154513032';

select * from order_detail
where order_detail_code like 'SF-OP-20231204102907801%';

# 주문 조회: 부분취소, 환불 여부 확인
select * from order_detail
where
    history like '%PARTIAL%'
order by created_at desc;