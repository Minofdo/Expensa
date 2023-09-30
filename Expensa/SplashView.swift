//
//  SplashView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-30.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Image("Expensa")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .foregroundColor(.primary)
                .shadow(color: .green, radius: 2, x: 0, y: 0)
                .padding(.top, 10)
            Spacer()
            ProgressView()
                .padding()
                .controlSize(.large)
                .tint(.primary)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
