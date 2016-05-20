hadoop fs -rm -r h2o_outputs
hadoop jar h2o/h2o-2.9.0.1676/hadoop/h2odriver_cdh5.jar water.hadoop.h2odriver -libjars h2o/h2o-2.9.0.1676/h2o.jar -mapperXmx 30g -nodes 30 -output h2o_outputs
