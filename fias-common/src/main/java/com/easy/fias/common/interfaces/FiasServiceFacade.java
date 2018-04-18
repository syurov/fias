package com.easy.fias.common.interfaces;


import com.easy.fias.common.dto.AddressItem;
import com.easy.fias.common.dto.FiasFilterDto;
import com.easy.fias.common.dto.HierarchyAddress;
import com.easy.fias.common.dto.Page;

import java.util.List;

public interface FiasServiceFacade {
  HierarchyAddress hierarchyBuild(String addressId) throws Exception;

  List<AddressItem> addressList(FiasFilterDto filter, Page page);

  AddressItem getAddressItem(String addressId) throws Exception;
}
