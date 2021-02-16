//
//  CatRow.swift
//  TheCatApp
//
//  Created by Danny Narvaez on 15/2/21.
//

import Foundation
import SwiftUI

struct CatRow: View {
	let url: String
	
	var body: some View {
		AsyncImage(url: url, placeholder: { Spinner(style: .medium) })
			.frame(maxWidth: .infinity, minHeight: 200)
	}
}
