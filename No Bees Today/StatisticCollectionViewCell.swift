//
//  StatisticCollectionViewCell.swift
//  No Bees Today
//
//  Created by Moritz Kanzler on 20.03.18.
//  Copyright © 2018 Moritz Kanzler. All rights reserved.
//

import UIKit
import Charts

class StatisticCollectionViewCell: PillInfoCell {
    
    @IBOutlet weak var resultPieChartView: PieChartView!
    
    
    var statistics = Statistics()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateView), name: Notification.Name("ClearStorageNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateView), name: Notification.Name("PillStateChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateView), name: Notification.Name("PillTakingNotification"), object: nil)
        self.updateView()
    }
    
    @objc func updateView() {
        guard let statisticData = Statistics.shared.getCurrentPillCylceStatistic() else { return }
        
        resultPieChartView.centerText = NSLocalizedString("Monthly statistics", comment: "")
        resultPieChartView.chartDescription?.text = ""
        resultPieChartView.rotationEnabled = false
        resultPieChartView.rotationAngle = 180

        let legend = resultPieChartView.legend
        legend.horizontalAlignment = .center
        legend.drawInside = false
        legend.enabled = false
        
        guard let takenData = statisticData[PillDay.PillDayState.pillTaken.rawValue], let forgottenData = statisticData[PillDay.PillDayState.pillForgotten.rawValue], let openData = statisticData[PillDay.PillDayState.pillNotYetTaken.rawValue] else { return }
        let takenDataEntry = PieChartDataEntry(value: Double(takenData))
        let forgottenDataEntry = PieChartDataEntry(value: Double(forgottenData))
        let openDateEntry = PieChartDataEntry(value: Double(openData))
        
        let dataSet = PieChartDataSet(values: [takenDataEntry, forgottenDataEntry, openDateEntry], label: nil)
        dataSet.colors = [NSUIColor(red: 89/255, green: 189/255, blue: 53/255, alpha: 1.0), NSUIColor(red: 236 / 255, green: 125 / 255, blue: 123 / 255, alpha: 1.0), NSUIColor.groupTableViewBackground]
        dataSet.valueFormatter = StatisticsFormatter()
        dataSet.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: dataSet)
        resultPieChartView.data = data
        
        //All other additions to this function will go here
        resultPieChartView.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .linear)
        //This must stay at end of function
        resultPieChartView.notifyDataSetChanged()

    }
    
}
