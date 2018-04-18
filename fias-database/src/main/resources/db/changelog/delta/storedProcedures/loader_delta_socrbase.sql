CREATE OR REPLACE FUNCTION delta.loader_delta_socrbase()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_SOCRBASE f
  set level=d.level,scname=d.scname,socrname=d.socrname,kod_t_st=d.kod_t_st
  from delta.FIAS_SOCRBASE d
  where d.kod_t_st = f.kod_t_st;

  insert into fias.FIAS_SOCRBASE (level,scname,socrname,kod_t_st)
  select d.level,d.scname,d.socrname,d.kod_t_st
  from delta.FIAS_SOCRBASE d
  left join fias.FIAS_SOCRBASE f on d.kod_t_st = f.kod_t_st
  where f.kod_t_st is null;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;