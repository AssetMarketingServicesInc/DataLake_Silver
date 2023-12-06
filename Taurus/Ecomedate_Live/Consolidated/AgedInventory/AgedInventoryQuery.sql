SELECT 
	 im.[ITM_CD] as Item_Number
	,im.[LONG_NM] as Description
	,im.[ITM_STA_LGCY_CD] as Item_Status
	,im.[MAJ_CAT_LGCY_CD] as Major_Category_Code
	,im.[SUB_MAJ_CAT_LGCY_CD] as Sub_Major_Category_Code
	,im.[MIN_CAT_LGCY_CD] as Minor_Category_Code
	,im.[SUB_MIN_CAT_LGCY_CD] as Sub_Minor_Category_Code
	,im.[SELL_PRICE_AMT] as Selling_Price
	,im.[CO_CD] as Company
	,im.[DIV_CD] as Division
	, case when im.[MAJ_CAT_LGCY_CD] != 'C' then cast(im.[SUB_MIN_CAT_LGCY_CD] as varchar) + ' - ' + cast(case when im.[SUB_MIN_CAT_LGCY_CD] = 'C' then 'Consignment' when im.[SUB_MIN_CAT_LGCY_CD] = 'E' then 'Evergreen' when im.[SUB_MIN_CAT_LGCY_CD] = 'L' then 'Liquidation' when im.[SUB_MIN_CAT_LGCY_CD] = 'S' then 'Short Term' else '' end as varchar) else '' end as Cat1NT_Cat4Coin
	,im.[STY_CD] as Style
	,id.[WH_LOC_CD] as Warehouse_Location
	,id.[AVL_INV] as Units_on_Hand
	,id.[TRANS_COST_AMT] as Unit_Cost
	,id.[USABLE_LGCY_CD] as Usable_Code
	,cast(id.[INV_SORT_DT] as date) as Inventory_Sort_Date
	,SUBSTRING (id.[WH_LOC_CD], 1, 2) as Warehouse
	,im.[BUYER_CD] as Buyer_Code
	,im.[MERCH_LGCY_CD] as Merchendiser
	, case when id.[USABLE_LGCY_CD] = 'U' then id.[AVL_INV] else 0 end as Usable_Inventory
	, case when id.[USABLE_LGCY_CD] = 'N' then id.[AVL_INV] else 0 end as Unusable_Inventory
	, case when cast(SUBSTRING (id.[WH_LOC_CD], 1, 2) as int) <= '89' then id.[AVL_INV] else 0 end as Good_Inventory
	, case when cast(SUBSTRING (id.[WH_LOC_CD], 1, 2) as int) >= '90' then id.[AVL_INV] else 0 end as Bad_Inventory 
	, case when (im.[STY_CD] <> NULL AND im.[STY_CD] <> '') then 'N' else 'Y' end as Style_Flag 
	, DATEDIFF(day,CAST(id.[INV_SORT_DT] AS DATE),GETDATE()) AS Aged_Days  
	, case when DATEDIFF(day,CAST(id.[INV_SORT_DT] AS DATE),GETDATE()) <= 90 then 'A - 0-90' when DATEDIFF(day,CAST(id.[INV_SORT_DT] AS DATE),GETDATE()) <=180 then 'B 91-180' when DATEDIFF(day,CAST(id.[INV_SORT_DT] AS DATE),GETDATE()) <= 270 then 'C - 181-270' when DATEDIFF(day,CAST(id.[INV_SORT_DT] AS DATE),GETDATE()) <= 360 then 'D - 271-360' when DATEDIFF(day,CAST(id.[INV_SORT_DT] AS DATE),GETDATE()) <= 720 then 'E - 361-720' else 'F - 720+' end as Aging
	, CAST(im.[MAJ_CAT_LGCY_CD] as varchar) + cast(im.[SUB_MAJ_CAT_LGCY_CD] as varchar) + cast(im.[MIN_CAT_LGCY_CD] as varchar) + cast(im.[SUB_MIN_CAT_LGCY_CD] as varchar)  AS ProductCategory
	, id.[AVL_INV] * id.[TRANS_COST_AMT] as TotalValue
	, case when im.[SUB_MIN_CAT_LGCY_CD] = 'C' then 'Consignment' when im.[SUB_MIN_CAT_LGCY_CD] = 'E' then 'Evergreen' when im.[SUB_MIN_CAT_LGCY_CD] = 'L' then 'Liquidation' when im.[SUB_MIN_CAT_LGCY_CD] = 'S' then 'Short Term' else '' end as Sub_Minor_Description
	, case when  im.[MAJ_CAT_LGCY_CD] = 'C' then 'Collateral' else '01' end as Part#Type 

  FROM [Ecomedate_Live].[dbo].[SV_MACITM_ITEM_MAST] im 

  inner join [Ecomedate_Live].[dbo].[SV_MACITM_INV_DETAILS] id
  on im.[EDP_NO_ID] = id.[EDP_NO_ID]

  where CAST(im.[CO_CD] AS INT) = 11 

  order by 1 
