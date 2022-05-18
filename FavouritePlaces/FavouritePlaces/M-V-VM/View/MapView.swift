//
//  MapView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 09/05/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State var isEditing: Bool = false
    @Binding var favouritePlaceModel: FavouritePlaceDataModel
    @ObservedObject var favouritePlaceObservableModel: FavouritePlaceObservableModel
    @State var latitudeTextField: String = "35.0"
    @State var longitudeTextField: String = "35.0"
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var body: some View {
        VStack(alignment: .leading) {
            if isEditing {
                showEditModeView()
            } else {
                showNonEditModeView()
            }
        }.onAppear(perform: {
            syncDataFromModel()
        }).onDisappear(perform: {
            syncMasterModel()
        }).navigationTitle(StringConstants.mapOf + (favouritePlaceModel.location ?? ""))
            .toolbar {
                //To show buttons in navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        addEditModeHeaderView()
                    } else {
                        Button(StringConstants.edit) {
                            self.isEditing.toggle()
                        }
                    }
                }
            }
    }
    
    /// Get initial values from master view and show in parent view
    func syncDataFromModel() {
        latitudeTextField = favouritePlaceModel.latitude ?? "0.0"
        longitudeTextField = favouritePlaceModel.longitude ?? "0.0"
        region.center.latitude = Double(latitudeTextField) ?? region.center.latitude
        region.center.longitude = Double(longitudeTextField) ?? region.center.longitude
    }
    /// Show Header view with reset or undo reset button based on user selection.
    /// - Returns: view
    func addEditModeHeaderView () -> some View {
        HStack {
            Button(isEditing ? StringConstants.done : StringConstants.edit) {
                if isEditing {
                    doneButtonAction()
                }
                self.isEditing.toggle()
            }
        }
    }
    
    func doneButtonAction() {
        region.center.latitude = Double(latitudeTextField) ?? region.center.latitude
        region.center.longitude = Double(longitudeTextField) ?? region.center.longitude
    }
    
    func syncMasterModel() {
        favouritePlaceModel.latitude = latitudeTextField
        favouritePlaceModel.longitude = longitudeTextField
        for (index, item) in favouritePlaceObservableModel.favouritePlaceModels.enumerated() {
            if item.id == favouritePlaceModel.id {
                favouritePlaceObservableModel.favouritePlaceModels[index] = favouritePlaceModel
            }
        }
    }
    
    /// View to display when user is in edit more
    /// - Returns: Edit more view
    func showEditModeView() -> some View {
        VStack(alignment: .leading) {
            getMapView()
            VStack(alignment: .leading) {
                HStack {
                    Text(StringConstants.latitude)
                    TextField(StringConstants.enterCityName, text: $latitudeTextField)
                }
                HStack {
                    Text(StringConstants.longitude)
                    TextField(StringConstants.enterImageURL, text: $longitudeTextField)
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
                    Text("\(region.center.latitude)")
                }
                HStack {
                    Text(StringConstants.longitude)
                    Text("\(region.center.longitude)")
                }
            }.padding()
        }
    }
    func getMapView() -> some View {
        VStack {
            Map(coordinateRegion: $region)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(favouritePlaceModel: .constant(FavouritePlaceDataModel(id: UUID(), imageURL: "", latitude: "", location: "", enterLocationDetailsText: "", locationDescription: "", longitude: "")), favouritePlaceObservableModel: FavouritePlaceObservableModel())
    }
}

extension Double {
    
    func toString() -> String {
        return String(self)
    }
}
