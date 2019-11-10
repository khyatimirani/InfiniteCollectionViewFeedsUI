//
//  ViewController.swift
//  TaskForLivQuik
//
//  Created by Khyati Mirani on 06/11/19.
//  Copyright © 2019 Khyati Mirani. All rights reserved.
//

import UIKit

let cellId = "cellId"


class LivQuikFeedsController: UICollectionViewController {
    
    var posts = [Post]()
    var isFetchRequired = false
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
   
    func initialSetUp() {
        setUpFeedsData()
        navigationItem.title = "Khyati's Feed"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.titleView?.backgroundColor = UIColor.systemBackground
        collectionView?.alwaysBounceVertical = true
        collectionView.overrideUserInterfaceStyle = .dark
        collectionView?.backgroundColor = UIColor.systemBackground
        //register the cell with the collectionView
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
}


extension LivQuikFeedsController: UICollectionViewDelegateFlowLayout {
    
    // return number of sections in collectinView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        feedCell.post = posts[indexPath.row]
        return feedCell
    }
    //set the size of the collectionView cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let statusText = posts[indexPath.item].statusText {
            
            let rect = NSString(string: statusText).boundingRect(with:CGSize.init(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            //padding + profileImage + paddingTwice + ImageView + padding + likeCommentsLabel + dividerLine
            return CGSize.init(width: view.frame.width, height: rect.height + knownHeight + 24)
            
        }
        
        return CGSize(width: view.frame.width, height: 300)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}


// Infinite ScrollView Logic
extension LivQuikFeedsController {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    // pagination 
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height {
            if !isFetchRequired  {
              refetchItems()
            }
        }
    }
    
    func refetchItems() {
        isFetchRequired = true
        print("batch fetch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            let newItems = self.posts
            for eachItem in newItems {
                self.posts.append(eachItem)
            }
            self.isFetchRequired = false
            self.collectionView.reloadData()
        })
    }
    
    func setUpFeedsData() {
        let postDoggy = Post()
        postDoggy.name = "Khyati Mirani"
        postDoggy.statusText = "Hieeeee happy Hooman!🐶🐾"
        postDoggy.profileImageName = "profile_picture"
        postDoggy.statusImageName = "beast_darkside"
        postDoggy.numLikes = 500
        postDoggy.numComments = 5
        
        let postTraveller = Post()
        postTraveller.name = "psychotraveller"
        postTraveller.statusText = "Every time I stand before a beautiful beach, its waves seem to whisper to me: If you choose the simple things and find joy in nature's simple treasures, life and living need not be so hard.🏖 ⛅️"
        postTraveller.profileImageName = "traveller"
        postTraveller.statusImageName = "beach_post"
        postTraveller.numLikes = 369
        postTraveller.numComments = 500
        
        let postKerela = Post()
        postKerela.name = "Kerela Tourisum"
        postKerela.statusText = "Gods own country 🌈🌴✨"
        postKerela.profileImageName = "logo"
        postKerela.statusImageName = "munnar"
        postKerela.numLikes = 500
        postKerela.numComments = 223
        
        let postPruple = Post()
        postPruple.name = "The Purple Beauty"
        postPruple.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\nThe weak can never forgive. Forgiveness is the attribute of the strong.\nHappiness is when what you think, what you say, and what you do are in harmony.💜💜💜"
        postPruple.statusImageName = "purple_garden"
        postPruple.profileImageName = "purple"
        postPruple.numLikes = 333
        postPruple.numComments = 444
        posts.append(postKerela)
        posts.append(postPruple)
        posts.append(postDoggy)
        posts.append(postTraveller)
    }
    
}
