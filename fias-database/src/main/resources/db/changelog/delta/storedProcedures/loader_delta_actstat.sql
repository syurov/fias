CREATE OR REPLACE FUNCTION delta.loader_delta_actstat()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_ACTSTAT f
  set actstatid=d.actstatid,name=d.name
  from delta.FIAS_ACTSTAT d
  where d.actstatid = f.actstatid;

  insert into fias.FIAS_ACTSTAT (actstatid,name)
  select d.actstatid,d.name
  from delta.FIAS_ACTSTAT d
  left join fias.FIAS_ACTSTAT f on d.actstatid = f.actstatid
  where f.actstatid is null;

RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;