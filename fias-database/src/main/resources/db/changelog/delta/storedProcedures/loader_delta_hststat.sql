CREATE OR REPLACE FUNCTION delta.loader_delta_hststat()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_HSTSTAT f
  set housestid=d.housestid,name=d.name
  from delta.FIAS_HSTSTAT d
  where d.housestid = f.housestid;

  insert into fias.FIAS_HSTSTAT (housestid,name)
  select d.housestid,d.name
  from delta.FIAS_HSTSTAT d
  left join fias.FIAS_HSTSTAT f on d.housestid = f.housestid
  where f.housestid is null;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;