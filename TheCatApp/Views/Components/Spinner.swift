//
//  Spinner.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import Foundation
import SwiftUI

struct Spinner: UIViewRepresentable {
	let style: UIActivityIndicatorView.Style

	func makeUIView(context: Context) -> UIActivityIndicatorView {
		let spinner = UIActivityIndicatorView(style: style)
		spinner.hidesWhenStopped = true
		spinner.startAnimating()
		return spinner
	}
	
	func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
