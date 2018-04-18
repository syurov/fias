package com.easy.fias.services;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.UrlResource;
import scriptella.driver.spring.EtlExecutorBean;
import scriptella.interactive.ConsoleProgressIndicator;

import java.io.IOException;
import java.net.URL;

@Configuration
@ComponentScan("com.easy.fias.dal")
public class FiasServicesConfig {


  @Bean
  ConsoleProgressIndicator getConsoleProgressIndicator() {
    return new ConsoleProgressIndicator();
  }


  @Bean
  EtlExecutorBean getEtlExecutorBean0() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean1() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean2() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean3() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean4() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean5() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean6() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean7() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean8() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean9() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean10() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean11() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean12() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean13() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean14() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean15() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean16() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean17() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean18() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean19() throws IOException {
    return getEtlExecutorBean();
  }

  @Bean
  EtlExecutorBean getEtlExecutorBean20() throws IOException {
    return getEtlExecutorBean();
  }


  private EtlExecutorBean getEtlExecutorBean() throws IOException {
    EtlExecutorBean etlExecutorBean = new EtlExecutorBean();
    etlExecutorBean.setProgressIndicator(getConsoleProgressIndicator());
    URL location = FiasServicesConfig.class.getClassLoader().getResource("script.xml");
    if (location == null)
      return null;
    etlExecutorBean.setConfigLocation(new UrlResource(location));
    return etlExecutorBean;
  }
}
