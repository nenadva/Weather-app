//
//  WeatherForecastView.swift
//  TheWeather
//
//  Created by Matthew Carroll on 12/5/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import UIKit

final class WeatherForecastView: UIView {

    @IBOutlet weak var weekDay: UILabel?
    @IBOutlet weak var monthDay: UILabel?
    
    @IBOutlet weak var hiTemp: UILabel?
    @IBOutlet weak var lowTemp: UILabel?
    @IBOutlet weak var icon: UIImageView?
    @IBOutlet weak var phrase: UILabel?
    
    @IBOutlet weak var humidity: UILabel?
    @IBOutlet weak var pressure: UILabel?
    @IBOutlet weak var wind: UILabel?

    @IBOutlet weak var recognizer: UITapGestureRecognizer?
}
