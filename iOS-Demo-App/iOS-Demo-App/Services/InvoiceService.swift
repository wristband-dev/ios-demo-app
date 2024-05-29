import Foundation

class InvoiceService {
    
    static let shared = InvoiceService()
    
    private let userDefaultsKey = "invoices"

    func saveInvoices(_ invoices: [Invoice]) {
        if let encoded = try? JSONEncoder().encode(invoices) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    func loadInvoices() -> [Invoice] {
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedInvoices = try? JSONDecoder().decode([Invoice].self, from: savedData) {
            return decodedInvoices
        }
        return []
    }

    func addInvoice(_ invoice: Invoice) {
        var invoices = loadInvoices()
        invoices.append(invoice)
        saveInvoices(invoices)
    }

    func updateInvoice(with updatedInvoice: Invoice) {
        var invoices = loadInvoices()
        if let index = invoices.firstIndex(where: { $0.id == updatedInvoice.id }) {
            invoices[index] = updatedInvoice
            saveInvoices(invoices)
        }
    }

    func deleteInvoice(withId id: UUID) {
        var invoices = loadInvoices()
        invoices.removeAll { $0.id == id }
        saveInvoices(invoices)
    }
}
