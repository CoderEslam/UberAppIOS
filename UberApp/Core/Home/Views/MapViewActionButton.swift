//
//  MapViewActionButton.swift
//  UberApp
//
//  Created by Eslam Ghazy on 19/8/23.
//

import SwiftUI

struct MapViewActionButton: View {
    
    // we use binding when you want pass value live data 
    @Binding var mapState:MapViewState
    
    var body: some View {
        
        Button{
            withAnimation(.spring()){
                actionForState(mapState)
            }
        }label: {
            Image(systemName: imageNameForState(mapState) )
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .blue, radius: 6 ,x: 0,y: 6)
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        
    }
    
    func actionForState(_ state:MapViewState)  {
        switch state{
        case .notInput:
            print("Debug map is : No input")
        case .searchingForLocation:
            mapState = .notInput
        case .locationSelected:
            print("Dubug map is  : locationSelected")
        }
    }
    
    func imageNameForState(_ state:MapViewState) -> String{
        switch state {
        case .notInput:
            return "line.3.horizontal"
        case .searchingForLocation , .locationSelected:
            return"arrow.left"
        }
    }
}

struct MapViewActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapViewActionButton(mapState: .constant(.notInput))
    }
}
