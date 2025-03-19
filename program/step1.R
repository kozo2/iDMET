rm(list=ls(all=TRUE))

url <- "https://github.com/riramatsuta/iDMET/archive/refs/heads/main.zip"
download.file(url, destfile = "iDMET.zip", mode = "wb")
unzip("iDMET.zip", exdir = "unzipped_folder")

#----------------
#  Step 1 
#----------------
# metabolite name dicitonary upload
file <- "./unzipped_folder/iDMET-main/program/metabodic.csv"
K <- read.csv(file)[,c(1,2)]

# list of csv files (metabolomic data)
# path <- "./data/csv_set1"       # data set 1
path <- "./data/csv_set2"         # data set 2

path <- "./unzipped_folder/iDMET-main/dataset 1"

# ----------------------------
#   matchings
# ----------------------------
ALL <- NULL
k <- 1
L <- list.files(path = path, recursive = TRUE, full.names = TRUE)

for(i in 1:length(L)){

  # csv files
  D <- read.csv(L[i], header=TRUE)[-1,]
  
  # metabolite name
  M <- as.character(D[,1]) 

   # matching with metabolite dictionary
   MT <- as.numeric(matrix(NA,length(M)))
   for(k in 1:length(M)){    # metabolite name of differential data
     
      for(j in 1:nrow(K)){       # metabolite name of dictionary
      a <- as.character(K[j,2])  
      b <- strsplit(a,";")[[1]]   # each splitted metabolite name of dictionary
        for(l in 1:length(b)){
        if (tolower(M[k])==tolower(b[l])){  
          MT[k] <- as.character(K[j,1])
        }
      }
    }
  }
  
  index <- !is.na(MT)
  all <- cbind(MT,D)[index,]
  # all of differential table
  ALL[i] <- list(all)
}

names(ALL) <- L

# ----------------
#   data save
# ----------------

save(ALL,file = "ALL.RData")

