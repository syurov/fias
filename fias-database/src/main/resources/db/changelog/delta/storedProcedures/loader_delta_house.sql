CREATE OR REPLACE FUNCTION delta.loader_delta_house()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_HOUSE f
  set postalcode=d.postalcode,ifnsfl=d.ifnsfl,terrifnsfl=d.terrifnsfl,ifnsul=d.ifnsul,
      terrifnsul=d.terrifnsul,okato=d.okato,oktmo=d.oktmo,updatedate=d.updatedate,housenum=d.housenum,
      eststatus=d.eststatus,buildnum=d.buildnum,strucnum=d.strucnum,strstatus=d.strstatus,
      houseid=d.houseid,houseguid=d.houseguid,aoguid=d.aoguid,startdate=d.startdate,
      enddate=d.enddate,statstatus=d.statstatus,normdoc=d.normdoc,counter=d.counter
  from delta.FIAS_HOUSE d
  where d.houseid = f.houseid;

  insert into fias.FIAS_HOUSE (postalcode,ifnsfl,terrifnsfl,ifnsul,terrifnsul,okato,oktmo,
      updatedate,housenum,eststatus,buildnum,strucnum,strstatus,
      houseid,houseguid,aoguid,startdate,enddate,statstatus,normdoc,counter)
  select
      d.postalcode,d.ifnsfl,d.terrifnsfl,d.ifnsul,d.terrifnsul,d.okato,d.oktmo,
      d.updatedate,d.housenum,d.eststatus,d.buildnum,d.strucnum,d.strstatus,
      d.houseid,d.houseguid,d.aoguid,d.startdate,d.enddate,d.statstatus,d.normdoc,d.counter
  from delta.FIAS_HOUSE d
  left join fias.FIAS_HOUSE f on d.houseid = f.houseid
  where f.houseid is null;

  delete from fias.FIAS_HOUSE where houseid in (select houseid from delta.FIAS_DEL_HOUSE);

  RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;