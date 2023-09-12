//
//  HomeView.swift
//  UberApp
//
//  Created by Eslam Ghazy on 18/8/23.
//

import SwiftUI
// https://github.com/barisozgenn/LuxTaxiSwiftUI
struct HomeView: View {
    @State private var mapState = MapViewState.notInput
    var body: some View {
        ZStack(alignment: .top){
            
            UberMabViewRepresentable(mapState: $mapState)
                .ignoresSafeArea()
            
            if mapState == .searchingForLocation {
                LocationSearchView(mapState: $mapState)
            }else if mapState == .notInput{
                LocationSearchActivationView()
                    .padding(.top,72)
                    .onTapGesture {
                        withAnimation(.spring()){
                            mapState = .searchingForLocation
                        }
                    }
            }
            
            MapViewActionButton(mapState: $mapState)
                .padding(.leading)
                .padding(.top,5)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
