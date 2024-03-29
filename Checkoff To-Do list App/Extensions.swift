//
//  Extensions.swift
//  Checkoff To-Do list App
//
//  Created by Gabe Hargett on 5/10/22.
//

import UIKit

struct User {
    var id: String
    var fullName: FullName
    var dateJoined: Double
    var imageRef: String?
    var emoji: String?
}

struct FullName {
    var firstName: String
    var lastName: String
    
    func firstAndLastName() -> String {
        var string = ""
        string.append(firstName)
        string.append(" ")
        string.append(lastName)
        string.append("'s")
        return string
    }
    
    func firstAndLastInitial() -> String {
        var string = ""
        string.append(firstName + " ")
        if let lastFirst = lastName.first {
            string.append(lastFirst)
            string.append(".")
        }
        return string
    }
}

class NameCache {
    static let shared = NameCache()
    var nameDictionary: [String: FullName] = [:]
    func insertName(uid: String, name: FullName) {
        nameDictionary[uid] = name
    }
    func getName(uid: String) -> FullName? {
        return nameDictionary[uid]
    }
}

class GroupManager {
    static var shared = GroupManager()
    
    func getCurrentGroupID() -> String? {
        return UserDefaults.standard.string(forKey: "CurrentGroupID")
    }
    func setCurrentGroupID(groupID: String) {
        UserDefaults.standard.set(groupID, forKey: "CurrentGroupID")
    }
    func clearGroupID() {
        UserDefaults.standard.set(nil, forKey: "CurrentGroupID")
    }
}

class DateAnalyzer {
    static func getWeekAndYearFromDate(date: Date) -> WeekAndYear? {
        let allComponents = Calendar.current.dateComponents([.year, .weekOfYear], from: date)
        guard let weekOfYear = allComponents.weekOfYear,
              let year = allComponents.year else {
            return nil
        }
        return WeekAndYear(week: weekOfYear, year: year)
    }
}

extension Date {
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd YY"
        return dateFormatter.string(from: self)
    }
}
//func getComponetsOfDates() {
//    let components = date.get(.day, .month, .year)
//    if let day = components.day, let month = components.month, let year = components.year {
//        print("day: \(day), month: \(month), year: \(year)")
//    }
//}

extension String {
    func textToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 1024) // you can change your font size here
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0) //  begin image context
        UIColor.clear.set() // clear background
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize)) // set rect size
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes) // draw text within rect
        let image = UIGraphicsGetImageFromCurrentImageContext() // create image from context
        UIGraphicsEndImageContext() //  end image context

        return image ?? UIImage()
    }
}
extension String {

    var underLined: NSAttributedString {
        NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension UIView {
    
    func addShadow(shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
    }
    
    func addBorders(color: UIColor, thickness: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = thickness
    }
    
    func cornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func centerInSuperview() {
        guard let superview = self.superview else { return }
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
    }
    
    func height(constant: CGFloat) {
        setConstraint(value: constant, attribute: .height)
    }
    
    func width(constant: CGFloat) {
        setConstraint(value: constant, attribute: .width)
    }
    
    private func removeConstraint(attribute: NSLayoutConstraint.Attribute) {
        constraints.forEach {
            if $0.firstAttribute == attribute {
                removeConstraint($0)
            }
        }
    }
    
    private func setConstraint(value: CGFloat, attribute: NSLayoutConstraint.Attribute) {
        removeConstraint(attribute: attribute)
        let constraint =
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: value)
        self.addConstraint(constraint)
    }
    
    public func fillSuperview() {
        guard let superview = self.superview else { return }
        activate(
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        )
    }
    
    @discardableResult
    public func fillSuperviewLayoutMargins() -> (left: NSLayoutConstraint, right: NSLayoutConstraint, top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        guard let superview = self.superview else {
            fatalError("\(self) has not been added as a subview")
        }
        let left = leftAnchor.constraint(equalTo: superview.leftMargin)
        let right = rightAnchor.constraint(equalTo: superview.rightMargin)
        let top = topAnchor.constraint(equalTo: superview.topMargin)
        let bottom = bottomAnchor.constraint(equalTo: superview.bottomMargin)
        activate(left, right, top, bottom)
        return (left, right, top, bottom)
    }
    
    @discardableResult
    public func fillSuperviewMargins() -> (left: NSLayoutConstraint, right: NSLayoutConstraint, top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        guard let superview = self.superview else {
            fatalError("\(self) has not been added as a subview")
        }
        let left = leftAnchor.constraint(equalTo: superview.leftAnchor, constant: superview.layoutMargins.left)
        let right = rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -superview.layoutMargins.right)
        let top = topAnchor.constraint(equalTo: superview.topAnchor, constant: superview.layoutMargins.top)
        let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -superview.layoutMargins.bottom)
        activate(left, right, top, bottom)
        return (left, right, top, bottom)
    }
    
    public func activate(_ constraints: NSLayoutConstraint...) {
        NSLayoutConstraint.activate(constraints)
    }
    
    func addAutoLayoutSubview(_ subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private var leftMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.leftAnchor
    }
    
    private var leadingMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.leadingAnchor
    }
    
    private var rightMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.rightAnchor
    }
    
    private var trailingMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.trailingAnchor
    }
    
    private var centerXMargin: NSLayoutXAxisAnchor {
        return layoutMarginsGuide.centerXAnchor
    }
    
    private var widthMargin: NSLayoutDimension {
        return layoutMarginsGuide.widthAnchor
    }
    
    private var topMargin: NSLayoutYAxisAnchor {
        return layoutMarginsGuide.topAnchor
    }
    
    private var bottomMargin: NSLayoutYAxisAnchor {
        return layoutMarginsGuide.bottomAnchor
    }
    
    private var centerYMargin: NSLayoutYAxisAnchor {
        return layoutMarginsGuide.centerYAnchor
    }
    
    private var heightMargin: NSLayoutDimension {
        return layoutMarginsGuide.heightAnchor
    }
    
    func makeToast(view: UIView, duration: Double) {
        self.addSubview(view)
        UIView.animate(withDuration: 0.6, delay: duration, options: .curveEaseOut, animations: {
             view.alpha = 0.0
        }, completion: {(isCompleted) in
            view.removeFromSuperview()
        })
    }
}

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach(addArrangedSubview)
    }
}

extension UILabel {
    func quickConfigure(textAlignment: NSTextAlignment, font: UIFont, textColor: UIColor, numberOfLines: Int = 1) {
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}
