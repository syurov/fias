CREATE OR REPLACE FUNCTION fias.clear()
  RETURNS void AS
$BODY$

BEGIN
 truncate table fias.fias_actstat;
 truncate table fias.fias_addrobj;
 truncate table fias.fias_centerst;
 truncate table fias.fias_curentst;
 truncate table fias.fias_eststat;
 truncate table fias.fias_house;
 truncate table fias.fias_houseint;
 truncate table fias.fias_hststat;
 truncate table fias.fias_intvstat;
 truncate table fias.fias_landmark;
 truncate table fias.fias_ndoctype;
 truncate table fias.fias_normdoc;
 truncate table fias.fias_operstat;
 truncate table fias.fias_socrbase;
 truncate table fias.fias_strstat;
 truncate table fias.version;
 return;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;