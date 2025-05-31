import UIKit
import SwiftData

class MyApplicationsViewController: UITableViewController {

    var modelContext: ModelContext!
    var appliedJobs: [AppliedJob] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "My Applications"

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let container = appDelegate.container {
            modelContext = ModelContext(container)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchAppliedJobs()  
    }

    func fetchAppliedJobs() {
        do {
            let fetchDescriptor = FetchDescriptor<AppliedJob>()
            appliedJobs = try modelContext.fetch(fetchDescriptor)
            tableView.reloadData()
        } catch {
            print("Failed to fetch applied jobs: \(error)")
        }
    }

    // MARK: - TableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appliedJobs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AppliedJobCell", for: indexPath)
        let appliedJob = appliedJobs[indexPath.row]
        cell.textLabel?.text = appliedJob.title
        cell.detailTextLabel?.text = appliedJob.desc
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appliedJob = appliedJobs[indexPath.row]
        let alert = UIAlertController(
            title: appliedJob.title,
            message: "Description: \(appliedJob.desc)\nLocation: (\(appliedJob.latitude), \(appliedJob.longitude))",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

