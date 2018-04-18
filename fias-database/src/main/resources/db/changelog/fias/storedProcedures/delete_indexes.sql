CREATE OR REPLACE FUNCTION fias.delete_indexes()
  RETURNS void AS
$BODY$

BEGIN
--------------------------------fias_addrobj_view------------------------------------------------------------
IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_AOLEVEL_IDX') THEN
  DROP INDEX fias."FIAS_AOBJECT_AOLEVEL_IDX";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_01') THEN
  DROP INDEX fias."fias_aobject_name_idx_01";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_02') THEN
  DROP INDEX fias."fias_aobject_name_idx_02";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_03') THEN
  DROP INDEX fias."fias_aobject_name_idx_03";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_04') THEN
  DROP INDEX fias."fias_aobject_name_idx_04";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_05') THEN
  DROP INDEX fias."fias_aobject_name_idx_05";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_06') THEN
  DROP INDEX fias."fias_aobject_name_idx_06";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_07') THEN
  DROP INDEX fias."fias_aobject_name_idx_07";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_08') THEN
  DROP INDEX fias."fias_aobject_name_idx_08";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_09') THEN
  DROP INDEX fias."fias_aobject_name_idx_09";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_11') THEN
  DROP INDEX fias."fias_aobject_name_idx_11";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_aobject_name_idx_13') THEN
  DROP INDEX fias."fias_aobject_name_idx_13";
END IF;

--------------------------------fias_house-------------------------------------------------------------------
IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_house_aoguid_idx') THEN
  DROP INDEX fias."fias_house_aoguid_idx";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_house_idx') THEN
  DROP INDEX fias."fias_house_idx";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_house_idx_01') THEN
  DROP INDEX fias."fias_house_idx_01";
END IF;

IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'fias_house_num_idx') THEN
  DROP INDEX fias."fias_house_num_idx";
END IF;


  return;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;
