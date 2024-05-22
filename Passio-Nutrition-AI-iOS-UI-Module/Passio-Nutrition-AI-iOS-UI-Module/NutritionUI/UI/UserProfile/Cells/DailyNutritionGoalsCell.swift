//
//  EditNutritionGoalCell.swift
//  BaseApp
//
//  Created by Nikunj Prajapati on 14/03/22.
//  Copyright © 2022 Passio Inc. All rights reserved.
//

import UIKit

final class DailyNutritionGoalsCell: UITableViewCell {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nutritionView: DonutProgressView!
    @IBOutlet weak var caloriesValueLabel: UILabel!
    @IBOutlet weak var carbsPercentLabel: UILabel!
    @IBOutlet weak var carbsValueLabel: UILabel!
    @IBOutlet weak var proteinPercentLabel: UILabel!
    @IBOutlet weak var proteinValueLabel: UILabel!
    @IBOutlet weak var fatPercentLabel: UILabel!
    @IBOutlet weak var fatValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.dropShadow()
    }
    
    func updateProfile(userProfile: UserProfileModel){

        self.caloriesValueLabel.text = "\(userProfile.caloriesTarget)"
        self.carbsPercentLabel.text = "\(userProfile.carbsPercent)%"
        self.carbsValueLabel.text = "\(userProfile.carbsGrams) \(Localized.gramUnit)"
        self.proteinPercentLabel.text = "\(userProfile.proteinPercent)%"
        self.proteinValueLabel.text = "\(userProfile.proteinGrams) \(Localized.gramUnit)"
        self.fatPercentLabel.text = "\(userProfile.fatPercent)%"
        self.fatValueLabel.text = "\(userProfile.fatGrams) \(Localized.gramUnit)"
        
        
        let c = DonutProgressView.Datasource.init(label: "carbs", color: .lightBlue, percent: Double(userProfile.carbsPercent))
        let p = DonutProgressView.Datasource.init(label: "protein", color: .green500, percent: Double(userProfile.proteinPercent))
        let f = DonutProgressView.Datasource.init(label: "Fat", color: .purple500, percent: Double(userProfile.fatPercent))
        
        self.nutritionView.updateData(data: [c,p,f])
        
    }
}
