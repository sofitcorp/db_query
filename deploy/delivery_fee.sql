# 테이블 생성
create table delivery_fee2
(
    id        bigint      not null auto_increment,
    type      varchar(10) not null,
    target    varchar(10) not null,
    target_id bigint      not null,
    value     integer     not null,
    primary key (id)
) engine = InnoDB;

# 기존 data migration
# insert into delivery_fee2 (type, target, target_id, value)
#         (select if (old.type = 'DOMESTIC', 'FAR', 'ABROAD'), 'MARKET', market_id, if(old.type = 'DOMESTIC', old.inter_island_fee, old.fee_per_piece) from delivery_fee old);

# 마켓 데이터 기본 배송비 데이터 생성
# insert into delivery_fee2 (type, target, target_id, value)
#         (select 'USUAL', 'MARKET', m.id, 0 from market m);

# target_id 별 개수 조회
select target, target_id, count(*) from delivery_fee2
group by target_id;
# 이상 데이터 유무 확인
select target, target_id, count(*) from delivery_fee2
group by target_id having count(*) != 3;

# 기존 테이블 이름 교체
rename table delivery_fee to delivery_fee_old;
# 신규 테이블 이름 교체
rename table delivery_fee2 to delivery_fee;




# TODO: 기존 DB old로 변경 및 새 테이블 2제거