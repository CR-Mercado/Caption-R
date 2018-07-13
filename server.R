

# Define server logic 
shinyServer(function(input,output,session) {
  
  
  observeEvent(
    eventExpr = input[["submit"]],
    handlerExpr = {
      print("Running")
    }
  )
  
  # this starts once the "submit" button as been hit
  output$done <- eventReactive(input$submit,{ 
    
    #input the uploaded files
    inFiles <- input$the.files
    # read it from its location [NOTE: uploaded files create a data frame of columns: name,size, type, datapath]  in datapath 
    
    
    #move items "1-..." "2-..." ... "9-..." to the top 
    one.to.nine <- NULL   # this empty vector will be filled with the indexes for re-ordering
    for(i in 1:9){
      holder <- grep(paste0("^", # begins with 
                            i,   # relevant number
                            "-"), # and a dash
                     inFiles$name) # among the file names
      one.to.nine <- c(one.to.nine,holder)
    }
    inFiles <- rbind(inFiles[one.to.nine,],  # puts 1 through 9 on top
                     inFiles[-one.to.nine,]) # then puts the rest under it 
    
    # record file name + number of captions
    num.captions.table <- NULL
    
    # record chunk alone 
    captions.themselves <- NULL 
    
    for(i in 1:nrow(inFiles)){
      # these below will be replaced on each loop through
      the.text <- readLines(inFiles$datapath[i]) # read the i'th file 
      the.name <- inFiles$name[i]           # get the name of the file
      
      num.captions.table <- rbind(num.captions.table, # rowbind the existing table and
                                  chunks.counter(the.text, # count the chunks
                                                 the.name  # reference the name 
                                                  )
                                  )
      captions.themselves <- rbind(captions.themselves,     # rowbind the existing table
                                   splits.to.table(the.text)# and the chunks
                                   )  
    }
    colnames(num.captions.table) <- c("Slide Name","Number of Captions")
    
    # write a excel open-able csv named "N-captions table.csv" where N is number of slides
    write.csv(num.captions.table, file = paste0(nrow(inFiles),
                                                "- ",
                                                "number of captions table.csv"))
    
    # write an excel open-able csv of all the captions (a header is included) 
    colnames(captions.themselves) <- "Captions in Order"
    write.csv(captions.themselves, file = paste0(nrow(inFiles),"- ",
                                                 "all captions in column.csv"))
    
    return("process complete, please check for errors.")
  })
  
  #remove the 4#'s later 
  #session$onSessionEnded(function() {
  #  stopApp()
  #  q("no")
  #})
})



##############################

chunks.counter <- function(chunked.output,name.of.file,separator = "          "){
  # this function takes a chunked output and counts how many chunks there are
  # it spits out the name of the file and the number of chunks required 
  # 
  #
  numchunks <- length(strsplit(chunked.output, paste0(separator," "))[[1]])
  
  return(c(name.of.file, numchunks)) #returns a class character vector. Which is easy to rbind 
}

###############################

splits.to.table <- function(chunked.output, separator = "          "){ #reuse the separator from previous function - default 10 
  # 
  #
  numchunks <- length(strsplit(chunked.output, paste0(separator," "))[[1]])  # this is copied from the previous function but it is not used
  # as a return here 
  #it does output as integer
  chunk.matrix <- matrix(strsplit(chunked.output,paste0(separator, " "))[[1]][1:numchunks]) 
  
  # Be careful changing the default separations because this sub will have separator # of spaces / 2 on all non chunk 1. 
  # this shrinks extra spaces down to 1 by repeatedly removing back to back spaces
  chunk.matrix <- gsub("  ","",chunk.matrix)
  chunk.matrix <- gsub("\n","",chunk.matrix, fixed = TRUE)
  
  return(chunk.matrix)
}







