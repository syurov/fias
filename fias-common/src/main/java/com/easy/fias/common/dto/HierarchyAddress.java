package com.easy.fias.common.dto;

import lombok.extern.log4j.Log4j;

import java.util.ArrayList;
import java.util.Collection;

@Log4j
public class HierarchyAddress extends ArrayList<AddressItem> {

  public HierarchyAddress(Collection<? extends AddressItem> c) {
    super(c);
  }

  public AddressItem getHouse() {
    for (int i = 0; i < this.size(); i++) {
      AddressItem addressItem = this.get(i);
      if (addressItem.getLevel() > 7)
        return addressItem;
    }

    return null;
  }

  public AddressItem getStreet() {
    for (int i = 0; i < this.size(); i++) {
      AddressItem addressItem = this.get(i);
      if (addressItem.getLevel() == 7)
        return addressItem;
    }

    return null;
  }

  public AddressItem getSettlement() {
    for (int i = 0; i < this.size(); i++) {
      AddressItem addressItem = this.get(i);
      if (addressItem.getLevel() == 6)
        return addressItem;
    }

    return null;
  }

  public AddressItem getUrbanArea() {
    for (int i = 0; i < this.size(); i++) {
      AddressItem addressItem = this.get(i);
      if (addressItem.getLevel() == 5)
        return addressItem;
    }

    return null;
  }

  public AddressItem getCity() {
    for (int i = 0; i < this.size(); i++) {
      AddressItem addressItem = this.get(i);
      if (addressItem.getLevel() == 4)
        return addressItem;
    }

    return null;
  }

  public AddressItem getDistrict() {
    for (int i = 0; i < this.size(); i++) {
      AddressItem addressItem = this.get(i);
      if (addressItem.getLevel() == 3)
        return addressItem;
    }

    return null;
  }

  public AddressItem getRegion() {
    for (int i = 0; i < this.size(); i++) {
      AddressItem addressItem = this.get(i);
      if (addressItem.getLevel() == 1)
        return addressItem;
    }

    return null;
  }

  @Override
  public String toString() {
    StringBuilder builder = new StringBuilder();
    try {
      for (int i = 0; i < this.size(); i++) {
        builder.append(this.get(i).getName());
        builder.append(" ");
        builder.append(this.get(i).getSocr());
        if (i < this.size() - 1) {
          builder.append(", ");
        }
      }
    } catch (Exception ex) {
      log.error(ex.toString());
    }
    return builder.toString();
  }
}
