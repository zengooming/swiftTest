//
//  ViewController.swift
//  SwiftDatePickerView
//
//  Created by 明 on 2020/9/24.
//

import UIKit

class ViewController: UIViewController {

    var datePickerView : ZMDatePickerView?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        datePickerView = ZMDatePickerView.init(frame:UIScreen.main.bounds)
        datePickerView?.delegate = self
        
        datePickerView?.setMaxYearMonthDay(year: 2030, month: 12, day: 12)
        datePickerView?.setMinYearMonthDay(year: 2000, month: 5, day: 12)
        datePickerView?.setDefaultYearMonthDay(year: 2010, month: 10, day: 10)
        
        //注意 一定要在先设置完限制之后显示 不然容易导致数组越界
        datePickerView?.show()
        
        view.addSubview(datePickerView!)
        
    }


}


extension ViewController : ZMDatePickerViewDelegate {
    
    func datePickerDidSelect(component: Int, row: Int, year: String, month: String, day: String) {
        
        print("滚动第\(component)个 到\(row)行  \(year)年-\(month)月-\(day)")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        datePickerView!.show()
    }

}

