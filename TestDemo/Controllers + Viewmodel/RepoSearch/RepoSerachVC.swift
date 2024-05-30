import UIKit

class RepoSerachVC: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var repoTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Instance Variables
    let repoSearchViewModel = RepoSearchViewModel()
    var timer: Timer?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.isHidden = true
    }
}

// MARK: - UITableViewDataSource
extension RepoSerachVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repoSearchViewModel.repostitoriesItemData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = repoSearchViewModel.repostitoriesItemData[indexPath.row].full_name
        if let language = repoSearchViewModel.repostitoriesItemData[indexPath.row].language {
            cell.detailTextLabel?.text = language
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.repoSearchViewModel.repostitoriesItemData.count - 2 && self.repoSearchViewModel.reloadNext {
            getRepoData(loadPage: self.repoSearchViewModel.currentPage + 1)
        }
    }
}

// MARK: - UITableViewDelegate
extension RepoSerachVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let object = self.repoSearchViewModel.repostitoriesItemData[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let repoDetailVC = storyBoard.instantiateViewController(withIdentifier: "RepoDetailVC") as! RepoDetailVC
        repoDetailVC.selectedRepoData = object
        repoDetailVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(repoDetailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate & Helper Functions
extension RepoSerachVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.searchRepoData), userInfo: nil, repeats: false)
    }
    
    @objc func searchRepoData() {
        guard let query = self.searchBar.text else { return }
        if query.isEmpty {
            self.repoSearchViewModel.repostitoriesItemData.removeAll()
            self.repoTableView.reloadData()
            self.activityIndicator.stopAnimating()
            return
        }
        repoSearchViewModel.query = query
        self.repoSearchViewModel.currentPage = 1
        self.repoSearchViewModel.reloadNext = true
        self.repoSearchViewModel.repostitoriesItemData.removeAll()
        self.repoTableView.reloadData()
        self.activityIndicator.startAnimating()
        
        if Reachability.isConnectedToNetwork() {
            repoSearchViewModel.request(page: self.repoSearchViewModel.currentPage) { (result) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.repoTableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    print(error.localizedDescription)
                }
            }
        } else {
            self.repoSearchViewModel.loadDataFromLocalStorage()
            DispatchQueue.main.async {
                self.repoTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func getRepoData(loadPage: Int) {
        if self.repoSearchViewModel.reloadNext && self.searchBar.text != "" {
            self.repoSearchViewModel.request(page: loadPage) { (result) in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.repoTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

