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

struct OnboardingView: View {
    let snippets: [OnboardingSnippet] = [
        OnboardingSnippet(title: "Classic Gameplay, Modern Look", subtitle: "Play Freecell with a clean, modern design and quick, snappy animations.", image: Image.settings),
        OnboardingSnippet(title: "Modern or Classic Controls", subtitle: "Choose between a smart, touch- and drag-first experience, or indulge in your early-00's nostalgia.", image: Image.settings)
    
    ]
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Welcome to").font(.system(.largeTitle)).fontWeight(.semibold)
                    Text("Freecell").font(.system(.largeTitle)).foregroundColor(.freecellTheme).fontWeight(.black)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 30) {
                    ForEach(snippets) { snippet in
                        HStack(spacing: 30) {
                            snippet.image.font(.system(size: 30))
                            VStack(alignment: .leading) {
                                Text(snippet.title).font(.body).fontWeight(.bold).foregroundColor(.freecellTheme)
                                Text(snippet.subtitle)
                            }
                        }
                    }
                }
                Spacer()
            }
            Button(action: {
                print("Get Started")
            }) {
                Text("Get Started").foregroundColor(.white).padding().padding([.leading, .trailing], 60).background(Color.freecellTheme).cornerRadius(12.0)
            }
        }
        .padding([.top, .bottom], 50)
        .padding([.leading, .trailing], 50)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .previewLayout(.fixed(width: 520, height: 640))
    }
}
