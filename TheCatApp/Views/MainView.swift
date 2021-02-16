//
//  MainView.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import SwiftUI

struct MainView: View {
    var body: some View {
		TabView {
			CatsView(viewModel: CatsViewModel())
				.tabItem {
					Label("Cats", systemImage: "list.dash")
				}
			
			FavoritesView(viewModel: FavoritesViewModel())
				.tabItem {
					Label("Favorites", systemImage: "heart")
				}
		}
    }
}
