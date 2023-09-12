//
//  LocationSearchView.swift
//  UberApp
//
//  Created by Eslam Ghazy on 19/8/23.
//

import SwiftUI

struct LocationSearchView: View {
    @State private var startlocationText = ""
    // we use @Binding to change state from View To another View
    @Binding var mapState : MapViewState
    @EnvironmentObject var viewModel : LocationSearchViewViewModel
    var body: some View {
        VStack{
            
            // hearder View
            HStack{
                
                VStack{
                    Circle()
                        .fill(Color(.systemGray))
                        .frame(width: 6,height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray))
                        .frame(width: 1,height: 24)
                    
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6,height: 6)
                    
                    
                }
                
                VStack{
                    TextField( "Current Location", text: $startlocationText)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                    
                    TextField( "Where to ?", text: $viewModel.queryFragment)
                        .frame(height: 32)
                        .background(Color(.systemGray))
                        .padding(.trailing)
                }
                
            }
            .padding(.leading)
            .padding(.top,64)
            
            Divider()
                .padding(.vertical)
                
            // list View
            ScrollView{
                
                VStack{
                    ForEach(viewModel.resulte,id: \.self){ reslut in
                        
                        LocationSearchResultCell(title: reslut.title,
                                                  subTitle: reslut.subtitle)
                        .onTapGesture {
                            viewModel.selectedLocation(reslut)
                            mapState = .locationSelected
                        }
                        
                    }
                }
                
            }
            
        }.background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView( mapState: .constant(.searchingForLocation))
    }
}
