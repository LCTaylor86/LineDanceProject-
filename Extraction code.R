library("rvest")
library("stringr")
library("robotstxt")

all_ld <- vector('character')

for (i in seq(0, 93120, by= 20)) {

url <- paste0('https://www.copperknob.co.uk/search.aspx?Order=Alphabetical&Lang=Any&SearchType=Title&Level=Any&Beat=-1&Wall=-1&Search=&recnum=', i)

line_dance_websites <- read_html(url) %>%
                          html_nodes('div') %>%
                          html_attr("onclick") %>%
                          str_extract("http[s]?://www.copperknob.co.uk/stepsheets/(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+.aspx") %>% 
                          na.omit() %>%
                          str_trim(side="both")

all_ld<- c(all_ld, line_dance_websites)

print(i)
Sys.sleep(0.01)
flush.console()
}


all_ld_2<-all_ld[57461:93139]


info<-vector('character')

for (i in all_ld_2) {
  
  url <- i
  
  line_dance_info <- read_html(url) %>%
    html_nodes('div:nth-child(15), #sheetinfo tr:nth-child(1) div+ div, #musicinfo, #chorinfo')%>%
    html_text(trim = TRUE) 
  
  x <- as.data.frame(line_dance_info[1:6], row.names = c('LD_name', 'Count', 'Wall', 'Level', 'Choreographer', 'Music'))

  info<-rbind(info, t(x))
  
  rownames(info) <- NULL
  
  require(svMisc)
  print(i)
  Sys.sleep(0.01)
  flush.console()
  
}

LineDanceAll <- as.data.frame(info)

