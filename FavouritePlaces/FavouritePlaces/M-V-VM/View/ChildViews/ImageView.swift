//
//  ImageView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 05/05/22.
//

import SwiftUI

struct ImageView: View {
    let imageURL: String
    var width: CGFloat = 40
    var height: CGFloat = 40
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL.removeEmptySpaces())) { image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
        }.frame(width: width, height: height, alignment: .center)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageURL: "https://picsum.photos/seed/picsum/200/300")
    }
}
