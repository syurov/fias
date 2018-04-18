CREATE OR REPLACE FUNCTION delta.loader_delta_intvstat()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_INTVSTAT f
  set intvstatid=d.intvstatid,name=d.name
  from delta.FIAS_INTVSTAT d
  where d.intvstatid = f.intvstatid;

  insert into fias.FIAS_INTVSTAT (intvstatid,name)
  select d.intvstatid,d.name
  from delta.FIAS_INTVSTAT d
  left join fias.FIAS_INTVSTAT f on d.intvstatid = f.intvstatid
  where f.intvstatid is null;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;