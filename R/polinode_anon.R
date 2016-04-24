###############################################
# script to anonymize survey responses from Polinode
# author: Richard Vidgen, UNSW
# date: 24 April 2016
###############################################

# set directory to where the SURVEY download file is
setwd("/Users/richardvidgen/Dropbox/_RICHARD/RdataRV/Polinode")
getwd()

# set input and ouput excel file names
infile = "UNSW lecture test 4.xlsx"
outfile = "networkout.xlsx"

# set node and edge sheet names
nodesheet = "Node Attributes" # this is the same for all excel survey downloads
edgesheet = "Relationship Question 1" # this changes and there can be more than one to choose from

library(xlsx)
library(plyr)
library(random)

##
# no further editing of script required from here on
##

# read the nodes
nodes <- read.xlsx(infile, sheetName=nodesheet, as.data.frame=TRUE, stringsAsFactors=F)
nodes

# generate unique random codes
rand = randomStrings(n=nrow(nodes), len=5, digits=TRUE, upperalpha=TRUE,
                     loweralpha=TRUE, unique=TRUE, check=TRUE)
str(rand)
nodes$uniqueid = as.vector(rand)
nodes
str(nodes)

# make a key list
keylist = subset(nodes, select=c(Name, uniqueid))
keylist

# read edges
edges <- read.xlsx(infile, sheetName=edgesheet, as.data.frame=TRUE, stringsAsFactors=F)
edges

# merge random code for Source
edges = merge(edges, nodes, by.x=c("Source"), by.y=c("Name"))
edges

# merge random code for Target
edges = merge(edges, nodes, by.x=c("Target"), by.y=c("Name"))
edges
str(edges)

# now make nodes anonymous by removing Name
nodesanon = subset(nodes, select=-c(Name))
nodesanon
str(nodesanon)

# rename unique id as Name
nodesanon = rename(nodesanon, c("uniqueid"="Name"))
nodesanon
str(nodesanon)

# make edges anonymous
edgesanon = subset(edges, select=-c(Source, Target))
edgesanon
str(edgesanon)

# rename to Source and Target
edgesanon = rename(edgesanon, c("uniqueid.x"="Source", "uniqueid.y"="Target"))
edgesanon
str(edgesanon)

# write out new NETWORK file
write.xlsx(nodesanon, outfile, sheetName="Nodes",
           col.names=TRUE, row.names=F, )
write.xlsx(edgesanon, outfile, sheetName="Edges",
           col.names=TRUE, row.names=F, append=T)
write.xlsx(keylist, outfile, sheetName="Keylist",
           col.names=TRUE, row.names=F, append=T)
