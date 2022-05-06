//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 03/05/22.
//

import SwiftUI

struct MasterView: View {

    @State var favouritePlaceModels: [FavouritePlaceDataModel] = []
    let viewContext = PersistenceController.shared.container.viewContext
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favouritePlaceModels) { item in
                    NavigationLink {
                        ChildView(favouritePlaceModels: $favouritePlaceModels,
                                  favouritePlaceModel: item)
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
    
    func updateFavouritePlaceModels() {
        //favouritePlaceModels = CoreDataManager.getFavouritePlaceModels() ?? []
    }

    private func addItem() {
        withAnimation {
            let newItem = FavouritePlaceModel(context: viewContext)
            newItem.id = UUID()
            newItem.location = "New Place"
            CoreDataManager.shared.addItem()
            updateFavouritePlaceModels()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            CoreDataManager.shared.deleteData(offsets: offsets, favouritePlaceDataModels: favouritePlaceModels)
            updateFavouritePlaceModels()
    }
}
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView(favouritePlaceModels: [])
    }
}
