CREATE OR REPLACE FUNCTION delta.loader_delta_operstat()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_OPERSTAT f
  set operstatid=d.operstatid,name=d.name
  from delta.FIAS_OPERSTAT d
  where d.operstatid = f.operstatid;

  insert into fias.FIAS_OPERSTAT (operstatid,name)
  select d.operstatid,d.name
  from delta.FIAS_OPERSTAT d
  left join fias.FIAS_OPERSTAT f on d.operstatid = f.operstatid
  where f.operstatid is null;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;