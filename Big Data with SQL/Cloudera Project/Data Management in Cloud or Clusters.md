Assignment:

Create a table named tbm_sf_la in the database named dig to store the data from three tunnel boring machines (TBMs), which is currently stored in S3 in three separate subdirectories under a directory named tbm_sf_la in the bucket named training-coursera2. In this document, describe the steps taken to complete this task.
Solution
I performed the following steps to complete this task:

1.	Data Exploration: 

  a- listing the Subdirectory contents using the command (ls)
      $ hdfs dfs -ls s3a://training-coursera2/tbm_sf_la/

  b- Writing a “cat” and the “head” command to explore the contents of each file in their directories:

      Shai-Hulud: 
      hdfs dfs -cat s3a://training-coursera2/tbm_sf_la/central/hourly_central.csv|head
      
      Bertha II: 
      hdfs dfs -cat s3a://training-coursera2/tbm_sf_la/north/hourly_north.csv|head
      
      Diggy McDigface:
      hdfs dfs -cat s3a://training-coursera2/tbm_sf_la/south/hourly_south.tsv|head

2.	Create Table:

In HUE I ran SQL command

      CREATE DATABASE IF NOT EXISTS dig;

      
      Central Table: 
      CREATE table IF NOT EXISTS tbm_sf_la_central (
          tbm STRING,
          year SMALLINT,
          month TINYINT,
          day TINYINT,
          hour TINYINT,
          dist DECIMAL(8,2),
          long DECIMAL(9,6),
          lat DECIMAL(9,6)
      )
      ROW FORMAT DELIMITED
          FIELDS TERMINATED BY ','
      STORED AS TEXTFILE
      LOCATION 's3a://training-coursera2/tbm_sf_la/central/'
      TBLPROPERTIES 
      ('skip.header.line.count' = '1',
      'serialization.null.format' = '999999')
      ;

North Table:

      CREATE table IF NOT EXISTS tbm_sf_la_north (
          tbm STRING,
          year SMALLINT,
          month TINYINT,
          day TINYINT,
          hour TINYINT,
          dist DECIMAL(8,2),,
          long DECIMAL(9,6),
          lat DECIMAL(9,6)
      )
      ROW FORMAT DELIMITED
          FIELDS TERMINATED BY ','
      STORED AS TEXTFILE
      LOCATION 's3a://training-coursera2/tbm_sf_la/north/'
      TBLPROPERTIES ('serialization.null.format' = '\N')
      ;

South Table:

      CREATE table IF NOT EXISTS tbm_sf_la_south (
          tbm STRING,
          year SMALLINT,
          month TINYINT,
          day TINYINT,
          hour TINYINT,
          dist DECIMAL(8,2),
          long DECIMAL(9,6),
          lat DECIMAL(9,6)
      )
      ROW FORMAT DELIMITED
          FIELDS TERMINATED BY '\t'
      STORED AS TEXTFILE
      LOCATION 's3a://training-coursera2/tbm_sf_la/south/'
      TBLPROPERTIES 
      ('serialization.null.format' = '\N')
      ;

3.	Load the Data into the Table

        CREATE TABLE IF NOT EXISTS tbm_sf_la as
        
        SELECT * FROM tbm_sf_la_central
        
        UNION ALL
        
        SELECT * FROM tbm_sf_la_north
        
        UNION ALL
        
        SELECT * FROM tbm_sf_la_south ;
