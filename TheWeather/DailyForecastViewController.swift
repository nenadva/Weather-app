//
//  DailyForecastViewController.swift
//  TheWeather
//
//  Created by Matthew Carroll on 12/5/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import UIKit


final class DailyForecastViewController: UIViewController {
    
    private let forecast: WeatherForecast
    
    init(forecast: WeatherForecast) {
        self.forecast = forecast
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let nib = UINib(nibName: "ForecastViewDetail", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! UIView
        self.view = view 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        let view = self.view as! WeatherForecastView
        view.backgroundColor = .groupTableViewBackground
        let forecastModel = ForecastViewModel(forecast: forecast)
        view.weekDay?.text = forecastModel.weekDay
        view.monthDay?.text = forecastModel.monthDay
        view.hiTemp?.text = forecastModel.hiTemp
        view.lowTemp?.text = forecastModel.lowTemp
        view.icon?.image = forecastModel.icon
        view.phrase?.text = forecastModel.phrase
        view.humidity?.text = forecastModel.humidity
        view.pressure?.text = forecastModel.pressure
        view.wind?.text = forecastModel.wind
    }
}

