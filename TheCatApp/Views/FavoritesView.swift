//
//  FavoritesView.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import SwiftUI

struct FavoritesView: View {
	
	@ObservedObject var viewModel: FavoritesViewModel
	
	var body: some View {
		return NavigationView {
			VStack {
				if viewModel.images.isEmpty {
					Text("Favorites list is empty")
				} else {
					List {
						ForEach(viewModel.images) { image in
							VStack {
								NavigationLink(destination: DetailView(viewModel: DetailViewModel(id: image.id, url: image.url))) {
									CatRow(url: image.url)
								}
							}
						}
					}
				}
			}
			.onAppear(perform: viewModel.fetchImages)
			.onReceive(NotificationCenter.default.publisher(for: .updateFavorites), perform: { _ in
				viewModel.fetchImages()
			})
			.navigationBarTitle("Favorites", displayMode: .large)
		}
	}

}
