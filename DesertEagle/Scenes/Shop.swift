import SwiftUI

struct Shop: View {
    @State private var selectedIndex: Int = 0
    @State private var coins: Int
    
    var onClose: () -> Void
    
    init(onClose: @escaping () -> Void) {
        self.coins = CoinStorage.shared.getBalance()
        self.onClose = onClose
    }
    
    var skins = SkinStore.shared.getAllSkins()
    var birds = SkinStore.shared.getAllSkins().map { Assets.Eagle.image(for: $0.name) }
    
    var body: some View {
        ZStack(alignment: .center) {
            Assets.Background.blue
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Верхняя панель с монетами и закрытием
                HStack {
                    HStack(spacing: -40) {
                        Assets.Other.coin
                            .frame(width: 70, height: 70)
                        ZStack {
                            Assets.Button.sublayer
                                .frame(width: 160, height: 70)
                            StrokedText(text: " \(coins)")
                        }
                        .zIndex(-1)
                    }
                    Spacer()
                    Button {
                        onClose()
                    } label: {
                        Assets.Button.close
                            .frame(width: 70, height: 70)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Карусель птиц
                ZStack {
                    ForEach(birds.indices, id: \.self) { index in
                        birds[index]
                            .resizable()
                            .scaledToFit()
                            .frame(width: index == selectedIndex ? 240 : 120, height: index == selectedIndex ? 240 : 120)
                            .opacity(index == selectedIndex ? 1.0 : 0.5)
                            .offset(x: CGFloat(index - selectedIndex) * 180)
                            .animation(.spring(), value: selectedIndex)
                    }
                    
                    HStack {
                        Button {
                            if selectedIndex > 0 {
                                selectedIndex -= 1
                            }
                        } label: {
                            Assets.Other.arrowLeft
                                .frame(width: 100, height: 80)
                        }
                        
                        Spacer()
                        
                        Button {
                            if selectedIndex < birds.count - 1 {
                                selectedIndex += 1
                            }
                        } label: {
                            Assets.Other.arrowRight
                                .frame(width: 100, height: 80)
                        }
                    }
                    .padding(.horizontal, 80)
                    .padding(.bottom, 50)
                }
                
                Button {
                    if SkinStore.shared.selectedSkinName == skins[selectedIndex].name {
                        return
                    } else if skins[selectedIndex].isPurchased {
                        SkinStore.shared.selectedSkinName = skins[selectedIndex].name
                    } else {
                        if coins >= skins[selectedIndex].price {
                            if SkinStore.shared.purchase(name: skins[selectedIndex].name, using: CoinStorage.shared
                            ) {
                                coins -= skins[selectedIndex].price
                                coins = CoinStorage.shared.getBalance()
                            }
                        }
                    }
                } label: {
                    ZStack {
                        Assets.Button.sublayer
                            .frame(width: 240, height: 80)
                        if SkinStore.shared.selectedSkinName == skins[selectedIndex].name {
                            StrokedText(text: "SELECTED")
                        } else if skins[selectedIndex].isPurchased {
                            StrokedText(text: "SELECT")
                        } else {
                            HStack(spacing: 10) {
                                Assets.Other.coin
                                    .frame(width: 50, height: 50)
                                StrokedText(text: "\(skins[selectedIndex - 1].price)")
                            }
                        }
                    }
                }.padding(.top, -40)
            }.padding()
        }
    }
}


#Preview {
    Shop() {
        
    }
}
