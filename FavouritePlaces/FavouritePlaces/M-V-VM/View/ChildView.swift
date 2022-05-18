//
//  ChildView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 05/05/22.
//

import SwiftUI

struct ChildViewModel {
     var isEditing: Bool = false
     var cityNameTextField: String = ""
     var locationTextField: String = ""
     var imageURLTextField: String = ""
     var latitudeTextField: String = ""
     var longitudeFieldEntry: String = ""
}

struct ChildView: View {
    ///Variables to get data from master view and to keep track of user entry
    @State var favouritePlaceModel: FavouritePlaceDataModel
    @ObservedObject var favouritePlaceObservableModel = FavouritePlaceObservableModel()
    @State var childViewModel = ChildViewModel()
    
    var body: some View {
        VStack {
            if childViewModel.isEditing {
                showEditModeView()
            } else {
                showNonEditModeView()
            }
        }.onReceive(favouritePlaceObservableModel.$favouritePlaceModels, perform: { items in
            favouritePlaceModel = items.filter{$0.id == favouritePlaceModel.id}.last ?? favouritePlaceModel
        })
        .onAppear {
            syncDataFromModel()
        }.onDisappear(perform: {
            syncMasterModel()
        })
        .navigationTitle(childViewModel.cityNameTextField)
            .toolbar {
                //To show buttons in navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                    if childViewModel.isEditing {
                        addEditModeHeaderView()
                    } else {
                        Button(StringConstants.edit) {
                            childViewModel.isEditing.toggle()
                        }
                    }
                }
            }
    }
    
    
    /// Get initial values from master view and show in parent view
    func syncDataFromModel() {
        childViewModel.cityNameTextField = favouritePlaceModel.location ?? ""
        childViewModel.locationTextField = favouritePlaceModel.locationDescription ?? ""
        childViewModel.imageURLTextField = favouritePlaceModel.imageURL ?? ""
        childViewModel.latitudeTextField = favouritePlaceModel.latitude ?? "0.0"
        childViewModel.longitudeFieldEntry = favouritePlaceModel.longitude ?? "0.0"
    }
    
    /// Show Header view with reset or undo reset button based on user selection.
    /// - Returns: view
    func addEditModeHeaderView () -> some View {
        HStack {
            Button(childViewModel.isEditing ? StringConstants.done : StringConstants.edit) {
                childViewModel.isEditing.toggle()
                saveDataInModel()
            }
        }
    }
    
    
    /// View to display when user is in edit more
    /// - Returns: Edit more view
    func showEditModeView() -> some View {
        List {
            
            TextField("Enter City Name", text: $childViewModel.cityNameTextField)
            TextField("Enter Image URL", text: $childViewModel.imageURLTextField)
            Text("Enter Location Details: ")
                .fontWeight(.bold)
            TextField("Enter Location", text: $childViewModel.locationTextField)
            HStack {
                Text("Latitude: ")
                TextField("Text Field", text: $childViewModel.latitudeTextField)
                    .onChange(of: childViewModel.latitudeTextField) { newValue in
                        favouritePlaceModel.latitude = newValue
                    }
            }
            HStack {
                Text("Longitude: ")
                TextField("Text Field", text: $childViewModel.longitudeFieldEntry)
                    .onChange(of: childViewModel.longitudeFieldEntry) { newValue in
                        favouritePlaceModel.longitude = newValue
                    }
            }
        }
    }
    
    
    /// Function to save data in model and save it in core data
    func saveDataInModel() {
        favouritePlaceModel.location = childViewModel.cityNameTextField
        favouritePlaceModel.locationDescription = childViewModel.locationTextField
        favouritePlaceModel.imageURL = childViewModel.imageURLTextField
        favouritePlaceModel.latitude = childViewModel.latitudeTextField
        favouritePlaceModel.longitude = childViewModel.longitudeFieldEntry
    }
    
    
    /// Function to update parent view when user make changes in child view
    func syncMasterModel() {
        favouritePlaceObservableModel.favouritePlaceModels = favouritePlaceObservableModel.favouritePlaceModels.map({ favouritePlaceDataModel in
            if favouritePlaceDataModel.id == favouritePlaceModel.id {
                return favouritePlaceModel
            }
            return favouritePlaceDataModel
        })
        CoreDataManager.shared.syncCoreData(favouritePlaceDataModels: favouritePlaceObservableModel.favouritePlaceModels)
    }
    
    
    /// Function to create nonedit mode view where user can not edit anything
    /// - Returns: Non edit more view
    func showNonEditModeView() -> some View {
        List {
            ImageView(imageURL: childViewModel.imageURLTextField,
                      width: UIScreen.main.bounds.width * 0.8,
                      height: UIScreen.main.bounds.width * 0.8)
            Text(childViewModel.locationTextField)
            NavigationLink {
                MapView(favouritePlaceModel: $favouritePlaceModel,
                        favouritePlaceObservableModel: favouritePlaceObservableModel)
            } label: {
                HStack{
                    ImageView(imageURL: "")
                    Text("Show Map View")
                }
            }

            HStack {
                Text("Latitude: ")
                Text(childViewModel.latitudeTextField)
            }
            HStack {
                Text("Longitude: ")
                Text(childViewModel.longitudeFieldEntry)
            }
        }
    }
}

#if DEBUG
struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView(favouritePlaceModel: FavouritePlaceDataModel(id: UUID()), favouritePlaceObservableModel: FavouritePlaceObservableModel())
    }
}
#endif

