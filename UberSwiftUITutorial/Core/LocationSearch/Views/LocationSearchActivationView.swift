//
//  LocationSearchActivationView.swift
//  UberSwiftUITutorial
//
//  Created by Ivan Verdugo on 26/05/26.
//

import SwiftUI

struct LocationSearchActivationView: View {
    var body: some View {
        //UIScreen.main.bounds.width - 64
        GeometryReader { geometry in
            HStack{
                Spacer()
                
                HStack {
                    Rectangle()
                        .fill(.black)
                        .frame(width: 8, height: 8)
                        .padding(.horizontal)
                    
                    Text("Where to go?")
                        .foregroundColor(Color(.darkGray))
                    
                    Spacer()
                }
                .frame(width: geometry.size.width - 64, height: 50)
                .background(
                    Rectangle()
                        .fill(.white)
                        .shadow(color: .black, radius: 6)
                )
                
                Spacer()
            }
        }
        //.frame(width: .infinity, height: 50)
    }
}

#Preview {
    LocationSearchActivationView()
}
