import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {

        if ( row < 0 && image.count < row && column < 0 && image[row].count < column &&
             row > 50 && column > 50 && newColor < 0 && newColor > 65536 ) {return image}

        var result = image.map{$0.map{$0}}
        fillColor(image: &result, n: row, m: column, color: image[row][column], newColor: newColor)
        return result
    }
    
    func fillColor(image: inout [[Int]], n: Int, m: Int, color: Int, newColor: Int){
        image[n][m] = newColor
        let directions: [(n:Int, m:Int)] = [(n - 1, m), (n + 1, m), (n, m - 1), (n, m + 1)]
        directions.forEach{ c in
            if (c.n >= 0 && c.n < image.count && c.m >= 0 && c.m < image[c.n].count && image[c.n][c.m] == color){
                fillColor(image: &image, n: c.n, m: c.m, color: color, newColor: newColor)
            }
        }
    }
}
