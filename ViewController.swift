//
//  ViewController.swift
//  Travel Dreamer
//
//  Created by Brooke Stanford on 8/2/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var originTextField: UITextField!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var resultsTableView: UITableView!

    private var flights: [Flight] = []
    private let apiManager = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        searchButton.addTarget(self, action: #selector(searchFlights), for: .touchUpInside)
    }
    
    @objc private func searchFlights() {
        guard let origin = originTextField.text, !origin.isEmpty,
              let destination = destinationTextField.text, !destination.isEmpty else {
            // Show an alert if fields are empty
            let alert = UIAlertController(title: "Error", message: "Please enter both origin and destination.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        apiManager.searchFlights(from: origin, to: destination) { [weak self] result in
            switch result {
            case .success(let flights):
                self?.flights = flights
                DispatchQueue.main.async {
                    self?.resultsTableView.reloadData()
                }
            case .failure(let error):
                // Show an alert if there's an error
                let alert = UIAlertController(title: "Error", message: "Failed to fetch flights: \(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath)
        let flight = flights[indexPath.row]
        cell.textLabel?.text = "\(flight.airline) - \(flight.price)"
        cell.detailTextLabel?.text = "Departure: \(flight.departure), Arrival: \(flight.arrival)"
        return cell
    }
}
