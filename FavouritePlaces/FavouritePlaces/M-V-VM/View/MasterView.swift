//
//  MasterView.swift
//  FavouritePlaces
//
//  Created by Ajay Girolkar on 03/05/22.
//

import SwiftUI

struct MasterView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavouritePlaceModel.id, ascending: true)],
        animation: .default)
    private var favouritePlaceModels: FetchedResults<FavouritePlaceModel>

    var body: some View {
        NavigationView {
            List {
                ForEach(favouritePlaceModels) { item in
                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        ImageItemView(text: "Australia", imageURL: "")
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
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = FavouritePlaceModel(context: viewContext)
            newItem.location = "New Item"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { favouritePlaceModels[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
