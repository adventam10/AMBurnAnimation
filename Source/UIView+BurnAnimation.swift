//
//  UIView+BurnAnimation.swift
//  BurnAnimation
//
//  Created by am10 on 2018/07/08.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

public extension UIView {
    func burnAnimation(duration: TimeInterval,
                       completion: (() -> Void)? = nil) {
        let baseView = makeBaseView()
        let imageView = makeImageview(baseView: baseView)
        baseView.addSubview(imageView)
        
        let gradientLayer = makeGradientLayer(baseView: baseView)
        baseView.layer.addSublayer(gradientLayer)
        
        let emitterLayer = makeEmitterLayer(baseView: baseView)
        baseView.layer.addSublayer(emitterLayer)
        
        let startPoint = CGPoint(x: baseView.frame.size.width/2,
                                 y: baseView.frame.size.height)
        let endPoint = CGPoint(x: baseView.frame.size.width/2,
                               y: 0)
        
        emitterLayer.emitterPosition = startPoint
        gradientLayer.position = CGPoint(x: startPoint.x, y: startPoint.y - 5)
        
        superview?.addSubview(baseView)
        
        let animationE = makeEmitterLayerAnimation(duration: duration,
                                                   startPoint: startPoint,
                                                   endPoint: endPoint)
        let animationG = makeGradientLayerAnimation(duration: duration,
                                                    startPoint: startPoint,
                                                    endPoint: endPoint)
        emitterLayer.add(animationE, forKey: nil)
        gradientLayer.add(animationG, forKey: nil)
        
        var frame = baseView.frame
        var imageViewFrame = imageView.frame
        frame.size.height = 0
        imageViewFrame.size.height = 0
        self.isHidden = true
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations:{
                        imageView.frame = imageViewFrame
        },
                       completion:nil)
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .curveEaseOut,
                       animations:{
                        baseView.frame = frame
        },
                       completion: { [weak self] (finished: Bool) in
                        baseView.removeFromSuperview()
                        self?.isHidden = false
                        completion?()
        })
    }
    
    // MARK: - Animation
    private func makeGradientLayerAnimation(duration: TimeInterval,
                                            startPoint: CGPoint,
                                            endPoint: CGPoint) -> CABasicAnimation {
        let sPoint = CGPoint(x: startPoint.x, y: startPoint.y - 5)
        let ePoint = CGPoint(x: endPoint.x, y: endPoint.y - 5)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fromValue = NSValue(cgPoint: sPoint)
        animation.toValue = NSValue(cgPoint: ePoint)
        return animation
    }
    
    private func makeEmitterLayerAnimation(duration: TimeInterval,
                                           startPoint: CGPoint,
                                           endPoint: CGPoint) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "emitterPosition")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.fromValue = NSValue(cgPoint: startPoint)
        animation.toValue = NSValue(cgPoint: endPoint)
        return animation
    }
    
    // MARK: - EmitterLayer
    private func makeEmitterLayer(baseView: UIView) -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        let size = baseView.bounds.size
        emitterLayer.emitterPosition = CGPoint(x: size.width/2, y: size.height/2)
        emitterLayer.renderMode = CAEmitterLayerRenderMode.additive
        emitterLayer.emitterShape = CAEmitterLayerEmitterShape.line
        emitterLayer.emitterSize = CGSize(width: baseView.frame.size.width + 10, height: 10)
        
        let fireColor = UIColor(red: 0.89, green: 0.56, blue: 0.36, alpha: 0.5)
        let smokeColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        emitterLayer.emitterCells = [makeEmitterCell(imageName: "amb_particle.png", color: fireColor),
                                     makeEmitterCell(imageName: "amb_particle1.png", color: fireColor),
                                     makeSmokeEmitterCell(imageName: "amb_particle2.png", color: smokeColor)]
        return emitterLayer
    }
    
    private func makeEmitterCell(imageName: String,
                                 color: UIColor) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        class dummyClass {}
        let bundle = Bundle(for: type(of: dummyClass()))
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        emitterCell.contents = image?.cgImage
        emitterCell.emissionLongitude = CGFloat(Double.pi*2)
        emitterCell.emissionRange = CGFloat(Double.pi)
        emitterCell.birthRate = 500
        emitterCell.lifetimeRange = 1.2
        emitterCell.velocity = 230
        emitterCell.color = color.cgColor
        return emitterCell
    }
    
    private func makeSmokeEmitterCell(imageName: String,
                                      color: UIColor) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        class dummyClass {}
        let bundle = Bundle(for: type(of: dummyClass()))
        let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        emitterCell.contents = image?.cgImage
        emitterCell.emissionLongitude = CGFloat(Double.pi*2)
        emitterCell.emissionRange = 0
        emitterCell.birthRate = 50
        emitterCell.lifetimeRange = 1.0
        emitterCell.velocity = 200
        emitterCell.color = color.cgColor
        return emitterCell
    }
    
    // MARK: - GradientLayer
    private func makeGradientLayer(baseView: UIView) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.opacity = 0.5
        var layerFrame = baseView.frame
        layerFrame.size.height = 10
        layerFrame.origin.y = layerFrame.origin.y + baseView.frame.size.height - layerFrame.size.height
        gradientLayer.frame = layerFrame
        return gradientLayer
    }
    
    // MARK: - View
    private func makeBaseView() -> UIView {
        let baseView = UIView(frame: self.frame)
        return baseView
    }
    
    private func makeImageview(baseView: UIView) -> UIImageView {
        let imageView = UIImageView(frame: baseView.bounds)
        imageView.image = screenCapture()
        imageView.contentMode = .top
        imageView.layer.masksToBounds = true
        return imageView
    }
    
    private func screenCapture() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
