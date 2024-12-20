//
//  ActorExample.swift
//  MySwiftUI
//
//  Created by yongyou on 2024/12/19.
//

import Foundation

class ActorExample {
    actor Counter {
         var value = 0

        func increment() {
            value += 1
        }

        func getValue() -> Int {
            return value
        }
    }

    let counter = Counter()

    func runTask() {
        Task {
            await counter.increment()
            let currentValue = await counter.getValue()
            print(currentValue)
        }
    }

    func runTask1() {
        Task {
            await print(counter.value)
        }
    }

    actor DataManager {
        private var data: [String] = []

        // 与异步函数无缝集成
        func addItem(_ item: String) async {
            data.append(item)
        }

        func fetchData() async -> [String] {
            return data
        }
    }

    /// 什么时候使用actor
    /// 需要管理共享状态并保证线程安全时
    /// 替代传统的锁、信号量等低级并发控制工具
    /// 与Swift的异步/并发模型紧密结合的场景

}
