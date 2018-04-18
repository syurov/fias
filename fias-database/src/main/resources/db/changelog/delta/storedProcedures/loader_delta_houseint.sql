CREATE OR REPLACE FUNCTION delta.loader_delta_houseint()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_HOUSEINT f
  set postalcode=d.postalcode,ifnsfl=d.ifnsfl,terrifnsfl=d.terrifnsfl,ifnsul=d.ifnsul,
      terrifnsul=d.terrifnsul,okato=d.okato,oktmo=d.oktmo,updatedate=d.updatedate,
      intstart=d.intstart,intend=d.intend,houseintid=d.houseintid,intguid=d.intguid,
      aoguid=d.aoguid,startdate=d.startdate,enddate=d.enddate,intstatus=d.intstatus,normdoc=d.normdoc,counter=d.counter
  from delta.FIAS_HOUSEINT d
  where d.houseintid = f.houseintid;

  insert into fias.FIAS_HOUSEINT (postalcode,ifnsfl,terrifnsfl,ifnsul,terrifnsul,okato,oktmo,updatedate,intstart,
      intend,houseintid,intguid,aoguid,startdate,enddate,intstatus,normdoc,counter)
  select
      d.postalcode,d.ifnsfl,d.terrifnsfl,d.ifnsul,d.terrifnsul,d.okato,d.oktmo,d.updatedate,d.intstart,
      d.intend,d.houseintid,d.intguid,d.aoguid,d.startdate,d.enddate,d.intstatus,d.normdoc,d.counter
  from delta.FIAS_HOUSEINT d
  left join fias.FIAS_HOUSEINT f on d.houseintid = f.houseintid
  where f.houseintid is null;

  delete from fias.FIAS_HOUSEINT where houseintid in (select houseintid from delta.FIAS_DEL_HOUSEINT);

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;