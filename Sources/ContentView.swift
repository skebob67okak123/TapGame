import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var best = UserDefaults.standard.integer(forKey: "best")
    @State private var timeLeft = 20
    @State private var playing = false
    @State private var pos = CGPoint(x: 150, y: 300)
    @State private var size: CGFloat = 80
    @State private var color: Color = .orange

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    HStack {
                        Text("Очки: \(score)")
                        Spacer()
                        Text("⏱ \(timeLeft)")
                        Spacer()
                        Text("Рекорд: \(best)")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    Spacer()
                }

                if playing {
                    Circle()
                        .fill(color)
                        .frame(width: size, height: size)
                        .position(pos)
                        .onTapGesture { hit(in: geo.size) }
                } else {
                    VStack(spacing: 16) {
                        Text(timeLeft == 20 ? "Лови кружки!" : "Игра окончена: \(score)")
                            .font(.title.bold())
                            .foregroundColor(.white)
                        Button("Старт") { start(in: geo.size) }
                            .font(.title2.bold())
                            .padding(.horizontal, 40).padding(.vertical, 12)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(14)
                    }
                }
            }
            .onReceive(timer) { _ in
                guard playing else { return }
                timeLeft -= 1
                if timeLeft <= 0 { finish() }
            }
        }
    }

    func start(in s: CGSize) {
        score = 0
        timeLeft = 20
        playing = true
        move(in: s)
    }

    func hit(in s: CGSize) {
        score += 1
        move(in: s)
    }

    func move(in s: CGSize) {
        size = CGFloat.random(in: 50...100)
        let m = size / 2 + 10
        pos = CGPoint(x: CGFloat.random(in: m...(max(m + 1, s.width - m))),
                      y: CGFloat.random(in: (m + 60)...(max(m + 61, s.height - m - 20))))
        color = [Color.orange, .pink, .cyan, .yellow, .purple].randomElement()!
    }

    func finish() {
        playing = false
        if score > best {
            best = score
            UserDefaults.standard.set(best, forKey: "best")
        }
    }
}
