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
    @IBOutlet weak var wheelTitle: UILabel!
    @IBOutlet weak var selectGoalTypeBtn: UIButton!

    private weak var goalService : GoalService?{
        return GoalService()
    }
    internal var goalsArr : [Goal]? {
        didSet{
            self.setPopupButton()
        }
    }
    //hierarchy -> get goalsArr -> setPopupButton() -> onclick -> getGoalDetail -> configureWheel()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initUI()

    }
    
    func initUI(){
        if let user = baseUSER{
            goalService?.getGoals(){ result in
                switch result {
                case .success(let goals):
                    self.goalsArr = goals
                    
                    
                case .failure(let error):
                    Banner.showErrorBanner(with: error)

                }
            }
        }
    }
    
    func configureWheel(goalItemsArr: [GoalItem]){
        if goalItemsArr.count < 2{
            Banner.showInfoBanner(message: "Insufficient items(less than 2) in the selected goal. Please select another one.")
        }else{
            let hostingController = UIHostingController(rootView: WheelView(model: RouletteModel.init(parts: CreateWheelModel(goalItemsArr: goalItemsArr))))
                    addChild(hostingController)
                    hostingController.view.frame = WheelUIView.bounds
                    WheelUIView.addSubview(hostingController.view)
                    hostingController.didMove(toParent: self)
        }
        DispatchQueue.main.async {
            LoadingScreen.hide()
        }
    }
    
    
    
    
     func goalSelected(goalId: Int) {
        DispatchQueue.main.async {
            LoadingScreen.show()
        }
        self.goalService?.getGoalDetail(goalId: goalId){ result in
            switch result {
            case .success(let goalObj ):
                self.configureWheel(goalItemsArr: goalObj.goalItems ?? [])
            case .failure(let error):
                Banner.showErrorBanner(with: error)
                
            }
        }
    }
    
    func setPopupButton() {
        var menuChildren: [UIAction] = []
        
        if let goalsArr = self.goalsArr, goalsArr.count > 2 {
            for goal in goalsArr {
                let action = UIAction(title: goal.title, handler: { [weak self] _ in
                    self?.goalSelected(goalId: goal.goalId)
                })
                menuChildren.append(action)
            }
            goalSelected(goalId: goalsArr[0].goalId)
        }
        selectGoalTypeBtn.menu = UIMenu(children: menuChildren)
        selectGoalTypeBtn.showsMenuAsPrimaryAction = true
        selectGoalTypeBtn.changesSelectionAsPrimaryAction = true
       
    }

    
    func CreateWheelModel(goalItemsArr : [GoalItem]) -> [PartData] {
        var rModelParts: [PartData] = []
        for (index, goalItem) in goalItemsArr.enumerated() {
            let content = Content.label(String(index))
            let title = goalItem.content
            let colorString = collectionCardColorsArr[index % collectionCardColorsArr.count]
            let color = Color(UIColor(named: colorString)!)
            let partData = PartData(index: index, content: content, title: title, area: .flex(1), fillColor: color)
            rModelParts.append(partData)
           
        }
        return rModelParts
    }
    

}
