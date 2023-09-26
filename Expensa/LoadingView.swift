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
    
    @ObservedObject var dashViewModel: DashboardViewModel
    @State var categoryID: String
    
    //    init(progressValue: Double, progressColor: Color) {
    //        self.progressColor = progressColor
    //        if (progressValue > Double.greatestFiniteMagnitude || progressValue < -Double.greatestFiniteMagnitude) {
    //            self.progressValue = 1
    //            self.textLabel = "∞"
    //        } else {
    //            self.progressValue = progressValue
    //            self.textLabel = String(format: "%.0f", (progressValue * 100)) + "%"
    //        }
    //    }
    
    var body: some View {
        let colour = dashViewModel.catColors[categoryID] ?? Color.gray
        let object = calculateData(dashViewModel.catValues[categoryID] ?? 0)
        
        VStack {
            ZStack {
                Text(object.text)
                    .font(.title2)
                    .bold()
                Circle()
                    .stroke(
                        colour.opacity(0.2),
                        lineWidth: 30
                    )
                
                Circle()
                    .trim(from: 0, to: abs(object.value))
                    .stroke(
                        colour,
                        style: StrokeStyle(
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .scaleEffect(x: (object.value < 0) ? -1 : 1, y: 1)
                    .animation(.easeOut, value: abs(object.value))
                    .opacity(1)
                
                Circle()
                    .trim(from: 0, to: abs(object.value))
                    .stroke(
                        Color.red,
                        style: StrokeStyle(
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .scaleEffect(x: (object.value < 0) ? -1 : 1, y: 1)
                    .animation(.easeOut, value: abs(object.value))
                    .opacity((object.value < 0) ? 1 : calculateOpacity())
            }
        }.padding()
    }
    
    func calculateOpacity() -> Double {
        let tempVal = abs(dashViewModel.catValues[categoryID] ?? 0)
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
    
    func calculateData(_ progressValue: Double) -> (text: String, value: Double) {
        var updatedProgress: Double = 0
        var textValue = ""
        if (progressValue > Double.greatestFiniteMagnitude || progressValue < -Double.greatestFiniteMagnitude) {
            updatedProgress = 1
            textValue = "∞"
        } else {
            updatedProgress = progressValue
            textValue = String(format: "%.0f", (progressValue * 100)) + "%"
        }
        return (textValue, updatedProgress)
    }
    
}
