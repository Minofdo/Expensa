//
//  AddRecordView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-24.
//

import SwiftUI

struct AddRecordView: View {
    
    @EnvironmentObject var userData: UserData
    @State var selection = "I"
    @ObservedObject var recordViewModel = AddRecordViewModel()
    
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                Text("Income")
                    .tag("I")
                Text("Expense")
                    .tag("E")
            }
            .pickerStyle(.segmented)
            .padding(.all, 10)
            if selection == "I" {
                VStack {
                    Spacer()
                    Text("ADD INCOME")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                        .padding(.bottom, -1)
                        .font(.subheadline)
                    VStack {
                        DatePicker(selection: $recordViewModel.date, in: ...Date.now, displayedComponents: .date) {
                            Text("Date")
                        }
                        .datePickerStyle(.compact)
                        .padding(.bottom, 20)
                        
                        HStack{
                            Text("Amount")
                            Spacer()
                            HStack {
                                Text("LKR")
                                    .fixedSize()
                                TextField("Amount", text: $recordViewModel.amount)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(.plain)
                                    .keyboardType(.decimalPad)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .frame(width: 120, alignment: .trailing)
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
                        TextEditor(text: $recordViewModel.description)
                            .padding(5)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.bottom, 20)
                            .frame(maxHeight: 70)
                        
                        Text("Location")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, -2)
                        TextField("Enter Location", text: $recordViewModel.location)
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
                    Spacer()
                    Button(action: {
                        Task {
                            if let balance = userData.basicBudget?.balance {
                                userData.isLoadingData = true
                                await recordViewModel.saveIncome(userData.email, balance: balance) { result in
                                    userData.isLoadingData = false
                                    userData.isLoadingData = false
                                    if (result) {
                                        //dismiss()
                                    }
                                }
                            } else {
                                recordViewModel.messageTitle = "ERROR"
                                recordViewModel.messageBody = "Error occurred when retrieving user data. Please try again later."
                                recordViewModel.showAlert = true
                            }
                        }
                    }) {
                        Text("Save Income").font(.title2)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 10)
                .background(Color.secondary.opacity(0.4))
            } else {
                VStack {
                    Spacer()
                    Text("ADD EXPENSE")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                        .padding(.bottom, -1)
                        .font(.subheadline)
                    VStack {
                        DatePicker(selection: $recordViewModel.date, in: ...Date.now, displayedComponents: .date) {
                            Text("Date")
                        }
                        .datePickerStyle(.compact)
                        .padding(.bottom, 20)
                        
                        HStack{
                            Text("Amount")
                            Spacer()
                            HStack {
                                Text("LKR")
                                    .fixedSize()
                                TextField("Amount", text: $recordViewModel.amount)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(.plain)
                                    .keyboardType(.decimalPad)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .frame(width: 120, alignment: .trailing)
                            }
                            .padding(.all, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 3)
                                    .stroke(.gray, lineWidth: 1)
                            )
                        }
                        .padding(.bottom, 20)
                        
                        HStack{
                            Text("Category")
                            Picker("", selection: $recordViewModel.category) {
                                Text("Savings")
                                    .tag("savings")
                                Text("Entertainment")
                                    .tag("entertainment")
                                Text("Food & Beverage")
                                    .tag("food")
                                Text("Travel")
                                    .tag("travel")
                                Text("Maintenance")
                                    .tag("maintenance")
                                Text("Other Expense")
                                    .tag("other")
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.bottom, 20)
                        
                        Text("Description")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, -2)
                        TextEditor(text: $recordViewModel.description)
                            .padding(5)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.bottom, 20)
                            .frame(maxHeight: 70)
                        
                        Text("Location")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, -2)
                        TextField("Enter Location", text: $recordViewModel.location)
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
                    Spacer()
                    Button(action: {
                        Task {
                            if let balance = userData.basicBudget?.balance {
                                userData.isLoadingData = true
                                await recordViewModel.saveExpense(userData.email, balance: balance) { result in
                                    userData.isLoadingData = false
                                    userData.isLoadingData = false
                                    if (result) {
                                        //dismiss()
                                    }
                                }
                            } else {
                                recordViewModel.messageTitle = "ERROR"
                                recordViewModel.messageBody = "Error occurred when retrieving user data. Please try again later."
                                recordViewModel.showAlert = true
                            }
                        }
                    }) {
                        Text("Save Expense").font(.title2)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 10)
                .background(Color.secondary.opacity(0.4))
                
            }
        }
        .navigationBarTitle("New Record", displayMode: .inline)
        .overlay(
            userData.isLoadingData ? LoadingView() : nil
        )
        .alert(isPresented: $recordViewModel.showAlert) {
            Alert(title: Text(recordViewModel.messageTitle), message: Text(recordViewModel.messageBody), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddRecordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddRecordView()
        }
    }
}
