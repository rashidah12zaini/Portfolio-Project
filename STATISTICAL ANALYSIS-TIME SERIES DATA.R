#To import the data from csv
Demand_for_Roses<-read.csv(file.choose(),header=TRUE)
str(Demand_for_Roses)

#To change the data frame to time series data frame 
Demand_for_Roses<- ts (Demand_for_Roses,start =1971.3,frequency =1)
str(Demand_for_Roses)

Demand_for_Roses [,-1]
plot (Demand_for_Roses[,-1], main = "Plotting for All Variables over Times (1971-1975)")

#-------------------------------------------------------------------------------

#to fit linear regression model to the data
library(dynlm)

Function_1<- dynlm(Y~X2+X3+X4 ,data =Demand_for_Roses)
summary (Function_1)

#to check for the presence of multicollinearity

#use cor() to obtain the pairwise correlation among the variable 
#cor(Demand_for_Roses[,-1])

library(car)
library(carData)
vif(Function_1)

tol<-1/vif(Function_1)
tol

#to test for autocorrelation
library(lmtest)
dwtest(Function_1)

#to test for heterocedasticity
bptest(Function_1)



#--------------------------------------------------------------------------------
#DROP X4 FROM FUNCTION_1

Function_2<- dynlm(Y~X2+X3 ,data =Demand_for_Roses)
summary (Function_2)

#to check for the presence of multicollinearity

#use cor() to obtain the pairwise correlation among the variable 
#cor(Demand_for_Roses[,-1])

library(car)
library(carData)
vif(Function_2)

tol<-1/vif(Function_2)
tol

#to test for autocorrelation
library(lmtest)
dwtest(Function_2)

#to test for heterocedasticity
bptest(Function_2)


#-------------------------------------------------------------------------------

#ADD LOG TO FUNCTION 1
Function_3<- dynlm(log(Y)~log(X2)+log(X3)+log(X4) ,data =Demand_for_Roses)
summary (Function_3)

#to check for the presence of multicollinearity

#use cor() to obtain the pairwise correlation among the variable 
#cor(Demand_for_Roses[,-1])

library(car)
library(carData)
vif(Function_3)

tol<-1/vif(Function_3)
tol

#to test for autocorrelation
library(lmtest)
dwtest(Function_3)

#to test for heterocedasticity
bptest(Function_3)

#-------------------------------------------------------------------------------

#ADD LOG TO FUNCTION 2

Function_4<- dynlm(log(Y)~log(X2)+log(X3) ,data =Demand_for_Roses)
summary (Function_4)

#to check for the presence of multicollinearity

#use cor() to obtain the pairwise correlation among the variable 
#cor(Demand_for_Roses[,-1])

library(car)
library(carData)
vif(Function_4)

tol<-1/vif(Function_4)
tol

#to test for autocorrelation
library(lmtest)
dwtest(Function_4)

#to test for heterocedasticity
bptest(Function_4)

