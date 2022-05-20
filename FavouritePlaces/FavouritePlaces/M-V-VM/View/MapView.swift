//
//  MapView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 09/05/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var  mapViewViewModel: MapViewViewModel
    @State var isEditing: Bool = false
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            if isEditing {
                showEditModeView()
            } else {
                showNonEditModeView()
            }
        }.onAppear(perform: {
            mapViewViewModel.syncDataFromModel()
        }).onDisappear(perform: {
            mapViewViewModel.syncMasterModel()
        }).navigationTitle(StringConstants.mapOf + (mapViewViewModel.favouritePlaceModel.location ?? ""))
            .toolbar {
                //To show buttons in navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        addEditModeHeaderView()
                    } else {
                        Button(StringConstants.edit) {
                            isEditing.toggle()
                        }
                    }
                }
            }
    }
    
    func getMapView() -> some View {
        VStack {
            Map(coordinateRegion: $mapViewViewModel.region)
        }
    }
    
    /// Show Header view with reset or undo reset button based on user selection.
    /// - Returns: view
    func addEditModeHeaderView () -> some View {
        HStack {
            Button(isEditing ? StringConstants.done : StringConstants.edit) {
                if isEditing {
                    mapViewViewModel.doneButtonAction()
                }
                isEditing.toggle()
            }
        }
    }
    
    /// View to display when user is in edit more
    /// - Returns: Edit more view
    func showEditModeView() -> some View {
        VStack(alignment: .leading) {
            showSearchView()
            getMapView()
            VStack(alignment: .leading) {
                HStack {
                    Text(StringConstants.latitude)
                    TextField(StringConstants.enterCityName, text: $mapViewViewModel.latitudeTextField)
                }
                HStack {
                    Text(StringConstants.longitude)
                    TextField(StringConstants.enterImageURL, text: $mapViewViewModel.longitudeTextField)
                }
            }.padding()
        }
    }
    
    func showNonEditModeView() -> some View {
        VStack(alignment: .leading) {
            getMapView()
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(StringConstants.latitude)
                    Text("\(mapViewViewModel.region.center.latitude)")
                }
                HStack {
                    Text(StringConstants.longitude)
                    Text("\(mapViewViewModel.region.center.longitude)")
                }
            }.padding()
        }
    }
    
    func showSearchView() -> some View {
        HStack {
            HStack {
                Image(systemName: ImageName.magnifyingGlass)
                    .foregroundColor(.blue)
                TextField("search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                }).foregroundColor(.primary)
                
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: ImageName.cancelButton).opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }.padding([.leading, .trailing])
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(MapViewViewModel())
    }
}

extension Double {
    
    func toString() -> String {
        return String(self)
    }
}
