import SwiftUI

struct SectionHeader: View {
    let icon: String?
    let title: String
    
    init(icon: String? = nil, title: String) {
        self.icon = icon
        self.title = title
    }
    
    var body: some View {
        HStack(spacing: 8) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color("primaryAccent"))
            }
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
        }
    }
}
