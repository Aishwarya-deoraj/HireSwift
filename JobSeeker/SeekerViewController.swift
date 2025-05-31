import UIKit
import SwiftData
import CoreLocation
import MapKit

class SeekerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!  // ← ADD this IBOutlet for the map

    var modelContext: ModelContext!
    var jobs: [Note] = []
    var filteredJobs: [Note] = []

    var locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let container = appDelegate.container {
            modelContext = ModelContext(container)
        }

        tableView.delegate = self
        tableView.dataSource = self

        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsUserLocation = true  // Show the blue dot for user

        addTapGestureOnMap()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        fetchJobs()

        navigationItem.title = "Available Jobs"
        distanceTextField.placeholder = "Distance in miles"

    }

    func fetchJobs() {
        do {
            let fetchDescriptor = FetchDescriptor<Note>()
            jobs = try modelContext.fetch(fetchDescriptor)
            filteredJobs = jobs  // Show all jobs initially
            tableView.reloadData()
            print("fetch jobsssss: \(filteredJobs)")
        } catch {
            print("Failed to fetch jobs: \(error)")
        }
    }

    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            userLocation = location
            print("📍 User location: \(location.latitude), \(location.longitude)")

            // Center map on user's current location
            let region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            mapView.setRegion(region, animated: true)
        }
        locationManager.stopUpdatingLocation()
    }

    // MARK: - Tap Gesture to select location
    func addTapGestureOnMap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc func mapTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: mapView)
        let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)

        userLocation = tappedCoordinate  // Update user's selected location

        // Remove old annotations
        mapView.removeAnnotations(mapView.annotations)

        // Drop a new pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = tappedCoordinate
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)

        print("📍 User selected new location: \(tappedCoordinate.latitude), \(tappedCoordinate.longitude)")
    }

    // MARK: - Filter Button Action
    @IBAction func filterJobsTapped(_ sender: UIButton) {
        view.endEditing(true)  // Dismiss keyboard

        guard let seekerCoordinate = userLocation else {
            showAlert(message: "User location not available yet.")
            return
        }

        guard let inputText = distanceTextField.text, !inputText.isEmpty, let radiusInMiles = Double(inputText) else {
            // If no input given, show all jobs
            filteredJobs = jobs
            tableView.reloadData()
            print("fetch jobs newwww: \(filteredJobs)")
            return
        }
        
        let radiusInMeters = radiusInMiles * 1609.34

        filteredJobs = filterJobsWithinRadius(seekerCoordinate: seekerCoordinate, jobs: jobs, radiusInMeters: radiusInMeters)
        tableView.reloadData()
    }

    func filterJobsWithinRadius(seekerCoordinate: CLLocationCoordinate2D, jobs: [Note], radiusInMeters: Double) -> [Note] {
        let seekerLocation = CLLocation(latitude: seekerCoordinate.latitude, longitude: seekerCoordinate.longitude)

        return jobs.filter { job in
            let jobLocation = CLLocation(latitude: job.latitude, longitude: job.longitude)
            let distance = seekerLocation.distance(from: jobLocation)
            return distance <= radiusInMeters
        }
    }

    // MARK: - TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredJobs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)
        let job = filteredJobs[indexPath.row]
        cell.textLabel?.text = job.title
        return cell
    }

    // MARK: - TableView Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedJob = filteredJobs[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "JobDetailViewController") as? JobDetailViewController {
            detailVC.job = selectedJob
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    // MARK: - Simple Alert Helper
    func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

