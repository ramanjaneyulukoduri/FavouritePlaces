//
//  MapView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 09/05/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var mapViewViewModel: MapViewViewModel
    @State var isEditing: Bool = false
    @State private var showCancelButton: Bool = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .leading) {
            if isEditing {
                showEditModeView()
            } else {
                showNonEditModeView()
            }
        }.onAppear(perform: {
            mapViewViewModel.syncDataFromModel()
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
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: getBackButton())
    }
    
    func getMapView() -> some View {
        VStack {
            Map(coordinateRegion: $mapViewViewModel.region)
        }
    }
    
    func getBackButton() -> some View {
        HStack {
            Button(action: {
                mapViewViewModel.syncMasterModel(completion: {
                    self.presentationMode.wrappedValue.dismiss()
                })
            }) {
                HStack {
                    Image(systemName: "arrow.backward")
                    Text("Back")
                }
            }
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
        ZStack(alignment: .leading) {
            VStack {
                getMapView()
                Spacer()
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
            VStack {
                showSearchView()
                    .padding(.top)
                showSearchResultView()
                Spacer()
                
            }
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
                TextField("search", text: $mapViewViewModel.searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    print("onCommit")
                }).foregroundColor(.primary)
                    .onChange(of: mapViewViewModel.searchText) { newValue in
                        let delay = 0.3
                        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                            if newValue == mapViewViewModel.searchText {
                                self.mapViewViewModel.searchQuery()
                            }
                        }
                    }
                
                Button(action: {
                    mapViewViewModel.searchText = ""
                }) {
                    Image(systemName: ImageName.cancelButton).opacity(mapViewViewModel.searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }.padding([.leading, .trailing])
    }
    
    func showSearchResultView() -> some View {
        ScrollView {
            if !mapViewViewModel.places.isEmpty && !mapViewViewModel.searchText.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(mapViewViewModel.places) { place in
                        Text(place.placemark.name ?? "")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.size.height * 0.5, alignment: .leading)
                            .padding()
                            .background(Color.white)
                            .onTapGesture {
                                mapViewViewModel.selectPlace(place: place)
                                mapViewViewModel.isPlaceSelectedFromSearchField = true
                            }
                        
                    }
                }
            }
        }
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
