package com.easy.fias.database;

import liquibase.integration.spring.SpringLiquibase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

@Configuration
public class Config {

  @Autowired
  DataSource dataSource;

  @Bean
  SpringLiquibase liquibase() {
    SpringLiquibase springLiquibase = new SpringLiquibase();
    springLiquibase.setChangeLog("classpath:db/changelog/db.changelog-master.xml");
    springLiquibase.setDataSource(dataSource);

    return springLiquibase;
  }
}
