import SwiftUI

class PantryManager: ObservableObject {
    static let shared = PantryManager()
    
    @Published var pantryViewModel: PantryViewModel?
    
    private init() {}
    
    func hasAllIngredients(for meal: Meal, servingSize: Int) -> Bool {
        guard let pantryVM = pantryViewModel else { return false }
        
        for ingredientString in meal.ingredients {
            let parsed = parseIngredient(ingredientString)
            let requiredAmount = parsed.quantity * Double(servingSize) / Double(meal.servingSize)
            
            if let pantryItem = findPantryItem(named: parsed.name, in: pantryVM),
               pantryItem.quantity >= requiredAmount {
                continue
            } else {
                return false
            }
        }
        return true
    }
    
    func getMissingIngredients(for meal: Meal, servingSize: Int) -> [String] {
        guard let pantryVM = pantryViewModel else { return [] }
        
        var missing: [String] = []
        
        for ingredientString in meal.ingredients {
            let parsed = parseIngredient(ingredientString)
            let requiredAmount = parsed.quantity * Double(servingSize) / Double(meal.servingSize)
            
            if let pantryItem = findPantryItem(named: parsed.name, in: pantryVM) {
                if pantryItem.quantity < requiredAmount {
                    let shortfall = requiredAmount - pantryItem.quantity
                    missing.append("\(parsed.name) (need \(formatQuantity(shortfall)) more)")
                }
            } else {
                missing.append("\(parsed.name) (need \(formatQuantity(requiredAmount)))")
            }
        }
        
        return missing
    }
    
    func deductIngredients(for meal: Meal, servingSize: Int) {
        guard let pantryVM = pantryViewModel else { return }
        
        print("\n🔄 DEDUCTING INGREDIENTS")
        print("Meal: \(meal.name), Serving size: \(servingSize)")
        
        for ingredientString in meal.ingredients {
            let parsed = parseIngredient(ingredientString)
            let amountToDeduct = parsed.quantity * Double(servingSize) / Double(meal.servingSize)
            
            print("\nIngredient: '\(ingredientString)'")
            print("  Parsed: name='\(parsed.name)', qty=\(parsed.quantity)")
            print("  Amount to deduct: \(amountToDeduct)")
            
            if let pantryItem = findPantryItem(named: parsed.name, in: pantryVM) {
                let category = pantryVM.findCategory(for: pantryItem)
                let newQuantity = max(0, pantryItem.quantity - amountToDeduct)
                
                print("  Found: '\(pantryItem.name)' in '\(category)'")
                print("  Current: \(pantryItem.quantity) → New: \(newQuantity)")
                
                // ✅ THIS IS THE CRITICAL LINE - calls updateQuantity, NOT decrement
                pantryVM.updateQuantity(for: pantryItem, in: category, to: newQuantity)
            }
        }
        
        print("\n✅ DEDUCTION COMPLETE\n")
    }
    
    // MARK: - Parsing
    
    private func parseIngredient(_ ingredientString: String) -> (name: String, quantity: Double, unit: String) {
        let trimmed = ingredientString.trimmingCharacters(in: .whitespaces)
        
        // Format: "Butter: 100g" or "Whipped cream" (no colon)
        if trimmed.contains(":") {
            let parts = trimmed.components(separatedBy: ":")
            guard parts.count == 2 else {
                return (name: trimmed, quantity: 1.0, unit: "")
            }
            
            let name = parts[0].trimmingCharacters(in: .whitespaces)
            let quantityPart = parts[1].trimmingCharacters(in: .whitespaces)
            
            // Extract number using regex
            let numberPattern = "[0-9]+\\.?[0-9]*"
            guard let regex = try? NSRegularExpression(pattern: numberPattern),
                  let match = regex.firstMatch(in: quantityPart, range: NSRange(quantityPart.startIndex..., in: quantityPart)),
                  let range = Range(match.range, in: quantityPart),
                  let quantity = Double(quantityPart[range]) else {
                return (name: name, quantity: 1.0, unit: "")
            }
            
            let unitStartIndex = quantityPart.index(quantityPart.startIndex, offsetBy: match.range.length)
            let unit = String(quantityPart[unitStartIndex...]).trimmingCharacters(in: .whitespaces)
            
            return (name: name, quantity: quantity, unit: unit)
        } else {
            return (name: trimmed, quantity: 1.0, unit: "")
        }
    }
    
    private func findPantryItem(named name: String, in pantryVM: PantryViewModel) -> PantryItem? {
        let cleanName = name.trimmingCharacters(in: .whitespaces).lowercased()
        
        for (category, items) in pantryVM.items where category != "All" {
            if let item = items.first(where: { $0.name.lowercased() == cleanName }) {
                return item
            }
        }
        
        for (category, items) in pantryVM.items where category != "All" {
            if let item = items.first(where: {
                let itemName = $0.name.lowercased()
                return itemName.contains(cleanName) || cleanName.contains(itemName)
            }) {
                return item
            }
        }
        
        return nil
    }
    
    private func formatQuantity(_ value: Double) -> String {
        let rounded = (value * 10).rounded() / 10
        if rounded.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", rounded)
        } else {
            return String(format: "%.1f", rounded)
        }
    }
}
