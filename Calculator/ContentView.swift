import SwiftUI

enum Buttons: String {
    case one = "1", two = "2", three = "3", four = "4", five = "5", six = "6", seven = "7", eight = "8", nine = "9", zero = "0", add = "+", subtract = "-", divide = "÷", multiply = "×", equal = "=", clear = "AC", decimal = ".", percent = "%", negative = "+/-", sin = "sin", cos = "cos", tan = "tan", ctan = "ctan", ln = "ln", sqrt = "sqrt", pi = "pi", e = "e", abs = "abs", rand = "rand", ig = "Instagram"
    
    var buttonText: Color {
        switch self {
            case .clear, .negative, .percent:
                return Color("NumbersColor")
            default:
                return .white
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .equal, .add, .subtract, .multiply, .divide:
            return Color("OperatorsColor")
        case .clear, .negative, .percent:
            return Color("LightGray")
        default:
            return Color("NumbersColor")
        }
    }
    
    var buttonColorFlipped: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return Color("OperatorsColor")
        case .clear, .negative, .percent:
            return Color("LightGray")
        case .sin, .cos, .tan, .ctan, .ln, .sqrt, .pi, .e, .abs, .rand:
            return Color("FlippedColor")
        case .ig:
            return Color("IgColor")
        default:
            return Color("NumbersColor")
        }
    }
}

enum Operators {
    case add, subtract, multiply, divide, equal, none
}

struct ContentView: View {
    @State private var value = "0"
    @State private var runningNumber: Double = 0
    @State private var currentOperation: Operators = .none
    @State private var deletedValue = ""
    
    @State private var isIg = false
    @State private var alerTitle = "My Instagram"
    
    let buttons: [[Buttons]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    let buttonsFlipped: [[Buttons]] = [
        [.sin, .cos, .clear, .negative, .percent, .divide],
        [.tan, .ctan, .seven, .eight, .nine, .multiply],
        [.ln, .sqrt, .four, .five, .six, .subtract],
        [.pi, .e, .one, .two, .three, .add],
        [.ig, .abs, .rand, .zero, .decimal, .equal],
    ]
    
    var body: some View {
        ZStack {
            Color("BgColor")
                .ignoresSafeArea()
            
            GeometryReader {geometry in
                if(geometry.size.height > geometry.size.width) {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text(value)
                                .foregroundColor(.white)
                                .font(.system(size: 80))
                        }
                        .padding(20)
                        
                        ForEach(buttons, id: \.self) { row in
                            HStack(spacing: 15) {
                                ForEach(row, id: \.self) { item in
                                    Button {
                                        isTapped(button: item)
                                    } label: {
                                        Text(item.rawValue)
                                            .font(.system(size: 35))
                                            .foregroundColor(item.buttonText)
                                            .frame(
                                                width: self.buttonWidth(item: item),
                                                height: buttonHeight()
                                            )
                                            .background(item.buttonColor)
                                            .cornerRadius(self.buttonWidth(item: item) / 2)
                                    }
                                }
                            }
                            .padding(.bottom, 5)
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Text(value)
                                .bold()
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        .padding()
                        
                        ForEach(buttonsFlipped, id: \.self) { row in
                            HStack(spacing: 12) {
                                ForEach(row, id: \.self) { item in
                                    Button(action: {
                                        self.isTapped(button: item)
                                    }, label: {
                                        Text(item.rawValue)
                                            .font(.system(size: 20))
                                            .frame(
                                                width: self.buttonWidthFlipped(item: item),
                                                height: self.buttonHeightFlipped()
                                            )
                                            .background(item.buttonColorFlipped)
                                            .foregroundColor(item.buttonText)
                                            .cornerRadius(20)
                                    })
                                }
                            }
                            .padding(.bottom, 3)
                        }
                    }
                    .alert(alerTitle, isPresented: $isIg) {
                        Button("Continue") { }
                    } message: {
                        Text("gleblubecki")
                    }
                }
            }
        }
    }
    
    func isTapped(button: Buttons) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal, .percent:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Double(self.value) ?? 0.0
            } else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Double(self.value) ?? 0.0
            } else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Double(self.value) ?? 0.0
            } else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Double(self.value) ?? 0.0
            } else if button == .percent {
                let runningValue = Double(self.value) ?? 0.0
                self.value = "\(runningValue / 100)"
                break
            } else if button == .equal {
                
                let runningValue = self.runningNumber
                let currentValue = Double(self.value) ?? 0.0
                
                switch self.currentOperation {
                case .add: self.value = "\(runningValue + currentValue)"
                case .subtract: self.value = "\(runningValue - currentValue)"
                case .multiply: self.value = "\(runningValue * currentValue)"
                case .divide: self.value = "\(runningValue / currentValue)"
                case .equal: self.value = self.value
                case .none:
                    break
                }
                if (self.value.hasSuffix(".0")) {
                    self.value = String(self.value.dropLast(2))
                }
                self.currentOperation = .equal
            }
            
            if button != .equal {
                self.value = "0"
            }
        case .sin:
            self.runningNumber = Double(self.value) ?? 0.0
            self.value = "\(sin(runningNumber*(.pi / 180)))"
            
        case .cos:
            self.runningNumber = Double(self.value) ?? 0.0
            self.value = "\(cos(runningNumber*(.pi / 180)))"
            
        case .tan:
            self.runningNumber = Double(self.value) ?? 0.0
            self.value = "\(tan(runningNumber*(.pi / 180)))"
            
        case .ctan:
            self.runningNumber = Double(self.value) ?? 0.0
            self.value = "\(1/tan(runningNumber*(.pi / 180)))"
            
        case .e:
            self.value = "\(M_E)"
            
        case .sqrt:
            self.runningNumber = Double(self.value) ?? 0.0
            if (self.runningNumber >= 0) {
                self.value = "\(sqrt(runningNumber))"
            } else {self.value = "square root from negative number"}
            
        case .ln:
            self.runningNumber = Double(self.value) ?? 0.0
            self.value = "\(log(runningNumber))"
            
        case .pi:
            self.value = " \(Double.pi)"
            
        case .abs:
            self.runningNumber = Double(self.value) ?? 0.0
            self.value = "\(abs(runningNumber))"
            
        case .rand:
            self.value = "\(Int.random(in: 0...1000))"
            
        case .ig:
            self.isIg = true
            
            
        case .clear:
            self.deletedValue = self.value
            self.value = "0"
            
        case .negative:
            if (!self.value.hasPrefix("-")) {
                self.value.insert("-", at: self.value.startIndex)
            } else {
                self.value.remove(at: self.value.startIndex)
            }
            
        case .decimal:
            if (!self.value.contains(".")) {
                self.value.insert(".", at: self.value.endIndex)
            }
        
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            } else if (currentOperation == .equal) {
                self.value = ""
                self.value = "\(self.value)\(number)"
                currentOperation = .none
            } else {
                self.value = "\(self.value)\(number)"
            }
        }
    }
    func buttonWidth(item: Buttons) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4 * 10)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        (UIScreen.main.bounds.width - (5 * 14)) / 4
    }
    
    func buttonWidthFlipped(item: Buttons) -> CGFloat {
        return (UIScreen.main.bounds.width - (7 * 30)) / 6
    }

    func buttonHeightFlipped() -> CGFloat {
        return (UIScreen.main.bounds.height - (7 * 20)) / 6
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
