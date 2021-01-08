//
//  MyWelcomeViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 11/11/20.
//

import UIKit

class MyWelcomeViewController: UIViewController, UIScrollViewDelegate {
    
 
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var buttonNext: UIButton!
    @IBOutlet var buttonPrev: UIButton!
    @IBOutlet var buttonGetStarted: UIButton!
    @IBOutlet var buttonPreviousPage: UIButton!
    
    
    //table holding the images shown in the onboard.
    var images: [String] = ["0", "1", "2"]
    var frame = CGRect(x:0, y:0, width:0, height:0)
    
   

    @IBAction func buttonNextPressed(_ sender: Any) {
        
        pageControl.currentPage = (pageControl.currentPage) + 1
        self.scrollToPage(page: pageControl.currentPage, animated: true)
        
        defineHide(pageNumber: pageControl.currentPage)
    }
    
    @IBAction func buttonPrevPressed(_ sender: Any) {
        
        pageControl.currentPage = (pageControl.currentPage) - 1
        self.scrollToPage(page: pageControl.currentPage, animated: true)
        
        defineHide(pageNumber: pageControl.currentPage)
        
        
        
         
    }
    

    // Button at the end of the onboard.
    @IBAction func buttonGetStartedPressed(_ sender: Any) {
        Core.shared.setIsNotNewUser()
        dismiss(animated: true, completion: nil)
        return
    }
    
    // Button shown only at the last page.
    @IBAction func previousPageButtonPressed(_ sender: Any) {
        buttonPrevPressed(self)
    }
    
    // Decides when "PREV" and "NEXT" buttons can be shown.
    func defineHide(pageNumber: Int){
        
        if pageNumber == 0{
            buttonPrev.isHidden = true
            buttonNext.isHidden = false
            buttonGetStarted.isHidden = true
            pageControl.isHidden = false
            buttonPreviousPage.isHidden = true
        }
        else if pageNumber == 2{
            buttonPrev.isHidden = true
            buttonNext.isHidden = true
            buttonGetStarted.isHidden = false
            pageControl.isHidden = true
            buttonPreviousPage.isHidden = false
        }
        else{
            buttonPrev.isHidden = false
            buttonNext.isHidden = false
            buttonGetStarted.isHidden = true
            pageControl.isHidden = false
            buttonPreviousPage.isHidden = true
        }
    }
  
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: animated)
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for index in 0..<images.count{
            frame.origin.x = scrollView.frame.size.width * CGFloat(index) // * number of images
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
            
         
            
        }
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
        
        defineHide(pageNumber: pageControl.currentPage)
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Scrolling Method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
        defineHide(pageNumber: pageControl.currentPage)
    }
    

    
    
    
}
