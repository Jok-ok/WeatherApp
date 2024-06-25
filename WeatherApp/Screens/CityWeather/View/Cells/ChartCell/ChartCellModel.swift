import UIKit.UIColor

final class ChartCellModel {
    let linesDatasets: [DataSet]
    let title: String

    init(linesDatasets: [DataSet], title: String) {
        self.linesDatasets = linesDatasets
        self.title = title
    }
    
    struct DataSet {
        struct Point {
            let x: String
            let y: Double
        }
        let points: [Point]
        let colorSceme: ColorScheme
    }
    
    enum ColorScheme: Int {
        case standart
        case green
        case orange
        
        var accentColor: UIColor {
            switch self {
            case .standart:
                    .systemBlue
            case .green:
                    .systemGreen
            case .orange:
                    .systemOrange
            }
        }
        var secondaryColor: UIColor {
            switch self {
            case .standart:
                    .systemBlue.withAlphaComponent(0.5)
            case .green:
                    .systemGreen.withAlphaComponent(0.5)
            case .orange:
                    .systemOrange.withAlphaComponent(0.5)
            }
        }
        
    }
    
}
