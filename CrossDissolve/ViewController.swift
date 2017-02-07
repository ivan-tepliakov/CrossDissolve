//
//  ViewController.swift
//  CrossDissolve
//
//  Created by Iwan Teplyakov on 2/6/17.
//  Copyright © 2017 Iwan Teplyakov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let transition = UIPercentDrivenInteractiveTransition()

    @IBAction func screenEdgePan(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        let percentComplete = abs(translation.x / view.bounds.width)
        
        switch gestureRecognizer.state {
        case .began:
            performSegue(withIdentifier: "test", sender: self)
        case .changed:
            transition.update(percentComplete)
        default:
            if percentComplete > 0.5 {
                transition.finish()
            } else {
                transition.cancel()
            }
        }
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGradient(with: [.red, .green])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        segue.destination.transitioningDelegate = self
        segue.destination.view.addGradient(with: [.blue, .yellow])
    }
    
}

// MARK: UIViewControllerAnimatedTransitioning

extension ViewController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        func fadeIn() {
            toView.alpha = 1
        }
        
        func fadeOut() {
            toView.alpha = 0
        }
        
        fadeOut()
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: duration, animations: fadeIn) { (finished) in
            let didComplete = !transitionContext.transitionWasCancelled
            transitionContext.completeTransition(didComplete)
            
            //  http://openradar.appspot.com/radar?id=5320103646199808
            let view = didComplete ? toView : fromView
            UIApplication.shared.keyWindow?.addSubview(view)
        }
    }
 
}

// MARK: UIViewControllerTransitioningDelegate

extension ViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transition
    }
    
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return transition
    }
    
}

// MARK: UIView

extension UIView {
    
    func addGradient(with colors: [UIColor]) {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
}
