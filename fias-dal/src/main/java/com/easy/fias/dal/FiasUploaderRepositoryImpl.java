package com.easy.fias.dal;


import com.easy.fias.common.dto.Version;
import com.easy.fias.common.interfaces.FiasUploaderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Types;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class FiasUploaderRepositoryImpl implements FiasUploaderRepository {


  final private String procApplyVersion = "apply_version";
  final private String procClear = "clear";
  final private String procCreateIndex = "create_indexes";
  final private String procDeleteIndex = "delete_indexes";
  final private String procDeltaClear = "delta_clear";
  final private String procGetLastVersion = "get_last_version";
  final private String procFillAdrView = "fill_addrobj_view";

  private pgProc addressApplyVersion;
  private pgProc addressClear;
  private pgProc addressCreateIndex;
  private pgProc addressDeleteIndex;
  private pgProc addressDeltaClear;
  private pgProc addressGetLastVersion;
  private pgProc fillAdrView;

  @Autowired
  public void setJbdcTemplate(JdbcTemplate fiasJdbcTemplate) {

    addressApplyVersion = new pgProc(fiasJdbcTemplate, "fias", procApplyVersion, false) {

      @Override
      protected void setProcParameters(SimpleJdbcCall call) {
        call
            .declareParameters(new SqlParameter("p_id", Types.INTEGER))
            .declareParameters(new SqlParameter("p_text", Types.VARCHAR))
            .addDeclaredRowMapper("cur_fias_last", new BeanPropertyRowMapper<>(Version.class));
      }
    };

    addressGetLastVersion = new pgProc(fiasJdbcTemplate, "fias", procGetLastVersion, false) {

      @Override
      protected void setProcParameters(SimpleJdbcCall call) {
        call
            .addDeclaredRowMapper("cur_fias_last", new BeanPropertyRowMapper<>(Version.class));
      }
    };

    addressClear = new pgProc(fiasJdbcTemplate, "fias", procClear, true) {
      @Override
      protected void setProcParameters(SimpleJdbcCall call) {
      }
    };

    addressCreateIndex = new pgProc(fiasJdbcTemplate, "fias", procCreateIndex, true) {
      @Override
      protected void setProcParameters(SimpleJdbcCall call) {
      }
    };

    addressDeleteIndex = new pgProc(fiasJdbcTemplate, "fias", procDeleteIndex, true) {
      @Override
      protected void setProcParameters(SimpleJdbcCall call) {
      }
    };

    addressDeltaClear = new pgProc(fiasJdbcTemplate, "fias", procDeltaClear, true) {
      @Override
      protected void setProcParameters(SimpleJdbcCall call) {
      }
    };

    fillAdrView = new pgProc(fiasJdbcTemplate, "fias", procFillAdrView, true) {
      @Override
      protected void setProcParameters(SimpleJdbcCall call) {
      }
    };
  }


  @Override
  @Transactional
  public void clear() {
    final HashMap<String, Object> paramMap = new HashMap<>();
    addressClear.execute(paramMap);
  }

  @Override
  @Transactional
  public void deltaClear() {
    final HashMap<String, Object> paramMap = new HashMap<>();
    addressDeltaClear.execute(paramMap);
  }

  @Override
  @Transactional
  public void createIndex() {
    final HashMap<String, Object> paramMap = new HashMap<>();
    addressCreateIndex.execute(paramMap);
  }

  @Override
  @Transactional
  public void deleteIndex() {
    final HashMap<String, Object> paramMap = new HashMap<>();
    addressDeleteIndex.execute(paramMap);
  }

  @Override
  public Version getLastVersion() {
    final HashMap<String, Object> paramMap = new HashMap<>();

    Map ret = addressGetLastVersion.execute(paramMap);
    List<Version> items = (List) ret.get("cur_fias_last");
    if (items.size() > 0)
      return items.get(0);
    return null;
  }

  @Override
  @Transactional
  public Version applyVersion(Integer id, String text) {
    final HashMap<String, Object> paramMap = new HashMap<>();

    paramMap.put("p_id", id);
    paramMap.put("p_text", text);

    Map ret = addressApplyVersion.execute(paramMap);
    List<Version> items = (List) ret.get("cur_fias_last");
    return items.get(0);
  }

  @Override
  @Transactional
  public void fillAddressView() {
    final HashMap<String, Object> paramMap = new HashMap<>();
    Map ret = fillAdrView.execute(paramMap);
  }
}
