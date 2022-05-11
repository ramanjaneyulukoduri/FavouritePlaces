//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 03/05/22.
//

import SwiftUI

struct MasterView: View {
    
    ///State variable to update SwiftUI View
    @State var favouritePlaceModels: [FavouritePlaceDataModel] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favouritePlaceModels) { item in
                    NavigationLink {
                        ChildView(favouritePlaceModel: item, favouritePlaceModels: $favouritePlaceModels)
                    } label: {
                        ImageItemView(text: item.location ?? "", imageURL: item.imageURL ?? "")
                    }
                }
                .onDelete(perform: deleteItems)
            }.navigationTitle(StringConstants.favouritePlaces)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            Text("Select an item")
        }.onAppear {
            updateFavouritePlaceModels()
        }
    }
    
    
    /// Function to get data from core data when view appears
    func updateFavouritePlaceModels() {
        favouritePlaceModels = CoreDataManager.shared.getFavouritePlaceModels() ?? []
    }
    
    /// Function to update coredata model
    func syncWithCoreData() {
        CoreDataManager.shared.syncCoreData(favouritePlaceDataModels: favouritePlaceModels)
    }
    
    
    /// Function to add new default entry
    private func addItem() {
        withAnimation {
            favouritePlaceModels.append(FavouritePlaceDataModel(id: UUID(),
                                                                location: "New Places \(favouritePlaceModels.count) "))
        }
        syncWithCoreData()
    }
    
    
    /// function to delete entry from screen and coredata
    /// - Parameter offsets: index of deleted item
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            favouritePlaceModels.remove(atOffsets: offsets)
            syncWithCoreData()
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView(favouritePlaceModels: [FavouritePlaceDataModel(id: UUID(), imageURL: "https://picsum.photos/id/0/200/300",
                                                                  latitude: nil, location: nil, enterLocationDetailsText: "Nature",
                                                                  locationDescription: "", longitude: nil),
                                          FavouritePlaceDataModel(id: UUID(), imageURL: "https://picsum.photos/id/1018/200/300",
                                                                                                    latitude: nil, location: nil, enterLocationDetailsText: "Nature",
                                                                                                    locationDescription: "", longitude: nil),
                                          FavouritePlaceDataModel(id: UUID(), imageURL: "https://picsum.photos/id/1018/200/300",
                                                                                                    latitude: nil, location: nil, enterLocationDetailsText: "Nature",
                                                                                                    locationDescription: "", longitude: nil)])
    }
}
