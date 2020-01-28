-- *********** DEMO. Встроенная JAVA в Oracle ****************

-- Версия JAVA
select  dbms_java.get_ojvm_property(propstring=>'java.version') from dual

--------- Пример 1. Простой класс INFO о системе

-- 1. Создаем класс
create or replace and compile java source named "SystemInfo" as
public class SystemInfo {
   
  public static String getOsVersion(){
    return System.getProperty("os.name");    
  }
  
  public static String getJvmVersion(){
    return System.getProperty("java.vm.version");
  }
}
;
/

-- 2. Определения для вызова JAVA-класса
create or replace function get_os_version return varchar2 as
  language java name 'SystemInfo.getOsVersion() return java.lang.String';
/
create or replace function get_jvm_version return varchar2 as
  language java name 'SystemInfo.getJvmVersion() return java.lang.String';
/

-- 3. Вызываем функции
select get_os_version(),
       get_jvm_version()
  from dual;


-------- Пример 2. TimeBased GUID

-- взять исходники из папки java_guid

-- тестируем функционал
declare
  v_guid varchar2(100 char);
  v_date date;
begin
  --- генерация гуида (из sysdate)
  v_guid := guid_pack.get_new_guid();
  dbms_output.put_line('New guid: '|| v_guid); 
  
  v_date := guid_pack.get_date_from_guid(v_guid);
  dbms_output.put_line('From guid: '||to_char(v_date,'dd.mm.YYYY hh24:mi:ss') ); 

  dbms_output.put_line('');
  
  --- генерация гуида (из указанной даты)  
  v_guid := guid_pack.get_new_guid(pi_date => trunc(sysdate, 'YYYY')+1/24/60);
  dbms_output.put_line('New guid: '|| v_guid); 
  
  v_date := guid_pack.get_date_from_guid(v_guid);
  dbms_output.put_line('From guid: '||to_char(v_date,'dd.mm.YYYY hh24:mi:ss') ); 
  
end;
/

