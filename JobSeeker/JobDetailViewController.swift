import UIKit
import MapKit
import SwiftData

class JobDetailViewController: UIViewController {

    var job: Note?
    var modelContext: ModelContext!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var applyButton: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true

        // Setup SwiftData context
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let container = appDelegate.container {
            modelContext = ModelContext(container)
        }

        if let job = job {
            titleLabel.text = job.title
            descriptionLabel.text = job.desc
            setupMap(for: job)
        }
        
        printDatabasePath()
    }

    func setupMap(for job: Note) {
        let coordinate = CLLocationCoordinate2D(latitude: job.latitude, longitude: job.longitude)

        let region = MKCoordinateRegion(center: coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = job.title
        mapView.addAnnotation(annotation)
    }

    @IBAction func applyButtonTapped(_ sender: UIButton) {
        guard let job = job else {
            showAlert(title: "Error", message: "No job selected.")
            return
        }

        let appliedJob = AppliedJob(
            title: job.title,
            desc: job.desc,
            latitude: job.latitude,
            longitude: job.longitude
        )

        modelContext.insert(appliedJob)

        do {
            try modelContext.save()
            showAlert(title: "Success", message: "You have successfully applied for the job!")
            applyButton.isEnabled = false
            applyButton.setTitle("Apply", for: .normal)
            print("Applied Job Saved: \(job.title)")
        } catch {
            showAlert(message: "Failed to save applied job.")
            print("Apply save error: \(error)")
        }
    }


    func showAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
}

