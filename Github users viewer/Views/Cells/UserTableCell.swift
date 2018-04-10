//
//  UserTableCell.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/10/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import Kingfisher
import Alamofire

class UserTableCell: UITableViewCell, TableObjectCellProtocol {
    
    let padding: CGFloat = 16
    
    var userImageView: UIImageView!
    var loginLabel: UILabel!
    var profileLinkLabel: UILabel!
    
    var user: User?
    var disposable: Disposable?
    var updateDisposable: Disposable?
    
    static func heightFor(object: AnyObject, atIndexPath: IndexPath, tableView: UITableView) -> CGFloat {
        return 120.0
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        selectionStyle = .none
        
        userImageView = UIImageView(frame: CGRect.zero)
        userImageView.image = UIImage(named: "emptyImagePlaceholder")
        contentView.addSubview(userImageView)
        
        loginLabel = UILabel(frame: CGRect.zero)
        contentView.addSubview(loginLabel)
        
        profileLinkLabel = UILabel(frame: CGRect.zero)
        contentView.addSubview(profileLinkLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func updateCellWithObject(object: User) {
        self.user = object

        if let photoUrl = object.avatarUrl, let url = URL(string: photoUrl) {
            userImageView?.kf.setImage(with: url, placeholder: UIImage(named: "emptyImagePlaceholder"), options: [.transition(.fade(0.2))])
        }
        
        loginLabel.text = object.login ?? ""
        
        profileLinkLabel.text = object.htmlUrl ?? ""
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposable?.dispose()
        user = nil
        userImageView.kf.cancelDownloadTask()
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.size = CGSize(width: 100, height: 100)
        userImageView.left = padding
        userImageView.top = ceil(height / 2 - userImageView.height / 2)
        
        loginLabel.sizeToFit()
        loginLabel.width = width - userImageView.right
        loginLabel.left = userImageView.right + padding
        loginLabel.top = userImageView.top + 3
        
        profileLinkLabel.sizeToFit()
        profileLinkLabel.left = userImageView.right + padding
        profileLinkLabel.top = loginLabel.bottom + 4
        profileLinkLabel.width = width - (userImageView.width + 3 * padding)

    }
    
}
