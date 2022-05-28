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
    @StateObject var mapViewViewModel = MapViewViewModel()
    
    var body: some View {
        VStack {
            if childViewModel.isEditing {
                showEditModeView()
            } else {
                showNonEditModeView()
            }
        }.onReceive(favouritePlaceObservableModel.$favouritePlaceModels, perform: { items in
            favouritePlaceModel = items.filter{$0.id == favouritePlaceModel.id}.last ?? favouritePlaceModel
            syncDataFromModel()
        })
            .onAppear {
                syncDataFromModel()
                getNetworkData()
                syncMasterModel()
            }.navigationTitle(favouritePlaceModel.location  ?? "")
            .toolbar {
                //To show buttons in navigation bar
                ToolbarItem(placement: .navigationBarTrailing) {
                   getToolBarItem()
                }
            }
    }
    
    func getToolBarItem() -> some View {
        HStack {
            if childViewModel.isEditing {
                addEditModeHeaderView()
            } else {
                Button(StringConstants.edit) {
                    childViewModel.isEditing.toggle()
                }
            }
        }
    }
    
    /// Show Header view with reset or undo reset button based on user selection.
    /// - Returns: view
    func addEditModeHeaderView () -> some View {
        HStack {
            Button(childViewModel.isEditing ? StringConstants.done : StringConstants.edit) {
                childViewModel.isEditing.toggle()
                saveDataInModel()
                syncMasterModel()
            }
        }
    }
    
    
    /// View to display when user is in edit more
    /// - Returns: Edit more view
    func showEditModeView() -> some View {
        VStack {
            List {
                TextField(StringConstants.enterCityName, text: $childViewModel.cityNameTextField)
                TextField(StringConstants.enterImageURL, text: $childViewModel.imageURLTextField)
                Text(StringConstants.enterLocationDetails)
                    .fontWeight(.bold)
                TextField(StringConstants.enterLocation, text: $childViewModel.locationTextField)
                HStack {
                    Text(StringConstants.latitude)
                    TextField(StringConstants.textField, text: $childViewModel.latitudeTextField)
                        .onChange(of: childViewModel.latitudeTextField) { newValue in
                            favouritePlaceModel.latitude = newValue
                        }
                }
                HStack {
                    Text(StringConstants.longitude)
                    TextField(StringConstants.textField, text: $childViewModel.longitudeFieldEntry)
                        .onChange(of: childViewModel.longitudeFieldEntry) { newValue in
                            favouritePlaceModel.longitude = newValue
                        }
                }
            }.background(Color.clear)
                .listStyle(PlainListStyle())

            getSunriseAndSunsetView()
        }.padding()
    }
    
    /// Function to create nonedit mode view where user can not edit anything
    /// - Returns: Non edit more view
    func showNonEditModeView() -> some View {
        VStack {
            List {
                ImageView(imageURL: childViewModel.imageURLTextField,
                          width: UIScreen.main.bounds.width * 0.8,
                          height: UIScreen.main.bounds.width * 0.8)
                    .padding()
                Text(childViewModel.locationTextField)
                NavigationLink {
                    MapView()
                        .environmentObject(mapViewViewModel)
                } label: {
                    HStack{
                        Image(systemName: ImageName.circle)
                        Text(StringConstants.showMapView)
                    }
                }
                
                HStack {
                    Text(StringConstants.latitude)
                    Text(favouritePlaceModel.latitude ?? "0.0")
                }
                HStack {
                    Text(StringConstants.longitude)
                    Text(favouritePlaceModel.longitude ?? "0.0")
                }
            }.background(Color.clear)
                .listStyle(PlainListStyle())

            getSunriseAndSunsetView()
        }.padding()
    }
    
    func getSunriseAndSunsetView() -> some View {
        HStack {
            if let sunrise = favouritePlaceModel.sunrise,
               let sunset = favouritePlaceModel.sunset {
                HStack {
                    Image(systemName: ImageName.sunrise)
                    Text(sunrise)
                }
                Spacer()
                HStack {
                    Image(systemName: ImageName.sunset)
                    Text(sunset)
                }
            }
        }
    }
}

extension ChildView {
    
    func getNetworkData() {
        NetworkManager.shared.getWeatherInformation(latitude: favouritePlaceModel.latitude ?? "",
                                                    longitude: favouritePlaceModel.longitude ?? "") { weatherInformation, error in
            favouritePlaceModel.sunrise = weatherInformation?.sunrise ?? ""
            favouritePlaceModel.sunset = weatherInformation?.sunset ?? ""
        }
    }
    
    /// Get initial values from master view and show in parent view
    func syncDataFromModel() {
        mapViewViewModel.favouritePlaceModel = favouritePlaceModel
        mapViewViewModel.favouritePlaceObservableModel = favouritePlaceObservableModel
        childViewModel.cityNameTextField = favouritePlaceModel.location ?? ""
        childViewModel.locationTextField = favouritePlaceModel.locationDescription ?? ""
        childViewModel.imageURLTextField = favouritePlaceModel.imageURL ?? ""
        childViewModel.latitudeTextField = favouritePlaceModel.latitude ?? "0.0"
        childViewModel.longitudeFieldEntry = favouritePlaceModel.longitude ?? "0.0"
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
    
}

#if DEBUG
struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView(favouritePlaceModel: FavouritePlaceDataModel(id: UUID()), favouritePlaceObservableModel: FavouritePlaceObservableModel())
    }
}
#endif

