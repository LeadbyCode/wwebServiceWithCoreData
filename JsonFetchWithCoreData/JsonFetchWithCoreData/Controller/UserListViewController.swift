//
//  ViewController.swift
//  JsonFetchWithCoreData
//
//  Created by Nilesh Vernekar on 07/09/21.
//

import UIKit

class UserListViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var userList:  [UserDataModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
//        initialSetUp()
        loaddata()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialSetUp()
//        self.navigationController?.navigationBar.isHidden = true
    }
    fileprivate func initialSetUp() {
        self.tableview.delegate = self
        self.tableview.dataSource = self
        tableview.register(UINib(nibName: PhoneListTableViewCell.xibName, bundle: nil), forCellReuseIdentifier: PhoneListTableViewCell.cellIdentifier)
    }

}
extension UserListViewController: UITableViewDelegate,UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhoneListTableViewCell.cellIdentifier, for: indexPath) as! PhoneListTableViewCell
        cell.cellData(data: userList?[indexPath.row] ?? UserDataModel())
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        if let viewControl = storyBoard.instantiateViewController(withIdentifier: "UserDetailViewController") as? UserDetailViewController {
            viewControl.userDetail = userList?[indexPath.row]
//            self.present(viewControl, animated: true, completion: nil)
            self.navigationController?.pushViewController(viewControl, animated: true)
        }
    }

    func loaddata() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        URLSession.shared.fetchData(for: url) { (result: Result<[UserDataModel], Error>) in
            switch result {
            case .success(let user):
                // A list of todos!
                DispatchQueue.main.async {
                    self.userList = user
                    let model = UserDic()
                    model.userarray = user
                    self.saveNotes(model: model)
                    self.tableview.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.fetchNotes()
                }
                break
            // A failure, please handle
            }
        }
    }
}

extension UserListViewController {
    fileprivate func saveNotes(model: UserDic) {
          
          let userDBDataSource = UsersDB(modelName: ConstantsStrings.xcdatamodeld, entityName: ConstantsStrings.modelEntity)
          
        userDBDataSource.createnote(ListModel: model)
      }
    
    fileprivate func fetchNotes() {
          let noteDBDataSource = UsersDB(modelName: ConstantsStrings.xcdatamodeld, entityName: ConstantsStrings.modelEntity)
          
          if let user: UserDic = noteDBDataSource.readNotesFromCache() {
              
            userList = user.userarray
            self.tableview.reloadData()
          }
      }
}


