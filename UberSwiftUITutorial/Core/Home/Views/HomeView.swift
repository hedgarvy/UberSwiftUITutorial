//
//  HomeView.swift
//  UberSwiftUITutorial
//
//  Created by Ivan Verdugo on 22/05/26.
//

import SwiftUI
import Combine

struct HomeView: View {
    @State private var mapState = MapViewState.noInput
    @Environment(LocationSearchViewModel.self) var viewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                UberMapViewRepresentable(mapState: $mapState)
                    .ignoresSafeArea()
                
                if mapState == .searchingForLocation{
                    LocationSearchView(mapState: $mapState)
                }else if mapState == .noInput {
                    LocationSearchActivationView()
                        .padding(.top, 72)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                mapState = .searchingForLocation
                            }
                        }
                }
                
                MapViewActionButton(mapState: $mapState)
                    .padding(.leading)
            }
            /*
            .sheet(isPresented: mapState == .locationSelected ? .constant(true) : .constant(false)) {
                mapState  = .noInput
            } content: {
                RideRequestView()
                    .padding(.vertical)
                
                    .presentationDetents([.medium])
                
                    .ignoresSafeArea()
            }
             */

            
            if  mapState == .locationSelected || mapState == .polylineAdded {
                RideRequestView()
                    .transition(.move(edge: .bottom))
            }
             
        }
        .ignoresSafeArea(edges: .bottom)
        .onReceive(LocationManager.shared.userLocation.publisher) { location in
            viewModel.userLocation = location
        }
    }
}

#Preview {
    HomeView()
        .environment(LocationSearchViewModel())
}
