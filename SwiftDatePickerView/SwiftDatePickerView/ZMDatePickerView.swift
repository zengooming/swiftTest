//
//  ZMDatePickerView.swift
//  DatePickerDemo
//
//  Created by 明 on 2020/9/23.
//

import UIKit




let kSCREEN_W = UIScreen.main.bounds.width
let kSCREEN_H = UIScreen.main.bounds.height


protocol ZMDatePickerViewDelegate : class {
    
    func datePickerDidSelect(component: Int , row : Int , year : String ,month : String , day : String)
    
}


class ZMDatePickerView : UIView {
    
    fileprivate lazy var pickerView : UIPickerView = {
        
        let picker = UIPickerView.init()
        picker.dataSource = self
        picker.delegate   = self
        picker.showsLargeContentViewer = true
        picker.layer.cornerRadius = 5
        picker.backgroundColor = .white
        return picker
        
    }()
    
    weak var delegate : ZMDatePickerViewDelegate?
    
    fileprivate var yearArray      : [String] = [String]()
    fileprivate var monthArray     : [String] = [String]()
    fileprivate var dayArray       : [String] = [String]()
    
    fileprivate var yearIndex      : Int = 0
    fileprivate var monthIndex     : Int = 0
    fileprivate var dayIndex       : Int = 0
    
    fileprivate var maxYear        : Int = 9999
    fileprivate var maxMonth       : Int = 12
    fileprivate var maxDay         : Int = 31
    
    fileprivate var minYear        : Int = 1
    fileprivate var minMonth       : Int = 1
    fileprivate var minDay         : Int = 1
    
    fileprivate var defaultYear    : Int = 1
    fileprivate var defaultMonth   : Int = 1
    fileprivate var defaultDay     : Int = 1
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: -  -- UIPickerViewDataSource,UIPickerViewDelegate
extension ZMDatePickerView : UIPickerViewDataSource , UIPickerViewDelegate {

    
///--------- UIPickerViewDataSource -------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return yearArray.count
        }
        if component == 1 {
            return monthArray.count
        }
        if component == 2 {
            return dayArray.count
        }
        
        return 0
    }
    
///--------- UIPickerViewDelegate -------------
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let contentLabel = UILabel()
        contentLabel.textColor = .red
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textAlignment = .center
        
        if component == 0 {
            contentLabel.text = String(format:"%@", yearArray[row])
        }
        if component == 1 {
            contentLabel.text = String(format:"%@", monthArray[row])
        }
        if component == 2 {
            contentLabel.text = String(format:"%@", dayArray[row])
        }
        
        return contentLabel
    }


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        //年 滚动
        if component == 0 {
            
            yearIndex = row
            
            setMonthArray()
            
            if monthIndex >= monthArray.count {
                monthIndex = monthArray.count - 1
            }
            
        }
        //月 滚动
        if component == 1 {
            monthIndex = row
        }
        //日 滚动
        if component == 2 {
            dayIndex = row
        }
        
        //滚动 年 月 轮轴时 实时计算 日 数量
        if component == 0 || component == 1 {
            
            setDayArray()
            
            if dayIndex >= dayArray.count {
                dayIndex = dayArray.count - 1;
            }
            
        }
        
        //代理
        if delegate != nil {
            
            let year  = yearArray[yearIndex]
            let month = monthArray[monthIndex]
            let day   = dayArray[dayIndex]
            
            delegate?.datePickerDidSelect(component: component, row: row, year: year, month: month, day: day)
        }
        
        
        
        pickerView.reloadAllComponents()
    }
    
}

//MARK: - -- UI处理
extension ZMDatePickerView {
    
