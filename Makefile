include ./Makefile.common


all: sparkpipe_java
	@echo "================================================================================"
	@echo "The Program has been compiled."
	@echo "Location    = $(LOCATION)/$(BUILD_DIR)/"
	@echo "JAVA_HOME   = $(JAVA_HOME)"
	@echo "HADOOP_HOME = $(HADOOP_HOME)"
	@echo "SPARK_HOME = $(SPARK_HOME)"
	@echo "================================================================================"

ckdir:
	if [ ! -d "$(BUILD_DIR)" ]; then mkdir $(BUILD_DIR); fi

download:
	if [ ! -f "$(LIBS_DIR)/spark-assembly-1.6.2-hadoop2.6.0.jar" ]; then \
	cd $(LIBS_DIR) && wget $(SPARK_URL) && tar xzvf $(SPARK_PACKAGE) && cp spark-1.6.2-bin-hadoop2.6/lib/spark-assembly-1.6.2-hadoop2.6.0.jar ./ && rm -Rf spark-1.6.2-bin-hadoop2.6 && rm $(SPARK_PACKAGE) && cd ..; \
	fi
sparkpipe_java: download ckdir
	$(JAVAC) -cp $(JAR_FILES) -d $(BUILD_DIR) -Xlint:none $(SRC_DIR)/*.java
	cd $(BUILD_DIR) && $(JAR) cfe SparkPipe.jar SparkPipe ./*.class && cd ..

clean:
	$(RMR) $(BUILD_DIR)
