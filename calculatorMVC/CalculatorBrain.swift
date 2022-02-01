//
//  CaculatorBrain.swift
//  calculatorMVC
//
//  Created by Taehoon Kim on 2022/02/01.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

class CalculatorBrain
{
    /// accumulator(누산기): 계산기에서 누적되는 값
    private var accumulator = 0.0
    
    /// operand: 연산의 대상값
    func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "𝝿" : Operation.Constant(.pi), // pi
        "e" : Operation.Constant(M_E), // M_E,
        "√" : Operation.UnaryOperation(sqrt), // sqrt
        "cos" : Operation.UnaryOperation(cos), // cos
        // Operation에 정의한 ((Double, Double) -> Double)로 유추가 가능함.
        //
        "*" : Operation.BinaryOperation({ $0 * $1 }), // cos
        "+" : Operation.BinaryOperation({ $0 + $1 }), // cos
        "-" : Operation.BinaryOperation({ $0 - $1 }), // cos
        "/" : Operation.BinaryOperation({ $0 / $1 }), // cos
        "=" : Operation.Equals
    ]
    
    // 1단계
    // { 를 앞으로 보내고 in을 추가함
    //    "*" : Operation.BinaryOperation({(op1: Double, op2: Double) -> Double in
    //    return op1 * op2
    //    })
    
    
    // 2단계
    // enum에서 double 타입임을 enum에서 알 수 있기때문에 제거가가능함.
    //    { (op1, op2) -> Double in
    //        return op1 * op2
    //     }
    
    // 3단계
    // 인자이름으로 $0, $1이가능함
    //    { ($0, $1) -> Double in
    //        return op1 * op2
    //     }
    // 이렇게 되면 { return $0 * $1} 로 줄일 수가 있음
    // enum에서 리턴값이 double임을 알기에 {$0 * $1} 으로 줄일 수 있음
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func perforOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            
            //value - associatedConstantValue
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    /// 준비된 이항연산 실행함
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    // Array, Double,Int,String 은 모두 struct, 값복사를 진행함
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
}
