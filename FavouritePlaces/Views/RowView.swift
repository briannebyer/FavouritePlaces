//
//  RowView.swift
//  FavouritePlaces
//
//  Created by Brianne Byer on 26/4/2023.
//

import SwiftUI

struct RowView: View {
    var place: Place
    @State var image = defaultImage
    var body: some View {
        HStack {
            image
                .frame(width:40, height: 40)
                .clipShape(Rectangle())
                .cornerRadius(5)
            Text(place.rowDisplay)
                .lineLimit(2)
        }
        .task {
            image = await place.getImage()
        }
    }
}
