rm(list=ls()) # clear all
##INSTALL AND LOAD LIBRARIES FOR R PACKAGES NEEDED TO RUN THIS CODE
if (!require('tidyverse')) install.packages('tidyverse'); library('tidyverse')
if (!require('readxl')) install.packages('readxl'); library('readxl')
if (!require('feather')) install.packages('feather'); library('feather')

setwd("/Users/mtmohr/Documents/Sparrow-BoiseState-IGL") #set Working directory where outputs go
FDT_directory <- "/Users/mtmohr/Documents/IGL redux/LAICPMS_example_FDTs" #sparrow directory
FDT_list_current <- list.files(FDT_directory, full.names = T, recursive = FALSE) #make a list of file names in the directory of choice, change recursive = TRUE if there are sub directories

if(file.exists("/Users/mtmohr/Documents/Sparrow-BoiseState-IGL/FDT_list_archive")){
  archive_status <- "present"
  load("/Users/mtmohr/Documents/Sparrow-BoiseState-IGL/FDT_list_archive")
  FDT_list_archive
}else{archive_status <- "absent"}

if(archive_status == "present"){FDT.list <- FDT_list_current[!(FDT_list_current %in% FDT_list_archive)]
FDT.list
}else{FDT.list <- FDT_list_current
FDT.list}
  
#NEW NAMES FOR COLUMNS THAT ARE R-FRIENDLY
FDT.col.names <- c('analysis', 'composition.U', 'composition.Th', 'composition.Pb', 'composition.ratio.ThU', 'composition.206Pbcps', 'composition.ratio.206Pb204Pb', 'composition.ratio.206Pb204Pb.1sigabs', 'isotope.ratio.208Pb232Th', 'isotope.ratio.208Pb232Th.2sigpercent', 'isotope.ratio.207Pb235U', 'isotope.ratio.207Pb235U.2sigpercent', 'isotope.ratio.206Pb238U', 'isotope.ratio.206Pb238U.2sigpercent', 'isotope.error.corr', 'isotope.ratio.238U206Pb', 'isotope.ratio.238U206Pb.2sigpercent', 'isotope.ratio.207Pb206Pb', 'isotope.ratio.207Pb206Pb.2sigpercent', 'date.208Pb232Th', 'date.208Pb232Th.2sigabs', 'date.208Pb232Th.2sigabs.sys', 'date.207Pb206Pb', 'date.207Pb206Pb.2sigabs', 'date.207Pb206Pb.2sigabs.sys', 'date.207Pb235U', 'date.207Pb235U.2sigabs', 'date.207Pb235U.2sigabs.sys', 'date.206Pb238U', 'date.206Pb238U.2sigabs', 'date.206Pb238U.2sigabs.sys', 'date.discordance.percent', 'date.discordance.percent.2sigpercent', 'P', 'Ti', 'Y', 'Nb', 'La', 'Ce', 'Pr',	'Nd',	'Sm',	'Eu',	'Gd',	'Tb',	'Dy',	'Ho',	'Er',	'Tm',	'Yb',	'Lu',	'Hf',	'Ta',	'Th',	'U', 'experiment')  

##IMPORT SAMPLES DATA
FDT.DF.samples <- lapply(FDT.list, function(i){
  zircon.samples <- data.frame(read_excel(i, sheet = 'Table S2 sample data', col_names = FALSE, range = 'A7:BE200')) #import sample data from FDT excel sheet
  zircon.samples <- zircon.samples[!is.na(zircon.samples$...2),] #remove rows with NA in the second column because they aren't analyses
  zircon.samples <- zircon.samples[-c(9)] #remove column 9 because it's empty
  colnames(zircon.samples) <- FDT.col.names #assign names to columns
  zircon.samples$type <- 'sample' #mark that this is a sample
  zircon.samples$FDT.file = i #add an attribute to the DF that tells you what file the analysis is in
  zircon.samples  # Return samples data
})
zircon.samples<-data.frame(bind_rows(FDT.DF.samples))
zircon.samples <- zircon.samples %>% separate(col = analysis, into = c('analysis', 'timestamp', 'other'), sep = "   ") 
zircon.samples$standard.type <- NA

