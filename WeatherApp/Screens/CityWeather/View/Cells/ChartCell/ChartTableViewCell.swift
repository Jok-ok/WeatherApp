import UIKit
import DGCharts

final class ChartTableViewCell: UITableViewCell, CellIdentifiableProtocol, CellConfigurableProtocol {
    typealias Model = ChartCellModel
    private var model: Model?
    private let titleLabel = UILabel()
    private let circleMarker = CircleMarker()
    
    private var chartView = LineChartView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: ChartCellModel) {
        self.model = model
        titleLabel.text = model.title
        drawChart()
    }
    
    private func drawChart() {
        guard let model = model else { return }
        var datasets = [LineChartDataSet]()
        
        let xAxis = chartView.xAxis
        
        for dataset in model.linesDatasets {
            var line = [ChartDataEntry]()
            for (index, point) in dataset.points.enumerated() {
                let lineEntry = ChartDataEntry(x: Double(index), y: point.y)
                line.append(lineEntry)
                print(123)
            }
            
            let lineChartDataSet = LineChartDataSet(entries: line)
            lineChartDataSet.setColor(dataset.colorSceme.accentColor)
            lineChartDataSet.lineWidth = 3
            lineChartDataSet.valueFont = FontLibrary.caption
            lineChartDataSet.mode = .cubicBezier
            lineChartDataSet.drawValuesEnabled = false
            lineChartDataSet.drawCirclesEnabled = false
            lineChartDataSet.drawFilledEnabled = true
            lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
            lineChartDataSet.highlightLineWidth = 2
            lineChartDataSet.highlightColor = dataset.colorSceme.accentColor
            
            xAxis.valueFormatter = IndexAxisValueFormatter(values: dataset.points.map{ $0.x })
            xAxis.labelPosition = .bottom
            xAxis.labelTextColor = .getAppColor(.accentOp)!
            
            if let gradient = getColorGradient(firsColor: dataset.colorSceme.accentColor, secondColor: dataset.colorSceme.secondaryColor) {
                lineChartDataSet.fill = LinearGradientFill(gradient: gradient, angle: 270)
            }
            
            datasets.append(lineChartDataSet)
        }
        
        let data = LineChartData(dataSets: datasets)
        
        chartView.data = data
        chartView.notifyDataSetChanged()
    }
    
    private func getColorGradient(firsColor: UIColor, secondColor: UIColor) -> CGGradient? {
        let mainColor = firsColor
        let secondary = secondColor
        let lastColor = secondColor.withAlphaComponent(0)
        
        
        let colors = [mainColor.cgColor, secondary.cgColor, lastColor.cgColor] as CFArray
        let locations: [CGFloat] =  [0, 0.67, 1]
        
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: colors, locations: locations) {
            return gradient
        }
        return nil
    }
}
//MARK: Appearance
private extension ChartTableViewCell {
    func configureAppearance() {
        selectionStyle = .none
        contentView.backgroundColor = .getAppColor(.secondaryBackgroundColor)
        configureChartAppearance()
        configureTitleLabelAppearance()
        constraintTitleLabel()
        constraintChart()
    }
    
    func configureTitleLabelAppearance() {
        titleLabel.textColor = .getAppColor(.accentColor)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = FontLibrary.headline
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    func configureChartAppearance() {
        // отключаем координатную сетку
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.drawGridBackgroundEnabled = false
        
        chartView.legend.enabled = false
        
        // отключаем подписи к осям
        chartView.xAxis.drawLabelsEnabled = true
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        
        // отключаем зум
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        
        // убираем артефакты вокруг области графика
        chartView.xAxis.enabled = true
        chartView.xAxis.axisLineColor = .clear
        chartView.xAxis.labelFont = FontLibrary.caption
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.drawBordersEnabled = false
        chartView.minOffset = 0
        
        chartView.drawMarkers = true
        circleMarker.chartView = chartView
        chartView.marker = circleMarker
    }
    
    func constraintTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        let inset = 25.0
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            titleLabel.topAnchor .constraint(equalTo: contentView.topAnchor, constant: inset)
        ])
    }
    
    func constraintChart() {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chartView)
        let inset = 25.0
        
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25.0),
            chartView.topAnchor .constraint(equalTo: titleLabel.bottomAnchor, constant: inset),
            chartView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
}

final class CircleMarker: MarkerView {
    override func draw(context: CGContext, point: CGPoint) {
        super.draw(context: context, point: point)
        guard let accentColor = UIColor.getAppColor(.accentColor),
              let accentOpColor = UIColor.getAppColor(.accentOp) else { return }
        context.setFillColor(accentOpColor.withAlphaComponent(0.1).cgColor)
        context.setStrokeColor(accentColor.cgColor)
        context.setLineWidth(2)
        let radius: CGFloat = 8
        let rectangle = CGRect(
            x: point.x - radius,
            y: point.y - radius,
            width: radius * 2,
            height: radius * 2
        )
        context.addEllipse(in: rectangle)
        context.drawPath(using: .fillStroke)
    }
}
