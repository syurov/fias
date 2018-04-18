CREATE OR REPLACE FUNCTION delta.loader_delta_ndoctype()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_NDOCTYPE f
  set ndtypeid=d.ndtypeid,name=d.name
  from delta.FIAS_NDOCTYPE d
  where d.ndtypeid = f.ndtypeid;

  insert into fias.FIAS_NDOCTYPE (ndtypeid,name)
  select d.ndtypeid,d.name
  from delta.FIAS_NDOCTYPE d
  left join fias.FIAS_NDOCTYPE f on d.ndtypeid = f.ndtypeid
  where f.ndtypeid is null;

    RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;