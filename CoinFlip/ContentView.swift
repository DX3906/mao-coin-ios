import SwiftUI

struct ContentView: View {
    @State private var angle: Double = 0
    @State private var jumpAmount: CGFloat = 0
    @State private var flipping = false
    @State private var result: Bool? = nil   // true = YES, false = NO
    @State private var yesCount = 0
    @State private var noCount = 0

    private let coinSize: CGFloat = 260

    var body: some View {
        ZStack {
            // 深色渐变背景
            LinearGradient(
                colors: [Color(red: 0.16, green: 0.14, blue: 0.25),
                         Color(red: 0.05, green: 0.04, blue: 0.08)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("🐾 毛二壮毛妹妹硬币")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.top, 40)

                Text("点硬币或按钮，让猫猫帮你做决定")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.45))
                    .padding(.top, 6)
                    .padding(.bottom, 36)

                // 硬币（按角度切换两面可见性，实现翻面消隐）
                let norm = angle.truncatingRemainder(dividingBy: 360)
                let frontVisible = abs(norm) < 90 || abs(norm) > 270
                ZStack {
                    CoinFace(imageName: "CoinYes")
                        .opacity(frontVisible ? 1 : 0)
                    CoinFace(imageName: "CoinNo")
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .opacity(frontVisible ? 0 : 1)
                }
                .frame(width: coinSize, height: coinSize)
                .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0), perspective: 0.6)
                .offset(y: jumpAmount)
                .onTapGesture { flip() }

                // 结果文字
                Text(resultText)
                    .font(.system(size: 44, weight: .heavy))
                    .foregroundStyle(result == true ? Color(red: 1, green: 0.48, blue: 0.64)
                                                    : Color(red: 0.48, green: 0.72, blue: 1))
                    .frame(height: 56)
                    .opacity(result == nil ? 0 : 1)
                    .padding(.top, 40)

                Button(action: flip) {
                    Text("抛一次")
                        .font(.system(size: 17, weight: .semibold))
                        .tracking(4)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 52)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: [Color(red: 1, green: 0.48, blue: 0.64), Color(red: 0.69, green: 0.42, blue: 0.70)],
                                           startPoint: .leading, endPoint: .trailing),
                            in: Capsule()
                        )
                        .shadow(color: .pink.opacity(0.35), radius: 12, y: 6)
                }
                .disabled(flipping)
                .opacity(flipping ? 0.4 : 1)
                .padding(.top, 28)

                HStack(spacing: 20) {
                    Text("YES × \(yesCount)").foregroundStyle(Color(red: 1, green: 0.62, blue: 0.72))
                    Text("NO × \(noCount)").foregroundStyle(Color(red: 0.61, green: 0.78, blue: 1))
                    Button("清零") { yesCount = 0; noCount = 0 }
                        .foregroundStyle(.white.opacity(0.7))
                        .underline()
                }
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.5))
                .padding(.top, 22)

                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            // 从桌面点开 App 自动抛一次
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { flip() }
        }
    }

    private var resultText: String {
        if let r = result { return r ? "YES！" : "NO！" }
        return ""
    }

    private func flip() {
        guard !flipping else { return }
        flipping = true
        result = nil

        let isYes = Double.random(in: 0..<1) < 0.5
        let spins = Double(3 + Int.random(in: 0..<3))      // 3~5 圈
        let base = (angle / 360).rounded(.up) * 360
        let target = base + spins * 360 + (isYes ? 0 : 180)

        withAnimation(.timingCurve(0.12, 0.62, 0.22, 1.0, duration: 1.7)) {
            angle = target
            jumpAmount = -90
        }

        // 跳跃回落
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.timingCurve(0.12, 0.62, 0.22, 1.0, duration: 1.2)) {
                jumpAmount = 0
            }
        }

        // 动画结束出结果
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
            result = isYes
            if isYes { yesCount += 1 } else { noCount += 1 }
            flipping = false
        }
    }
}

/// 硬币面：图片 + 金色币环
struct CoinFace: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 260, height: 260)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(Color(red: 0.85, green: 0.70, blue: 0.29), lineWidth: 5)
                    .shadow(color: .black.opacity(0.55), radius: 18, y: 8)
            )
    }
}

#Preview {
    ContentView()
}
