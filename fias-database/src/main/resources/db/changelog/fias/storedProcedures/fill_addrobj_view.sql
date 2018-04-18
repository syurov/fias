CREATE OR REPLACE FUNCTION fias.fill_addrobj_view()
  RETURNS void AS
$BODY$
  BEGIN
    truncate table fias.fias_addrobj_view;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_IDX') THEN
      DROP INDEX fias."FIAS_AOBJECT_IDX";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_AOGUID_IDX') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_AOGUID_IDX";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_AOLEVEL_IDX') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_AOLEVEL_IDX";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_NAME_IDX') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_NAME_IDX";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_PARENTGUID_IDX') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_PARENTGUID_IDX";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_PARENTGUID2_IDX') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_PARENTGUID2_IDX";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_PARENTGUID3_IDX') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_PARENTGUID3_IDX";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_ORDERNUM_IDX') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_ORDERNUM_IDX";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_ORDERNUM_IDX_2') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_ORDERNUM_IDX_2";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_ORDERNUM_IDX_3') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_ORDERNUM_IDX_3";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_NAME_UPPER_IDX') THEN
      DROP INDEX fias."FIAS_AOBJECT_VIEW_NAME_UPPER_IDX";
    END IF;

    IF EXISTS (SELECT 1 FROM   pg_class WHERE  relname = 'FIAS_AOBJECT_VIEW_NAME_UPPER_IDX') THEN
      DROP INDEX fias.fias_addrobj_view_idx_01;
    END IF;



    INSERT INTO fias.fias_addrobj_view
    (
     SELECT
      adr.Aoid                                                     AS Id,
      adr.Code                                                     AS Code,
      adr.Postalcode                                               AS Index,
      adr.Aolevel                                                  AS Level,
      adr.aoguid                                                   AS Uid,
      adr.Parentguid                                               AS ParentId,
      coalesce(adr.offname, adr.formalname)                        AS Name,
      adr.Shortname                                                AS Socr,
      coalesce(CASE adr4.offname
               WHEN NULL THEN ''
               ELSE
                 coalesce(adr4.offname, adr4.formalname) || ' ' || adr4.shortname || ', '
               END, '') ||
      coalesce(CASE adr3.offname
               WHEN NULL THEN ''
               ELSE
                 coalesce(adr3.offname, adr3.formalname) || ' ' || adr3.shortname || ', '
               END, '') ||
      coalesce(CASE adr2.offname
               WHEN NULL THEN ''
               ELSE
                 coalesce(adr2.offname, adr2.formalname) || ' ' || adr2.shortname || ', '
               END, '') ||
      coalesce(adr.offname, adr.formalname) || ' ' || adr.shortname AS Hint,
      adr.okato                                                    AS Okato,
      adr2.Parentguid                                              AS ParentId2,
      adr3.Parentguid                                              AS ParentId3,
      row_number()
      OVER (
        ORDER BY adr.aolevel, adr4.offname, adr4.shortname, adr3.offname, adr3.shortname, adr2.offname, adr2.shortname,
          adr.Offname, adr.shortname)                              AS OrderNum
    FROM fias.fias_addrobj adr
      LEFT OUTER JOIN fias.fias_addrobj adr2 ON adr2.actstatus = 1 AND adr2.aoguid = adr.parentguid
      LEFT OUTER JOIN fias.fias_addrobj adr3 ON adr3.actstatus = 1 AND adr3.aoguid = adr2.parentguid
      LEFT OUTER JOIN fias.fias_addrobj adr4 ON adr4.actstatus = 1 AND adr4.aoguid = adr3.parentguid
    WHERE adr.actstatus = 1
    ORDER BY adr.aolevel, adr4.offname, adr4.shortname, adr3.offname, adr3.shortname, adr2.offname, adr2.shortname,
      adr.Offname, adr.shortname
    );


    CREATE UNIQUE INDEX "FIAS_AOBJECT_IDX" ON fias.fias_addrobj_view (id);
    CREATE INDEX "FIAS_AOBJECT_VIEW_AOGUID_IDX" ON fias.fias_addrobj_view (uid);
    CREATE INDEX "FIAS_AOBJECT_VIEW_AOLEVEL_IDX" ON fias.fias_addrobj_view (level);
    CREATE INDEX "FIAS_AOBJECT_VIEW_NAME_IDX" ON fias.fias_addrobj_view (name);
    CREATE INDEX "FIAS_AOBJECT_VIEW_PARENTGUID_IDX" ON fias.fias_addrobj_view (parentid);
    CREATE INDEX "FIAS_AOBJECT_VIEW_PARENTGUID2_IDX" ON fias.fias_addrobj_view (parentid2);
    CREATE INDEX "FIAS_AOBJECT_VIEW_PARENTGUID3_IDX" ON fias.fias_addrobj_view (parentid3);
    CREATE INDEX "FIAS_AOBJECT_VIEW_ORDERNUM_IDX" ON fias.fias_addrobj_view (ordernum);
    CREATE INDEX "FIAS_AOBJECT_VIEW_ORDERNUM_IDX_2" ON fias.fias_addrobj_view (ordernum ASC) WHERE level <= 6;
    CREATE INDEX "FIAS_AOBJECT_VIEW_ORDERNUM_IDX_3" ON fias.fias_addrobj_view (ordernum ASC) WHERE level <= 7;
    CREATE INDEX "FIAS_AOBJECT_VIEW_NAME_UPPER_IDX" ON fias.fias_addrobj_view (upper(name));
    CREATE INDEX fias_addrobj_view_idx_01 ON fias.fias_addrobj_view USING btree (upper(name) COLLATE pg_catalog."default" text_pattern_ops, ordernum, (level <= 6));

  END;
  $BODY$
  LANGUAGE plpgsql VOLATILE SECURITY DEFINER
  COST 100;