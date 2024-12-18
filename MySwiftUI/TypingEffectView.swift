import SwiftUI

#if os(macOS)
struct TypingEffectView: View {
    // 原文内容
    let originalText: String
    // 用户输入的内容
    @State var inputText: String
    // 统计数据
    @State private var statistics = TypingStatistics()
    // 跟打开始时间
    @State private var startTime: Date?
    
    @FocusState private var isFocused: Bool
    
    @State private var lineHeight: CGFloat = 30  // 估计的每行高度
    @State private var visibleLines: Int = 3     // 可见行数
    
    @State var attributedText: AttributedString = ""
    
    @State private var scrollOffset: CGFloat = 0
    @State private var textOffset: CGFloat = 0
    
    @State private var textViewWidth: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            Text(attributedText)
                .font(.system(size: 24, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 0)
            .border(Color.red)
            .position(x:geometry.frame(in: .local).midX,y:geometry.frame(in: .local).maxY)
            
            
//            HiddenTextField(text: $inputText)
//                .position(x:geometry.frame(in: .local).midX,y:geometry.frame(in: .local).midY)
//                .frame(height: 30)
//                .focused($isFocused)
        }
        .border(.green)
        
        .onChange(of: inputText) { oldValue, newValue in
            // 开始计时
            if startTime == nil {
                startTime = Date()
            }
            
            isFocused = true
            
            attributedText = updateAttributedText()
            
            // 更新统计数据
            updateStatistics()
            // 更新文本偏移量
            updateTextOffset()
        }
        .onAppear {
            attributedText = updateAttributedText()
            isFocused = true
        }
    }
    
    // 计算属性：根据输入内容生成带有样式的文本
    private func updateAttributedText() ->  AttributedString {
        var result = AttributedString()
        let minLength = min(originalText.count, inputText.count)
        
        // 处理已输入的部分
        for i in 0..<minLength {
            let originalChar = originalText[originalText.index(originalText.startIndex, offsetBy: i)]
            let inputChar = inputText[inputText.index(inputText.startIndex, offsetBy: i)]
            
            var charString = AttributedString(String(originalChar))
            if originalChar == inputChar {
                charString.foregroundColor = .primary
                charString.font = .system(size: 24, weight: .bold, design: .monospaced)
            } else {
                charString.foregroundColor = .red
            }
            result.append(charString)
        }
        
        // 添加剩余未输入的部分
        if originalText.count > minLength {
            let remainingText = originalText[originalText.index(originalText.startIndex, offsetBy: minLength)...]
            result.append(AttributedString(String(remainingText)))
        }
        
        return result
    }
    // Add these computed properties
    private var charactersPerLine: CGFloat {
        // Assuming each Chinese character takes approximately 24 points width
        // and the text container width is around 300-400 points
        return floor(textViewWidth / 24) // Adjust these numbers based on your actual layout
    }
    
    private var currentLine: CGFloat {
        ceil(CGFloat(inputText.count) / charactersPerLine)
    }
    
    // Modified updateTextOffset method
    private func updateTextOffset() {
        // Start scrolling after the first line
//        if currentLine > 1 {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                // Scroll by the number of lines that exceed the first line
//                textOffset = -(currentLine - 1) * lineHeight
//            }
//        } else {
//            // Reset offset when back to first line
//            withAnimation(.easeInOut(duration: 0.3)) {
//                textOffset = 0
//            }
//        }
    }

    private func updateStatistics() {
        guard let startTime = startTime else { return }
        
        // 计算用时（秒）
        statistics.time = Date().timeIntervalSince(startTime)
        
        // 计算速度（字/分）
        statistics.speed = Double(inputText.count) / statistics.time * 60
        
        // 计算正确率
        var correctCount = 0
        for (index, char) in inputText.enumerated() {
            if index < originalText.count {
                let originalChar = originalText[originalText.index(originalText.startIndex, offsetBy: index)]
                if char == originalChar {
                    correctCount += 1
                }
            }
        }
        statistics.accuracy = Double(correctCount) / Double(inputText.count) * 100
        
        // 更新击键数（这里简单地用输入长度代替，实际应该统计实际的按键次数）
        statistics.keystrokes = inputText.count
    }
    
//    private func updateTextOffset() {
//        let lineHeight: CGFloat = 30 // Estimated line height
//        let visibleLines: CGFloat = 3 // Number of visible lines
//        let currentLine = CGFloat(inputText.count) / 30 // Characters per line
//        
//        if currentLine > visibleLines {
//            withAnimation(.easeInOut(duration: 0.3)) {
//                textOffset = -((currentLine - visibleLines) * lineHeight)
//            }
//        }
//    }
}

// 隐藏输入框的实现
struct HiddenTextField: NSViewRepresentable {
    @Binding var text: String
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.isBordered = true
        textField.drawsBackground = false
        textField.textColor = .clear
        textField.font = .monospacedSystemFont(ofSize: 24, weight: .regular)
        
        
        // 自动成为第一响应者
        textField.window?.makeFirstResponder(textField)
        
        // 自定义光标颜色
        if let fieldEditor = textField.window?.fieldEditor(false, for: textField) as? NSTextView {
            fieldEditor.insertionPointColor = .red
        }
        
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                text = textField.stringValue
            }
        }
    }
}

// 跟打统计数据模型
struct TypingStatistics {
    var speed: Double = 0      // 速度（字/分）
    var accuracy: Double = 0    // 正确率
    var time: TimeInterval = 0  // 用时
    var keystrokes: Int = 0     // 击键数
}

// 统计数据显示视图
struct StatisticsView: View {
    let statistics: TypingStatistics
    
    var body: some View {
        HStack(spacing: 20) {
            StatItem(title: "速度", value: String(format: "%.1f字/分", statistics.speed))
            StatItem(title: "正确率", value: String(format: "%.1f%%", statistics.accuracy))
            StatItem(title: "用时", value: String(format: "%.1f秒", statistics.time))
            StatItem(title: "击键", value: "\(statistics.keystrokes)次")
        }
    }
}

// 单个统计项显示
private struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
    }
}

// Helper for getting view height
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    TypingEffectView(originalText: "如果这种方式不是一个好方式那我们就应该把脚步慢下来看看做些其它什么有时候慢就是快如果这种方式不是一个好方式那我们就应该把脚步慢下来看看做些其它什么有时候慢就是快如果这种方式不是一个好方式那我们就应该把脚步慢下来看看做些其它什么有时候慢就是快如果这种方式不是一个好方式那我们就应该把脚步慢下来看看做些其它什么有时候慢就是快如果这种方式不是一个好方式那我们就应该把脚步慢下来看看做些其它什么有时候慢就是快如果这种方式不是一个好方式那我们就应该把脚步慢下来看看做些其它什么有时候慢就是快如果这种方式不是一个好方式那我们就应该把脚步慢下来看看做些其它什么有时候慢就是快如果这种方式不是一个好方式那我们就应该把脚步慢下来看看做些其它什么有时候慢就是快如果这种方式不是一个好方式那我们就应该把脚步慢下来看看做些其它什么有时候慢就是快", inputText: "")
}

#endif
