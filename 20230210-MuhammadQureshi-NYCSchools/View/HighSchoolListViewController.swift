//
//  HighSchoolListViewController.swift
//  20230210-MuhammadQureshi-NYCSchools
//
//  Created by Muhammad Qureshi on 2/10/23.
//

import UIKit

class HighSchoolListViewController: UITableViewController {
    
    //MARK: *********  Properties  *********
    private var viewModel = HighSchoolListViewModel()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    //MARK: *********  Functions  *********
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        viewModel.delegate = self
        viewModel.fetchHighSchools()
    }
    
    //registering tableView cells with table view
    private func registerTableViewCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    //setting up loader
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    //showing loader
    private func showIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    //hiding loader
    private func stopIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    //displaing content for high school more info
    private func displayAdditionalSchoolInfo(content: (String , String)) {
        let alert = UIAlertController(title: content.0, message: content.1 , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //TableView delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.titleForRowAtIndexPath(indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showIndicator()
        viewModel.fetchSATAndHighSchoolAdditionalInfo(dbn: viewModel.dbnForRowAtIndexPath(indexPath))
    }
}

//MARK: *********  Delegate handling for viewModel interaction  *********
extension HighSchoolListViewController: HighSchoolListViewModelDelegate {
    //making content for high school more info
    func highSchoolAdditionalInfoDidChange() {
        DispatchQueue.main.async {
            self.stopIndicator()
            self.displayAdditionalSchoolInfo(content: self.viewModel.setupAlertForSchoolMoreDetail())
        }
    }
    //notifing method for schools list update
    func highSchoolsDidChange() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.stopIndicator()
        }
    }
    
    //error fall back for api calls
    func errorFallBack(errorString: String) {
        DispatchQueue.main.async {
            self.stopIndicator()
            self.onFaildError(reason: errorString)
        }
    }
    
    //Alert for error mapping
    private func onFaildError(reason: String) {
        let alert = UIAlertController(title: "Warning!", message: reason , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
