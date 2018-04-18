package com.easy.fias.services.client;

import javax.xml.bind.annotation.*;


/**
 * <p>Java class for anonymous complex type.
 * <p/>
 * <p>The following schema fragment specifies the expected content contained within this class.
 * <p/>
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="GetAllDownloadFileInfoResult" type="{http://fias.nalog.ru/WebServices/Public/DownloadService.asmx}ArrayOfDownloadFileInfo" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "getAllDownloadFileInfoResult"
})
@XmlRootElement(name = "GetAllDownloadFileInfoResponse")
public class GetAllDownloadFileInfoResponse {

  @XmlElement(name = "GetAllDownloadFileInfoResult")
  protected ArrayOfDownloadFileInfo getAllDownloadFileInfoResult;

  /**
   * Gets the value of the getAllDownloadFileInfoResult property.
   *
   * @return possible object is
   * {@link ArrayOfDownloadFileInfo }
   */
  public ArrayOfDownloadFileInfo getGetAllDownloadFileInfoResult() {
    return getAllDownloadFileInfoResult;
  }

  /**
   * Sets the value of the getAllDownloadFileInfoResult property.
   *
   * @param value allowed object is
   *              {@link ArrayOfDownloadFileInfo }
   */
  public void setGetAllDownloadFileInfoResult(ArrayOfDownloadFileInfo value) {
    this.getAllDownloadFileInfoResult = value;
  }

}
