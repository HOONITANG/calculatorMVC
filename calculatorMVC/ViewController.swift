//
//  ViewController.swift
//  calculatorMVC
//
//  Created by Taehoon Kim on 2022/02/01.
//

import UIKit

class ViewController: UIViewController {
    
    // Properties
    
    // 계산기의 계산결과를 보여줄 label 뷰
    let display: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    private var userIsIntheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUIView()
    }
    
    //Helpers
    
    
    
    
    /// displaydhk keypad 버튼을 stackView로 생성하는 함수
    private func createUIView() {
        let keypadStructure = [["*", "/", "+", "-"],
                           ["𝝿", "7", "8", "9"],
                           ["√", "4", "5", "6"],
                           ["save", "1", "2", "3"],
                           ["restore", ".", "0", "="]]
        
        /// 전체적인 스택뷰
        let fullOfCalculatorView = UIStackView(arrangedSubviews: [display])
        fullOfCalculatorView.axis = .vertical
        fullOfCalculatorView.distribution = .fillEqually
        fullOfCalculatorView.spacing = 8
        
        keypadStructure.forEach { (keypadNames) in
            /// 계산기의 한줄을 맡는 Stackview
            let oneOfRowView = UIStackView()
            oneOfRowView.axis = .horizontal
            oneOfRowView.spacing = 8
            oneOfRowView.distribution = .fillEqually
            
            keypadNames.forEach { (keypadName) in
                let button = UIButton()
                button.setTitle(keypadName, for: .normal)
                button.backgroundColor = .systemGray6
                button.setTitleColor(.systemBlue, for: .normal)
                if (keypadName == "𝝿" || keypadName == "√" || keypadName == "cos" || keypadName == "*" || keypadName == "=" ||  keypadName == "+" ||  keypadName == "-" ||  keypadName == "/") { button.addTarget(self, action: #selector(performOperator(_:)), for: .touchUpInside) }
                else { button.addTarget(self, action: #selector(keypadButtonTapped(_:)), for: .touchUpInside) }
                
                oneOfRowView.addArrangedSubview(button)
            }
            fullOfCalculatorView.addArrangedSubview(oneOfRowView)
        }
        
        view.addSubview(fullOfCalculatorView)
        fullOfCalculatorView.translatesAutoresizingMaskIntoConstraints = false
        fullOfCalculatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        fullOfCalculatorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        fullOfCalculatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        fullOfCalculatorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
    }
    
    // Selector
    
    /// 얻어 올땐 Double로 설정 할땐 String으로 넣어주는 get, set을 작성함
    /// 연산되는 변수를 작성함
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    
    /// keypad 클릭시 동작하는 함수
    @objc private func keypadButtonTapped(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsIntheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        
        userIsIntheMiddleOfTyping = true
    }
    
    private var brain = CalculatorBrain()
    
    @objc private func performOperator(_ sender: UIButton) {
        // 사용자가 숫자를 입력중이라면 숫자값을 설정해주는 함수
        if userIsIntheMiddleOfTyping {
            // brain.setOperand를 왜 실행시키지
            brain.setOperand(displayValue)
            userIsIntheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.perforOperation(symbol: mathematicalSymbol)
            displayValue = brain.result
        }
    }
}
