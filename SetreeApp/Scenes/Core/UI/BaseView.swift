//
//  BaseView.swift
//  SetreeApp
//
//  Created by HilalOruc on 10.02.2023.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromXib()
    }
    
    @discardableResult
    private func loadViewFromXib() -> UIView{
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName:  String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        return view
    }
}
