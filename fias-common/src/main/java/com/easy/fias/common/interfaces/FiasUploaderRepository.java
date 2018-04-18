package com.easy.fias.common.interfaces;

import com.easy.fias.common.dto.Version;

public interface FiasUploaderRepository {
  void clear();

  void deltaClear();

  void createIndex();

  void deleteIndex();

  Version getLastVersion();

  Version applyVersion(Integer id, String text);

  void fillAddressView();


}
