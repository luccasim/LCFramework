//
//  ChartView.swift
//  Pokedex
//
//  Created by owee on 27/09/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import SwiftUI

public struct ChartView: View {
    
    public struct ChartData {
        
        let key : String
        let value : Int
        let maxValue : Double
        
        public init(Key:String, Value:Int, MaxValue:Double) {
            self.key = Key
            self.value = Value
            self.maxValue = MaxValue
        }
        
        var percent : Double {
            return Double(value) / maxValue
        }
    }
    
    public init(Title:String, Color:Color, Height:CGFloat=20, Delay:TimeInterval=1, Data:[ChartData]) {
        self.title = Title
        self.color = Color
        self.height = Height
        self.data = Data
        self.delay = Delay
    }
    
    public func Animate() {
        withAnimation {
            self.isAnimate = true
        }
    }
    
    @State var isAnimate = false
    
    let title : String
    let data : [ChartData]
    let color : Color
    let height : CGFloat
    let delay : TimeInterval
    
    public var body: some View {
        
        VStack {
            
            Text(self.title)
                .font(.title)
                .padding()
            
            ForEach(self.data, id:\.key) {
                ChartCell(data: $0, color: color, height: 20, Animate: $isAnimate)
            }
            
            
        }.onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.isAnimate = true
            }
        }
    }
}

struct ChartCell: View {
    
    let data : ChartView.ChartData
    let color : Color
    let height : CGFloat
    
    @Binding var Animate : Bool
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 2) {
            
            Text("\(data.key)")
                .frame(width: 50,alignment: .leading)
                .font(Font.body.bold())
                .padding(5)
                .foregroundColor(color)
            
            Text("\(data.value)")
                .frame(width: 40)
            
            ZStack {
                
                GeometryReader { geo in
                    
                    Rectangle()
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Rectangle()
                            .fill(color)
                            .frame(width: Animate ? geo.size.width * CGFloat(data.percent) : 0)
                            .cornerRadius(10)
                            .animation(.easeIn(duration: 1))
                        Spacer()
                    }
                }
            }
            .frame(height: self.height)
            .cornerRadius(15)
            .padding(5)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        
        let data : [ChartView.ChartData] = [
            ChartView.ChartData(Key: "HP", Value: 190, MaxValue: 255),
            ChartView.ChartData(Key: "ATK", Value: 67, MaxValue: 255),
            ChartView.ChartData(Key: "DEF", Value: 97, MaxValue: 255),
            ChartView.ChartData(Key: "SATK", Value: 40, MaxValue: 255),
            ChartView.ChartData(Key: "SDEF", Value: 229, MaxValue: 255),
            ChartView.ChartData(Key: "SP", Value: 90, MaxValue: 180),
        ]
        
        return ChartView(Title: "Stats", Color: .orange, Delay:20, Data: data)
    }
}
