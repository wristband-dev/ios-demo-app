import SwiftUI

struct InvoicesView: View {
    @StateObject var invoiceViewModel = InvoiceViewModel()
    
    var body: some View {
        VStack {
            VStack (spacing: 20) {
                CreateInvoiceView()
                    .environmentObject(invoiceViewModel)
                if !invoiceViewModel.invoices.isEmpty {
                    Divider()
                    AllInvoicesView()
                        .environmentObject(invoiceViewModel)
                } else {
                    Spacer()
                }
            }
            .padding()
            .onAppear {
                invoiceViewModel.loadInvoices()
            }
        }
        .navigationTitle("Invoices")
    }
    
    struct CreateInvoiceView: View {
        @EnvironmentObject var invoiceViewModel: InvoiceViewModel
        
        var body: some View {
            VStack {
                SubHeaderView(subHeader: invoiceViewModel.editMode ? "Edit Invoice" : "Create Invoice")
                HStack {
                    TextField("Company Name", text: $invoiceViewModel.companyName)
                        .defaultTextFieldStyle()
                    HStack {
                        Text("$")
                            .font(.title)
                            .bold()
                        TextField("Amount", text: $invoiceViewModel.amount)
                            .keyboardType(.decimalPad)
                            .defaultTextFieldStyle()
                    }
                }
                TextField("Description", text: $invoiceViewModel.description)
                    .defaultTextFieldStyle()
                if invoiceViewModel.newInvoiceComplete() {
                    Button(action: {
                        withAnimation {
                            if invoiceViewModel.editMode {
                                invoiceViewModel.editInvoice()
                            } else {
                                invoiceViewModel.addInvoice()
                            }
                        }
                    }, label: {
                        Text("Save")
                            .defaultButtonStyle()
                    })
                } else {
                    Text("Save")
                        .defaultButtonStyle().opacity(0.5)
                }
            }
        }
    }
    
    struct AllInvoicesView: View {
        @EnvironmentObject var invoiceViewModel: InvoiceViewModel
        
        var body: some View {
            VStack {
                SubHeaderView(subHeader: "All Invoices")
                ScrollView {
                    ForEach(invoiceViewModel.invoices) { invoice in
                        HStack {
                            VStack {
                                HStack {
                                    Text(invoice.companyName)
                                    Spacer()
                                    if let formattedAmount = invoiceViewModel.formatDollarAmount(amount: invoice.amount) {
                                        Text(formattedAmount)
                                            .bold()
                                    }
                                }
                                .font(.title2)
                                Text(invoice.description)
                                    .font(.caption)
                                    .italic()
                            }
                            .defaultTextFieldStyle()
                            if invoice.id == invoiceViewModel.selectedInvoiceId {
                                Button(action: {
                                    if invoiceViewModel.editMode {
                                        invoiceViewModel.setEditModeFalse()
                                    } else {
                                        invoiceViewModel.setEditModeTrue(invoice: invoice)
                                    }
                                }, label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 45)
                                        .foregroundColor(invoiceViewModel.editMode ? CustomColors.invoBlue : .gray)
                                })
                                Button(action: {
                                    invoiceViewModel.removeInvoice(invoiceId: invoice.id)
                                    invoiceViewModel.setEditModeFalse()
                                }, label: {
                                    Image(systemName: "x.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 45)
                                        .foregroundColor(.red)
                                })
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                if invoiceViewModel.selectedInvoiceId == invoice.id {
                                    invoiceViewModel.selectedInvoiceId = nil
                                    invoiceViewModel.setEditModeFalse()
                                } else {
                                    invoiceViewModel.selectedInvoiceId = invoice.id
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}



struct InvoicesView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationStack {
            InvoicesView()
        }
    }
}
