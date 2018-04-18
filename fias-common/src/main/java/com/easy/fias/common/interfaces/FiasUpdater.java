package com.easy.fias.common.interfaces;

/**
 * Created by syurov on 20.04.2015.
 */
public interface FiasUpdater {
  void setDirectoryDestination(String directoryDestination);

  void reload() throws Exception;

  void up() throws Exception;
}
