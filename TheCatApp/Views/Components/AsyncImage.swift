//
//  AsyncImage.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
	static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
	var imageCache: ImageCache {
		get { self[ImageCacheKey.self] }
		set { self[ImageCacheKey.self] = newValue }
	}
}

struct AsyncImage<Placeholder: View>: View {
	@StateObject private var loader: ImageLoader
	private let placeholder: Placeholder
	private let image: (UIImage) -> Image
	
	init(
		url: String,
		@ViewBuilder placeholder: () -> Placeholder,
		@ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
	) {
		self.placeholder = placeholder()
		self.image = image
		_loader = StateObject(wrappedValue: ImageLoader(url: URL(string: url)!, cache: Environment(\.imageCache).wrappedValue))
	}
	
	var body: some View {
		content
			.onAppear(perform: loader.load)
	}
	
	private var content: some View {
		Group {
			if loader.image != nil {
				image(loader.image!)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			} else {
				placeholder
			}
		}
	}
}
