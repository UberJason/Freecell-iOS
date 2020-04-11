//
//  OnboardingView.swift
//  Freecell
//
//  Created by Jason Ji on 4/10/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI


struct OnboardingSnippet: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let image: Image
}

public struct OnboardingView: View {
    private let snippets: [OnboardingSnippet] = [
        OnboardingSnippet(title: "Classic Gameplay, Modern Look", subtitle: "Play Freecell with a clean, modern design and quick, snappy animations.", image: Image.spades),
        OnboardingSnippet(title: "Modern or Classic Controls", subtitle: "Choose between a smart, touch- and drag-first experience, or indulge in your early-00's nostalgia.", image: Image.controls)
    ]
    
    public init() {}
    
    public var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 75) {
                VStack(alignment: .leading) {
                    Text("Welcome to").font(.system(.largeTitle)).fontWeight(.semibold)
                    Text("Freecell").font(.system(.largeTitle)).foregroundColor(.freecellTheme).fontWeight(.black)
                }
                
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(snippets) { snippet in
                        HStack(spacing: 30) {
                            snippet.image
                                .font(.system(size: 45))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(snippet.title)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(.freecellTheme)
                                Text(snippet.subtitle).fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                Spacer()
            }
            Button(action: {
                NotificationCenter.default.post(name: .dismissOnboarding, object: nil)
            }) {
                Text("Get Started").foregroundColor(.white).padding().padding([.leading, .trailing], 75).background(Color.freecellTheme).cornerRadius(12.0)
            }
        }
        .padding([.top, .bottom], 75)
        .padding([.leading, .trailing], 75)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let game = Game()
        return ZStack {
            GameView(game: game)
            BackgroundColorView(color: Color.black.opacity(0.2)).edgesIgnoringSafeArea(.all)
            OnboardingView().background(Color.white).cornerRadius(16).frame(width: 520, height: 640)
        }.previewLayout(.fixed(width: 1024, height: 768))
        
            
    }
}
