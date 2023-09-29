//
//  HistoryView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-28.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject var userData: UserData
    
    @State var historyType = "E"
    @State var startDate = Date()
    @State var endDate = Date()
    
    @State var visibleRecords: [Record] = []
    @State var expenseRecords: [Record] = []
    @State var incomeRecords: [Record] = []
    
    @State var currentRecord: Record = Record(newBalance: 0, isExpense: false, amount: 0, recordDate: Date(), description: "", location: "", category: "")
    @State var showDetailSheet = false
    
    var catLabel = Categories().categoryLabel
    
    var body: some View {
        VStack {
            VStack {
                HStack(spacing: 0) {
                    Spacer()
                    DatePicker("", selection: $startDate, in: ...endDate, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                    Text(" to ")
                        .font(.subheadline)
                    DatePicker("", selection: $endDate, in: startDate...Date.now, displayedComponents: .date)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                    Spacer()
                    Button {
                        searchHistory()
                    } label: {
                        Text("Search")
                            .font(.subheadline)
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                    Spacer()
                }
                .padding(.top, 5)
                Picker("", selection: $historyType) {
                    Text("Expense")
                        .tag("E")
                    Text("Income")
                        .tag("I")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.vertical, 2)
                .padding(.horizontal, 10)
                .onChange(of: historyType, perform: { _ in
                        searchHistory()
                })
                
                Divider()
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, -8)
            
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    VStack {
                        
                        if (visibleRecords.isEmpty) {
                            Text("NO RECORDS TO DISPLAY")
                                .bold()
                                .font(.title3)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding(.top)
                                .padding()
                        }
                        
                        ForEach(0..<visibleRecords.count, id: \.self) { index in
                            let record = visibleRecords[index]
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    if (historyType == "E") {
                                        Text(catLabel[record.category] ?? "")
                                            .bold()
                                            .font(.title3)
                                        Spacer()
                                    }
                                    Text(dateFormatter(record.recordDate))
                                        .font(.body)
                                    Spacer()
                                    Text("LKR " + String(format: "%.2f", record.amount))
                                        .font(.body)
                                        .bold()
                                        .foregroundColor(.primary)
                                }
                                Text(record.description)
                                    .lineLimit(2)
                                    .padding(.top, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                HStack (spacing: 0) {
                                    Image(systemName: "mappin.circle")
                                        .padding(.trailing, 3)
                                    Text(record.location)
                                        .lineLimit(1)
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 3)
                            }
                            .padding(.all, 10)
                            .frame(maxWidth: .infinity)
                            .background((historyType == "E") ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                            .background(Color(.quaternarySystemFill))
                            .onTapGesture {
                                DispatchQueue.main.async() {
                                    self.currentRecord = visibleRecords[index]
                                    self.showDetailSheet = true
                                }
                            }
                            .cornerRadius(10)
                            .padding(.horizontal, 10)
                            .padding(.top, 10)
                        }
                    }
                    .frame(minHeight: geometry.size.height, alignment: .top)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGroupedBackground))
                .navigationBarTitle("History", displayMode: .inline)
            }
        }.onAppear {
            searchHistory()
        }
        .sheet(isPresented: $showDetailSheet) {
            RecordDetailView(record: $currentRecord)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    func searchHistory() {
        if let email = userData.email {
            let fireStore = FireStoreService(email)
            let dateCodes = fireStore.getDateCodesInRange(startDate, endDate)
            let data = fireStore.loadDetailedRecordsForDates(dateCodes, userData.dataSnapshot)
            expenseRecords = data.expenses
            incomeRecords = data.income
            if (historyType == "E") {
                visibleRecords = expenseRecords
            } else {
                visibleRecords = incomeRecords
            }
        }
    }
    
    func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView()
        }
    }
}
