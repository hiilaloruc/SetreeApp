//
//  WheelViewController.swift
//  SetreeApp
//
//  Created by HilalOruc on 11.02.2023.
//

import UIKit
import SwiftUI
import SimpleRoulette

class WheelViewController: UIViewController {
    @IBOutlet weak var WheelUIView: UIView!
    let rModel : RouletteModel = .init(parts: [
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
            fillColor: Color(UIColor.mainRoyalBlueColor)
        ),
        PartData(
            index: 5,
            content: .label("6"),
            area: .flex(1),
            fillColor: Color(UIColor.softDarkblue)
        ),
    ])
    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = UIHostingController(rootView: WheelView(model: rModel))
                addChild(hostingController)
                hostingController.view.frame = WheelUIView.bounds
                WheelUIView.addSubview(hostingController.view)
                hostingController.didMove(toParent: self)

    }
    

}
