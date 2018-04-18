CREATE OR REPLACE FUNCTION delta.loader_delta_normdoc()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_NORMDOC f
  set normdocid=d.normdocid,docname=d.docname,docdate=d.docdate,docnum=d.docnum,doctype=d.doctype,docimgid=d.docimgid
  from delta.FIAS_NORMDOC d
  where d.normdocid = f.normdocid;

  insert into fias.FIAS_NORMDOC (normdocid,docname,docdate,docnum,doctype,docimgid)
  select d.normdocid,d.docname,d.docdate,d.docnum,d.doctype,d.docimgid
  from delta.FIAS_NORMDOC d
  left join fias.FIAS_NORMDOC f on d.normdocid = f.normdocid
  where f.normdocid is null;

  delete from fias.FIAS_NORMDOC where normdocid in (select normdocid from delta.FIAS_DEL_NORMDOC);

  RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;