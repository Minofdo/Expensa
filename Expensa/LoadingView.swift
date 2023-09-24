//
//  LoadingView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black).opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 48) {
                ProgressView().scaleEffect(3.0, anchor: .center)
                Text("Please Wait").font(.subheadline).fontWeight(.semibold)
            }
            .padding(.top, 20)
            .frame(width: 200, height: 200)
            .background(Color.white)
            .foregroundColor(Color.primary)
            .cornerRadius(16)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
