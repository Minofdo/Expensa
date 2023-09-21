//
//  SetBudgetView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-16.
//

import SwiftUI

struct SetBudgetView: View {
    
    @ObservedObject var budgetViewModel = SetBudgetViewModel()
    
    var categories = Categories()
    
    var body: some View {
        // https://medium.com/@sharma17krups/swiftui-form-tutorial-how-to-create-settings-screen-using-form-part-1-8e8e80cf584e
        Form {
            HStack{
                Spacer()
                VStack {
                    Text("BALANCE")
                        .font(.title2)
                    HStack {
                        Text("LKR")
                            .font(.title)
                        Text("0.00")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 1)
                    .padding(.bottom, 2)
                    Text("entered values will get reflected here")
                        .font(.callout)
                }
                Spacer()
            }
            
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
            
            Section(header: Text("Budget"), content: {
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
            })
            
            Button(
                action: {
                },
                label: {
                    Text("SAVE")
                        .font(.title2)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .bold()
                }
            )
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .listRowBackground(Color.clear)
            .padding(.horizontal, 50)
        }
        .navigationBarTitle("Set-UP", displayMode: .large)
    }
}

struct SetBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SetBudgetView()
        }
    }
}
