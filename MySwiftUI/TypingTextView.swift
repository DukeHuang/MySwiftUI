//
//  TypingTextView.swift
//  MySwiftUI
//
//  Created by sakuragi on 2024/12/18.
//

import SwiftUI

struct LineSplitTextView: View {
    private enum Editor: Int, Hashable {
        case input
    }
    @FocusState private var focusedEditor: Editor?

    let text = """
                        Mr Willy Wonka can make marshmallows that taste of violets, 
                        and rich caramels that change color every ten seconds as 
                        you suck them Mr Willy Wonka can make marshmallows that 
                        taste of violets, and rich caramels that change color 
                        every ten seconds as you suck them Mr Willy Wonka can 
                        make marshmallows that taste of violets, and rich 
                        caramels that change color every ten seconds as 
                        you suck them Mr Willy Wonka can make marshmallows
                        that taste of violets, and rich caramels that change
                        color every ten seconds as you suck them Mr Willy 
                        Wonka can make marshmallows that taste of violets,
                        and rich caramels that change color every ten 
                        seconds as you suck them Mr Willy Wonka can 
                        make marshmallows that taste of violets, and
                        rich caramels that change color every ten 
                        seconds as you suck them Mr Willy Wonka can
                        make marshmallows that taste of violets, and 
                        rich caramels that change color every ten 
                        seconds as you suck them Mr Willy Wonka 
                        can make marshmallows that taste of 
                        violets, and rich caramels that 
                        change color every ten seconds
                        as you suck them 保存每行文本保存每
                        行文本保存每行文本保存每行文本保存每行
                        文本保存每行文本保存每行文本.
                        """
    @State private var lines: [AttributedString] = [] // 保存每行文本
    @State private var padding: CGFloat = 30
    @State private var currentIndex: Int = 0
    @State private var inputText = ""

    private var monoSpacedFont: Font {
        .system(size: 16, design: .monospaced)
    }

    var body: some View {
        GeometryReader { proxy in
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(Array(lines.enumerated()), id: \.0) { (_, line) in
                        Text(line)
                            .font(monoSpacedFont)
                            .foregroundColor(.primary)
                    }
                }
                .offset(y: CGFloat(-(25 * currentIndex)))
                .background(
                    TextLineSplitterView(
                        text: text,
                        width: proxy.frame(in: .local).size.width - padding * 2
                    ) { splitLines in
                        DispatchQueue.main.async {
                            self.lines = splitLines
                            if currentIndex > 0 { lines[currentIndex - 1].foregroundColor = .black }
                            let origin = String(lines[currentIndex].characters)
                            lines[currentIndex] = compareAndColorize(origin, with: inputText)
                        }
                    }
                        .hidden()
                )
                .padding(.top, 100)
                .padding(.horizontal, padding)
                .overlay(alignment: .topLeading) {
                    TextField("", text: $inputText)
                        .font(monoSpacedFont)
                        .opacity(0)
                        .focusable()
                        .focused($focusedEditor, equals: .input)
                        .onAppear {
                            focusedEditor = .input
                        }
//                        .onKeyPress(.delete) {
//                            print("delete key pressed!")
//                            return .handled
//                        }
//                        .onKeyPress(.clear) {
//                            print("clear key pressed!")
//                            return .handled
//                        }
                        .onKeyPress(.init("\u{7F}"), phases: .down, action: { _ in
                            print("delete key pressed!")

                            if currentIndex > 0 && inputText.count == 0 {
                                withAnimation(.easeInOut) {
                                    currentIndex -= 1
                                }
                            }
                            return .ignored
                        })
//                        .onKeyPress(.deleteForward, phases: .down, action: { _ in
//                            print("clear key pressed!")
//                            return .ignored
//                        })
//                        .onKeyPress(action: { keyPress in
//                            print("""
//                                    keyPress ====>
//                                    Key: \(keyPress.key)
//                                    Modifiers: \(keyPress.modifiers)
//                                    Phase: \(keyPress.phase)
//                                    Debug description: \(keyPress.debugDescription)
//                                    =======
//                                   """
//                            )
//                            return .ignored
//                        })
                        .padding(padding)
                        .onChange(of: inputText) { oldValue, newValue in
                            print("oldValue = \(oldValue), newValue = \(newValue)")
                            if newValue.count >= String(lines[currentIndex].characters).count {
                                withAnimation(.easeInOut) {
                                    currentIndex += 1
                                    inputText = ""
                                }
                            }
                        }

                    }
                }
        }

    }

    func compareAndColorize(_ originMutableString: String, with inputImmutableString: String) -> AttributedString {

        var result = AttributedString()
        let minLength = min(originMutableString.count, inputImmutableString.count)
        let mutableChars = Array(originMutableString)
        let immutableChars = Array(inputImmutableString)

        for index in 0..<minLength {
            var mutableChar = AttributedString(String(mutableChars[index]))
            if mutableChars[index] == immutableChars[index] {
                // 如果汉字相同，背景颜色变成灰色
                mutableChar.foregroundColor = .green
            } else {
                // 如果汉字不同，背景颜色变成红色
                mutableChar.foregroundColor = .red
            }
            result.append(mutableChar)
        }

        // 如果原文比输入框中的内容字符串长，需要接接上剩余部分的原文，说明还有剩余内容
        if originMutableString.count > minLength {
            // 将下一个字符加上灰色的背景，表示是将要输入的字符
            var nextChar = AttributedString(String(mutableChars[minLength]))
            nextChar.backgroundColor = .lightGray
            nextChar.foregroundColor = .white
            result.append(nextChar)
            // 剩下的字符
            let index = originMutableString.index(originMutableString.startIndex, offsetBy: minLength+1)
            var remainingString = AttributedString(String(originMutableString[index...]))
            remainingString.foregroundColor = .gray.opacity(0.5)
            result.append(remainingString)
        }
        return result
    }
}

