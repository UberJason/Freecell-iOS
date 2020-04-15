//
//  PathView.swift
//  FreecellKit
//
//  Created by Jason Ji on 4/14/20.
//  Copyright © 2020 Jason Ji. All rights reserved.
//

import SwiftUI

extension GeometryProxy {
    var bounds: CGRect {
        return CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
}

struct PathView: View {
    @State var percentComplete: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.makePath(in: geometry.bounds)
                    .stroke(Color.orange, lineWidth: 3)
                Rectangle()
                    .frame(width: geometry.size.height/10, height: geometry.size.height/10)
                    .position(CGPoint(x: geometry.size.width, y: 0))
                    .modifier(PathFollowingEffect(percentComplete: self.percentComplete, path: self.makePath(in: geometry.bounds), rect: geometry.bounds))
                    .animation(.easeIn(duration: 1.5))
                
                Button(action: {
                    self.percentComplete = (self.percentComplete == 0.0) ? 1.0 : 0.0
                }) {
                    Text("Animate")
                }
            }
        }
        .overlay(Rectangle().stroke())
        .frame(width: 700, height: 400)
    }
    
    func makePath(in rect: CGRect) -> Path {
        let p0 = CGPoint(x: rect.size.width, y: 0)
        let p1 = CGPoint(x: 2/3*rect.size.width, y: rect.size.height)
        let p2 = CGPoint(x: 1/3*rect.size.width, y: rect.size.height)
        let p3 = CGPoint(x: -1/8*rect.size.width, y: 13/8*rect.size.height)
        
        let c1 = CGPoint(x: 5/6*rect.size.width, y: -1*rect.size.height)
        let c2 = CGPoint(x: 1/2*rect.size.width, y: -1/2*rect.size.height)
        let c3 = CGPoint(x: 1/6*rect.size.width, y: 0)
        
        return Path { path in
            path.move(to: p0)
            path.addQuadCurve(to: p1, control: c1)
            path.addQuadCurve(to: p2, control: c2)
            path.addQuadCurve(to: p3, control: c3)
        }
    }
}

struct PathFollowingEffect: GeometryEffect {
    var percentComplete: CGFloat
    let path: Path
    let rect: CGRect
    
    var animatableData: CGFloat {
        get {
            return percentComplete
        }
        set {
            percentComplete = newValue
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let location = point(at: percentComplete)
        let startingPoint = CGPoint(x: rect.size.width, y: 0)
        
        let offset = CGSize(width: location.x - startingPoint.x, height: location.y - startingPoint.y)
        return ProjectionTransform(CGAffineTransform(translationX: offset.width, y: offset.height))
    }
    
    func point(at percent: CGFloat) -> CGPoint {
        // percent difference between points
        let diff: CGFloat = 0.001
        let comp: CGFloat = 1 - diff
        
        // handle limits
        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)
        
        let f = pct > comp ? comp : pct
        let t = pct > comp ? 1 : pct + diff
        let tp = path.trimmedPath(from: f, to: t)
        
        return CGPoint(x: tp.boundingRect.midX, y: tp.boundingRect.midY)
    }
}

struct PathView_Previews: PreviewProvider {
    static var previews: some View {
        PathView().previewLayout(.fixed(width: 1000, height: 600))
    }
}
