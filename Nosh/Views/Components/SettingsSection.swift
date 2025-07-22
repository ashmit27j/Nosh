//import SwiftUI
//
//struct SettingsSection: View {
//    let title: String
//    let items: [ProfileItem]
//    var isActionSection: Bool = false 
//    var body: some View {
//        SectionContainer {
//            VStack(alignment: .leading, spacing: 12) {
//                Text(title)
//                    .font(.headline)
//                    .foregroundColor(.primary)
//
//                ForEach(items) { item in
//                    NavigationLink(destination: item.destination) {
//                        HStack {
//                            Image(systemName: item.icon)
//                                .foregroundColor(item.iconColor)
//                                .frame(width: 24)
//
//                            Text(item.title)
//                                .foregroundColor(.primary)
//
//                            Spacer()
//
//                            if item.enabled {
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        .padding(.vertical, 8)
//                    }
//                }
//            }
//        }
//    }
//}


import SwiftUI

struct SettingsSection: View {
    let title: String
    let items: [ProfileItem]
    var isActionSection: Bool = false

    var body: some View {
        SectionContainer {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                ForEach(items) { item in
                    Group {
                        if let destination = item.destination {
                            NavigationLink(destination: destination) {
                                SettingsRow(item: item)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            SettingsRow(item: item)
                                .onTapGesture {
                                    item.action?()
                                }
                        }
                    }
                }
            }
        }
    }
}

