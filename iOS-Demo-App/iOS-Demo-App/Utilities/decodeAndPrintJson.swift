import Foundation

// DECODE RAW JSON
func decodeAndPrintJson(data: Data) {
    do {
        // Attempt to decode the JSON data to a JSON object
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        
        // Convert the JSON object back to Data with pretty printed option
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        // Convert the JSON data to a String for pretty printing
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Received JSON string: \(jsonString)")
        } else {
            print("Failed to convert JSON data to string.")
        }
    } catch {
        // Print error if any of the JSON processing steps fail
        print("Error decoding JSON: \(error)")
    }
}
