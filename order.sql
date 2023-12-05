# 주문 조회
select created_at    주문일시,
       count         수량,
       delivery_code 송장번호,
       delivery_name 택배사,
       replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
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
                                                                                               'TRANSIT', '배송중'),
                                                                                       'DELIVERED', '배송완료'),
                                                                               'CANCELING1', '취소요청'),
                                                                       'CANCELING2', '취소처리중'),
                                                               'PARTIAL_CANCELING1', '부분취소요청'),
                                                       'PARTIAL_CANCELING2', '부분취소처리중'),
                                               'PARTIAL_CANCELLED', '부분취소완료'),
                                       'EXCHANGING1', '교환요청'),
                               'EXCHANGING2', '교환처리중'),
                       'EXCHANGED', '교환완료'),
               'REFUNDING1', ''
       )             주문상태이력
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
select * from order_detail od
join order_group og on od.order_group_id = og.id
where og.order_code = 'SF-OP-20231205135929939';