//
//  ImageItemView.swift
//  FavouritePlaces
//
//  Created by Ajay Girolkar on 03/05/22.
//

import SwiftUI

struct ImageItemView: View {
    let text: String
    let imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: "https://picsum.photos/seed/picsum/200/300")) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }.frame(width: 100, height: 100, alignment: .center)
    }
}

struct ImageItemView_Previews: PreviewProvider {
    static var previews: some View {
        ImageItemView(text: "Australia", imageURL: "")
    }
}
