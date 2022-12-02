import SwiftUI

struct Item: Identifiable {
    var id: UUID = .init()
    var color: Color = .random()
    var frame: CGRect = CGRect(
        x: CGFloat.random(in: 0...300).rounded(),
        y: .random(in: 0...300).rounded(),
        width: .random(in: 100...500).rounded(),
        height: .random(in: 100...500).rounded()
    )
}

extension Color {
    static func random() -> Self {
        Color(hue: .random(in: 0...1), saturation: 0.9, brightness: 0.9)
    }
}

let initialItems: [Item] = [
    .init(),
    .init(),
    .init(),
    .init(),
]

struct ContentView: View {
    @State var items: [Item] = initialItems
    @State var selectedItem: Item.ID? = nil

    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical]) {
                ZStack(alignment: .topLeading) {
                    ForEach(items) { item in
                        let isSelected = item.id == selectedItem
                        MyShape(color: item.color, isSelected: isSelected)
                            .frame(width: item.frame.width, height: item.frame.height)
                            .position(x: item.frame.midX, y: item.frame.midY)
                            .onTapGesture {
                                selectedItem = item.id
                            }

                    }
                }
                .frame(minWidth: geometry.size.width, minHeight: geometry.size.height, alignment: .topLeading)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedItem = nil
                }
            }
        }
        .toolbar {
            toolbar
        }
        .focusedSceneValue(\.items, $items)
        .focusedSceneValue(\.selectedItem, $selectedItem)
    }

    @ToolbarContentBuilder private var toolbar: some ToolbarContent {
        ToolbarItem {
            Button {
                withAnimation {
                    items.append(Item())
                }
            } label: {
                Label("Add", systemImage: "plus")
            }
            .help("Add shape")
        }
        ToolbarItem {
            Button {
                withAnimation {
                    if let idx = items.firstIndex(where: { $0.id == selectedItem }) {
                        items.remove(at: idx)
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .help("Delete")
            .disabled(selectedItem == nil)
        }
    }
}

struct MyShape: View {
    var color: Color
    var isSelected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(color)
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 5)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
