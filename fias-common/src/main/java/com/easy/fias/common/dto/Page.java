package com.easy.fias.common.dto;

import lombok.Data;

@Data
public class Page {
  private int pageNumber = 1;
  private int recordsOnPage = 50;

  public int getStartIndex() {
    return (pageNumber - 1) * recordsOnPage;
  }
}


