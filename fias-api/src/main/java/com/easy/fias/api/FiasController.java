package com.easy.fias.api;

import com.easy.fias.common.dto.AddressItem;
import com.easy.fias.common.interfaces.FiasUpdater;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import static com.easy.fias.common.utils.RESTservices.JSONContentType;

@RestController
@RequestMapping("/fias/")
@Log4j
public class FiasController {

  @Autowired
  FiasUpdater fiasUpdater;

  @RequestMapping(value = "/reload", method = RequestMethod.GET, produces = JSONContentType)
  public void reload() throws Exception {
    fiasUpdater.reload();
  }
}
