CREATE OR REPLACE FUNCTION delta.loader_delta_landmark()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_LANDMARK f
  set location=d.location,postalcode=d.postalcode,ifnsfl=d.ifnsfl,terrifnsfl=d.terrifnsfl,ifnsul=d.ifnsul,
      terrifnsul=d.terrifnsul,okato=d.okato,oktmo=d.oktmo,updatedate=d.updatedate,landid=d.landid,
      landguid=d.landguid,aoguid=d.aoguid,startdate=d.startdate,enddate=d.enddate,normdoc=d.normdoc
  from delta.FIAS_LANDMARK d
  where d.landid = f.landid;

  insert into fias.FIAS_LANDMARK (location,postalcode,ifnsfl,terrifnsfl,ifnsul,terrifnsul,okato,oktmo,updatedate,
         landid,landguid,aoguid,startdate,enddate,normdoc )
  select d.location,d.postalcode,d.ifnsfl,d.terrifnsfl,d.ifnsul,d.terrifnsul,d.okato,d.oktmo,d.updatedate,d.landid,d.landguid,
         d.aoguid,d.startdate,d.enddate,d.normdoc
  from delta.FIAS_LANDMARK d
  left join fias.FIAS_LANDMARK f on d.landid = f.landid
  where f.landid is null;

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;