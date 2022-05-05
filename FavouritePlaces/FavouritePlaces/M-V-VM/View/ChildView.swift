//
//  ChildView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 05/05/22.
//

import SwiftUI

struct ChildView: View {
    @State var favouritePlaceModel: FavouritePlaceModel
    @State var isEditing: Bool = false
    @State var cityNameTextField: String = ""
    @State var locationTextField: String = ""
    @State var imageURLTextField: String = ""
    @State var latitudeTextField: String = ""
    @State var longitudeFieldEntry: String = ""
    
    var body: some View {
        VStack {
            if isEditing {
                showEditModeView()
            } else {
                showNonEditModeView()
            }
        } .onAppear {
            syncDataFromModel()
        }.navigationTitle(cityNameTextField)
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
    
    func syncDataFromModel() {
        cityNameTextField = favouritePlaceModel.location ?? ""
        locationTextField = favouritePlaceModel.locationDescription ?? ""
        imageURLTextField = favouritePlaceModel.imageURL ?? ""
        latitudeTextField = favouritePlaceModel.latitude ?? "0.0"
        longitudeFieldEntry = favouritePlaceModel.longitude ?? "0.0"

    }
    
    /// Show Header view with reset or undo reset button based on user selection.
    /// - Returns: view
    func addEditModeHeaderView () -> some View {
        HStack {
            Button(isEditing ? StringConstants.done : StringConstants.edit) {
                self.isEditing.toggle()
                //syncDataFromModel()
            }
        }
    }
    
    func showEditModeView() -> some View {
        List {
            TextField("Enter City Name", text: $cityNameTextField)
            TextField("Enter Image URL", text: $imageURLTextField)
            Text("Enter Location Details: ")
            TextField("Enter Location", text: $locationTextField)
            HStack {
                Text("Latitude: ")
                TextField("Text Field", text: $latitudeTextField)
            }
            HStack {
                Text("Longitude: ")
                TextField("Text Field", text: $longitudeFieldEntry)
            }
        }
    }
    
    func showNonEditModeView() -> some View {
        List {
            ImageView(imageURL: imageURLTextField,
                      width: UIScreen.main.bounds.width * 0.8,
                      height: UIScreen.main.bounds.width * 0.8)
            Text(locationTextField)
            HStack {
                Text("Latitude: ")
               Text(latitudeTextField)
            }
            HStack {
                Text("Longitude: ")
                Text(longitudeFieldEntry)
            }
        }
    }
}

#if DEBUG
struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView(favouritePlaceModel: FavouritePlaceModel())
    }
}
#endif

