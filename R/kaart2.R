# library(dplyr)
# library(gridExtra)
# library(maptools)
# library(readr)
# library(rgdal)
# library(rgeos)
# library(stringr)
# library(tmap)
# library(ggplot2)
#
#
# # http://www.tekstikaeve.ee/blog/2017-10-24-kaartide-muutmine-r/
# # https://analyticsestonia.wordpress.com/2013/11/21/kuidas-teha-eesti-maakaarti-r-is/
# # https://geoportaal.maaamet.ee/index.php?page_id=119&lang_id=1
#
# eesti <- readOGR(dsn="maakond_shp", layer="maakond_20210301")
#
# eesti@data$id <- eesti@data$MNIMI
# eesti@data$id <- as.character(eesti@data$id)
# eesti.points <- fortify(eesti, region="id")
#
#
# eesti.df <- cbind(eesti.points, eesti@data[match(eesti.points$id, eesti@data$id),])
#
# osalus<-data.frame(maakond=c("Harju maakond","Hiiu maakond","Ida-Viru maakond","Jõgeva maakond","Järva maakond","Lääne maakond",
#                               "Lääne-Viru maakond", "Põlva maakond", "Pärnu maakond","Rapla maakond","Saare maakond",
#                               "Tartu maakond", "Valga maakond","Viljandi maakond", "Võru maakond","Tallinn", "Tartu linn"),
#                     osalus=c(60.1, 55.7, 51.6, 59.8, 56.9,57.1, 53.6, 60.3, 52.5, 53.6, 49.6, 58.3,56.7, 52.7, 59,64.1, 52.6))
#
# osalus$vahemik<-cut(osalus$osalus, breaks=c(49, 52, 55, 58, 61, 65),
#                              labels=c("49-52","52-55", "55-58","58-61", "61-65"))
#
# maakondadetsentroidid = as.data.frame(gCentroid(eesti,byid=TRUE))
# maakondadetsentroidid$maakond<-eesti$MNIMI
# library(plyr)
# osalus<-join(osalus, maakondadetsentroidid)
#
# eestiov = readOGR(dsn="omavalitsus_shp", layer="omavalitsus_20210301")
# eestiov@data$id = eestiov@data$ONIMI
# eestiov.points = fortify(eestiov, region="id")
# eestiov.df = cbind(eestiov.points, eestiov@data[match(eestiov.points$id, eestiov@data$id),])
#
# tlntrt.df<-subset(eestiov.df, id%in%c("Tallinn", "Tartu linn"))
# tlntrttsentroidid = as.data.frame(gCentroid(eestiov,byid=TRUE))
#
# tlntrttsentroidid$maakond<-eestiov$ONIMI
# tlntrttsentroidid<-subset(tlntrttsentroidid, maakond%in%c("Tallinn", "Tartu linn"))
#
# osalus$x[osalus$maakond=="Tallinn"]<-tlntrttsentroidid$x[tlntrttsentroidid$maakond=="Tallinn"]
# osalus$y[osalus$maakond=="Tallinn"]<-tlntrttsentroidid$y[tlntrttsentroidid$maakond=="Tallinn"]
# osalus$x[osalus$maakond=="Tartu linn"]<-tlntrttsentroidid$x[tlntrttsentroidid$maakond=="Tartu linn"]
# osalus$y[osalus$maakond=="Tartu linn"]<-tlntrttsentroidid$y[tlntrttsentroidid$maakond=="Tartu linn"]
#
# osalus$maakond<-revalue(osalus$maakond, replace=c("Tartu linn"="Tartu"))
# tlntrt.df$id<-revalue(tlntrt.df$id, replace=c("Tartu linn"="Tartu"))
#
# ### joonis Tallinna ja Tartuga
# p<-ggplot(osalus, aes(fill=vahemik))+
#   geom_map(aes(map_id=maakond), map=eesti.df, color="grey")+
#   geom_map(aes(map_id=maakond), map=tlntrt.df, color="black")+
#   expand_limits(x=eesti.df$long, y=eesti.df$lat)+
#   coord_fixed()+
#   geom_text(aes(label=maakond,x=x-5000, y=y+5000), data=subset(osalus, maakond%in%c("Tallinn", "Tartu")),
#             hjust=1, vjust=0)+
#   theme(axis.title=element_blank(), axis.text=element_blank(),line=element_blank(),
#         panel.background=element_blank())+
#   ggtitle("KOV valimistest 2013 osavõtjate osakaal maakondade kaupa")+
#   scale_fill_brewer("Osavõtt\nvalimistest (%)") +
#   annotate("text", x = 700000, y = 6370000, label = c("kaart: Maa-amet, 01.10.2013"), size=3, color="grey")
#
# ggsave(p, file="Eestikov2.png", height=2, width=3, scale=3)
#
# ## joonis 15 maakonnaga
# library(readxl)
# rvtu <- read_excel("valim jms//download.xlsx")
#
# o <- osalus[1:15,]
#
# o$osalus <- round(rvtu$KKO[1:15]*100,1) # yldine osalus
# o$osalus <- round(rvtu$MKo[1:15]*100,1) #mehed
# o$osalus <- round(rvtu$NKo[1:15]*100,1) #naised
# o$vahemik <- cut(o$osalus, seq(20,45, 2.5))
#
#
# p<-ggplot(o, aes(fill=vahemik))+
#   geom_map(aes(map_id=maakond), map=eesti.df, color="black")+
#   expand_limits(x=eesti.df$long, y=eesti.df$lat)+
#   coord_fixed()+
#   geom_text(aes(label=osalus,x=x, y=y), data=o)+
#   theme(axis.title=element_blank(), axis.text=element_blank(),
#         line=element_blank(), panel.background=element_blank())+
#   ggtitle("Osalusmäär maakondades")+
# #  ggtitle("Naiste osalusmäär")+
# #    ggtitle("Meeste osalusmäär")+
#   scale_fill_brewer("Osalusmäär (%)") +
#   annotate("text", x = 700000, y = 6370000, label = c("kaart: Maa-amet, 2021"), size=3)
#
# print(p)
# ggsave(p, file="Osalus_yld_2.5.png", height=2, width=3, scale=6)
# ggsave(p, file="Osalus_m_2.5.png", height=2, width=3, scale=6)
# ggsave(p, file="Osalus_n_2.5.png", height=2, width=3, scale=6)
#
#
#
# m <- (unlist(rvtu[16,2:16]))
# n <- (unlist(rvtu[16,2:16+16]))
# x <- "[<-"(as.numeric(sub("M", "", names(m))), 11,65)
# par(mar=c(4,4,0.5,0.5))
# plot(x,m ,type="p", ylim = c(0.15,0.5), col="blue", pch=17, xlab="Vanus", ylab="Osalusmäär")
# lines(smooth.spline(x,m, spar=0.5), col="blue", lty="solid", lwd=3)
# points(x, n, type="p", col="red", pch=16)
# lines(smooth.spline(x,n, spar=0.5), col="red", lty="solid", lwd=3)
#
# legend(19, 0.5, pch=c(17,16), col=c("blue", "red"), c("mehed", "naised"), lty="solid", bty="n", lwd=3)
