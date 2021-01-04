---
title: "R Notebook"
output: html_notebook
---

This is an [R Markdown](http://rmarkdown.rstudio.com) Notebook. When you execute code within the notebook, the results appear beneath the code. 

Try executing this chunk by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Ctrl+Shift+Enter*. 

```{r}
library(tidyverse)
library(lubridate)

last_date = ymd("2020-12-31")
dates = seq(last_date-ddays(x = 1)*30, last_date, by = 'day')


all = NULL


for(i in 1:length(dates)){
  date = dates[i]
  
  the_url = paste0("https://api.coronavirus.data.gov.uk/v2/data?areaType=overview&metric=newDeaths28DaysByDeathDate&format=csv&release=",as.character(date))
 
  dat = read_csv(url(the_url))
  dat$data_date = date
  if (!is.null((all))){
    all = bind_rows(all,dat)
  }
  else{
    all =dat
  }
   }



```

```{r}
library(ggrepel)
ggplot(all%>% filter(date>"2020-12-01"),aes(y=newDeaths28DaysByDeathDate,color=as.factor(date),x=data_date-date,group=date,label=as.character(date)))+geom_line()+labs(y="Number of deaths reported",x="Days after date of death",color="Date of death") + geom_text_repel(size=2,data=all %>% group_by(date) %>% filter(data_date=="2020-12-30")%>% filter(date>"2020-12-01"),segment.color="black")+theme_bw()
ggsave("deaths.pdf",width=10,height=5)


```

Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Ctrl+Alt+I*.

When you save the notebook, an HTML file containing the code and output will be saved alongside it (click the *Preview* button or press *Ctrl+Shift+K* to preview the HTML file).

The preview shows you a rendered HTML copy of the contents of the editor. Consequently, unlike *Knit*, *Preview* does not run any R code chunks. Instead, the output of the chunk when it was last run in the editor is displayed.
