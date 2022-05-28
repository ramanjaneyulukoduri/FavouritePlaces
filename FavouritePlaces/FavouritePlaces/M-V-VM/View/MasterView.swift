//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 03/05/22.
//

import SwiftUI

struct MasterView: View {
    
    ///State variable to update SwiftUI View
    @StateObject var favouritePlaceObservableModel = FavouritePlaceObservableModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favouritePlaceObservableModel.favouritePlaceModels) { item in
                    NavigationLink {
                        ChildView(favouritePlaceModel: item,
                                  favouritePlaceObservableModel: favouritePlaceObservableModel)
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
        }
    }
    
    
    /// Function to add new default entry
    private func addItem() {
        withAnimation {
            favouritePlaceObservableModel.addItem()
        }
    }
    
    
    /// function to delete entry from screen and coredata
    /// - Parameter offsets: index of deleted item
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            favouritePlaceObservableModel.deleteItems(offsets: offsets)
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static let favouritePlaceObservableModel = FavouritePlaceObservableModel()
    static var previews: some View {
        VStack {
            MasterView(favouritePlaceObservableModel: favouritePlaceObservableModel)
        }.onAppear {
            favouritePlaceObservableModel.favouritePlaceModels =   [FavouritePlaceDataModel(id: UUID(), imageURL: "https://picsum.photos/id/0/200/300",
                                                                                          location: nil, enterLocationDetailsText: "Nature",
                                                                                            locationDescription: "",   latitude: nil, longitude: nil),
                                                                    FavouritePlaceDataModel(id: UUID(), imageURL: "https://picsum.photos/id/1018/200/300",
                                                                                             location: nil, enterLocationDetailsText: "Nature",
                                                                                            locationDescription: "", latitude: nil, longitude: nil),
                                                                    FavouritePlaceDataModel(id: UUID(), imageURL: "https://picsum.photos/id/1018/200/300",
                                                                                            location: nil, enterLocationDetailsText: "Nature",
                                                                                            locationDescription: "",  latitude: nil, longitude: nil)]
        }
    }
}
