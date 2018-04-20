package com.easy.fias.services;

import com.easy.fias.common.dto.Version;
import com.easy.fias.common.interfaces.FiasUpdater;
import com.easy.fias.common.interfaces.FiasUploaderRepository;
import com.easy.fias.services.client.DownloadFileInfo;
import com.easy.fias.services.client.DownloadService;
import com.github.junrar.Archive;
import com.github.junrar.exception.RarException;
import com.github.junrar.rarfile.FileHeader;
import lombok.extern.log4j.Log4j;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jndi.JndiTemplate;
import org.springframework.stereotype.Service;
import scriptella.configuration.ConfigurationFactory;
import scriptella.execution.EtlExecutor;

import javax.naming.NamingException;
import javax.xml.ws.WebServiceException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.stream.Collectors;


@Log4j
@Service
public class FiasUpdaterImpl implements FiasUpdater {

  public static final String DIR_NAME_DELTA = "delta";
  public static final String FILE_NAME_FIAS_XML = "fias_xml.rar";
  public static final String FIAS_DELTA_XML_RAR = "fias_delta_xml.rar";
  protected static final String DIR_NAME_COMPLETE = "complete";

  @Autowired
  FiasUploaderRepository addressRepository;

  private File directoryDestination;

  @Autowired
  List<EtlExecutor> etlExecutorBeans;

  private DownloadService service;

  public FiasUpdaterImpl() {
    try {
      service = new DownloadService();
      JndiTemplate jndi = new JndiTemplate();

    } catch (WebServiceException ex) {
      log.error("Нет доступа к сервису обновления ФИАС. Обновление ФИАС толкьо вручном режиме", ex);
      service = null;
    }

    try {
      JndiTemplate jndi = new JndiTemplate();

      String directoryDestination = Paths.get((String) jndi.lookup("java:comp/env/exchange/loadFolder"), "fias").toString();
      this.directoryDestination = new File(directoryDestination);

    } catch (NamingException e) {
      log.fatal("NamingException for PropertiesBatch");
    }
  }

  @Override
  public void setDirectoryDestination(String directoryDestination) {
    this.directoryDestination = new File(directoryDestination);
  }

  @Override
  public synchronized void reload() throws Exception {
    log.info("Старт перезагрузки ФИАС");
    addressRepository.deleteIndex();
    log.info("Выключены индексы");
    addressRepository.clear();
    log.info("Очищены таблицы");
    DownloadFileInfo lastDownloadFileInfo = getLastDownloadFileInfo();
    log.info("Получена информация о последней версии");
    File file = downloadsComplete(lastDownloadFileInfo);
    log.info("Скачен архив");
    List<File> fileList = unrarFias(file);
    log.info("Распакован архив");

    // удаляем файлы del
    fileList = fileList.stream().filter(x -> !x.getName().contains("_DEL_")).collect(Collectors.toList());
    loadFias(fileList);
    log.info("Файлы загружены в схему fias");
    addressRepository.createIndex();
    log.info("Включены индексы");
    addressRepository.deltaClear();
    log.info("Очиена схема delta");
    addressRepository.applyVersion(lastDownloadFileInfo.getVersionId(), lastDownloadFileInfo.getTextVersion());
    addressRepository.fillAddressView();
    log.info("Применена версия №" + lastDownloadFileInfo.getVersionId() + " " + lastDownloadFileInfo.getTextVersion());
    log.info("Конец перезагрузки ФИАС");
  }

  @Override
  public synchronized void up() throws Exception {
    log.info("Старт обновления ФИАС");
    List<DownloadFileInfo> allDownloadFileInfo = getAllDownloadFileInfo();
    Version lastVersion = addressRepository.getLastVersion();

    if (lastVersion == null)
      throw new Exception("Не найдена текущая версия ФИАС");

    log.info("Получена информация об обновлениях ФИАС");
    boolean f = true;
    for (DownloadFileInfo downloadFileInfo : allDownloadFileInfo) {
      if (lastVersion.getId() < downloadFileInfo.getVersionId()) {
        log.info("Обрабатывается обновление №" + downloadFileInfo.getVersionId() + " " + downloadFileInfo.getTextVersion());
        addressRepository.deltaClear();
        log.info("Очищены таблицы импорта дельты");
        File file = downloadsDelta(downloadFileInfo);
        log.info("Скачен архив");
        List<File> fileList = unrarFias(file);
        log.info("Распакован архив");
        loadFias(fileList);
        log.info("Файлы загружены в схему fias");
        lastVersion = addressRepository.applyVersion(downloadFileInfo.getVersionId(), downloadFileInfo.getTextVersion());
        addressRepository.fillAddressView();
        log.info("Применена версия №" + downloadFileInfo.getVersionId() + " " + downloadFileInfo.getTextVersion());
        f = false;
      }
    }

    if (f)
      log.info("Новых обновлений ФИАС не обнаружено");
  }


