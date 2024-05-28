import Foundation

@MainActor
class InvoiceViewModel: ObservableObject {
    
    @Published var id: UUID? = nil
    @Published var companyName = ""
    @Published var description = ""
    @Published var amount = ""
    
    @Published var invoices: [Invoice] = []
    
    @Published var selectedInvoiceId: UUID? = nil
    @Published var editMode: Bool = false
    
    func loadInvoices() {
        self.invoices = InvoiceService.shared.loadInvoices()
    }
    
    func addInvoice() {
        if let doubleAmount = Double(self.amount) {
            let invoice = Invoice(
                id: UUID(),
                companyName: self.companyName,
                description: self.description,
                amount: doubleAmount
            )
            
            InvoiceService.shared.addInvoice(invoice)
            
            self.companyName = ""
            self.description = ""
            self.amount = ""
            
            invoices.append(invoice)
        }
    }
    
    func setEditModeTrue(invoice: Invoice) {
        self.id = invoice.id
        self.editMode = true
        self.companyName = invoice.companyName
        self.amount = String(invoice.amount)
        self.description = invoice.description
    }
    
    func setEditModeFalse() {
        self.id = nil
        self.editMode = false
        self.companyName = ""
        self.amount = ""
        self.description = ""
    }
    
    func editInvoice() {
        if let doubleAmount = Double(self.amount), let id = self.id {
            let invoice = Invoice(
                id: id,
                companyName: self.companyName,
                description: self.description,
                amount: doubleAmount
            )
            
            InvoiceService.shared.updateInvoice(with: invoice)
            
            self.companyName = ""
            self.description = ""
            self.amount = ""
            
            if let index = self.invoices.firstIndex(where: { $0.id == id }) {
                invoices[index] = invoice
            }
            self.id = nil
            self.selectedInvoiceId = nil
            self.editMode = false
        }
    }
    
    func removeInvoice(invoiceId: UUID) {
        InvoiceService.shared.deleteInvoice(withId: invoiceId)
        invoices.removeAll { $0.id == invoiceId }
    }
    
    func newInvoiceComplete() -> Bool {
        if self.editMode {
            if let index = invoices.firstIndex(where: { $0.id == self.id }) {
                let originalInvoice = self.invoices[index]
                return originalInvoice.companyName != self.companyName ||
                    originalInvoice.description != self.description ||
                    String(originalInvoice.amount) != self.amount
            }
        } else {
            if let _ = Double(self.amount) {
                return self.companyName != "" && self.amount != ""
            }
        }
        return false
    }
    
    func formatDollarAmount(amount: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let formattedAmount = formatter.string(from: NSNumber(value: amount)) {
            return formattedAmount
        }
        return nil
    }
}
