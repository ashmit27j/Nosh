
<p align="center">
  <img src="logo.png" alt="Nosh Logo" width="150"/>
</p>

# Nosh

Nosh is a cross-platform (iOS + Android) hybrid SwiftUI + UIKit application that helps you plan meals based on your pantry. It intelligently recommends dishes, generates shopping lists, and provides interactive cooking instructions — all tailored to your diet, time, and taste.

---

## 🧠 Core Features

- ✅ **Ingredient-Based Dish Suggestions**
- ✅ **Smart Search & Filters** — by prep time, difficulty, and veg/non-veg
- ✅ **Favorites** — save recipes offline
- ✅ **Cook Now Mode** — interactive, filterable recipe discovery
- ✅ **Meal Plan Builder** — drag-and-drop weekly planner
- ✅ **Cooking Instructions** — timers, steps, and substitutes
- ✅ **Nutrition Insights** — macros, vitamins, and more
- ✅ **Substitution Suggestions** — with nutrition comparison
- ✅ **Auto Shopping List** — generated from plans
- ✅ **User Preferences** — dietary filters, goals, and themes

---

## 📱 App Screens (UI Navigation)

| Screen            | Description                                                            |
|-------------------|------------------------------------------------------------------------|
| **Home**          | Pantry entry, welcome message, smart suggestions                       |
| **Cook Now**      | Interactive recipe finder with filters                                 |
| **Dish Detail**   | Ingredients, substitutes, instructions with timers                     |
| **Meal Plan**     | Weekly meal planning interface                                         |
| **Grocery & Pantry** | Auto grocery list + editable pantry with expiry tracking         |
| **Favorites**     | Saved recipes                                                          |
| **Profile/Settings** | Dietary filters, preferences, macros, skill level                 |

---

## 🧭 Navigation Flow

- 🏠 Home  
- 🔥 Cook Now  
- 📅 Meal Plan  
- 🛒 Grocery & Pantry  
- ⭐ Favorites  
- 👤 Profile/Settings  

---

## ⚙️ Project Architecture (MVVM + SwiftUI/UIKit)

```
Nosh/
├── Models/             # Data models (Meal, Ingredient, etc.)
├── ViewModels/         # Logic & state (MealViewModel, PlanViewModel)
├── Views/              # SwiftUI Views
├── Controllers/        # UIKit ViewControllers (legacy or hybrid)
├── App/                # AppDelegate, SceneDelegate, entry points
├── Assets.xcassets     # App icons, images
├── Info.plist
```

---

## 🌐 External APIs Used

- [Spoonacular API](https://spoonacular.com/food-api) – Recipe & nutrition data  
- [TheMealDB](https://www.themealdb.com/api.php) – Backup recipe source  

---

## 🚀 Download & Installation

### 📲 iOS (TestFlight)
1. Download from TestFlight: [TestFlight Link Here](#) *(replace with actual link)*
2. Tap **Install** and launch the app from your home screen.

### 🤖 Android (APK)
1. Download the APK: [Nosh-v1.0.apk](#) *(replace with actual download link)*
2. Go to **Settings > Security** and enable "Install from Unknown Sources".
3. Open the APK file and tap **Install**.

---

## 🧪 Testing

- ✅ Unit Tests: Logic for meal filtering, substitution, planning
- ✅ UI Tests: Navigation, cooking steps, edge cases

---

## 🛠 Tech Stack

- **Language**: Swift 5  
- **Frameworks**: SwiftUI + UIKit  
- **Architecture**: MVVM  
- **Storage**: CoreData or UserDefaults  
- **Networking**: URLSession, JSON Decoding  
- **Cross-platform**: iOS + Android (via Kotlin or Swift multiplatform [WIP])

---

## 🧠 Future Scope

- 🧾 **Barcode Scanner** for pantry input  
- ☁️ **CloudKit sync** for multi-device use  
- 🗣 **Voice-Guided Cooking** with speech prompts  
- 🤖 **AI Recipe Assistant** (e.g., "I have eggs and spinach...")  

---

## 💬 Sample User Flows

### 🍳 Cooking a Dish
1. Select a recipe
2. View ingredient checklist + substitutions
3. Tap to expand instructions with built-in timers

### 🧑‍🍳 Weekly Planning
1. Navigate to “Meal Plan”
2. Drag dishes into weekly calendar (B/L/D/S)
3. Auto-generates shopping list

---

## 🧠 Advanced Features Overview

- 🎛️ Filters by Hunger Level, Cook Time, and Serving Size  
- 📦 Pantry tracks current stock, greys out incompatible dishes  
- ⏱️ Multiple cook durations: *Instant*, *SuperFast*, *Fast*, *Long*  
- 📤 Shareable grocery checklist  
- 🌗 Dark/Light mode support  

---

## 📊 Views Overview

### 1. **Detailed Dish View**
- Ingredients, time, difficulty
- Cooking steps with timers
- Substitutes shown on tap

### 2. **Make Meal Plan View**
- Weekly calendar layout
- Add meals to breakfast/lunch/dinner
- Auto-reminder for grocery refresh

---

## 📈 Data Handling

- 📄 **Excel Sheet** for Recipes, Ingredients & Substitutions (source data)
- 📂 Clean copy + working copy updated per user interaction

---

## 👨‍💻 Author

**Ashmit Jain**  
[Portfolio](https://ashmit27j.wixstudio.com/my-blogs)  
[GitHub](https://github.com/ashmit27j)  
[HackerRank](https://www.hackerrank.com/profile/ashmit)

---

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.
