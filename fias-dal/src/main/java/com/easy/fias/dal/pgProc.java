package com.easy.fias.dal;

import lombok.extern.log4j.Log4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.jdbc.datasource.DataSourceUtils;

import java.sql.Array;
import java.sql.Connection;
import java.util.Map;

/**
 * Оболочка хранимой процедуры
 */
@Log4j
public abstract class pgProc {

  protected String schema = "public";

  SimpleJdbcCall call;

  public pgProc(JdbcTemplate jdbcTemplate, String procName, Boolean isProcedure) {
    call = new SimpleJdbcCall(jdbcTemplate).
        withoutProcedureColumnMetaDataAccess().
        withCatalogName(schema);
    if (isProcedure)
      call.withProcedureName(procName);
    else
      call.withFunctionName(procName);
    setProcParameters(call);
  }

  @SuppressWarnings("unchecked")
  public pgProc(JdbcTemplate jdbcTemplate, String schema, String procName, Boolean isProcedure) {
    call = new SimpleJdbcCall(jdbcTemplate).
        withoutProcedureColumnMetaDataAccess();

    if (schema != null)
      call.withCatalogName(schema);

    if (isProcedure)
      call.withProcedureName(procName);
    else
      call.withFunctionName(procName);
    setProcParameters(call);
  }


  protected abstract void setProcParameters(SimpleJdbcCall call);

  @SuppressWarnings("unchecked")
  public Map execute(Map parameters) {
    return call.execute(parameters);
  }

  public Array GetArrayParam(Long[] array, String type, Boolean useScheme) {

    try {
      // conn call.getJdbcTemplate().getDataSource().getConnection()

      Array ar = call.getJdbcTemplate().getDataSource().getConnection().createArrayOf(useScheme ? String.format("{0}.{1}", schema, type) : type, array);

      return ar;
    } catch (Exception ex) {
      log.error(ex, ex);
    }
    return null;
  }

  public Connection getConnection() {
    return DataSourceUtils.getConnection(call.getJdbcTemplate().getDataSource());
  }

}
