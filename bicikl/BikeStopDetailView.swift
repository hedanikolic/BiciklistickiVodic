//
//  BikeDetailView.swift
//  bicikl
//
//  Created by Heda Nikolić on 04.09.2025..
//

import SwiftUI

struct BikeStopDetailView: View {
    let stop: BikeStop
    private var symbolName: String {
        switch stop.type.lowercased() {
        case "rent": return "bicycle"
        case "pump": return "fuelpump"
        case "service": return "wrench.and.screwdriver.fill"
        default: return "mappin.circle"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: symbolName)
                .font(.system(size:30))
                .foregroundStyle(.black)
                .padding(.bottom)
            Text(stop.name)
                .font(.title2).bold()
            Text(stop.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.vertical)
 
        }
        .padding([.bottom, .horizontal])
    }
}


/*#Preview {
    BikeStopDetailView()
}*/

