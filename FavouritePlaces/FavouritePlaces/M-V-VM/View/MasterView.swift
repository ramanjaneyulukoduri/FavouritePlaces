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
        }.onAppear {
            updateFavouritePlaceModels()
        }
    }
    
    func syncWithCoreData() {
        CoreDataManager.shared.syncCoreData(favouritePlaceDataModels: favouritePlaceModels)
    }
    
    func updateFavouritePlaceModels() {
        favouritePlaceModels = CoreDataManager.shared.getFavouritePlaceModels() ?? []
    }
    
    private func addItem() {
        withAnimation {
            favouritePlaceModels.append(FavouritePlaceDataModel(id: UUID(),
                                                                location: "New Object \(favouritePlaceModels.count) "))
        }
        syncWithCoreData()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            favouritePlaceModels.remove(atOffsets: offsets)
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView(favouritePlaceModels: [])
    }
}
