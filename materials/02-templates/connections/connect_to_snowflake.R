#CONNECT TO SNOWFLAKE 

library("rJava")
library("RJDBC")
library("dplyr.snowflakedb")

#location of jdbc jar file 
jdbc_loc <- "/Users/tania.jogesh/Downloads/snowflake-jdbc-3.9.2.jar"
pwd <- key_get("snowflake")
username <- "tjogesh"
db <- ""

options(dplyr.jdbc.classpath = jdbc_loc)
jdbcDriver <- JDBC(driverClass = "com.snowflake.client.jdbc.SnowflakeDriver", 
                   classPath = jdbc_loc)

my_db <- src_snowflakedb(user = username,
                         password = pwd,
                         account = "ccsf",
                         host = "ccsf.us-gov-virginia.azure.snowflakecomputing.com",
                         opts = list(database = db,
                                   warehouse = "LOAD_WH",
                                   role = "SYSADMIN",
                                   schema = "DEV"))



db_conn <- dbConnect(jdbcDriver, "jdbc:snowflake://ccsf.us-gov-virginia.azure.snowflakecomputing.com/?account=ccsf&database=POLICE_CALLS_FOR_SERVICE&warehouse=LOAD_WH&role=SYSADMIN&schema=DEV", 
                            User = username, 
                            Password = pwd)


result <- dbGetQuery(db_conn, "select current_timestamp() as now")
print(result)




