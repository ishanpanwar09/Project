# reading CSV's
concert = read.csv('/Users/ishansingh/Documents/tf_ishan/april_26_5PM/metadata_extracted/Concert_metadata.csv')
conference = read.csv('/Users/ishansingh/Documents/tf_ishan/april_26_5PM/metadata_extracted/Conference_metadata.csv')
cycling = read.csv('/Users/ishansingh/Documents/tf_ishan/april_26_5PM/metadata_extracted/Cycling_metadata.csv')
football = read.csv('/Users/ishansingh/Documents/tf_ishan/april_26_5PM/metadata_extracted/Football_metadata.csv')


library(dplyr)
gpConcert= group_by(concert,name)
concert= summarise(gpConcert,count = n())
concert$class = rep('concert',length(concert$name))

gpCycling= group_by(cycling,name)
cycling= summarise(gpCycling,count = n())
cycling$class = rep('Cycling',length(cycling$name))

gpConference = group_by(conference,name)
conference= summarise(gpConference,count = n())
conference$class = rep('conference',length(conference$name))

gpfootball= group_by(football,name)
football= summarise(gpfootball,count = n())
football$class = rep('football',length(football$name))

# Union DF
NewDF = rbind(cycling,concert,conference, football)

#writing Combined Data to CSV
write.csv(NewDF, 'All_metadata.csv')

# Taking Prominent Concepts only from Each Class
NewDF = NewDF%>%
  filter(count > 90)



library(ggplot2)
# used First one to get everything
q= ggplot(data=NewDF, aes(x=name, y=count, fill=class)) + geom_bar(stat="identity") + 
  ggtitle(expression("Stacked bar chart of prominent concepts (metaData) of all classes"))
q = q + theme(legend.position="top")
q = q + theme(legend.background = element_rect(fill="lightblue", 
                                               size=0.5, linetype="solid"))
q + theme(axis.text.x = element_text(angle = 45, hjust = 1,size = 6))


# extra plots
#q = ggplot(NewDF, aes(x=name, y=count, color = class)) + geom_point()
#q + theme(axis.text.x = element_text(angle = 90, hjust = 1))



# q = ggplot(NewDF, aes(x=factor(class), y=count, fill=name)) + 
#   geom_bar(aes(fill = name), position = "dodge", stat="identity") + 
#   labs(x = "Prominent Concepts") + 
#   labs(y = expression("blank")) + 
#   xlab("bla") + 
#   ggtitle(expression("Histogram of Prominent Concepts (MetaData)"))
# q + theme(axis.text.x = element_text(angle = 90, hjust = 1))
