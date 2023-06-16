//
//  WheelView.swift
//  SetreeApp
//
//  Created by HilalOruc on 11.02.2023.
//

import SwiftUI
import SimpleRoulette

struct WheelView: View {
    @ObservedObject var model: RouletteModel
    @State private var decidedPart: PartData?
    @State private var length: CGFloat = 220

    //var valuesArray: [String]

    var body: some View {
        HStack {
            VStack {
                Group {
                    if let decidedPart = decidedPart, let text = decidedPart.title {
                        Text("\(text)")
                            .font(.custom("Futura-Bold", size: 25))
                            .italic()
                            .bold()
                            .padding()
                            .foregroundColor(Color(UIColor.softYellow))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true) // Allow text to wrap to multiple lines
                    } else {
                        Text("")
                            .foregroundColor(.white)
                    }
                }.frame(height: 100)
                RouletteView(
                    model: model,
                    length: length
                ) .foregroundColor(.white)
                .font(Font.custom("Futura-Bold", size: 15))
                HStack {
                    Group {
                        Button(model.state.isAnimating ? "◼" : "▶") {
                            if model.state.isAnimating {
                                model.stop()
                            } else {
                                model.start(speed: .very_fast)
                            }
                        } .foregroundColor(.white)
                    }
                    .buttonStyle(.bordered)
                    .font(.title)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity) // Set the width to maximum
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.mainRoyalBlueColor))
        .onReceive(model.onDecidePublisher) { part in
            decidedPart = part
        }
    }
}

struct WheelView_Previews: PreviewProvider {

    static func defaultModel() -> RouletteModel {
        let viewModel = RouletteModel(
            parts: [
                PartData(
                    index: 0,
                    content: .label("1"),
                    title: "test1",
                    area: .flex(1),
                    fillColor: Color(UIColor.softOrange)
                ),
                PartData(
                    index: 1,
                    content: .label("2"),
                    title: "test2",
                    area: .flex(1),
                    fillColor: Color(UIColor.softPink)
                ),
                PartData(
                    index: 2,
                    content: .label("3"),
                    title: "test3",
                    area: .flex(1),
                    fillColor: Color(UIColor.softLilac)
                ),
                PartData(
                    index: 3,
                    content: .label("4"),
                    title: "test4",
                    area: .flex(1),
                    fillColor: Color(UIColor.softGreen)
                ),
                PartData(
                    index: 4,
                    content: .label("5"),
                    title: "test5",
                    area: .flex(1),
                    fillColor: Color(UIColor.verySoftRed)
                ),
                PartData(
                    index: 5,
                    content: .label("6"),
                    title: "test6",
                    area: .flex(1),
                    fillColor: Color(UIColor.softDarkblue)
                ),
            ]
        )
        return viewModel
    }

    static var previews: some View {
        let goalsArray = ["Go stay in Poland for at least  2 weeks",
                          "Join a workshop as a part of a team",
                          "Learn a new programming language",
                          "Membership to a gym a gym a gym",
                          "Have a dog/catdog /catdog/cat",
                          "Start a dairy a dairy a dairy a dairy"]
        
        WheelView(model: defaultModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
    }
}