#if os(iOS)
struct TextLineSplitterView: UIViewRepresentable {
    let text: String
    let width: CGFloat
    var onSplit: ([AttributedString]) -> Void

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
        label.preferredMaxLayoutWidth = width
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text

        let lines = getLines(for: uiView, width: width)
        onSplit(lines)
    }

    // 获取文本换行分割后的每一行
    private func getLines(for label: UILabel, width: CGFloat) -> [AttributedString] {
        let text = label.text ?? ""
        let font = label.font ?? UIFont.systemFont(ofSize: 16)

        // 创建布局工具
        let textStorage = NSTextStorage(string: text, attributes: [.font: font])
        let textContainer = NSTextContainer(size: CGSize(width: width, height: .greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byWordWrapping

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        var lines: [AttributedString] = []
        var index = 0

        // 遍历每一行
        while index < layoutManager.numberOfGlyphs {
            var range = NSRange()
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &range)
            if let substring = (text as NSString?)?.substring(with: range) {
                lines.append(AttributedString(substring))
            }
            index = NSMaxRange(range)
        }
        return lines
    }
}

#else
struct TextLineSplitterView: NSViewRepresentable {
    let text: String
    let width: CGFloat
    var onSplit: ([AttributedString]) -> Void

    func makeNSView(context: Context) -> NSTextField {
        let label = NSTextField()
        label.isEditable = false
        label.isBordered = false
        label.isBezeled = false
        label.backgroundColor = .clear
        label.lineBreakMode = .byWordWrapping
        label.font = NSFont.monospacedSystemFont(ofSize: 16, weight: .regular)
        label.preferredMaxLayoutWidth = width
        return label
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text

        let lines = getLines(for: nsView, width: width)
        onSplit(lines)
    }

    // 获取文本换行分割后的每一行
    private func getLines(for label: NSTextField, width: CGFloat) -> [AttributedString] {
        let text = label.stringValue
        let font = label.font ?? NSFont.systemFont(ofSize: 16)

        // 使用 NSLayoutManager 和 NSTextContainer
        let textStorage = NSTextStorage(string: text, attributes: [.font: font])
        let textContainer = NSTextContainer(size: CGSize(width: width, height: .greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byWordWrapping

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        var lines: [AttributedString] = []
        var index = 0

        // 遍历每一行
        while index < layoutManager.numberOfGlyphs {
            var range = NSRange()
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &range)
            if let substring = (text as NSString?)?.substring(with: range) {
                var attributeString = AttributedString(substring)
                attributeString.foregroundColor = .gray.opacity(0.5)
                lines.append(attributeString)
            }
            index = NSMaxRange(range)
        }
        return lines
    }
}
#endif

#Preview {
    LineSplitTextView()
}
