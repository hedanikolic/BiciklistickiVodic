//
//  RouteData.swift
//  bicikl
//
//  Created by Heda Nikolić on 27.06.2024..
//

import Foundation
import Combine

struct Route: Identifiable {
    var id = UUID()
    var name: String
    var description: String
}

class RouteData: ObservableObject {
    @Published var routes: [Route] = [
        Route(name: "Zeleno polje – Lučki prilaz", description: "4096 m Zeleno polje – Ulica Matije Gupca – Trg bana J. Jelačića – Ulica Cara Hadrijana – Europska Avenija – Kapucinska – Lučki prilaz"),
        Route(name: "Donji grad - Centar", description: "3250 m Ulica Matije Gupca – Cvjetkova ulica – Vukovarska ulica – Gajev Trg – Ulica Stjepana Radića"),
        Route(name: "Promenada (desna obala)", description: "4381 m Ulica Cara Hadrijana – ispod Mosta dr. Franje Tuđmana – Promenada – Solarski trg – Ulica J.J.Strossmayera (do A. Kanižlića) – (od Kolodvorske – do Š. Petefija 620 m)"),
        Route(name: "Promenada (lijeva obala)", description: "2815 m Promenadom od ZOO Hotela do istočnog ulaza/izlaza Copacabane i od zapadnog ulaza/izlaza Copacabane do željezničkog mosta na Dravi uključujući i pješački most na Dravi"),
        Route(name: "Gradski vrt - Tuđmanov most", description: "2000 m Ulicom kneza Trpimira od Gradskog vrta do Mosta dr. Franje Tuđmana"),
        Route(name: "Biljska cesta", description: "1170 m Od mosta dr. Franje Tuđmana, uz Biljsku cestu do benzinske postaje na Biljskoj cesti i dalje prema Bilju"),
        Route(name: "Tvrđa – gornjogradska tržnica", description: "1509 m Srednjoškolsko igralište – Ulica kralja Zvonimira – Ulica Alojzija Stepinca (sudski prolaz), spoj na Europsku aveniju"),
        Route(name: "Bosutsko naselje – Jug II", description: "3970 m Gacka (od Miljacke ulice) – Ulica Maritna Divalta – Velebitska ulica (Jug II)"),
        Route(name: "Gundulićeva", description: "2040 m Gajev trg – Trg baruna Trenka – Ulica Ivana Gundulića (od A. Kanižlića)"),
        Route(name: "Svačićeva - Tenja", description: "4590 m Ulica kralja P. Svačića (od ul. C. Hadrijana) – nadvožnjak Rosinjača – Tenjska ulica"),
        Route(name: "Jug II (Opatijska)", description: "1302 m Opatijska ul. (od Ulice kralja P. Svačića do Srijemske, obostrano na dionici od Trpanjske do Srijemske)"),
        Route(name: "Uske njive", description: " 500 m Delnička ulica - Novogradiška ulica - Lipička ulica do Kutinske ulice"),
        Route(name: "Vinkovačka", description: "1440 m Od kružnog toka Đakovština do Dunavske ul. obostrano, od Dunavske ul. sa zapadne strane do kružnog toka Drinska-Bosutska (Mačkamama)"),
        Route(name: "Borova - Portanova", description: "1700 m Uz Gospodarsku zonu od Borove ulice do Portanove"),
        Route(name: "Portanova", description: " 550 m Od Svilajske ulice uz Portanovu"),
        Route(name: "Prolaz Ante Slavičeka", description: " 230 m Od Ulice Ivana Gundulića do Ulice Hrvatske Republike"),
        Route(name: "Šetalište Joze Petroviča (Sjenjak)", description: " 650 m Sjenjak (od Robne kuće) do Ulice Ivana Zajca i spoj prema biciklističkoj stazi na Ulici Martina Divalta")
    ]
}
