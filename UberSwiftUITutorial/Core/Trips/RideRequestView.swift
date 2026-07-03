//
//  RideRequestView.swift
//  UberSwiftUITutorial
//
//  Created by Ivan Verdugo on 29/05/26.
//

import SwiftUI

struct RideRequestView: View {
    @State private var selectedRideType: RideTypes = .uberX
    
    @Environment(LocationSearchViewModel.self) var viewModel

    var body: some View {
        VStack{
            Capsule()
                .foregroundStyle(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            //trip info view
            HStack{
                VStack{
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 8, height: 8)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 32)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                }
                
                VStack(alignment: .leading, spacing: 24){
                    HStack{
                        Text("Current location")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        if let pickupTime = viewModel.pickupTime {
                            Text(pickupTime)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    HStack{
                        if let location = viewModel.selectedUberLocation {
                            Text(location.title)
                                .font(.system(size: 16, weight: .semibold))
                        }else{
                            Text("Destination")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    
                        Spacer()
                        
                        Text(viewModel.dropOffTime ?? "hh:mm pm")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.gray)

                    }
                    
                }
                .padding(.leading, 8)
            }
            .padding()
            
            Divider()
            
            // ride type selection view
            Text("SUGGESTED RIDES")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 12){
                    ForEach(RideTypes.allCases) { rideType in
                        VStack(alignment: .leading) {
                            Image(rideType.imageName)
                                .resizable()
                                .scaledToFit()
                            
                            VStack(alignment: .leading, spacing: 4){
                                Text(rideType.description)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text(viewModel.computeRidePrice(forType: rideType).toCurrency())  
                                    .font(.system(size: 14, weight: .semibold))
                                    
                            }
                            .padding()
                        }
                        .frame(width: 112, height: 140)
                        .foregroundStyle(rideType == selectedRideType ? .white : Color.theme.primaryTextColor)
                        .background(rideType == selectedRideType ? Color(.systemBlue) : Color.theme.secundaryBackgroundColor)
                        .scaleEffect(rideType == selectedRideType ? 1.2 : 1.0)
                        .cornerRadius(10)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedRideType = rideType
                            }
                        }
                    }
                }
                
            }
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical, 8)
            
            //payment option view
            HStack(spacing: 12){
                Text("Visa")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(6)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat(4)))
                    .foregroundStyle(.white)
                    .padding(.leading)
                
                Text("************1234")
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.medium)
                    .padding()
                
            }
            .frame(height: 50)
            .background(Color.theme.secundaryBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(10)))
            //.padding(1)
            //.background(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            
            
            //Reques ride button
            Button {
                
            } label: {
                Text("CONFIRM RIDE")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: CGFloat(10)))
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: CGFloat(16)))
    }
}

#Preview {
    RideRequestView()
        .environment(LocationSearchViewModel())
}
