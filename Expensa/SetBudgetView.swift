//
//  SetBudgetView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-16.
//

import SwiftUI

struct SetBudgetView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userData: UserData
    @ObservedObject var budgetViewModel = SetBudgetViewModel()
    
    @State var isUpdate = false
    
    var categories = Categories()
    
    var body: some View {
        // https://medium.com/@sharma17krups/swiftui-form-tutorial-how-to-create-settings-screen-using-form-part-1-8e8e80cf584e
        Form {
            
            if !isUpdate {
                HStack{
                    Spacer()
                    VStack {
                        Text("MONTHLY BALANCE")
                            .font(.title2)
                        HStack {
                            Text("LKR")
                                .font(.title)
                            Text(String(format: "%.2f", budgetViewModel.balance))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 1)
                        .padding(.bottom, 2)
                        Text("Entered values will get reflected here. You can continue with a negative value")
                            .multilineTextAlignment(.center)
                            .font(.callout)
                    }
                    Spacer()
                }
                .listRowInsets(EdgeInsets())
                .padding()
                .background(Color.green.opacity(0.3))
                
                Section(header: Text("Amount for budgeting"), content: {
                    HStack{
                        Text("Initial Amount")
                        Spacer()
                        HStack {
                            Text("LKR")
                                .fixedSize()
                            TextField("Amount", text: $budgetViewModel.initialAmount)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .keyboardType(.decimalPad)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(width: 90, alignment: .trailing)
                        }
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.gray, lineWidth: 1)
                        )
                    }
                    
                })
            }
            
            Section(header: Text("Budget"), content: {
                VStack {
                    Picker("", selection: $budgetViewModel.savingsPeriod) {
                        Text("Weekly Allowance")
                            .tag("W")
                        Text("Monthly Allowance")
                            .tag("M")
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .padding(.top, 5)
                    .padding(.leading, -3)
                    HStack{
                        Text("Savings")
                        Spacer()
                        HStack {
                            Text("LKR")
                                .fixedSize()
                            TextField("Amount", text: $budgetViewModel.savings)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .keyboardType(.decimalPad)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(width: 90, alignment: .trailing)
                        }
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.gray, lineWidth: 1)
                        )
                    }
                }
                
                VStack {
                    Picker("", selection: $budgetViewModel.entertainmentPeriod) {
                        Text("Weekly Allowance")
                            .tag("W")
                        Text("Monthly Allowance")
                            .tag("M")
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .padding(.top, 5)
                    .padding(.leading, -3)
                    HStack{
                        Text("Entertainment")
                        Spacer()
                        HStack {
                            Text("LKR")
                                .fixedSize()
                            TextField("Amount", text: $budgetViewModel.entertainment)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .keyboardType(.decimalPad)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(width: 90, alignment: .trailing)
                        }
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.gray, lineWidth: 1)
                        )
                    }
                }
                VStack {
                    Picker("", selection: $budgetViewModel.foodPeriod) {
                        Text("Weekly Allowance")
                            .tag("W")
                        Text("Monthly Allowance")
                            .tag("M")
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .padding(.top, 5)
                    .padding(.leading, -3)
                    HStack{
                        Text("Food & Beverage")
                        Spacer()
                        HStack {
                            Text("LKR")
                                .fixedSize()
                            TextField("Amount", text: $budgetViewModel.food)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .keyboardType(.decimalPad)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(width: 90, alignment: .trailing)
                        }
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.gray, lineWidth: 1)
                        )
                    }
                }
                
                VStack {
                    Picker("", selection: $budgetViewModel.travelPeriod) {
                        Text("Weekly Allowance")
                            .tag("W")
                        Text("Monthly Allowance")
                            .tag("M")
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .padding(.top, 5)
                    .padding(.leading, -3)
                    HStack{
                        Text("Travel")
                        Spacer()
                        HStack {
                            Text("LKR")
                                .fixedSize()
                            TextField("Amount", text: $budgetViewModel.travel)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .keyboardType(.decimalPad)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(width: 90, alignment: .trailing)
                        }
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.gray, lineWidth: 1)
                        )
                    }
                }
                
                VStack {
                    Picker("", selection: $budgetViewModel.maintenancePeriod) {
                        Text("Weekly Allowance")
                            .tag("W")
                        Text("Monthly Allowance")
                            .tag("M")
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .padding(.top, 5)
                    .padding(.leading, -3)
                    HStack{
                        Text("Maintenance")
                        Spacer()
                        HStack {
                            Text("LKR")
                                .fixedSize()
                            TextField("Amount", text: $budgetViewModel.maintenance)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .keyboardType(.decimalPad)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(width: 90, alignment: .trailing)
                        }
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.gray, lineWidth: 1)
                        )
                    }
                }
                
                VStack {
                    Picker("", selection: $budgetViewModel.otherPeriod) {
                        Text("Weekly Allowance")
                            .tag("W")
                        Text("Monthly Allowance")
                            .tag("M")
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .padding(.top, 5)
                    .padding(.leading, -3)
                    HStack{
                        Text("Other Expense")
                        Spacer()
                        HStack {
                            Text("LKR")
                                .fixedSize()
                            TextField("Amount", text: $budgetViewModel.other)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(.plain)
                                .keyboardType(.decimalPad)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .frame(width: 90, alignment: .trailing)
                        }
                        .padding(.all, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(.gray, lineWidth: 1)
                        )
                    }
                }
            })
            
            VStack {
                Button(
                    action: {
                        Task {
                            budgetViewModel.isLoadingData = true
                            await budgetViewModel.saveBasicBudgetDetails(userData.email, isUpdate) { result in
                            }
                            do {
                                try await userData.loadExpenses()
                            } catch {
                                print(error)
                            }
                            budgetViewModel.isLoadingData = false
                            dismiss()
                        }
                    },
                    label: {
                        Text(isUpdate ? "UPDATE" : "SAVE")
                            .font(.title2)
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity)
                            .bold()
                    }
                )
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .listRowBackground(Color.clear)
                .padding(.horizontal, 50)
                .alert(isPresented: $budgetViewModel.showAlert) {
                    Alert(title: Text(budgetViewModel.messageTitle), message: Text(budgetViewModel.messageBody), dismissButton: .default(Text("OK")))
                }
                if isUpdate {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.borderless)
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity)
                }
            }
            .listRowBackground(Color.clear)
        }
        .navigationBarTitle("Set-UP", displayMode: .large)
        .interactiveDismissDisabled()
        .overlay(
            budgetViewModel.isLoadingData ? LoadingView() : nil
        )
    }
}

struct SetBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SetBudgetView()
        }
    }
}
