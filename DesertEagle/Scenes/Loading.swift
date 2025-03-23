
import SwiftUI

struct Loading: View {
    
    @State var isShowGreeting: Bool = false
    @State var isLoaded: Bool = false
    @AppStorage("isGreetingShown") var isGreetingShown: Bool?

    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack(alignment: .center) {
            Assets.Background.main
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Assets.Button.restart
                    .rotationEffect(.degrees(rotationAngle))
                    .frame(width: 100, height: 100)
                StrokedText(text: "LOADING...")
            }
           
            if isLoaded {
                if isShowGreeting || isGreetingShown ?? false {
                    GreetingWrapper(link: Assets.greetingUrl)
                        .padding()
                        .background(ignoresSafeAreaEdges: .all)
                        .onAppear {
                            GameManager.shared.isGreetingShowing = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                                UIViewController.attemptRotationToDeviceOrientation()
                            }
                        }
                } else {
                    MainMenu()
                }
            }
        }
        .onAppear {
            startRotation()
            validateGreetingURL()
        }
        .onDisappear {
            stopRotation()
        }
    }

    private func startRotation() {
        isAnimating = true
        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }

    private func stopRotation() {
        isAnimating = false
        rotationAngle = 0
    }
    
    private func validateGreetingURL() {
        Task {
            if await Network().isURLValid() {
                isShowGreeting = true
                isGreetingShown = true
            }
            isLoaded = true
        }
    }
}

#Preview {
    Loading()
}
