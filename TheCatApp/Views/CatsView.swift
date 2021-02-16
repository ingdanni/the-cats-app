//
//  ContentView.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 12/2/21.
//

import UIKit
import SwiftUI
import Combine

struct CatsView: View {
	
	@ObservedObject var viewModel: CatsViewModel
	
    var body: some View {
		return NavigationView {
			VStack {
				CatsList(
					images: viewModel.state.images,
					isLoading: viewModel.state.canLoadNextPage,
					onScrolledAtBottom: viewModel.fetchNextPage
				)
				.onAppear(perform: viewModel.fetchNextPage)
			}
			.navigationBarTitle("Cats", displayMode: .large)
		}
    }
}

struct CatsList: View {
	let images: [CatImage]
	let isLoading: Bool
	let onScrolledAtBottom: () -> Void
	
	var body: some View {
		List {
			imageList
			if isLoading {
				loadingIndicator
			}
		}
	}
	
	private var imageList: some View {
		ForEach(images) { image in
			VStack {
				NavigationLink(destination: DetailView(viewModel: DetailViewModel(id: image.id, url: image.url))) {
					CatRow(url: image.url)
						.onAppear {
							if images.last == image {
								self.onScrolledAtBottom()
							}
						}
				}
			}
		}
	}
	
	private var loadingIndicator: some View {
		Spinner(style: .medium)
			.frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
	}
}



