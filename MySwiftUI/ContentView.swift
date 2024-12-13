//
//  ContentView.swift
//  MySwiftUI
//
// AnimationColorView.swift
// GetGirlsMoney
//
// Created by 赵纯想 on 2024/9/12.
//

import SwiftUI
class Model: ObservableObject {
    @Published var searchText: String = ""
    @Published var tokens: [FruitToken] = [.apple,.banana,.pear]
}

class Product: Identifiable {
//    var ID: UUID = UUID()
}

class Department: Identifiable {
//    var ID: UUID = UUID()
}

enum FruitToken: String, Identifiable, Hashable, CaseIterable {
    case apple
    case pear
    case banana
    var id: Self { self }
}

struct MyView: View {
    var body: some View {
        Button("Upgrade Now", action: {

        })
        .buttonStyle(MyButtonStyle())
    }
}

#Preview {
    MyView()
}

//struct ContentView: View {
//    @EnvironmentObject private var model: Model
//    @State private var departmentId: Department.ID?
//    @State private var productId: Product.ID?
//
//
//    var body: some View {
//        NavigationSplitView {
//            DepartmentList(departmentId: $departmentId)
//        } content: {
////            ProductList(departmentId: departmentId, productId: $productId)
////                .searchable(text: $model.searchText)
////                .searchSuggestions {
////                    Text("111")
////                    Text("222")
////                }
//            ProductList(departmentId: departmentId, productId: $productId)
//                .searchable(
//                    text: $model.searchText,
//                    tokens: $model.tokens
////                    suggestedTokens: $model.suggestions
//                ) { token in
//                    switch token {
//                        case .apple: Text("Apple")
//                        case .pear: Text("Pear")
//                        case .banana: Text("Banana")
//                    }
//                }
//        } detail: {
////            ProductDetails(productId: productId)
//            Button("Upgrade Now", action: {
//
//            })
//                .buttonStyle(MyButtonStyle())
//                .frame(width: 200,height: 50)
//        }
//    }
//}

struct DepartmentList: View {
    @Binding var departmentId: Department.ID?
    var body: some View {
        Text("Select a department")
    }
}

struct ProductList: View {
    var departmentId: Department.ID?
    @Binding var productId: Product.ID?

    var body: some View {
        Text("Select a department")
    }
}

struct ProductDetails: View {
    var productId: Product.ID?

    var body: some View {
        Text("Select a ProductDetails")
    }
}


struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            let offset: CGFloat = 5

            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(.black)
                .offset(y:offset)
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(.gray)
                .offset(y: configuration.isPressed ? offset : 0)

            configuration.label
                .offset(y: configuration.isPressed ? offset : 0)

        }
        .compositingGroup()
        .shadow(radius: 6, y: 4)

    }
}



#Preview {
    Button(action: { print("Pressed") }) {
        Label("Press Me", systemImage: "star")
    }
    .buttonStyle(MyButtonStyle())
    .frame(width: 200,height: 40)
}


//#Preview {
//    ContentView()
//}
