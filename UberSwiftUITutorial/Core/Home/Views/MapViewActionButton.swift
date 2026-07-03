//
//  MapViewActionButton.swift
//  UberSwiftUITutorial
//
//  Created by Ivan Verdugo on 27/05/26.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var mapState: MapViewState
    @Environment(LocationSearchViewModel.self) var locationViewModel
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundStyle(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    func actionForState(_ state: MapViewState) {
        switch state {
        case .noInput:
            print("DEBUG: no input")
        case .locationSelected, .polylineAdded:
            mapState = .noInput
            locationViewModel.selectedUberLocation = nil
        case .searchingForLocation:
            mapState = .noInput
        }
    }
    
    func imageNameForState(_ state: MapViewState) -> String{
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .locationSelected, .searchingForLocation, .polylineAdded:
            return "arrow.left"
        }
    }
}

#Preview {
    MapViewActionButton(mapState: .constant(.noInput))
        .environment(LocationSearchViewModel())
}
