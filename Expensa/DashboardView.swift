//
//  DashboardView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-12.
//

import SwiftUI
import Firebase

struct DashboardView: View {
    
    @EnvironmentObject var userData: UserData
    @StateObject var dashViewModel = DashboardViewModel()
    
    @State var showUpdateSheet = false
    
    var body: some View {
        VStack {
            VStack {
                Text("Running Balance")
                    .padding(.top, 0)
                HStack(spacing:0) {
                    Button {} label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .padding(.trailing, 2)
                    .opacity(0)
                    
                    HStack {
                        Text("LKR")
                        Text(String(format: "%.2f", userData.basicBudget?.balance ?? 0))
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(10)
                    
                    NavigationLink(destination: HistoryView()) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                    .tint(.blue)
                    .padding(.leading, 2)
                }
                
                Picker("", selection: $dashViewModel.pickerOption) {
                    Text("Weekly")
                        .tag("W")
                    Text("Monthly")
                        .tag("M")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical, 2)
                .padding(.horizontal, 10)
                .onChange(of: dashViewModel.pickerOption, perform: { _ in
                    dashViewModel.isLoadingData = true
                    Task {
                        do {
                            try await userData.loadExpenses()
                        } catch {
                            print(error)
                        }
                        DispatchQueue.main.async {
                            dashViewModel.calcExpensePercentage(userData)
                            self.dashViewModel.isLoadingData = false
                        }
                    }
                })
                
                Divider()
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, -8)
            
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack {
                        // dynamically create and display dashboard gauges
                        let userBudget = userData.basicBudget
                        ForEach(0..<(dashViewModel.categories.count/2), id: \.self) { index in
                            let indexOne = (index*2)
                            let catOne = dashViewModel.categories[indexOne].id
                            let indexTwo = ((index*2) + 1)
                            let catTwo = dashViewModel.categories[indexTwo].id
                            HStack {
                                VStack {
                                    Text(dashViewModel.categories[indexOne].label)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                    CircleProgressView(dashViewModel: dashViewModel, categoryID: catOne)
                                    HStack {
                                        Text("Budget:")
                                        Spacer()
                                        Text(String(format: "%.0f", userBudget?.budgetForCategory[catOne] ?? 0))
                                            .bold()
                                    }
                                    HStack {
                                        Text("Current:")
                                        Spacer()
                                        Text(String(format: "%.0f", userBudget?.expenseForCategory[catOne] ?? 0))
                                            .bold()
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.leading)
                                .padding(.trailing, 3)
                                VStack {
                                    Text(dashViewModel.categories[indexTwo].label)
                                        .bold()
                                        .multilineTextAlignment(.center)
                                    CircleProgressView(dashViewModel: dashViewModel, categoryID: catTwo)
                                    HStack {
                                        Text("Budget:")
                                        Spacer()
                                        Text(String(format: "%.0f", userBudget?.budgetForCategory[catTwo] ?? 0))
                                            .bold()
                                    }
                                    HStack {
                                        Text("Current:")
                                        Spacer()
                                        Text(String(format: "%.0f", userBudget?.expenseForCategory[catTwo] ?? 0))
                                            .bold()
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.trailing)
                                .padding(.leading, 3)
                            }
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                    .padding(.vertical)
                }
                .frame(maxWidth: .infinity)
                .navigationBarTitle("Dashboard", displayMode: .inline)
            }
            .toolbar {
                // add buttons to navigation bar
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dashViewModel.showLogout = true
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                    .tint(.green)
                    .confirmationDialog("", isPresented: $dashViewModel.showLogout) {
                        Button("Change Budget") {
                            showUpdateSheet = true
                        }
                        Button("Log Out", role: .destructive) {
                            do {
                                try Auth.auth().signOut()
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text(userData.email ?? "Are you sure to log out?")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddRecordView()) {
                        Text("Add")
                        Image(systemName: "plus.square")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
            .onAppear {
                print("DASHBOARD")
                // show different welcome messages depending on user status
                if (!userData.isGreetDisplayed) {
                    if (userData.isFirstLogin) {
                        dashViewModel.messageTitle = "Welcome"
                        dashViewModel.messageBody = "Welcome to Expensa. Start your journey by creating a budget."
                    } else {
                        dashViewModel.messageTitle = "Welcome Back!"
                        dashViewModel.messageBody = "Welcome back to Expensa. Don't forget to add your daily expenses."
                    }
                    DispatchQueue.main.async {
                        dashViewModel.showAlert = true
                        userData.isGreetDisplayed = true
                    }
                }
                
                dashViewModel.isLoadingData = true
                Task {
                    do {
                        try await userData.loadExpenses()
                    } catch {
                        print(error)
                    }
                    DispatchQueue.main.async {
                        dashViewModel.calcExpensePercentage(userData)
                        self.dashViewModel.isLoadingData = false
                    }
                }
            }
            .alert(isPresented: $dashViewModel.showAlert) {
                Alert(title: Text(dashViewModel.messageTitle), message: Text(dashViewModel.messageBody), dismissButton: .default(Text("Let's GO!")) {
                    if (userData.isFirstLogin) {
                        dashViewModel.showSetupSheet = true
                    }
                })
            }
            .sheet(isPresented: $dashViewModel.showSetupSheet) {
                SetBudgetView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $showUpdateSheet) {
                SetBudgetView(budgetViewModel: getBudgetViewModel(), isUpdate: true)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
            .overlay(
                dashViewModel.isLoadingData ? LoadingView() : nil
            )
        }
    }
    
    func getBudgetViewModel() -> SetBudgetViewModel {
        let data = SetBudgetViewModel()
        data.balance = userData.basicBudget?.balance ?? 0
        data.initialAmount = String(format: "%.0f", userData.basicBudget?.balance ?? 0)
        let catBudget = userData.basicBudget?.budgetForCategory
        if let catBudget = catBudget {
            data.savings = String(format: "%.0f", catBudget["savings"] ?? 0)
            data.entertainment = String(format: "%.0f", catBudget["entertainment"] ?? 0)
            data.food = String(format: "%.0f", catBudget["food"] ?? 0)
            data.travel = String(format: "%.0f", catBudget["travel"] ?? 0)
            data.maintenance = String(format: "%.0f", catBudget["maintenance"] ?? 0)
            data.other = String(format: "%.0f", catBudget["other"] ?? 0)
        }
        return data
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DashboardView()
        }
    }
}
