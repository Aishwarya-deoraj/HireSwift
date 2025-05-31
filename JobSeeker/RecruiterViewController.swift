import UIKit
import MapKit
import SwiftData
import CoreLocation

class RecruiterViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!

    var selectedCoordinate: CLLocationCoordinate2D?
    var locationManager = CLLocationManager()

    var modelContext: ModelContext!  // New SwiftData context

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup SwiftData context
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let container = appDelegate.container {
            modelContext = ModelContext(container)
        }

        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsUserLocation = true
        
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 8

        addTapGestureOnMap()
        printDatabasePath()

    }
    
    func printDatabasePath() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let container = appDelegate.container {
            if let url = container.configurations.first?.url {
                print("SwiftData database is stored at: \(url.path)")
            } else {
                print("Could not find SwiftData database URL.")
            }
        }
    }


    // MARK: - Location Manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }

        let region = MKCoordinateRegion(
            center: userLocation.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: true)

        locationManager.stopUpdatingLocation()
    }

    // MARK: - Map Tap Gesture
    func addTapGestureOnMap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc func mapTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let locationInView = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)

        selectedCoordinate = coordinate

        mapView.removeAnnotations(mapView.annotations)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)
    }

    // MARK: - Zoom Buttons
    @IBAction func zoomInTapped(_ sender: UIButton) {
        var region = mapView.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapView.setRegion(region, animated: true)
    }

    @IBAction func zoomOutTapped(_ sender: UIButton) {
        var region = mapView.region
        region.span.latitudeDelta *= 2.0
        region.span.longitudeDelta *= 2.0
        mapView.setRegion(region, animated: true)
    }

    // MARK: - Save Note
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "Please enter a title.")
            return
        }

        guard let coordinate = selectedCoordinate else {
            showAlert(message: "Please tap on the map to select a location.")
            return
        }

        let newNote = Note(
            title: title,
            desc: descriptionTextView.text ?? "",
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )

        modelContext.insert(newNote)

        do {
            try modelContext.save()
            showAlert(title: "Success", message: "Job listed successfully!")
            print("Note saved: \(coordinate.latitude), \(coordinate.longitude)")
        } catch {
            showAlert(message: "Failed to save note.")
            print("Save error: \(error)")
        }
    }

    
    // MARK: - Alerts
    func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

