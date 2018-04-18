package com.easy.fias.common.dto;

import lombok.Data;

@Data
public class FiasFilterDto {

  private String parent;

  private String search;

  private Boolean isNew;
}
