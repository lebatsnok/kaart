#' Maakondade kaart
#'
#' Maakondade kaart (siia pikem kirjeldus!)
#'
#' @param df andmetabeli nimi
#' @param fill tunnuse nimi andmetabelist (see, mis läheb värvidena kaardile)
#' @param labels tunnuse nimi andmetabelist (tekst, mis läheb kaardile)
#' @param title joonise nimi
#' @param legend.title legendi nimi
#' @param annotation annotatsioon all paremal servas
#'
#' @return a ggplot
#' @details tba
#' @export
kaart <- function(df, fill, labels, title="", legend.title = "", annotation="kaart: Maa-amet, 2021"){
  #chk
  useless <- ""
  FILL <- deparse(substitute(fill))
  LABS <- deparse(substitute(labels))
  ggplot(df, aes(fill=.data[[FILL]]))+
    geom_map(aes(map_id=maakond), map=maakonnad, color="black")+
    expand_limits(x=maakonnad$long, y=maakonnad$lat)+
    coord_fixed()+
    geom_text(aes(label=.data[[LABS]],x=x, y=y), data=df)+
    theme(axis.title=element_blank(), axis.text=element_blank(),
          line=element_blank(), panel.background=element_blank())+
    ggtitle(title)+
    scale_fill_brewer(legend.title) +
    annotate("text", x = 700000, y = 6370000, label = annotation, size=3, color="grey")
}


#' Maakondade kaart Tallinna ja Tartuga
#'
#' Maakondade kaart Tallinna ja Tartuga (siia pikem kirjeldus?!)
#'
#' @param df andmetabeli nimi
#' @param fill tunnuse nimi andmetabelist (see, mis läheb värvidena kaardile)
#' @param labels praegu kasutamata
#' @param title joonise nimi
#' @param legend.title legendi nimi
#' @param annotation annotatsioon all paremal servas
#'
#' @return a ggplot
#' @details tba
#' @export
kaart2 <- function(df, fill, labels, title="", legend.title = "", annotation="kaart: Maa-amet, 2021"){
  FILL <- deparse(substitute(fill))
  LABS <- deparse(substitute(labels))
  ggplot(df, aes(fill=.data[[FILL]]))+
    geom_map(aes(map_id=maakond), map=maakonnad, color="grey")+
    geom_map(aes(map_id=maakond), map=tlntrt, color="black")+
    expand_limits(x=maakonnad$long, y=maakonnad$lat)+
    coord_fixed()+
    geom_text(aes(label=.data[[LABS]],x=x-5000, y=y+5000), data=subset(df, maakond%in%c("Tallinn", "Tartu")),
              hjust=1, vjust=0)+
    geom_text(aes(label=.data[[LABS]],x=x-1000, y=y), data=subset(df, !maakond%in%c("Tallinn", "Tartu") &
                                                                    !maakond %in% c("Harju maakond", "Tartu maakond")), hjust=1, vjust=0)+
    geom_text(aes(label=.data[[LABS]],x=x+21000, y=y-1000), data=subset(df,
                                                                        maakond %in% c("Harju maakond", "Tartu maakond")), hjust=1, vjust=0)+
    theme(axis.title=element_blank(), axis.text=element_blank(),line=element_blank(),
          panel.background=element_blank())+
    ggtitle(title)+
    scale_fill_brewer(legend.title) +
    annotate("text", x = 700000, y = 6370000, label = annotation, size=3, color="grey")
}



