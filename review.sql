select *
from order_detail od
         left join review as r on od.id = r.order_detail_id
where od.status = 'CONFIRMED'
  and r.id is null;

select count(*)
from order_detail od
         left join review as r on od.id = r.order_detail_id
where od.status = 'CONFIRMED'
  and r.id is null;