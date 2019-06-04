# Indicamos los parametros para spark
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "/opt/spark-2.2.0/")
}

library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))

sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "1g"),enableHiveSupport=FALSE)

# Instalamos la version de spark
spark_install(version = "2.2.0")
sc <- spark_connect(master = "local", version = "2.2.0")
library(sparklyr)
library(dplyr)
# Leemos los datos
df <- spark_read_csv(sc, 
                       name="df", 
                       path="hdfs://hadoop-master/user/mp2019/ECBDL14_10tst.data", 
                       delimiter = ",", 
                       header=TRUE,
                       overwrite = TRUE)
# Vemos la cantidad de datos
count(df)
# Nos quedamos con las cinco primeras columnas y la de clase
df_filtered <- select(df, f1,f2,f3,f4,f5,class)
# Vemos la cantidad de entradas que hay
num_regs <- as.integer(collect(count(df)))
# Vemos el porcentaje de cada clase
summarize( group_by(df,class), count = n(), percent= n()/num_regs *100.0)
# Nos quedamos con el número de entradas de la clase minoritaria
regs_minor <- df %>% 
  filter(class==1) %>% 
  count %>%
  collect %>% 
  as.integer
# Creamos un dataset solo con la clase 0 y haciendo undersampling
only_class_0 <- df %>% 
  filter(class==0) %>%
  sdf_sample(regs_minor, fraction=as.double(regs_minor/as.integer(collect(count(df)))))
# Creamos un dataset solo con la clae 1
only_class_1 <- df %>% 
  filter(class==1)
# Vemos el tamaño de cada dataset
count(only_class_0)
count(only_class_1)
# Unimos los datasets
ds_ml <- rbind(only_class_1,only_class_0, name="ds_ml")
count(ds_ml)
# Creamos una particion en la que eñ 80% es para training y el 20% para test
partitions <- sdf_random_split(ds_ml,training=0.80,test=0.20)
count(partitions$test)
count(partitions$training)

# Modelo de regresión logística
ml_logv1 <- partitions$training %>%
  ml_logistic_regression(response = "class", features = c("f1","f2","f3","f4","f5"),iter.max = 100L)
ml_logv2 <- partitions$training %>%
  ml_logistic_regression(response = "class", features = c("f1","f2","f3","f4","f5"),iter.max = 200L)

# Modelo de random forest
ml_rfv1 <- ml_random_forest(partitions$training,response="class",features=c("f1","f2","f3","f4","f5"),num.trees = 20,type = "classification")
ml_rfv2 <- ml_random_forest(partitions$training,response="class",features=c("f1","f2","f3","f4","f5"),num.trees = 30,type = "classification")

# Modelo de decision tree
ml_dtv1 <- ml_decision_tree(partitions$training, response="class", features=c("f1","f2","f3","f4","f5"),type = "classification", max.depth = 5L )
ml_dtv2 <- ml_decision_tree(partitions$training, response="class", features=c("f1","f2","f3","f4","f5"),type = "classification", max.depth = 8L )

# Guardamos los tres modelos en una lista
ml_models <- list(
  "Logistic v1" = ml_logv1,
  "Logistic v2" = ml_logv2,
  "Decision tree v1" = ml_dtv1,
  "Decision tree v2" = ml_dtv2,
  "Random Forest v1" = ml_rfv1,
  "Random Forest v2" = ml_rfv2
)

# Creamos una funcion para comprobar el accuracy de cada modelo
score_test_data <- function(model, data=partitions$test){
  # Realizamos la prediccion
  pred <- ml_predict(model, data)
  # Nos quedamos con las columnas de clase y prediccion
  dfp <- select(pred, class, prediction)
  # Calculamos la cantidad de entradas que hay en el dataset
  n <- collect(count(dfp),n)$n[1]
  # Realizamos una tabla que muestra la cantidad de aciertos y fallos
  tf <- count(dfp,class==prediction)
  # Nos quedamos con los aciertos
  correct <- collect(tf,n)$n[2]
  # Devolvemos el porcentaje de acierto
  correct/n
}

# Usamos la funcion con los modelos guardados
ml_score <- lapply(ml_models, score_test_data)

ml_score