    fileprivate func setupUI() {
        
        addSubview(pickerView)
        pickerView.frame = CGRect.init(x: 0, y: 0, width: kSCREEN_W - 60, height: 250)
        pickerView.center = center
        
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        frame = CGRect(x: 0, y: 0, width: kSCREEN_W, height: kSCREEN_H)

        setDefalutConfig()
        pickerView.reloadAllComponents()
    }
    
    
    fileprivate func setDefalutConfig (){
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day,.month,.year,.hour], from: Date() as Date)
               
        defaultYear  = dateComponents.year!
        defaultMonth = dateComponents.month!
        defaultDay   = dateComponents.day!
        
        setYearArray()
        setMonthArray()
        setDayArray()
        
        
    }
    
    func show() {
        
        removeFromSuperview()
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        
        let yearRow  = yearArray.firstIndex(of: String(defaultYear))!
        let monthRow = monthArray.firstIndex(of: String(defaultMonth))!
        let dayRow   = dayArray.firstIndex(of: String(defaultDay))!
        
        yearIndex = yearRow
        monthIndex = monthRow
        dayIndex = dayRow
        
        pickerView.selectRow(yearRow, inComponent: 0, animated: false)
        pickerView.selectRow(monthRow, inComponent: 1, animated: false)
        pickerView.selectRow(dayRow, inComponent: 2, animated: false)
        pickerView.reloadAllComponents()
        
    }
    
}

//MARK: - -- 事件处理
extension ZMDatePickerView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        removeFromSuperview()
    }
    
    //设置 年 个数
    fileprivate func setYearArray (){
        
        yearArray.removeAll()
        //年 为 最小限制 到 最大限制
        for i in minYear ... maxYear {
            yearArray.append(String(i))
        }
        
    }
    
    //设置 月 个数
    fileprivate func setMonthArray (){
        
        //当 年 为最小年时 月个数为 最小限制到12
        if yearIndex == 0 {
            monthArray.removeAll()
            for i in minMonth ... 12 {
                monthArray.append(String(i))
            }
        }
        //当 年 为最大年时 月个数为 1到最大限制
        if yearIndex == yearArray.count - 1 {
            monthArray.removeAll()
            for i in 1 ... maxMonth {
                monthArray.append(String(i))
            }
        }
        //当 年 不为最大最小时 月个数为 1到12
        if yearIndex != 0 && yearIndex != yearArray.count - 1 {
            monthArray.removeAll()
            for i in 1 ... 12 {
                monthArray.append(String(i))
            }
        }
        
    
    }
    
    fileprivate func setDayArray ()  {
        
        let dayCount = daysCount()
        
        dayArray.removeAll()
        
        for i in 1...dayCount {
            dayArray.append(String(i))
        }
        
        //最小年月 天数计算
        if (yearIndex == 0 && monthIndex == 0) {
            dayArray.removeAll()
           
            for i in minDay ... dayCount {
                dayArray.append(String(i))
            }
        }
        
        //最大年月 天数计算
        if yearIndex == yearArray.count - 1 && monthIndex == monthArray.count - 1 {
            
            dayArray.removeAll()
            
            if maxDay < dayCount {
                for i in 1 ... maxDay {
                    dayArray.append(String(i))
                }
            }else{
                for i in 1 ... dayCount {
                    dayArray.append(String(i))
                }
            }
            
        }
       
    }
    
    /// 计算每个月的天数
    fileprivate func daysCount() -> Int{
        
        let year  = Int(yearArray[yearIndex])!
        let month = Int(monthArray[monthIndex])!
        
        let isrunNian = year%4 == 0 ? (year%100 == 0 ? (year%400 == 0 ? true:false):true):false
        if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12{
            return 31
        }else if month == 4 || month == 6 || month == 9 || month == 11{
            return 30
        }else if month == 2{
            if isrunNian{
                return 29
            }else{
                return 28
            }
        }
        return 0
    }
    
}
//MARK: -  对外暴露方法
extension ZMDatePickerView {
    
    
    /// 限制最大可选年 月 日
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    func setMaxYearMonthDay(year:Int,month:Int,day:Int) {
        
        maxYear = year
        maxMonth = month
        maxDay = day
        setYearArray()
    }
    
    /// 限制最小可选年 月 日
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    func setMinYearMonthDay(year:Int,month:Int,day:Int) {
        minYear = year
        minMonth = month
        minDay = day
        setYearArray()
    }
    
    /// 设置默认选择年月日
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    ///   - day: 日
    func setDefaultYearMonthDay(year:Int,month:Int,day:Int) {
        
        if year < maxYear && year > minYear {
            defaultYear = year
        }
        
        if month < maxMonth && year > minMonth {
            defaultMonth = month
        }
       
        if day < maxDay && day > minDay {
            defaultDay = day
        }
        
        setYearArray()
        setMonthArray()
        setDayArray()
        
    }
}





