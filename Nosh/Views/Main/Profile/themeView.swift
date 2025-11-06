//
//  themeView.swift
//  Nosh
//
//  Created by MacBook on 21/07/25.
//

import SwiftUI

struct themeView: View {
    @AppStorage("selectedTheme") private var selectedTheme = "System"
    @AppStorage("accentColor") private var accentColorName = "Teal"
    @State private var previewMode = false
    
    let themes = ["System", "Light", "Dark"]
    let accentColors: [ColorOption] = [
        ColorOption(name: "Teal", color: .teal),
        ColorOption(name: "Blue", color: .blue),
        ColorOption(name: "Green", color: .green),
        ColorOption(name: "Orange", color: .orange),
        ColorOption(name: "Pink", color: .pink),
        ColorOption(name: "Purple", color: .purple),
        ColorOption(name: "Red", color: .red),
        ColorOption(name: "Yellow", color: .yellow)
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                // Theme Mode Section
                Section {
                    Picker("Appearance", selection: $selectedTheme) {
                        ForEach(themes, id: \.self) { theme in
                            HStack {
                                Image(systemName: themeIcon(for: theme))
                                Text(theme)
                            }
                            .tag(theme)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // Theme Preview Cards
                    HStack(spacing: 16) {
                        ThemePreviewCard(theme: "Light", isSelected: selectedTheme == "Light")
                            .onTapGesture { selectedTheme = "Light" }
                        
                        ThemePreviewCard(theme: "Dark", isSelected: selectedTheme == "Dark")
                            .onTapGesture { selectedTheme = "Dark" }
                        
                        ThemePreviewCard(theme: "System", isSelected: selectedTheme == "System")
                            .onTapGesture { selectedTheme = "System" }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                } header: {
                    Label("Theme Mode", systemImage: "paintbrush.fill")
                } footer: {
                    Text("Choose how Nosh appears on your device")
                }
                
                // Accent Color Section
                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                        ForEach(accentColors) { colorOption in
                            AccentColorCircle(
                                colorOption: colorOption,
                                isSelected: accentColorName == colorOption.name
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    accentColorName = colorOption.name
                                }
                            }
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Label("Accent Color", systemImage: "paintpalette.fill")
                } footer: {
                    Text("Personalize your app with your favorite color")
                }
                
                // Preview Section
                Section {
                    Toggle(isOn: $previewMode) {
                        Label("Preview Mode", systemImage: "eye.fill")
                    }
                    .toggleStyle(SwitchToggleStyle(tint: currentAccentColor))
                    
                    if previewMode {
                        VStack(spacing: 16) {
                            // Sample Button
                            Button(action: {}) {
                                Text("Sample Button")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(currentAccentColor)
                                    .cornerRadius(12)
                            }
                            
                            // Sample Card
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "fork.knife.circle.fill")
                                        .foregroundColor(currentAccentColor)
                                        .font(.title2)
                                    Text("Recipe Card")
                                        .font(.headline)
                                }
                                
                                Text("This is how your recipes will look with the selected theme and accent color.")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                        }
                        .padding(.vertical, 8)
                    }
                } header: {
                    Label("Preview", systemImage: "sparkles")
                }
                
                // Reset Section
                Section {
                    Button(role: .destructive, action: resetToDefaults) {
                        Label("Reset to Defaults", systemImage: "arrow.counterclockwise")
                    }
                }
            }
            .navigationTitle("Theme & Appearance")
        }
    }
    
    private var currentAccentColor: Color {
        accentColors.first { $0.name == accentColorName }?.color ?? .teal
    }
    
    private func themeIcon(for theme: String) -> String {
        switch theme {
        case "Light": return "sun.max.fill"
        case "Dark": return "moon.fill"
        case "System": return "circle.lefthalf.filled"
        default: return "circle"
        }
    }
    
    private func resetToDefaults() {
        withAnimation {
            selectedTheme = "System"
            accentColorName = "Teal"
        }
    }
}

struct ThemePreviewCard: View {
    let theme: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .frame(height: 100)
                
                VStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundColor(textColor)
                    Text("Aa")
                        .font(.caption)
                        .foregroundColor(textColor)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 3)
            )
            
            Text(theme)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
        }
    }
    
    private var backgroundColor: Color {
        switch theme {
        case "Light": return Color(.systemBackground)
        case "Dark": return Color(.black)
        default: return Color(.systemGray5)
        }
    }
    
    private var textColor: Color {
        theme == "Dark" ? .white : .black
    }
    
    private var icon: String {
        switch theme {
        case "Light": return "sun.max.fill"
        case "Dark": return "moon.fill"
        default: return "circle.lefthalf.filled"
        }
    }
}

struct AccentColorCircle: View {
    let colorOption: ColorOption
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            Circle()
                .fill(colorOption.color)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )
                .overlay(
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.headline)
                        .opacity(isSelected ? 1 : 0)
                )
                .shadow(color: isSelected ? colorOption.color.opacity(0.5) : .clear, radius: 8)
            
            Text(colorOption.name)
                .font(.caption2)
                .fontWeight(isSelected ? .semibold : .regular)
        }
    }
}

struct ColorOption: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

#Preview {
    themeView()
}
