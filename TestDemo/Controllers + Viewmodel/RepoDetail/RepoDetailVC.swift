import UIKit

class RepoDetailVC: UIViewController {
    
    // MARK: - @IBOutlet's
    @IBOutlet weak var repoImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var repoContributerLabel: UILabel!
    @IBOutlet weak var repoProjectLabel: UILabel!
    
    // MARK: - Instance Variable
    var selectedRepoData: Items?
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIData()
        self.repoContributerLabel.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnContributer(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.repoContributerLabel.addGestureRecognizer(tapgesture)
        
        self.repoProjectLabel.isUserInteractionEnabled = true
        let tapgesture1 = UITapGestureRecognizer(target: self, action: #selector(tappedOnProjects(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.repoProjectLabel.addGestureRecognizer(tapgesture1)
    }
    
    // MARK: - Private Functions
    func setupUIData() {
        repoNameLabel.text = selectedRepoData?.name ?? "N/A"
        repoDescriptionLabel.text = selectedRepoData?.description ?? "N/A"
        repoContributerLabel.text = selectedRepoData?.contributors_url ?? "N/A"
        repoProjectLabel.text = selectedRepoData?.contents_url ??  "N/A"
    }
    
    // MARK: - Objc Helper Functions
    @objc func tappedOnContributer(_ gesture: UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let repoDetailVC = storyBoard.instantiateViewController(withIdentifier: "ProjectDetailVC") as! ProjectDetailVC
        repoDetailVC.navigationTitle = "Contibuters"
        repoDetailVC.receivedURL = selectedRepoData?.contributors_url ?? ""
        repoDetailVC.modalPresentationStyle = .automatic
        self.navigationController?.pushViewController(repoDetailVC, animated: true)
    }
    
    @objc func tappedOnProjects(_ gesture: UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let repoDetailVC = storyBoard.instantiateViewController(withIdentifier: "ProjectDetailVC") as! ProjectDetailVC
        repoDetailVC.navigationTitle = "Projects"
        repoDetailVC.receivedURL = selectedRepoData?.comments_url ?? ""
        repoDetailVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(repoDetailVC, animated: true)
    }
}
