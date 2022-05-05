//
//  ImageItemView.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 03/05/22.
//

import SwiftUI

struct ImageItemView: View {
    let text: String
    let imageURL: String
    
    var body: some View {
        HStack(spacing: 30) {
            ImageView(imageURL: imageURL)
            Text(text)
        }
    }
}

struct ImageItemView_Previews: PreviewProvider {
    static var previews: some View {
        ImageItemView(text: "Australia", imageURL: "")
    }
}