  private DownloadFileInfo getLastDownloadFileInfo() {
    if (service != null) {
      try {
        return service.getDownloadServiceSoap().getLastDownloadFileInfo();
      } catch (Exception ex) {
        log.error("Нет связи с сервером ФИАС, будут взяты локальные обновления.", ex);
      }
    }

    List<DownloadFileInfo> allDownloadFileInfoLocal = getAllDownloadFileInfoLocal();

    return allDownloadFileInfoLocal.get(allDownloadFileInfoLocal.size() - 1);
  }

  private List<DownloadFileInfo> getAllDownloadFileInfoLocal() {
    File[] files = directoryDestination.listFiles();
    if (files != null) {
      List<Integer> dirs = new ArrayList<>(files.length);
      for (File file : files) {
        if (file.isDirectory()) {
          int dir = Integer.parseInt(file.getName());
          dirs.add(dir);
        }
      }

      Collections.sort(dirs);

      List<DownloadFileInfo> list = new ArrayList<>(files.length);

      for (Integer dir : dirs) {
        DownloadFileInfo downloadFileInfo = new DownloadFileInfo();
        downloadFileInfo.setLocal(true);
        downloadFileInfo.setVersionId(dirs.get(dirs.size() - 1));
        downloadFileInfo.setFiasCompleteXmlUrl(Paths.get(directoryDestination.getAbsolutePath(), dir.toString()
            , DIR_NAME_COMPLETE, FILE_NAME_FIAS_XML).toString());
        downloadFileInfo.setFiasDeltaXmlUrl(Paths.get(directoryDestination.getAbsolutePath(), dir.toString()
            , DIR_NAME_DELTA, FIAS_DELTA_XML_RAR).toString());
        list.add(downloadFileInfo);
      }
      return list;
    }

    return new ArrayList<>();
  }

  private List<DownloadFileInfo> getAllDownloadFileInfo() {
    if (service != null) {
      try {
        return service.getDownloadServiceSoap().getAllDownloadFileInfo().getDownloadFileInfo();
      } catch (Exception ex) {
        log.error("Нет связи с сервером ФИАС, будут взяты локальные обновления.", ex);
      }
    }

    return getAllDownloadFileInfoLocal();
  }

  private File downloadsComplete(DownloadFileInfo downloadFileInfo) throws IOException {
    if (downloadFileInfo.getLocal()) {
      return new File(downloadFileInfo.getFiasCompleteXmlUrl());
    }

    File destination =
        Paths.get(directoryDestination.getAbsolutePath()
            , Integer.toString(downloadFileInfo.getVersionId())
            , DIR_NAME_COMPLETE).toFile();
    destination.mkdirs();
    destination = Paths.get(destination.getAbsolutePath(), FILE_NAME_FIAS_XML).toFile();
    if (!destination.exists()) {
      download(downloadFileInfo.getFiasCompleteXmlUrl(), destination);
    }
    return destination;
  }

  private File downloadsDelta(DownloadFileInfo downloadFileInfo) throws IOException {
    if (downloadFileInfo.getLocal()) {
      return new File(downloadFileInfo.getFiasDeltaXmlUrl());
    }

    File destination =
        Paths.get(directoryDestination.getAbsolutePath()
            , Integer.toString(downloadFileInfo.getVersionId())
            , DIR_NAME_DELTA
        ).toFile();

    destination.mkdirs();

    destination = Paths.get(destination.getAbsolutePath(), FIAS_DELTA_XML_RAR).toFile();
    download(downloadFileInfo.getFiasDeltaXmlUrl(), destination);
    return destination;
  }

