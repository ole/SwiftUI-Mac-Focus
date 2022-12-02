import SwiftUI

@main
struct FocusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            MyEditingCommands()
        }
    }
}

struct MyEditingCommands: Commands {
    @FocusedBinding(\.items) private var items: [Item]?
    @FocusedBinding(\.selectedItem) private var selectedItem: Item.ID??

    var body: some Commands {
        CommandGroup(after: .pasteboard) {
            Button("Delete") {
                withAnimation {
                    if let idx = items?.firstIndex(where: { $0.id == selectedItem }) {
                        items?.remove(at: idx)
                    }
                }
            }
            .keyboardShortcut(KeyboardShortcut(.delete, modifiers: []))
            .disabled(selectedItem == .some(nil) || selectedItem == .none)
        }
    }
}

struct SelectedShapeKey: FocusedValueKey {
    typealias Value = Binding<Item.ID?>
}

struct ItemsKey: FocusedValueKey {
    typealias Value = Binding<[Item]>
}

extension FocusedValues {
    var selectedItem: Binding<Item.ID?>? {
        get { self[SelectedShapeKey.self] }
        set { self[SelectedShapeKey.self] = newValue }
    }
}

extension FocusedValues {
    var items: Binding<[Item]>? {
        get { self[ItemsKey.self] }
        set { self[ItemsKey.self] = newValue }
    }
}
