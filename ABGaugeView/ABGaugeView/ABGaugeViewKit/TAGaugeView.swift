//
//  AppDelegate.swift
//  ABGaugeView
//
//  Created by Shubham Kaliyar on 06/02/21.
//
import Foundation
import UIKit

public class TAGaugeView: UIView {
    var unHighlitColor = "DCDCDC"
    var highlightCOlor = "FFA500"
    // MARK:- @IBInspectable
    var colorCodes: String = "DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC"
    var areas: String = "16,0.6,16,0.6,16,0.6,16,0.6,16,0.6,16"
    var arcAngle: CGFloat = 1.8
    var needleColor: UIColor = #colorLiteral(red: 1, green: 0.6470588235, blue: 0, alpha: 1)
    
    let triangleLayer = CAShapeLayer()
    let shadowLayer = CAShapeLayer()
    var needleValue: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
            self.updateColorAccordingNeedle(value: needleValue)
        }
    }
    
    func updateColorAccordingNeedle(value:CGFloat) {
        switch true {
        case 1...16 ~= value :
            self.colorCodes = "\(highlightCOlor),FFFFFF,DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC"
        case 17...32 ~= value :
            self.colorCodes = "\(unHighlitColor),FFFFFF,\(highlightCOlor),FFFFFF,DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC"
        case 33...48 ~= value :
            self.colorCodes = "\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(highlightCOlor),FFFFFF,DCDCDC,FFFFFF,DCDCDC,FFFFFF,DCDCDC"
        case 49...64 ~= value :
            self.colorCodes = "\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(highlightCOlor),FFFFFF,DCDCDC,FFFFFF,DCDCDC"
        case 65...80 ~= value :
            self.colorCodes = "\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(highlightCOlor),FFFFFF,DCDCDC"
        case 81...100 ~= value :
            self.colorCodes = "\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(highlightCOlor)"
        default:
            self.colorCodes = "\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor),FFFFFF,\(unHighlitColor)"
        }
        self.layoutIfNeeded()
        self.drawGauge()
    }
    
    var applyShadow: Bool = false {
        didSet {
            shadowColor = applyShadow ? shadowColor : UIColor.clear
        }
    }
    var isRoundCap: Bool = true {
        didSet {
            capStyle = isRoundCap ? .round : .butt
        }
    }
    var blinkAnimate: Bool = false
    var circleColor: UIColor = #colorLiteral(red: 1, green: 0.6470588235, blue: 0, alpha: 1)
    var shadowColor: UIColor = UIColor(hex: "DCDCDC")
    
    var firstAngle = CGFloat()
    var capStyle = CGLineCap.butt
    
    // MARK:- UIView Draw method
    override public func draw(_ rect: CGRect) {
        drawGauge()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        drawGauge()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawGauge()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        drawGauge()
    }
    
    // MARK:- Custom Methods
    func drawGauge() {
        layer.sublayers = []
        drawSmartArc()
        drawNeedle()
        drawNeedleCircle()
    }
    
    func drawSmartArc() {
        let angles = getAllAngles()
        let arcColors = colorCodes.components(separatedBy: ",")
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        var arcs = [ArcModel(startAngle: angles[0], endAngle: angles.last!, strokeColor: shadowColor, arcCap: capStyle,center:CGPoint(x: bounds.width / 2, y: (bounds.height / 2)))]
        for index in 0..<arcColors.count {
            let arc = ArcModel(startAngle: angles[index], endAngle: angles[index+1], strokeColor: UIColor(hex: arcColors[index]), arcCap: CGLineCap.butt, center: center)
            arcs.append(arc)
        }
        arcs.rearrange(from: arcs.count-1, to: 2)
        arcs[1].arcCap = self.capStyle
        arcs[2].arcCap = self.capStyle
        for i in 0..<arcs.count {
            createArcWith(startAngle: arcs[i].startAngle, endAngle: arcs[i].endAngle, arcCap: arcs[i].arcCap, strokeColor: arcs[i].strokeColor, center: arcs[i].center)
        }

    }

    func radian(for area: CGFloat) -> CGFloat {
        let degrees = arcAngle * area
        let radians = degrees * .pi/180
        return radians
    }
    
    func getAllAngles() -> [CGFloat] {
        var angles = [CGFloat]()
        firstAngle = radian(for: 0) + .pi/2
        var lastAngle = radian(for: 100) + .pi/2
        
        let degrees:CGFloat = 3.6 * 100
        let radians = degrees * .pi/(1.8*100)
        
        let thisRadians = (arcAngle * 100) * .pi/(1.8*100)
        let theD = (radians - thisRadians)/2
        firstAngle += theD
        lastAngle += theD
        
        angles.append(firstAngle)
        let allAngles = self.areas.components(separatedBy: ",")
        for index in 0..<allAngles.count {
            let n = NumberFormatter().number(from: allAngles[index])
            let angle = radian(for: CGFloat(truncating: n!)) + angles[index]
            angles.append(angle)
        }
        
        angles.append(lastAngle)
        return angles
    }
    
    func createArcWith(startAngle: CGFloat, endAngle: CGFloat, arcCap: CGLineCap, strokeColor: UIColor, center:CGPoint) {
        let center = center
        let radius: CGFloat = max(bounds.width, bounds.height)/2 - self.frame.width/20
        let lineWidth: CGFloat = self.frame.width/10
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = lineWidth
        path.lineCapStyle = arcCap
        strokeColor.setStroke()
        path.stroke()
    }
    
    func drawNeedleCircle() {
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2), radius: self.bounds.width/20, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = circleColor.cgColor
        layer.addSublayer(circleLayer)
    }
    
    func drawNeedle(isAnimate:Bool = true) {
        triangleLayer.frame = bounds
        shadowLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height)
        let needlePath = UIBezierPath()

