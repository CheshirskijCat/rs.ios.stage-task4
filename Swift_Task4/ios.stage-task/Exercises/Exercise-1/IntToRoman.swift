import Foundation

let romanLetters: Array = ["I", "V", "X", "X", "L", "C", "C", "D", "M", "M"];

public extension Int {
    
    var roman: String? {
        
        if (!(1...3999).contains(self)){ return nil }

        var result: String = ""
        var number = self
        
        for i in (0...4).reversed() {
            let devider = Int(pow(Double(10),Double(i)))
            let digit: Int = i == 0 ? number : number / devider
            let half = digit/5
            let residue = digit%5
            
            switch (half, residue) {
                case (0...1, 1...3):
                    if (half > 0) { result += romanLetters[i * 3 + half] }
                    for _ in (1...residue) { result += romanLetters[i * 3]  }
                    break;
                case (0...1, 4):
                    result += romanLetters[i * 3] + romanLetters[i * 3 + half + 1]
                    break;
                case (1, 0):
                    result += romanLetters[i * 3 + half]
                    break;
                default:
                    break;
            }
            number %= devider
        }
        return result
    }
}
