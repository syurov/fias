CREATE OR REPLACE FUNCTION delta.loader_delta_centerst()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_CENTERST f
  set centerstid=d.centerstid,name=d.name
  from delta.FIAS_CENTERST d
  where d.centerstid = f.centerstid;

  insert into fias.FIAS_CENTERST (centerstid,name)
  select d.centerstid,d.name
  from delta.FIAS_CENTERST d
  left join fias.FIAS_CENTERST f on d.centerstid = f.centerstid
  where f.centerstid is null;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;