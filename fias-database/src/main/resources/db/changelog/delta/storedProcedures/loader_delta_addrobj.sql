CREATE OR REPLACE FUNCTION delta.loader_delta_addrobj()
  RETURNS void AS
$BODY$
BEGIN

  update fias.FIAS_ADDROBJ f
  set actstatus=d.actstatus,aoguid=d.aoguid,aoid=d.aoid,
      aolevel=d.aolevel,areacode=d.areacode,autocode=d.autocode,
      centstatus=d.centstatus,citycode=d.citycode,code=d.code,
      currstatus=d.currstatus,enddate=d.enddate,formalname=d.formalname,
      ifnsfl=d.ifnsfl,ifnsul=d.ifnsul,nextid=d.nextid,offname=d.offname,
      okato=d.okato,oktmo=d.oktmo,operstatus=d.operstatus,parentguid=d.parentguid,
      placecode=d.placecode,plaincode=d.plaincode,postalcode=d.postalcode,previd=d.previd,
      regioncode=d.regioncode,shortname=d.shortname,startdate=d.startdate,streetcode=d.streetcode,
      ctarcode=d.ctarcode,extrcode=d.extrcode,sextcode=d.sextcode,livestatus=d.livestatus,normdoc=d.normdoc,
      terrifnsfl=d.terrifnsfl,terrifnsul=d.terrifnsul,updatedate=d.updatedate
  from delta.FIAS_ADDROBJ d
  where d.AOID = f.AOID;

  insert into fias.FIAS_ADDROBJ (actstatus,aoguid,aoid,aolevel,areacode,autocode,
				centstatus,citycode,code,currstatus,enddate,formalname,ifnsfl,ifnsul,nextid,
				offname,okato,oktmo,operstatus,parentguid,placecode,plaincode,postalcode,previd,
				regioncode,shortname,startdate,streetcode,ctarcode,extrcode,sextcode,livestatus,
				normdoc,terrifnsfl,terrifnsul,updatedate)
  select distinct
    d.actstatus,d.aoguid,d.aoid,d.aolevel,d.areacode,d.autocode,d.centstatus,
    d.citycode,d.code,d.currstatus,d.enddate,d.formalname,d.ifnsfl,d.ifnsul,
    d.nextid,d.offname,d.okato,d.oktmo,d.operstatus,d.parentguid,d.placecode,
    d.plaincode,d.postalcode,d.previd,d.regioncode,d.shortname,d.startdate,
    d.streetcode,d.ctarcode,d.extrcode,d.sextcode,d.livestatus,d.normdoc,d.terrifnsfl,d.terrifnsul,d.updatedate
  from
    delta.FIAS_ADDROBJ d
  left join fias.FIAS_ADDROBJ f on d.AOID = f.AOID
  where f.AOID is null;

  delete from fias.FIAS_ADDROBJ where aoid in (select aoid from delta.FIAS_DEL_ADDROBJ);
RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
