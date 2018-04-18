CREATE OR REPLACE FUNCTION fias.apply_version(
    p_id integer,
    p_text character varying)
  RETURNS refcursor AS
$BODY$
DECLARE
  cur_fias_last REFCURSOR;
BEGIN

  execute delta.loader_delta_actstat();
  execute delta.loader_delta_centerst();
  execute delta.loader_delta_curentst();
  execute delta.loader_delta_eststat();
  execute delta.loader_delta_hststat();
  execute delta.loader_delta_intvstat();
  execute delta.loader_delta_hststat();
  execute delta.loader_delta_landmark();
  execute delta.loader_delta_operstat();
  execute delta.loader_delta_socrbase();
  execute delta.loader_delta_strstat();
  execute delta.loader_delta_ndoctype();
  execute delta.loader_delta_normdoc();
  execute delta.loader_delta_houseint();
  execute delta.loader_delta_addrobj();
  execute delta.loader_delta_house();

  update fias.version
  set current = FALSE;

  insert into fias.version (row_id, text, current)
  values (p_id, p_text, TRUE);

  OPEN cur_fias_last FOR
  select t.row_id as id,
         t.text as text,
         t.current as isCurrent
  from   fias.version t
  where t.current = TRUE
  limit 1;

  RETURN cur_fias_last;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;