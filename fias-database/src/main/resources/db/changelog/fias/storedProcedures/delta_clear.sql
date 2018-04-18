CREATE OR REPLACE FUNCTION fias.delta_clear()
  RETURNS void AS
$BODY$

BEGIN
 truncate table delta.fias_actstat;
 truncate table delta.fias_addrobj;
 truncate table delta.fias_centerst;
 truncate table delta.fias_curentst;
 truncate table delta.fias_eststat;
 truncate table delta.fias_house;
 truncate table delta.fias_houseint;
 truncate table delta.fias_hststat;
 truncate table delta.fias_intvstat;
 truncate table delta.fias_landmark;
 truncate table delta.fias_ndoctype;
 truncate table delta.fias_normdoc;
 truncate table delta.fias_operstat;
 truncate table delta.fias_socrbase;
 truncate table delta.fias_strstat;
 truncate table delta.fias_del_house;
 truncate table delta.fias_del_addrobj;
 truncate table delta.fias_del_houseint;
 truncate table delta.fias_del_normdoc;
 return;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;