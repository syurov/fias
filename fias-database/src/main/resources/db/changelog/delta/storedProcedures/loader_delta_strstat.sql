CREATE OR REPLACE FUNCTION delta.loader_delta_strstat()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_STRSTAT f
  set strstatid=d.strstatid,name=d.name,shortname=d.shortname
  from delta.FIAS_STRSTAT d
  where d.strstatid = f.strstatid;

  insert into fias.FIAS_STRSTAT (strstatid,name,shortname)
  select d.strstatid,d.name,d.shortname
  from delta.FIAS_STRSTAT d
  left join fias.FIAS_STRSTAT f on d.strstatid = f.strstatid
  where f.strstatid is null;
 
  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
