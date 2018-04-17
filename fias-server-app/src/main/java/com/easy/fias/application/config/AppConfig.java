package com.easy.fias.application.config;


import lombok.extern.log4j.Log4j;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * Application config
 */
@Log4j
@Configuration
@ComponentScan({
    "com.easy.fias.dal",
    "com.easy.fias.services"})
public class AppConfig {



}
