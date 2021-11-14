#' Maakondade kaart
#'
#' Maakondade kaart (siia pikem kirjeldus!)
#'
#' @param df andmetabeli nimi
#' @param fill tunnuse nimi andmetabelist (see, mis läheb värvidena kaardile)
#' @param labels tunnuse nimi andmetabelist (tekst, mis läheb kaardile)
#' @param title joonise nimi
#' @param legend.title legendi nimi
#' @param textsize teksti suurus kaardil (nb! ühikute kohta vt https://stackoverflow.com/questions/25061822/ggplot-geom-text-font-size-control)
#' @param annotation annotatsioon all paremal servas
#'
#' @return a ggplot
#' @details tba
#' @export
kaart <- function(df, fill, labels, title="", legend.title = "", textsize = 7, annotation="kaart: Maa-amet, 2021"){
  #chk
  useless <- ""
  FILL <- deparse(substitute(fill))
  LABS <- deparse(substitute(labels))
  ggplot2::ggplot(df, ggplot2::aes(fill=.data[[FILL]]))+
    ggplot2::geom_map(ggplot2::aes(map_id=maakond), map=maakonnad, color="black")+
    ggplot2::expand_limits(x=maakonnad$long, y=maakonnad$lat)+
    ggplot2::coord_fixed()+
    ggplot2::geom_text(ggplot2::aes(label=.data[[LABS]],x=x, y=y), data=df, size=textsize)+
    ggplot2::theme(axis.title=element_blank(), axis.text=element_blank(),
          line=ggplot2::element_blank(), panel.background=ggplot2::element_blank())+
    ggplot2::ggtitle(title)+
    ggplot2::scale_fill_brewer(legend.title) +
    ggplot2::annotate("text", x = 700000, y = 6370000, label = annotation, size=3, color="grey")
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
#' @param textsize teksti suurus kaardil (nb! ühikute kohta vt https://stackoverflow.com/questions/25061822/ggplot-geom-text-font-size-control)
#' @param annotation annotatsioon all paremal servas
#'
#' @return a ggplot
#' @details tba
#' @export
kaart2 <- function(df, fill, labels, title="", legend.title = "", textsize=7, annotation="kaart: Maa-amet, 2021"){
  FILL <- deparse(substitute(fill))
  LABS <- deparse(substitute(labels))
  ggplot2::ggplot(df, ggplot2::aes(fill=.data[[FILL]]))+
    ggplot2::geom_map(ggplot2::aes(map_id=maakond), map=maakonnad, color="grey")+
    ggplot2::geom_map(ggplot2::aes(map_id=maakond), map=tlntrt, color="black")+
    ggplot2::expand_limits(x=maakonnad$long, y=maakonnad$lat)+
    ggplot2::coord_fixed()+
    ggplot2::geom_text(ggplot2::aes(label=.data[[LABS]],x=x-5000, y=y+5000), data=subset(df, maakond%in%c("Tallinn", "Tartu")),
              hjust=1, vjust=0, size=textsize)+
    ggplot2::geom_text(ggplot2::aes(label=.data[[LABS]],x=x-1000, y=y), data=subset(df, !maakond%in%c("Tallinn", "Tartu") &
                                                                    !maakond %in% c("Harju maakond", "Tartu maakond")), hjust=1, vjust=0,
                       size=textsize)+
    ggplot2::geom_text(ggplot2::aes(label=.data[[LABS]],x=x+21000, y=y-1000), data=subset(df,
                                                                        maakond %in% c("Harju maakond", "Tartu maakond")), hjust=1, vjust=0,
                       size=textsize)+
    ggplot2::theme(axis.title=element_blank(), axis.text=ggplot2::element_blank(),line=ggplot2::element_blank(),
          panel.background=ggplot2::element_blank())+
    ggplot2::ggtitle(title)+
    ggplot2::scale_fill_brewer(legend.title) +
    ggplot2::annotate("text", x = 700000, y = 6370000, label = annotation, size=3, color="grey")
}



