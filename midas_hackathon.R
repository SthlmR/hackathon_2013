library(Coldbir)
library(data.table)
library(ggplot2)

# Create connection to MiDAS DB
midasdb <- cdb("~/Desktop/MidasDEMO/")

# Which rows to select
alive_persons <- midasdb["ID"][midasdb["DEATHYEAR"] == 0]
person_sample <- alive_persons[sample(1:length(alive_persons),100000)]

# Look at data
get_vars(midasdb)

# Get data
pensions <- data.table(
	sex = midasdb["SEX"][person_sample],
	byear = midasdb["BIRTHYEAR"][person_sample],
	cvd = midasdb["CVD",2011][person_sample],
	utb = midasdb["UTB",2011][person_sample],
	rownr = midasdb["ID"][person_sample],
	G37 = midasdb["G37",2011][person_sample],
	G38 = midasdb["G38",2011][person_sample],
	I38 = midasdb["I38",2011][person_sample],
	T37 = midasdb["T37",2011][person_sample],
	T38 = midasdb["T38",2011][person_sample],
	BT = midasdb["BT",2011][person_sample],
	AFS = midasdb["AFS",2011][person_sample],
	PFO = midasdb["PFO",2011][person_sample],
	EL = midasdb["EL",2011][person_sample]
)

pensions[,tot_pension := sum(
	G37, G38, I38, T37, T38, BT, AFS, PFO, EL, na.rm=TRUE
), by=rownr]

pensions <- pensions[tot_pension != 0]

# Graphic analysis
ggplot(pensions,aes(x=tot_pension,fill=sex)) + geom_density() + xlim(0,20000)
