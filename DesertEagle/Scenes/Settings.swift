

import SwiftUI

struct Settings: View {
    
    @State var isSoundOn = true
    @State var isMusicOn = true
    @State var isVibraOn = true
    
    var onClose: () -> Void


    var body: some View {
        ZStack(alignment: .center) {
            Assets.Background.blue
                .ignoresSafeArea()
            
            ZStack {
                VStack(spacing: 0) {
                    HStack {
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
                    
                }.padding()
                
                ZStack {
                    Assets.Sublayers.yellow
                        .frame(width: 300, height: 300)
                    
                    VStack(spacing: 12) {
                        HStack(spacing: 32) {
                            ZStack {
                                Assets.Sublayers.settings
                                    .frame(width: 80, height: 80)
                                Assets.Settings.soundLogo
                                    .frame(width: 50, height: 50)
                                    .saturation(isSoundOn ? 1 : 0 )
                            }
                            
                            VStack(alignment: .leading) {
                                Assets.Settings.sound
                                    .frame(width: 80, height: 16)
                                SomeSwitcher(isOn: $isSoundOn) { result in
                                    GameManager.shared.isSoundEnabled = result
                                }
                            }
                        }
                        
                        HStack(spacing: 32) {
                            VStack(alignment: .trailing) {
                                Assets.Settings.music
                                    .frame(width: 80, height: 16)
                                SomeSwitcher(isOn: $isMusicOn) { result in
                                    MusicCentre.shared.isSoundOn = result
                                }
                            }
                            
                            ZStack {
                                Assets.Sublayers.settings
                                    .frame(width: 80, height: 80)
                                Assets.Settings.musicLogo
                                    .frame(width: 50, height: 50)
                                    .saturation(isMusicOn ? 1 : 0 )
                            }
                        }
                        
                        HStack(spacing: 32) {
                            ZStack {
                                Assets.Sublayers.settings
                                    .frame(width: 80, height: 80)
                                Assets.Settings.vibroLogo
                                    .frame(width: 50, height: 50)
                                    .saturation(isVibraOn ? 1 : 0 )
                            }
                            
                            VStack(alignment: .leading) {
                                Assets.Settings.vibro
                                    .frame(width: 80, height: 16)
                                SomeSwitcher(isOn: $isVibraOn) { result in
                                    GameManager.shared.isVibroEnabled = result
                                }
                            }
                        }
                    }
                }
               
            }
        }
    }
}

struct SomeSwitcher: View {
    
    @Binding var isOn: Bool
    var result: ((Bool) -> Void)?
    
    var body: some View {
        Button {
            isOn.toggle()
            result?(isOn)
        } label: {
            if isOn {
                Assets.Switcher.on
                    .frame(width: 60, height: 32)
            } else  {
                Assets.Switcher.off
                    .frame(width: 60, height: 32)
            }
        }

    }
}

#Preview {
    Settings {
        //
    }
}
