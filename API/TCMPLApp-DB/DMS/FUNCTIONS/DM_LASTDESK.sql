--------------------------------------------------------
--  DDL for Function DM_LASTDESK
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DM_LASTDESK" 
(
  vAssetID IN VARCHAR2 
) RETURN VARCHAR2 IS 
vDeskID Varchar2(5);
BEGIN

select deskid into vDeskID from (
select deskid, historydate, rownum rownumber from (
select deskid, historydate from dm_assetmove_tran_history
where ASSETID = vAssetID
and DESK_FLAG = 'T'
order by historydate desc) ) where rownumber = 1;

/*
    Select trim(ToDesk) INTO vDeskID from 
    (select movereqnum,to_char(historydate,'dd-Mon-yy') transdate,
    max(decode(cnt,2,decode(desk_flag,'C',deskid,null))) FromDesk,
    max(decode(cnt,1,decode(desk_flag,'T',deskid,null))) ToDesk from
    (select movereqnum,deskid,desk_flag,historydate,ROW_NUMBER() OVER 
    (PARTITION BY movereqnum  Order By movereqnum,desk_flag desc) cnt
    from (select movereqnum,assetid,deskid,desk_flag,historydate from dm_assetmove_tran_history) 
    where assetid = vAssetID and historydate is not null)
    group by movereqnum,historydate order by historydate desc,movereqnum desc)
    where rownum = 1;
*/

  return vDeskID;
exception
  when others then return null;
END DM_LASTDESK;

/
