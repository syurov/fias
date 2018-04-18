CREATE OR REPLACE FUNCTION delta.loader_delta_eststat()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_ESTSTAT f
  set eststatid=d.eststatid,name=d.name,shortname=d.shortname
  from delta.FIAS_ESTSTAT d
  where d.eststatid = f.eststatid;

  insert into fias.FIAS_ESTSTAT (eststatid,name,shortname)
  select d.eststatid,d.name,d.shortname
  from delta.FIAS_ESTSTAT d
  left join fias.FIAS_ESTSTAT f on d.eststatid = f.eststatid
  where f.eststatid is null;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;