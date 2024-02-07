//
//  HistoryViewController.swift
//  App01
//
//  Created by Getter Saar on 03.01.2024.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // For core data db
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataController = DataController()
    
    // For table view
    let tableView: UITableView = {
        let table  = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [WeatherInfo]()
    
    // Refresh control
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        
        // Add pull-to-refresh control
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        setUpTableView()
        
        // Load initial data
        models = dataController.getWeatherInfo(context: context).sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
    }
    
    private func setUpTableView(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    @objc private func refreshData() {
        
        // Reload table view after refreshing data
        models = dataController.getWeatherInfo(context: context).sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
        
        // End the refreshing animation
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let infoString = "\(model.temp)°C - \(model.date?.formatted(date: .abbreviated, time: .shortened) ?? "")"

        cell.textLabel?.text = infoString
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool){
        models = dataController.getWeatherInfo(context: context).sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "editInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "editInfo")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let weatherDetail = segue.destination as? EditWeatherInfoViewController
            
            let selectedInfo : WeatherInfo!
            selectedInfo = models[indexPath.row]
            weatherDetail!.selectedInfo = selectedInfo
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
