//
//  ChildView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 05/05/22.
//

import SwiftUI

struct ChildView: View {
    ///Variables to get data from master view and to keep track of user entry
    @State var favouritePlaceModel: FavouritePlaceDataModel
    @Binding var favouritePlaceModels: [FavouritePlaceDataModel]
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
    
    
    /// Get initial values from master view and show in parent view
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
                saveDataInModel()
            }
        }
    }
    
    
    /// View to display when user is in edit more
    /// - Returns: Edit more view
    func showEditModeView() -> some View {
        List {
            
            TextField("Enter City Name", text: $cityNameTextField)
            TextField("Enter Image URL", text: $imageURLTextField)
            Text("Enter Location Details: ")
                .fontWeight(.bold)
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
    
    
    /// Function to save data in model and save it in core data
    func saveDataInModel() {
        favouritePlaceModel.location = cityNameTextField
        favouritePlaceModel.locationDescription = locationTextField
        favouritePlaceModel.imageURL = imageURLTextField
        favouritePlaceModel.latitude = latitudeTextField
        favouritePlaceModel.longitude = longitudeFieldEntry
        syncMasterModel()
    }
    
    
    /// Function to update parent view when user make changes in child view
    func syncMasterModel() {
        favouritePlaceModels = favouritePlaceModels.map({ favouritePlaceDataModel in
            if favouritePlaceDataModel.id == favouritePlaceModel.id {
                return favouritePlaceModel
            }
            return favouritePlaceDataModel
        })
        CoreDataManager.shared.syncCoreData(favouritePlaceDataModels: favouritePlaceModels)
    }
    
    
    /// Function to create nonedit mode view where user can not edit anything
    /// - Returns: Non edit more view
    func showNonEditModeView() -> some View {
        List {
            ImageView(imageURL: imageURLTextField,
                      width: UIScreen.main.bounds.width * 0.8,
                      height: UIScreen.main.bounds.width * 0.8)
            Text(locationTextField)
            NavigationLink {
                MapView()
            } label: {
                HStack{
                    ImageView(imageURL: "")
                    Text("Show Map View")
                }
            }

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
        ChildView(favouritePlaceModel: FavouritePlaceDataModel(id: UUID()), favouritePlaceModels: .constant([]))
    }
}
#endif

