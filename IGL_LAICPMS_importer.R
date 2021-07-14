rm(list=ls()) # clear all
##INSTALL AND LOAD LIBRARIES FOR R PACKAGES NEEDED TO RUN THIS CODE
if (!require('tidyverse')) install.packages('tidyverse'); library('tidyverse')
if (!require('readxl')) install.packages('readxl'); library('readxl')
if (!require('reshape2')) install.packages('reshape2'); library('reshape2')
if (!require('MASS')) install.packages('MASS'); library('MASS')
if (!require('feather')) install.packages('feather'); library('feather')

##SPECIFY THE DIRECTORY YOU WANT THE VISUALIZATIONS TO BE SAVED TO
setwd("/Users/mtmohr/Documents/IGL redux/Hulett/plots")
vis.output <- getwd()
FDT.folder <- "/Users/mtmohr/Documents/IGL redux/Hulett/FDTs"

##IMPORT DATA FROM .CSV
FDT.list <- list.files(FDT.folder, full.names = T) #make a list of file names in the directory of choice
FDT.list #show list of file names

#NEW NAMES FOR COLUMNS THAT ARE R-FRIENDLY
FDT.col.names <- c('analysis', 'composition.U', 'composition.Th', 'composition.Pb', 'composition.ratio.ThU', 'composition.206Pbcps', 'composition.ratio.206Pb204Pb', 'composition.ratio.206Pb204Pb.1sigabs', 'isotope.ratio.208Pb232Th', 'isotope.ratio.208Pb232Th.2sigpercent', 'isotope.ratio.207Pb235U', 'isotope.ratio.207Pb235U.2sigpercent', 'isotope.ratio.206Pb238U', 'isotope.ratio.206Pb238U.2sigpercent', 'isotope.error.corr', 'isotope.ratio.238U206Pb', 'isotope.ratio.238U206Pb.2sigpercent', 'isotope.ratio.207Pb206Pb', 'isotope.ratio.207Pb206Pb.2sigpercent', 'date.208Pb232Th', 'date.208Pb232Th.2sigabs', 'date.208Pb232Th.2sigabs.sys', 'date.207Pb206Pb', 'date.207Pb206Pb.2sigabs', 'date.207Pb206Pb.2sigabs.sys', 'date.207Pb235U', 'date.207Pb235U.2sigabs', 'date.207Pb235U.2sigabs.sys', 'date.206Pb238U', 'date.206Pb238U.2sigabs', 'date.206Pb238U.2sigabs.sys', 'date.discordance.percent', 'date.discordance.percent.2sigpercent', 'P', 'Ti', 'Y', 'Nb', 'La', 'Ce', 'Pr',	'Nd',	'Sm',	'Eu',	'Gd',	'Tb',	'Dy',	'Ho',	'Er',	'Tm',	'Yb',	'Lu',	'Hf',	'Ta',	'Th',	'U', 'experiment')  

##IMPORT SAMPLES DATA
FDT.DF.samples <- lapply(FDT.list, function(i){
  zircon.samples <- data.frame(read_excel(i, sheet = 'Table S2 sample data', col_names = FALSE, range = 'A7:BE200')) #import sample data from FDT excel sheet
  zircon.samples <- zircon.samples[!is.na(zircon.samples$...2),] #remove rows with NA in the second column because they aren't analyses
  zircon.samples <- zircon.samples[-c(9)] #remove column 9 because it's empty
  colnames(zircon.samples) <- FDT.col.names #assign names to columns
  zircon.samples$type <- 'sample'
  zircon.samples$FDT.file = i #add an attribute to the DF that tells you what file the analysis is in
  zircon.samples  # Return samples data
})
zircon.samples<-data.frame(bind_rows(FDT.DF.samples))
zircon.samples <- zircon.samples %>% separate(col = analysis, into = c('sample', 'grain.size', 'spot.number'), sep = "_") 
zircon.samples$standard_type <- NA

##IMPORT STANDARDS DATA
FDT.DF.standards <- lapply(FDT.list, function(i){
  zircon.standards <- data.frame(read_excel(i, sheet = 'Table S3 standard data', col_names = FALSE, range = 'A7:BE200')) #import sample data from FDT excel sheet
  zircon.standards <- zircon.standards[!is.na(zircon.standards$...2),] #remove rows with NA in the second column because they aren't analyses
  zircon.standards <- zircon.standards[-c(9)] #remove column 9 because it's empty
  colnames(zircon.standards) <- FDT.col.names #assign names to columns
  zircon.standards$type <- 'standard'
  zircon.standards$FDT.file = i #add an attribute to the DF that tells you what file the analysis is in
  zircon.standards  # Return standards data
})

zircon.standards<-data.frame(bind_rows(FDT.DF.standards))
zircon.standards <- zircon.standards %>% separate(col = analysis, into = c('sample', 'spot.number'), sep = "_")
zircon.standards$grain.size <- NA
zircon.standards$standard_type <- ifelse(zircon.standards$sample == 'PL', 'primary', 'secondary')

zircon.output <- rbind(zircon.samples, zircon.standards)

write_feather(zircon.output, "IGLoutput.feather")
