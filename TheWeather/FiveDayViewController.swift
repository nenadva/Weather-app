//
//  FiveDayViewController.swift
//  TabbediOS
//
//  Created by Matthew Carroll on 11/16/16.
//  Copyright © 2016 Third Cup lc. All rights reserved.
//

import UIKit


final class FiveDayViewController: UITableViewController {

    private var todaysForecast: WeatherForecast?
    private var dataSource = FiveDayDataSource<WeatherForecast>(tableView: UITableView())
    
    var didSelect: (WeatherForecast) -> () = { _ in }
    var didTapHeader: (WeatherForecast) -> () = { _ in }
    var fetchWeather: (@escaping (WeatherResponse) -> ()) -> () = { _ in } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = FiveDayDataSource(tableView: tableView)
        tableView.dataSource = dataSource
        let nib = UINib(nibName: "ForecastViewHeader", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! UIView
        tableView.tableHeaderView = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWeather(weatherResponse)
        navigationController?.isNavigationBarHidden = true
    }
    
    func weatherResponse(response: WeatherResponse) {
        guard response.error == nil else {
            return UIAlertController.show(from: self, title: response.error!.message, ok: nil)
        }
        response.currentConditions.map { configureView(forecast: $0) }
        guard let forecasts = response.fiveDay, let first = forecasts.first else { return }
        todaysForecast = first
        dataSource.objects = forecasts.dropFirst
    }
    
    private func configureView(forecast: WeatherForecast) {
        let view = tableView.tableHeaderView as! WeatherForecastView
        let forecastModel = ForecastViewModel(forecast: forecast)
        view.monthDay?.text = forecastModel.monthDay
        view.hiTemp?.text = forecastModel.hiTemp
        view.lowTemp?.text = forecastModel.lowTemp
        view.icon?.image = forecastModel.icon
        view.phrase?.text = forecastModel.phrase
        view.recognizer?.addTarget(self, action: #selector(tappedHeaderView))
    }
    
    @objc private func tappedHeaderView() {
        todaysForecast.map { didTapHeader($0) }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(dataSource.objects[indexPath.row])
    }
}


private final class FiveDayDataSource<T>: NSObject, UITableViewDataSource {
    
    private let tableView: UITableView
    fileprivate var objects = [T]() {
        didSet { mainQueue.addOperation { self.tableView.reloadData() } }
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FiveDayCell
        let forecast = objects[indexPath.row] as! WeatherForecast
        let forecastModel = ForecastViewModel(forecast: forecast)
        cell.icon?.image = forecastModel.icon
        cell.weekDay?.text = forecastModel.weekDay
        cell.phrase?.text = forecastModel.phrase
        cell.hiTemp?.text = forecastModel.hiTemp
        cell.loTemp?.text = forecastModel.lowTemp
        return cell
    }
}
