import SwiftUI

struct PaperBackgroundView: View {
    var body: some View {
        ZStack {
            // 基础纸张背景色
            Color(red: 0.98, green: 0.96, blue: 0.92) // 柔和的米白色
                .overlay(
                    // 噪点纹理叠加
                    NoiseTexture()
                        .blendMode(.overlay) // 使用叠加模式，让噪点更自然
                )
                .clipShape(RoundedRectangle(cornerRadius: 12)) // 圆角
                .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 3) // 阴影增加立体感
                .padding(16)

            Text("非常棒的体验")
                .font(.largeTitle)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

// 噪点纹理实现
struct NoiseTexture: View {
    var body: some View {
        GeometryReader { _ in
            Canvas { context, size in
                for _ in 0..<1500 {
                    let xxx = CGFloat.random(in: 0...size.width)
                    let yyy = CGFloat.random(in: 0...size.height)
                    let opacity = Double.random(in: 0.01...0.05)
                    let diameter: CGFloat = CGFloat.random(in: 0.5...1.5)
                    context.fill(
                        Path(ellipseIn: CGRect(x: xxx, y: yyy, width: diameter, height: diameter)),
                        with: .color(Color.black.opacity(opacity))
                    )
                }
            }
        }
        .allowsHitTesting(false) // 避免影响点击事件
    }
}

struct ContentView1: View {
    var body: some View {
        VStack {
            Spacer()
            PaperBackgroundView()
//                .frame(height: 400)
            Spacer()
        }
    }
}

#Preview {
    ContentView1()
}
