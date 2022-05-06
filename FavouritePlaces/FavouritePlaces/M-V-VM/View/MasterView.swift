//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 03/05/22.
//

import SwiftUI

struct MasterView: View {
    
    @State var favouritePlaceModels: [FavouritePlaceModel] = []
    let viewContext = PersistenceController.shared.container.viewContext
    
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
    
    func updateFavouritePlaceModels() {
        favouritePlaceModels = CoreDataManager.shared.getFavouritePlaceModels() ?? []
    }
    
    private func addItem() {
        withAnimation {
            let newItem = FavouritePlaceModel(context: viewContext)
            newItem.id = Int32(favouritePlaceModels.count)
            newItem.location = "New Place"
            CoreDataManager.shared.addItem()
            updateFavouritePlaceModels()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            CoreDataManager.shared.deleteData(offsets: offsets, favouritePlaceModels: favouritePlaceModels)
            updateFavouritePlaceModels()
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView(favouritePlaceModels: [])
    }
}
