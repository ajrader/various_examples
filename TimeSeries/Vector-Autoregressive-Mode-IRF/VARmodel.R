### This code will perform Vector Autoregressive model. It takes multiple time series and determines if the shock in one creates a shock in the others. 
### The program with this setup takes two time series per state in the US and estimates the IRF's coefficient, lower bound and upper bound.
### According to Zhang and Chen (2009) in Ecological Economics, the IRF explains how a shock to one varialble affects another variable and 
### how long the effect lasts in the short run.


library(tseries)
library(forecast)
library(urca)
#library(dse)
library(vars)
library(xts)
# i=1


dd <- data.frame(State = character() , Actual = integer() , 
                 Lower = integer() , Upper = integer() , 
                 Sig = integer(), stringsAsFactors=FALSE) # Creates a data fraame to be used for writing the output.


dataVar=read.csv("HOW Data.csv", header=TRUE)

for(i in seq(1, 2860, 57)){
  tryCatch({  # Skips the error if Chelosky's decomposition does not return value.
    
    newdata <- dataVar[which(dataVar$STATE==dataVar$STATE[i]),] # Selects the data for State i.
    timeData <- ts(data = newdata, start = c(2011,1), 
                   end = c(2015,9), frequency = 12, deltat = 1,
                   ts.eps = getOption("ts.eps"), class = c("mts", "ts", "matrix")) # Creates time series class.
    
    timeData2 <- timeData[, c("PIF", "Reported.Count")] 
    #adf1 <- summary(ur.df(timeData2[, "PIF"], type = "trend", lags = 2)) # For diagnostic purposes. 
    #adf2 <- summary(ur.df(timeData2[, "Reported.Count"], type = "trend", lags = 2)) # For diagnostic purposes. 
    
    #VARselect(timeData2, lag.max = 30, type = "both") # Use to determine the number of lags to be used in the VAR model.
    VAR <- VAR(timeData2,type = "both", p=13) # Runs the VAR model
    
    # summary(VAR, equation="Reported.Count")  
    # norm1 <- normality.test(VAR)
    # norm1$jb.mul
    irf <- irf(VAR, impulse= "PIF", response="Reported.Count", boot = TRUE, cumulative=TRUE, ortho=TRUE, ci=0.90, n.ahead=3) # Performs IRF on the VAR model.
    #plot.ts(timeData2) # Plots multiple time series.
    #plot(irf(VAR, impulse= "PIF", response="Reported.Count", boot = TRUE, cumulative=TRUE, ortho=TRUE, ci=0.90, n.ahead=3)) # Plots the estimated coefficient and CI.
    
    Actual <- irf[1]$irf$PIF[1] # Actual IRF for 1 step ahead
    Lower <- irf[2]$Lower$PIF[1] # Lower IRF for 1 step ahead
    Upper <- irf[3]$Upper$PIF[1] # Higher IRF for 1 step ahead
    Sig <- ifelse(sign(Lower) == sign(Upper),1,0) # Determines if the association between the series significant. 0 is not significant.
    
    actual <- c("Actual", Actual)
    lower <- c("Lower", Lower)
    upper <- c("Upper", Upper)
    sig <- c("Significant", Sig)
    dd[i,] <- data.frame(dataVar$STATE[i], Actual,Lower, Upper,Sig) 
    # print(i)
    
  }, error=function(e){})
  
}

write.csv(dd[complete.cases(dd),], "outVAR.csv")