##IMPORT STANDARDS DATA
FDT.DF.standards <- lapply(FDT.list, function(i){
  zircon.standards <- data.frame(read_excel(i, sheet = 'Table S3 standard data', col_names = FALSE, range = 'A7:BE200')) #import sample data from FDT excel sheet
  zircon.standards <- zircon.standards[!is.na(zircon.standards$...2),] #remove rows with NA in the second column because they aren't analyses
  zircon.standards <- zircon.standards[-c(9)] #remove column 9 because it's empty
  colnames(zircon.standards) <- FDT.col.names #assign names to columns
  zircon.standards$type <- 'standard' # mark that this is a standard
  zircon.standards$FDT.file = i #add an attribute to the DF that tells you what file the analysis is in
  zircon.standards  # Return standards data
})
zircon.standards<-data.frame(bind_rows(FDT.DF.standards))
zircon.standards <- zircon.standards %>% separate(col = analysis, into = c('analysis', 'timestamp', 'other'), sep = "   ") 
zircon.standards$standard.type <- ifelse(grepl('z', zircon.standards$analysis), 'primary', 'secondary')

zircon.output <- rbind(zircon.samples, zircon.standards)
zircon.output <- zircon.output[,c('analysis', 'timestamp','type', 'standard.type', 'composition.U', 'composition.Th', 'composition.Pb', 'composition.ratio.ThU', 'composition.206Pbcps', 'composition.ratio.206Pb204Pb', 'composition.ratio.206Pb204Pb.1sigabs', 'isotope.ratio.208Pb232Th', 'isotope.ratio.208Pb232Th.2sigpercent', 'isotope.ratio.207Pb235U', 'isotope.ratio.207Pb235U.2sigpercent', 'isotope.ratio.206Pb238U', 'isotope.ratio.206Pb238U.2sigpercent', 'isotope.error.corr', 'isotope.ratio.238U206Pb', 'isotope.ratio.238U206Pb.2sigpercent', 'isotope.ratio.207Pb206Pb', 'isotope.ratio.207Pb206Pb.2sigpercent', 'date.208Pb232Th', 'date.208Pb232Th.2sigabs', 'date.208Pb232Th.2sigabs.sys', 'date.207Pb206Pb', 'date.207Pb206Pb.2sigabs', 'date.207Pb206Pb.2sigabs.sys', 'date.207Pb235U', 'date.207Pb235U.2sigabs', 'date.207Pb235U.2sigabs.sys', 'date.206Pb238U', 'date.206Pb238U.2sigabs', 'date.206Pb238U.2sigabs.sys', 'date.discordance.percent', 'date.discordance.percent.2sigpercent', 'P', 'Ti', 'Y', 'Nb', 'La', 'Ce', 'Pr',	'Nd',	'Sm',	'Eu',	'Gd',	'Tb',	'Dy',	'Ho',	'Er',	'Tm',	'Yb',	'Lu',	'Hf',	'Ta',	'Th',	'U', 'experiment', 'FDT.file')]

zircon.output <- zircon.output %>%    
                  mutate_if(.predicate = is.numeric,
                            .funs = ~ case_when(abs(.x) > 100 ~ format(round(.x, 0), nsmall = 0),
                                                abs(.x) > 10 ~ format(round(.x, 1), nsmall = 1),
                                                abs(.x) > 1 ~ format(round(.x, 2), nsmall = 2),
                                                abs(.x) > 0.1 ~ format(round(.x, 3), nsmall = 3),
                                                abs(.x) > 0 ~ format(round(.x, 4), nsmall = 4)))


if(file.exists("/Users/mtmohr/Documents/IGL redux/Importers/IGL_LAICPMS.feather")){
  zircon.archive <- read_feather("/Users/mtmohr/Documents/IGL redux/Importers/IGL_LAICPMS.feather")
  IGL_LAICPMS.output <- rbind(zircon.output, zircon.archive)
  IGL_LAICPMS.output
}else{
  IGL_LAICPMS.output <- zircon.output
}

write_feather(IGL_LAICPMS.output, "IGL_LAICPMS.feather")

FDT_list_archive <- FDT_list_current
save(FDT_list_archive, file="/Users/mtmohr/Documents/Sparrow-BoiseState-IGL/FDT_list_archive")
