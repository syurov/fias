CREATE OR REPLACE FUNCTION delta.loader_delta_curentst()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_CURENTST f
  set curentstid=d.curentstid,name=d.name
  from delta.FIAS_CURENTST d
  where d.curentstid = f.curentstid;

  insert into fias.FIAS_CURENTST (curentstid,name)
  select d.curentstid,d.name
  from delta.FIAS_CURENTST d
  left join fias.FIAS_CURENTST f on d.curentstid = f.curentstid
  where f.curentstid is null;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;