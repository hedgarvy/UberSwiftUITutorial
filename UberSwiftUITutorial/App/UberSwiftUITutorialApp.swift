//
//  UberSwiftUITutorialApp.swift
//  UberSwiftUITutorial
//
//  Created by Ivan Verdugo on 22/05/26.
//

import SwiftUI

@main
struct UberSwiftUITutorialApp: App {
    //@StateObject var locationViewModel = LocationSearchViewModel()
    @State var locationViewModel = LocationSearchViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                //.environmentObject(locationViewModel)
                .environment(locationViewModel)
        }
    }
}
