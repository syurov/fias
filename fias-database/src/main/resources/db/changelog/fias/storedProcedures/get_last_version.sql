CREATE OR REPLACE FUNCTION fias.get_last_version()
  RETURNS refcursor AS
$BODY$
DECLARE
  cur_fias_last REFCURSOR;
BEGIN
  OPEN cur_fias_last FOR
  select t.row_id as id,
         t.text_version as text,
         t.is_current as isCurrent
  from   fias.version t
  where t.is_current = TRUE
  limit 1;

  RETURN cur_fias_last;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;