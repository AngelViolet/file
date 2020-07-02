
select name from v$database;
select instance_name from v$instance;
drop table TBL_NXY_WECHAT_FLW_20180812;
select value from v$parameter where name = 'db_domain';
select value from v$parameter where name = 'service_name';
alter table TBL_NXY_ALIPAY_FLW_20181224 rename  to TBL_NXY_ALIPAY_FLW_20180411
alter table tbl_mir_collerr_flw add out_fee number(18,0) default 0;
select * from tbl_mir_collerr_flw
SELECT * FROM TBL_NXY_WECHAT_FLW_20180521;
select sysdate from dual
DELETE FROM TBL_NXY_WECHAT_FLW_20180521
COMMIT
--初始化对账数据
update tbl_nxy_wechat_flw_20180521 set coll_status=0;
update tbl_trans_mir set coll_status=0,out_fee=0;
delete from tbl_procedure_record;
delete from tbl_coll_error_flw;
delete from tbl_wechat_collerr_flw;
delete from TBL_MIR_COLLERR_FLW;
delete from bonus;
rollback
select * from bonus as of timestamp to_timestamp('2018-12-29 14:28:25','yyyy-mm-dd hh24:mi:ss');
alter table bonus enable row movement;


flashback table bonus to timestamp to_timestamp('2018-12-29 14:28:25','yyyy-mm-dd hh24:mi:ss');

--查询是否存在微信表
SELECT COUNT(*)   FROM user_tables WHERE table_name='TBL_NXY_WECHAT_FLW_20181210';

select substr(trans_datetime,1,8)-1 from tbl_trans_mir;

select to_char(to_date(finish_time,'yyyy/mm/dd hh24:mi'),'yyyymmddhh24mi') from tbl_nxy_alipay_flw_20181222;
select create_time from tbl_nxy_alipay_flw_20181222
select to_date('2018-12-12 12:12','yyyy-mm-dd hh24:mi') from dual;
update tbl_nxy_alipay_flw_20181222 set create_time=to_char(to_date(create_time,'yyyy/mm/dd hh24:mi'),'yyyymmddhh24mi');
 