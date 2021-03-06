package com.easy.fias.application.config;


import lombok.extern.log4j.Log4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jndi.JndiTemplate;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;

@Configuration
@Log4j
public class DataSourceConfig {

  @Bean
  @Lazy
  @Primary
  public PlatformTransactionManager transactionManager(DataSource dataSource) {
    PlatformTransactionManager transactionManager = new DataSourceTransactionManager(dataSource);
    return transactionManager;
  }

  @Bean(destroyMethod = "")
  @Lazy
  @Primary
  public DataSource dataSource() {

    DataSource dataSource = null;

    try {
      JndiTemplate jndi = new JndiTemplate();

      dataSource = (DataSource) jndi.lookup("java:comp/env/jdbc/ds");
    } catch (Exception e) {
      log.fatal(String.format("Cannon get resource for %1$s", "java:comp/env/jdbc/ds"), e);
    }
    return dataSource;
  }


  @Bean
  @Lazy
  public JdbcTemplate jdbcTemplate() {
    return new JdbcTemplate(dataSource());
  }

  @Bean
  public NamedParameterJdbcTemplate namedParameterJdbcTemplate() {
    return new NamedParameterJdbcTemplate(dataSource());
  }
}