//        needlePath.move(to: CGPoint(x: self.bounds.width/2, y: self.bounds.width * 0.82))
//        needlePath.addLine(to: CGPoint(x: self.bounds.width * 0.47, y: self.bounds.width * 0.47))
//        needlePath.addLine(to: CGPoint(x: self.bounds.width * 0.53, y: self.bounds.width * 0.47))
        
        
        needlePath.move(to: CGPoint(x: self.bounds.width/2, y: self.bounds.width * 0.82))
        needlePath.addLine(to: CGPoint(x: self.bounds.width * 0.460, y: self.bounds.width * 0.47))
        needlePath.addLine(to: CGPoint(x: self.bounds.width * 0.540, y: self.bounds.width * 0.47))
        
        needlePath.close()
        triangleLayer.path = needlePath.cgPath
        shadowLayer.path = needlePath.cgPath
        triangleLayer.fillColor = needleColor.cgColor
        triangleLayer.strokeColor = needleColor.cgColor
        shadowLayer.fillColor = shadowColor.cgColor
        layer.addSublayer(shadowLayer)
        layer.addSublayer(triangleLayer)
        self.changeNeedal()
    }
    
    func changeNeedal() {
        var firstAngle = radian(for: 0)
        let degrees:CGFloat = 3.6 * 100 // Entire Arc is of 240 degrees
        let radians = degrees * .pi/(1.8*100)
        let thisRadians = (arcAngle * 100) * .pi/(1.8*100)
        let theD = (radians - thisRadians)/2
        firstAngle += theD
        let needleValue = radian(for: self.needleValue) + firstAngle
        self.animate(triangleLayer: self.triangleLayer, shadowLayer: self.shadowLayer, fromValue: needleValue*0.95, toValue: needleValue, duration: 0.2, callBack: {})
    }
    
    func animate(triangleLayer: CAShapeLayer, shadowLayer:CAShapeLayer, fromValue: CGFloat, toValue:CGFloat, duration: CFTimeInterval, callBack:@escaping ()->Void) {
        CATransaction.begin()
        let spinAnimation1 = CABasicAnimation(keyPath: "transform.rotation.z")
        spinAnimation1.fromValue = fromValue//radian(for: fromValue)
        spinAnimation1.toValue = toValue//radian(for: toValue)
        spinAnimation1.duration = duration
        spinAnimation1.fillMode = CAMediaTimingFillMode.forwards
        spinAnimation1.isRemovedOnCompletion = false
        CATransaction.setCompletionBlock { callBack() }
        triangleLayer.add(spinAnimation1, forKey: "indeterminateAnimation")
        shadowLayer.add(spinAnimation1, forKey: "indeterminateAnimation")
        CATransaction.commit()
    }
}
