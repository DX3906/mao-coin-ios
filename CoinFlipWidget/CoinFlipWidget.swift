import WidgetKit
import SwiftUI

// MARK: - 点一下硬币时执行的意图（iOS 17+ 交互式小组件）
struct FlipCoinIntent: AppIntent {
    static var title: LocalizedStringResource = "抛硬币"
    static var description = IntentDescription("翻转猫猫硬币，立即显示结果")
    static var openAppWhenRun: Bool = false   // 不打开 App，直接在桌面上翻

    func perform() async throws -> some IntentResult {
        let yes = Bool.random()
        UserDefaults.standard.set(yes, forKey: "coinResult")
        return .result()
    }
}

// MARK: - 小组件配置
struct CoinConfiguration: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "猫猫硬币"
    static var description = IntentDescription("桌面上的猫猫硬币")
}

// MARK: - 时间线
struct CoinEntry: TimelineEntry {
    let date: Date
    let isYes: Bool
}

struct CoinProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CoinEntry {
        CoinEntry(date: Date(), isYes: true)
    }

    func snapshot(for configuration: CoinConfiguration, in context: Context) async -> CoinEntry {
        currentEntry()
    }

    func timeline(for configuration: CoinConfiguration, in context: Context) async -> Timeline<CoinEntry> {
        // 意图执行完后系统会重新请求时间线，这里直接读最新结果
        Timeline(entries: [currentEntry()], policy: .never)
    }

    private func currentEntry() -> CoinEntry {
        let yes = UserDefaults.standard.object(forKey: "coinResult") as? Bool ?? true
        return CoinEntry(date: Date(), isYes: yes)
    }
}

// MARK: - 小组件本体
struct CoinFlipWidget: Widget {
    let kind = "CoinFlipWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: CoinConfiguration.self, provider: CoinProvider()) { entry in
            CoinFlipWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("毛二壮毛妹妹硬币")
        .description("点一下硬币，直接翻面出结果")
        .supportedFamilies([.systemSmall])
    }
}

struct CoinFlipWidgetView: View {
    let entry: CoinProvider.Entry

    var body: some View {
        Button(intent: FlipCoinIntent()) {
            Image(entry.isYes ? "CoinYes" : "CoinNo")
                .resizable()
                .scaledToFit()
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }
}

@main
struct CoinFlipWidgetBundle: WidgetBundle {
    var body: some Widget {
        CoinFlipWidget()
    }
}

#Preview(as: .systemSmall) {
    CoinFlipWidget()
} timeline: {
    CoinEntry(date: .now, isYes: true)
    CoinEntry(date: .now, isYes: false)
}
