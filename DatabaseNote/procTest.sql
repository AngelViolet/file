--1
UPDATE
    TBL_NXY_WECHAT_FLW_20180521 NWF
SET
    NWF.COLL_STATUS=1
WHERE
    NWF.TRANS_STATUS='SUCCESS'
AND NWF.M_ORDER_ID IN
    (
        SELECT
            NWF.M_ORDER_ID
        FROM
            TBL_TRANS_MIR TTM,
            TBL_TRANS_TYPE_DEF TTTD,
            TBL_NXY_WECHAT_FLW_20180521 NWF
        WHERE
            TTM.TRANS_TYPE_ID=TTTD.TRANS_TYPE_ID
        AND TTM.DEVICE_TYPE_FLAG=TTTD.DEVICE_TYPE_FLAG
        AND TTTD.TRANS_COLL_FLAG=1
        AND TTM.COLL_STATUS IN(0,4)
        AND TTM.NXY_ORDER_NO=NWF.M_ORDER_ID
        AND TTM.TRANS_AMOUNT=NWF.ORDER_AMOUNT
        AND NWF.TRANS_STATUS='SUCCESS')
--2
UPDATE
    TBL_NXY_WECHAT_FLW_20180521 NWF
SET
    NWF.COLL_STATUS=1
WHERE
    NWF.TRANS_STATUS='REFUND'
AND NWF.M_ORDER_ID IN
    (
        SELECT
            NWF.M_ORDER_ID
        FROM
            TBL_TRANS_MIR TTM,
            TBL_TRANS_TYPE_DEF TTTD,
            TBL_NXY_WECHAT_FLW_20180521 NWF
        WHERE
            TTM.TRANS_TYPE_ID=TTTD.TRANS_TYPE_ID
        AND TTM.DEVICE_TYPE_FLAG=TTTD.DEVICE_TYPE_FLAG
        AND TTTD.TRANS_COLL_FLAG=1
        AND TTM.COLL_STATUS IN(0,4)
        AND TTM.NXY_ORDER_NO=NWF.M_ORDER_ID
        AND TTTD.TRANS_TYPE_ID='3023'
        AND TTM.ACTUAL_AMOUNT=NWF.RETURN_AMOUNT
        AND NWF.TRANS_STATUS='REFUND'
        AND NWF.RETURN_AMOUNT_STATUS='SUCCESS')
--3
UPDATE
    TBL_TRANS_MIR TTM
SET
    TTM.COLL_STATUS=1,
    TTM.TRANS_FLAG=1
WHERE
    TTM.TRANS_TYPE_ID='3022'
AND TTM.NXY_ORDER_NO IN
    (
        SELECT
            TTM.NXY_ORDER_NO
        FROM
            TBL_NXY_WECHAT_FLW_20180521 NWF ,
            TBL_TRANS_TYPE_DEF TTTD,
            TBL_TRANS_MIR TTM
        WHERE
            TTM.TRANS_TYPE_ID=TTTD.TRANS_TYPE_ID
        AND TTM.DEVICE_TYPE_FLAG=TTTD.DEVICE_TYPE_FLAG
        AND TTTD.TRANS_COLL_FLAG=1
        AND TTM.COLL_STATUS IN(0,4)
        AND TTM.NXY_ORDER_NO=NWF.M_ORDER_ID
        AND TTM.TRANS_AMOUNT=NWF.ORDER_AMOUNT
        AND NWF.TRANS_STATUS='SUCCESS')
--4
UPDATE
    TBL_TRANS_MIR TTM
SET
    TTM.COLL_STATUS=1,
    TTM.TRANS_FLAG=1
WHERE
    TTM.TRANS_TYPE_ID='3023'
AND TTM.NXY_ORDER_NO IN
    (
        SELECT
            TTM.NXY_ORDER_NO
        FROM
            TBL_NXY_WECHAT_FLW_20180521 NWF ,
            TBL_TRANS_TYPE_DEF TTTD,
            TBL_TRANS_MIR TTM
        WHERE
            TTM.TRANS_TYPE_ID=TTTD.TRANS_TYPE_ID
        AND TTM.DEVICE_TYPE_FLAG=TTTD.DEVICE_TYPE_FLAG
        AND TTTD.TRANS_COLL_FLAG=1
        AND TTM.COLL_STATUS IN(0,4)
        AND TTM.NXY_ORDER_NO=NWF.M_ORDER_ID
        AND TTTD.TRANS_TYPE_ID = '3023'
        AND TTM.ACTUAL_AMOUNT=NWF.RETURN_AMOUNT
        AND NWF.TRANS_STATUS='REFUND'
        AND NWF.RETURN_AMOUNT_STATUS='SUCCESS')
        
--5ɨ��΢�ű�״̬���¡�

MERGE INTO TBL_NXY_WECHAT_FLW_20180521 NWF
USING TBL_TRANS_MIR TTM
ON(

        TTM.COLL_STATUS IN(0,4)
        AND TTM.TRANS_TYPE_ID='3022'
        AND NWF.TRANS_STATUS='SUCCESS'
        AND TTM.NXY_ORDER_NO=NWF.M_ORDER_ID
        AND TTM.TRANS_AMOUNT=NWF.ORDER_AMOUNT
)WHEN MATCHED THEN UPDATE SET NWF.COLL_STATUS=1;

