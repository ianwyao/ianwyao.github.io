#install.packages('arrow')
#install.packages('r2d3')
library('arrow')
library('r2d3')

dat = arrow::read_parquet('power.parquet')

##
dat$date <- as.Date(dat$datetime)
dat2 <- aggregate(dat$Global_active_power, by=list(dat$date), sum)
colnames(dat2) <- c("Date", "Global_active_power")


