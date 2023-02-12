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

    var body: some View {
        HStack {
            VStack {
                Group {
                    if let decidedPart = decidedPart, let text = decidedPart.content.text {
                        Text("It is \(text)")
                            .font(.title)
                            .italic()
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                    } else {
                        Text("")
                            .foregroundColor(.white)
                    }
                }.frame(height: 40)
                RouletteView(
                    model: model,
                    length: length
                ) .foregroundColor(.white)
                .font(Font.custom("Futura-Bold", size: 40))
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
                Spacer()
            }
        }.background(Color(UIColor.mainRoyalBlueColor))
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
                    area: .flex(1),
                    fillColor: Color(UIColor.softOrange)
                ),
                PartData(
                    index: 1,
                    content: .label("2"),
                    area: .flex(1),
                    fillColor: Color(UIColor.softPink)
                ),
                PartData(
                    index: 2,
                    content: .label("3"),
                    area: .flex(1),
                    fillColor: Color(UIColor.softLilac)
                ),
                PartData(
                    index: 3,
                    content: .label("4"),
                    area: .flex(1),
                    fillColor: Color(UIColor.softGreen)
                ),
                PartData(
                    index: 4,
                    content: .label("5"),
                    area: .flex(1),
                    fillColor: Color(UIColor.verySoftRed)
                ),
                PartData(
                    index: 5,
                    content: .label("6"),
                    area: .flex(1),
                    fillColor: Color(UIColor.softDarkblue)
                ),
            ]
        )
        return viewModel
    }

    static var previews: some View {
        WheelView(model: defaultModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
    }
}