  private List<File> unrarFias(File file) throws IOException, RarException {
    File parentFile = file.getParentFile();
    List<File> fileList = new ArrayList<>(20);

    Archive rar = new Archive(file);
    FileHeader fh = rar.nextFileHeader();
    while (fh != null) {
      File out = Paths.get(parentFile.getAbsolutePath(), fh.getFileNameString()).toFile();
      if (!out.exists()) {
        FileOutputStream os = new FileOutputStream(out);
        rar.extractFile(fh, os);
        os.close();
      }
      fileList.add(out);
      fh = rar.nextFileHeader();
    }

    // заплатка
    File[] files = parentFile.listFiles(new FilenameFilter() {
      @Override
      public boolean accept(File dir, String name) {
        return name.contains(".XML");
      }
    });

    for (File f : files) {
      if (!fileList.contains(f))
        fileList.add(f);
    }


    return fileList;
  }

  private void loadFias(List<File> files) throws Exception {
    final URL location = FiasUpdaterImpl.class.getClassLoader().getResource("script.xml");
    ExecutorService threads = Executors.newCachedThreadPool();

    List<Future<Boolean>> tasks = new ArrayList<>(files.size());

    for (int i = 0; i < files.size(); i++) {
      final File file = files.get(i);
      final EtlExecutor executor = etlExecutorBeans.get(i);
      final Logger logger = log;
      tasks.add(
          threads.submit(() -> {
            try {
              logger.info("\r\nСтарт загрузки файла " + file.getName() + " в " + new Date().toString());

              HashMap<String, Object> properties = new HashMap<>(2);

              String tableName = getTableName(file.getAbsolutePath());
              if (!tableName.equals("fias.")) {
                properties.put("table", tableName);
                properties.put("file", file.getAbsolutePath());

                ConfigurationFactory cf = new ConfigurationFactory();
                cf.setResourceURL(location);
                cf.setExternalParameters(properties);
                executor.setConfiguration(cf.createConfiguration());
                executor.execute();
              }

              logger.info("\r\nКонец загрузки файла " + file.getName() + " в " + new Date().toString());
            } catch (Exception e) {
              logger.error(e.getMessage(), e);
              return false;
            }
            return true;
          }));
    }

    for (Future<Boolean> task : tasks) {
      Boolean res = task.get();
      if (!res)
        throw new Exception("Не удалось загрузить файлы ФИАС");
    }


    threads.shutdown();
  }

  private String getTableName(String fileName) throws Exception {
    String schema = fileName.contains("complete") ? "fias" : DIR_NAME_DELTA;
    String table = "";
    if (fileName.contains("AS_ACTSTAT")) {
      table = "fias_actstat";
    }
    if (fileName.contains("AS_ADDROBJ")) {
      table = "fias_addrobj";
    }
    if (fileName.contains("AS_CENTERST")) {
      table = "fias_centerst";
    }
    if (fileName.contains("AS_CURENTST")) {
      table = "fias_curentst";
    }
    if (fileName.contains("AS_ESTSTAT")) {
      table = "fias_eststat";
    }
    if (fileName.contains("AS_HOUSE")) {
      table = "fias_house";
    }
    if (fileName.contains("AS_HOUSEINT")) {
      table = "fias_houseint";
    }
    if (fileName.contains("AS_HSTSTAT")) {
      table = "fias_hststat";
    }
    if (fileName.contains("AS_INTVSTAT")) {
      table = "fias_intvstat";
    }
    if (fileName.contains("AS_LANDMARK")) {
      table = "fias_landmark";
    }
    if (fileName.contains("AS_NDOCTYPE")) {
      table = "fias_ndoctype";
    }
    if (fileName.contains("AS_NORMDOC")) {
      table = "fias_normdoc";
    }
    if (fileName.contains("AS_OPERSTAT")) {
      table = "fias_operstat";
    }
    if (fileName.contains("AS_SOCRBASE")) {
      table = "fias_socrbase";
    }
    if (fileName.contains("AS_STRSTAT")) {
      table = "fias_strstat";
    }

    if (fileName.contains("AS_DEL_ADDROBJ")) {
      table = "fias_del_addrobj";
    }

    if (fileName.contains("AS_DEL_HOUSE")) {
      table = "fias_del_house";
    }
    if (fileName.contains("AS_DEL_HOUSEINT")) {
      table = "fias_del_houseint";
    }
    if (fileName.contains("AS_DEL_NORMDOC")) {
      table = "fias_del_normdoc";
    }

    return schema + "." + table;
  }

  private void download(String url, File directoryDestination) throws IOException {
    URL website = new URL(url);
    ReadableByteChannel rbc = Channels.newChannel(website.openStream());
    FileOutputStream fos = new FileOutputStream(directoryDestination);
    fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
  }

}
