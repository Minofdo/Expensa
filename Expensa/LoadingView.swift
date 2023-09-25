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

struct CircleProgressView: View {
    @State private var progressValue: Double
    @State private var progressColor: Color
    @State private var textLabel: String
    
    init(progressValue: Double, progressColor: Color) {
        self.progressColor = progressColor
        if (progressValue > Double.greatestFiniteMagnitude || progressValue < -Double.greatestFiniteMagnitude) {
            self.progressValue = 1
            self.textLabel = "∞"
        } else {
            self.progressValue = progressValue
            self.textLabel = String(format: "%.0f", (progressValue * 100)) + "%"
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Text(textLabel)
                    .font(.title2)
                    .bold()
                Circle()
                    .stroke(
                        progressColor.opacity(0.2),
                        lineWidth: 30
                    )
                
                Circle()
                    .trim(from: 0, to: abs(progressValue))
                    .stroke(
                        progressColor,
                        style: StrokeStyle(
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .scaleEffect(x: (progressValue < 0) ? -1 : 1, y: 1)
                    .animation(.easeOut, value: abs(progressValue))
                    .opacity(1)
                
                Circle()
                    .trim(from: 0, to: abs(progressValue))
                    .stroke(
                        Color.red,
                        style: StrokeStyle(
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .scaleEffect(x: (progressValue < 0) ? -1 : 1, y: 1)
                    .animation(.easeOut, value: abs(progressValue))
                    .opacity((progressValue < 0) ? 1 : calculateOpacity())
            }
        }.padding()
    }
    
    func calculateOpacity() -> Double {
        let tempVal = abs(progressValue)
        if (tempVal < 0.05) {
            return 1
        } else if (tempVal < 0.10) {
            return 0.9
        } else if (tempVal < 0.15) {
            return 0.8
        } else if (tempVal < 0.20) {
            return 0.7
        } else {
            return 0
        }
    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView(progressValue: 0.2, progressColor: .yellow).padding()
    }
}
