//
//  GeometryReaderInScrollView.swift
//  MySwiftUI
//
//  Created by yongyou on 2024/12/13.
//

import SwiftUI

/*
 当前，GeometryReader 以一个布局容器的形式存在，其布局规则如下：

 它是一个多视图容器，其默认堆叠规则类似于 ZStack
 将父视图的建议尺寸（ Proposed size ）作为自身的需求尺寸（ Required Size ）返回给父视图
 将父视图的建议尺寸作为自身的建议尺寸传递给子视图
 将子视图的原点（0,0）置于 GeometryReader 的原点位置
 其理想尺寸（ Ideal Size）为 (10,10)
 */

struct GeometryReaderInScrollView: View {
    var body: some View {
        ScrollView {
            /* 这是因为 ScrollView 在向子视图提交建议尺寸时，
             其处理逻辑与大多数布局容器不同。在非滚动方向上，
             ScrollView 会向子视图提供该维度上的全部可用尺寸。而在滚动方向上，
             它向子视图提供的建议尺寸为 nil。
             */

            /*
             在上面对 GeometryReader 的布局规则描述中，我们指出了它的 ideal size 是（10,10 ）。或许有些读者不太了解其含义，ideal size 是指当父视图给出的建议尺寸为 nil 时（未指定模式），子视图返回的需求尺寸。如果对 GeometryReader 的这个设定不了解，
             可能会在某些场景下，开发者会感觉 GeometryReader 并没有如预期那样充满所有空间。
             */
            GeometryReader { _ in
                Rectangle().foregroundStyle(.orange)
            }
        }
    }
}

#Preview {
    GeometryReaderInScrollView()
}
