CREATE OR REPLACE FUNCTION fias.create_indexes()
  RETURNS void AS
$BODY$

BEGIN

------------------------fias_addrobj--------------------------------------------

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_AOLEVEL_IDX') THEN

 CREATE INDEX "FIAS_AOBJECT_AOLEVEL_IDX"
  ON fias.fias_addrobj
  USING btree
  (aolevel)
 ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_01') THEN

CREATE INDEX fias_aobject_name_idx_01
  ON fias.fias_addrobj
  USING btree
  (aolevel, upper(offname) COLLATE pg_catalog."default" varchar_pattern_ops, actstatus)
;

END IF;


IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_02') THEN

CREATE INDEX fias_aobject_name_idx_02
  ON fias.fias_addrobj
  USING btree
  (aolevel, offname COLLATE pg_catalog."default" varchar_pattern_ops, shortname COLLATE pg_catalog."default" varchar_pattern_ops)
  ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_03') THEN

CREATE INDEX fias_aobject_name_idx_03
  ON fias.fias_addrobj
  USING btree
  (actstatus, aolevel, offname COLLATE pg_catalog."default", shortname COLLATE pg_catalog."default")
  WHERE aolevel <= 6 AND actstatus = 1
  ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_04') THEN

CREATE INDEX fias_aobject_name_idx_04
  ON fias.fias_addrobj
  USING btree
  (aolevel, offname COLLATE pg_catalog."default")
  WHERE aolevel <= 6 AND actstatus = 1
  ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_05') THEN

CREATE INDEX fias_aobject_name_idx_05
  ON fias.fias_addrobj
  USING btree
  (upper(offname) COLLATE pg_catalog."default")
  WHERE aolevel <= 6 AND actstatus = 1
  ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_06') THEN

CREATE INDEX fias_aobject_name_idx_06
  ON fias.fias_addrobj
  USING btree
  (aolevel, offname COLLATE pg_catalog."default")
  ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_07') THEN

CREATE INDEX fias_aobject_name_idx_07
  ON fias.fias_addrobj
  USING btree
  (aolevel, offname COLLATE pg_catalog."default", shortname COLLATE pg_catalog."default")
  ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_08') THEN

CREATE INDEX fias_aobject_name_idx_08
  ON fias.fias_addrobj
  USING btree
  (aolevel, offname COLLATE pg_catalog."default", shortname COLLATE pg_catalog."default")
  ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_09') THEN

CREATE INDEX fias_aobject_name_idx_09
  ON fias.fias_addrobj
  USING btree
  (aolevel, offname COLLATE pg_catalog."default", shortname COLLATE pg_catalog."default")
  WHERE aolevel <= 6 AND actstatus = 1
  ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_11') THEN

CREATE INDEX fias_aobject_name_idx_11
  ON fias.fias_addrobj
  USING btree
  (aolevel)
  ;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_13') THEN

CREATE INDEX fias_aobject_name_idx_13
  ON fias.fias_addrobj
  USING btree
  (upper(offname) COLLATE pg_catalog."default" text_pattern_ops)
  WHERE aolevel <= 6 AND actstatus = 1
  ;

END IF;

--------------------------------------------------------------------

------------------------------fias_house--------------------------------------

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_house_aoguid_idx') THEN
   CREATE INDEX fias_house_aoguid_idx ON fias.fias_house
USING btree (aoguid COLLATE pg_catalog."default")
;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_house_idx') THEN

   CREATE INDEX fias_house_idx ON fias.fias_house
USING btree (houseid COLLATE pg_catalog."default")
;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_house_idx_01') THEN

   CREATE INDEX fias_house_idx_01 ON fias.fias_house
USING btree (aoguid COLLATE pg_catalog."default", housenum COLLATE pg_catalog."default" pg_catalog.text_pattern_ops)
;

END IF;

IF NOT EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_house_num_idx') THEN
   CREATE INDEX fias_house_num_idx ON fias.fias_house
USING btree (housenum COLLATE pg_catalog."default")
;

END IF;

--------------------------------------------------------------------
  return;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;