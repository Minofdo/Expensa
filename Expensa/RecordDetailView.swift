//
//  RecordDetailView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-29.
//

import SwiftUI

struct RecordDetailView: View {
    
    @Binding var record: Record
    
    var body: some View {
        VStack {
            DatePicker(selection: $record.recordDate, in: ...Date.now, displayedComponents: .date) {
                Text("Date")
            }
            .datePickerStyle(.compact)
            .padding(.bottom, 20)
            
            if (record.isExpense) {
                HStack{
                    Text("Category")
                    Spacer()
                    Text(Categories().categoryLabel[record.category] ?? "N/A")
                        .bold()
                }
                .padding(.bottom, 20)
            }
            
            HStack{
                Text("Amount")
                Spacer()
                HStack {
                    Text("LKR")
                        .fixedSize()
                    Text(String(format: "%.0f", record.amount))
                        .multilineTextAlignment(.trailing)
                        .frame(width: 120, alignment: .trailing)
                        .bold()
                }
                .padding(.all, 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(.gray, lineWidth: 1)
                )
            }
            .padding(.bottom, 20)
            
            Text("Description")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, -2)
            TextEditor(text: $record.description)
                .padding(5)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.bottom, 20)
                .frame(height: 80)
            
            Text("Location")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, -2)
            TextField("Enter Location", text: $record.location)
                .padding(5)
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray.opacity(0.5), lineWidth: 1)
                )
        }
        .padding()
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(5)
        .disabled(true)
    }
}