--6�˿�΢�Ÿ���

MERGE INTO TBL_NXY_WECHAT_FLW_20180521 NWF
USING TBL_TRANS_MIR TTM
ON(
        TTM.COLL_STATUS IN(0,4)
        AND TTM.TRANS_TYPE_ID='3023'
        AND NWF.TRANS_STATUS='REFUND'
        AND NWF.RETURN_AMOUNT_STATUS='SUCCESS'
        AND TTM.NXY_ORDER_NO=NWF.M_ORDER_ID
        AND TTM.TRANS_AMOUNT=NWF.RETURN_AMOUNT
)WHEN MATCHED THEN UPDATE SET NWF.COLL_STATUS=1;
        
        
--7 ɨ�������Ѳ������
MERGE INTO TBL_TRANS_MIR TTM
USING TBL_NXY_WECHAT_FLW_20180521 NWF
ON(     
        TTM.COLL_STATUS IN(0,4)
        AND TTM.TRANS_TYPE_ID = '3022'
        AND NWF.TRANS_STATUS='SUCCESS'
        AND TTM.NXY_ORDER_NO=NWF.M_ORDER_ID
        AND TTM.TRANS_AMOUNT=NWF.ORDER_AMOUNT      
)
WHEN MATCHED THEN UPDATE SET TTM.COLL_STATUS=1,TTM.TRANS_FLAG=1,TTM.OUT_FEE=NWF.FEE;
        
--8 �˿������Ѳ������

MERGE INTO TBL_TRANS_MIR TTM
USING TBL_NXY_WECHAT_FLW_20180521 NWF
ON(
        TTM.COLL_STATUS IN(0,4)
        AND TTM.TRANS_TYPE_ID = '3023'
        AND NWF.TRANS_STATUS='REFUND'
        AND NWF.RETURN_AMOUNT_STATUS='SUCCESS'
        AND TTM.NXY_ORDER_NO=NWF.M_ORDER_ID
        AND TTM.TRANS_AMOUNT=NWF.RETURN_AMOUNT
)WHEN MATCHED THEN UPDATE SET TTM.COLL_STATUS=1,TTM.TRANS_FLAG=1,TTM.OUT_FEE=NWF.FEE;

--------------֧��������---------------
--1ɨ��֧����������
MERGE INTO TBL_NXY_ALIPAY_FLW_20180409 NAF
USING TBL_TRANS_MIR TTM
ON(
        TTM.COLL_STATUS IN(0,4)
        AND TTM.TRANS_TYPE_ID='3022'
        AND NAF.RETURN_FLAG=1
        AND TTM.NXY_ORDER_NO=NAF.MER_ORDER_ID
        AND TTM.TRANS_AMOUNT=NAF.ORDER_AMOUNT
)WHEN MATCHED THEN UPDATE SET NAF.COLL_STATUS=1;

--2�˿�֧����������
MERGE INTO TBL_NXY_ALIPAY_FLW_20180409 NAF
USING TBL_TRANS_MIR TTM
ON(
        TTM.COLL_STATUS IN(0,4)
        AND TTM.TRANS_TYPE_ID='3023'
        AND NAF.RETURN_FLAG=0
        AND TTM.NXY_ORDER_NO=NAF.MER_ORDER_ID
        AND TTM.TRANS_AMOUNT=NAF.ORDER_AMOUNT
)WHEN MATCHED THEN UPDATE SET NAF.COLL_STATUS=1;

--3ɨ�뾵�������
MERGE INTO TBL_TRANS_MIR TTM
USING TBL_NXY_ALIPAY_FLW_20180409 NAF
ON(
        TTM.COLL_STATUS IN(0,4)
        AND TTM.TRANS_TYPE_ID='3022'
        AND NAF.RETURN_FLAG=1
        AND TTM.NXY_ORDER_NO=NAF.MER_ORDER_ID
        AND TTM.TRANS_AMOUNT=NAF.ORDER_AMOUNT
)WHEN MATCHED THEN UPDATE SET TTM.COLL_STATUS=1,TTM.TRANS_FLAG=1,TTM.OUT_FEE=NAF.SERVICE_CHARGE;

--4.�˿�������
MERGE INTO TBL_TRANS_MIR TTM
USING TBL_NXY_ALIPAY_FLW_20180409 NAF
ON(
        TTM.COLL_STATUS IN(0,4)
        AND TTM.TRANS_TYPE_ID='3023'
        AND NAF.RETURN_FLAG=0
        AND TTM.NXY_ORDER_NO=NAF.MER_ORDER_ID
        AND TTM.TRANS_AMOUNT=NAF.ORDER_AMOUNT
)WHEN MATCHED THEN UPDATE SET TTM.COLL_STATUS=1,TRANS_FLAG=1,TTM.OUT_FEE=NAF.SERVICE_CHARGE;


select * from tbl_trans_mir ttm,TBL_NXY_ALIPAY_FLW_20180409 naf
where(
TTM.COLL_STATUS IN(0,4)
        AND TTM.TRANS_TYPE_ID='3022'
        AND NAF.RETURN_FLAG=1
        AND TTM.NXY_ORDER_NO=NAF.MER_ORDER_ID
        AND TTM.TRANS_AMOUNT=NAF.ORDER_AMOUNT
)



