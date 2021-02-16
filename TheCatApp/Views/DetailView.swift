//
//  DetailView.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import SwiftUI

struct DetailView: View {
	
	let viewModel: DetailViewModel
	
	@State var isFavorite: Bool = false
	
    var body: some View {
		ScrollView(.vertical) {
			VStack(alignment: .center, spacing: 10) {
				AsyncImage(url: viewModel.url, placeholder: {
					Spinner(style: .medium)
				})
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				
				HStack(alignment: .center, spacing: 10) {
					Button(action: {
						viewModel.handleFavorite()
						isFavorite = viewModel.validate()
					}) {
						Image(systemName: isFavorite ? "heart.fill" : "heart")
					}
					
					Button(action: {
						viewModel.handleFavorite()
						isFavorite = viewModel.validate()
					}) {
						Text(isFavorite ? "Remove from favorites" : "Add to favorites")
					}
				}
				
				Spacer()
			}
			.frame(height: 350)
		}
		.onAppear {
			isFavorite = viewModel.validate()
		}
    }
	
	
}
