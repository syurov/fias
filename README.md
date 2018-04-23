# Обновление ФИАС (Федеральная информационная адресная система)

**Проект предназначен для ведения локальной БД 
https://www.nalog.ru/rn77/service/fias/ <br/>
FIAS on postgresql**

**Реализованные функции:**
1. При старте программы на пустой БД с помощью liquibase создается вся необходимая структура БД
2. Реализован контроллер со следующими функциями: <br/>
   2.1 Загрузка БД ФИАС <br/>
   2.2 Обновление БД ФИАС путем загрзки всех изменений начиная с текущей версии до последней с сайта ФИАС (функция в тестировании)<br/>
   2.3 Методы для доступа к адресной информации (в разработке) 

**Настройка проекта:**

1. Добавить файл  _tomcat/Context.xml_
   В нем прописать dataSource к БД и папку для хранения загруженных файлов от ФИАС
   
   `<?xml version='1.0' encoding='utf-8'?>
    <Context>
      <Resource name="jdbc/ds" auth="Container"
                type="javax.sql.DataSource"
                driverClassName="org.postgresql.Driver"
                url="jdbc:postgresql://localhost:5432/db"
                username="postgres" password="*****"
                defaultAutoCommit="true"
                accessToUnderlyingConnectionAllowed="true"
                maxActive="50" maxIdle="50" maxWait="10000"
                validationQuery="select 1"
                removeAbandoned="true"
                removeAbandonedTimeout="60" logAbandoned="true"
                poolPreparedStatements="true"
      />
    
      <Environment name="exchange/loadFolder" value="D:\workingExchange\in" type="java.lang.String" override="false"/>
    </Context>
`
**Сборка проекта:**

1. Выполнить **mvn clean install** файла  pom.xml

**Запуск проекта из IDE**
1. Выполнить в fias-server-app **tomcat7:run**
2. Выполнить запрос http://localhost:9118/server/api/fias/reload/ для старта загрузки
Примечание если в папку _workingExchange\in\fias\436\complete_  (436 номер текущей версии ФИАС) 
скачать архив и распоковать его там же, программа пропусит шаги скачитвания и разархивирования. На практике winrar распаковывает быстрее чем библиотеки java  

