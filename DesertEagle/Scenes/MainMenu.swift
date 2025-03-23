

import SwiftUI

struct MainMenu: View {
    
    @State private var gameSessionID = UUID()
    @State private var showGame = false
    
    @State private var isShowingShopMenu: Bool = false
    @State private var isShowingSettings: Bool = false

    var body: some View {
        ZStack(alignment: .center) {
            Assets.Background.main
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        withAnimation(.easeInOut) {
                            isShowingShopMenu = true
                        }
                    } label: {
                        Assets.Button.shop
                            .frame(width: 80, height: 80)
                    }
                    Spacer()
                    Button {
                        withAnimation(.easeInOut) {
                            isShowingSettings = true
                        }
                    } label: {
                        Assets.Button.settings
                            .frame(width: 80, height: 80)
                    }
                }
                
                Spacer()
                VStack(spacing: -200) {
                    Assets.Eagle.eagle1
                        .frame(width: 240, height: 240)
                        .offset(y: -100)
                    Button {
                        GameManager.shared.reset()
                        gameSessionID = UUID()
                        showGame = true
                    } label: {
                        Assets.Button.start
                            .frame(width: 240, height: 90)
                    }
                }
            }.padding()
            
            if isShowingSettings {
                Settings {
                    withAnimation(.easeInOut) {
                        isShowingSettings = false
                    }
                }.transition(.opacity)
            }
            
            if isShowingShopMenu {
                Shop {
                    withAnimation(.easeInOut) {
                        isShowingShopMenu = false
                    }
                }
                .transition(.opacity)
            }
        }.fullScreenCover(isPresented: $showGame) {
            EagleGame() {
                showGame = false
            }.id(gameSessionID)
        }
    }
}

#Preview {
    MainMenu()
}
