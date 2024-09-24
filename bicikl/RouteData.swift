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
        Route(name: "Zeleno polje – Lučki prilaz", description: "4096 m Zeleno polje – M. Gupca – Trg B. J. Jelačića – Park K. K. Kosače – C. Hadrijana – Europska Avenija – Kapucinska – Lučki prilaz"),
        Route(name: "Donji grad - Centar", description: "3250 m M. Gupca – Cvjetkova – Vukovarska – Gajev Trg – Radićeva"),
        Route(name: "Promenada (desna obala)", description: "4381 m C. Hadrijana – ispod Mosta Dr. F. Tuđmana – Promenada – Solarski trg – J.J.Strossmayerova (do A. Kanižlića) – (od Kolodvorske – do Š. Petefija 620 m)"),
        Route(name: "Promenada (lijeva obala)", description: "2815 m Promenadom od ZOO Hotela do istočnog ulaza/izlaza iz Copacabane i od zapadnog ulaza/zlaza iz Copacabane do željezničkog mosta na Dravi uključujući i pješački most na Dravi"),
        Route(name: "Gradski vrt - Tuđmanov most", description: "2000 m Ulicom kneza Trpimira od Gradskog vrta do mosta Dr. F. Tuđmana (cestovni)"),
        Route(name: "Biljska cesta", description: "1170 m Od mosta Dr. F. Tuđmana (cestovni), uz Biljski cestu do benzinske postaje na Biljskoj cesti i dalje prema Bilju"),
        Route(name: "Tvrđa – gornjogradska tržnica", description: "1509 m Križanje Trpimirove – C. Hadrijana – Vijenac I. Meštrovića – Srednjoškolsko igralište – Zvonimirova – A. Stepinca (sudski prolaz) spoj na Europsku aveniju"),
        Route(name: "Bosutsko naselje – Jug II", description: "3970 m Od Miljacke ul. – Gacka – M. Divalta – Velebitska (Jug II)"),
        Route(name: "Gundulićeva", description: "2040 m Gajev trg – Trg B. Trenka – I. Gundulića (od A. Kanižlića)"),
        Route(name: "Svačićeva - Tenja", description: "4590 m Ul. K. P. Svačića (od ul. C. Hadrijana) – nadvožnjak Rosinjača –  J.R. Kira – do Tenje"),
        Route(name: "Jug II(Opatijska)", description: "1302 m Opatijska ul. (od K. P. Svačića  do Srijemske, obostrano na dionici od Trpanjske do Srijemske)"),
        Route(name: "Ul. Woodrowa Wilsona - Kutinska", description: "A route from Stepinceva to Trpimirova."),
        Route(name: "Vinkovačka", description: "1440 m Od kružnog toka Đakovština do Dunavske ul. obostrano, od Dunavske ul. sa zapadne strane do kružnog toka Drinska-Bosutska (Mačkamama)"),
        Route(name: "Borova - Portanova", description: "A route from Stepinceva to Trpimirova."),
        Route(name: "Svilajska (uz Portanovu)", description: "A route from Stepinceva to Trpimirova."),
        Route(name: "Prolaz Ante Slavičeka", description: " 230 m Od ul. I. Gundulića do ul. Hrvatske Republike"),
        Route(name: "Šetalište Joze Petroviča (Sjenjak)", description: "A route from Stepinceva to Trpimirova.")
    ]
}
