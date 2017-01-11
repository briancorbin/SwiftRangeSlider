/* **
RappleColorPicker.swift
Custom Activity Indicator with swift 2.0

Created by Rajeev Prasad on 28/11/15.

The MIT License (MIT)

Copyright (c) 2015 Rajeev Prasad <rjeprasad@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
** */

import UIKit

class RappleColorPickerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    fileprivate var collectionView : UICollectionView!
    fileprivate var titleLabel : UILabel!
    
    var delegate: RappleColorPickerDelegate?
    var tag: Int = 1
    var attributes : [RappleCPAttributeKey : AnyObject] = [
        .Title : "Color Picker" as AnyObject,
        .BGColor  : UIColor.black,
        .TintColor : UIColor.white,
        .Style  : RappleCPStyleCircle as AnyObject
    ]
    
    fileprivate var colorDic = [Int: [UIColor]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAllColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = attributes[RappleCPAttributeKey.BGColor] as? UIColor
        
        self.view.layer.cornerRadius = 4.0
        self.view.layer.borderWidth = 2.0
        self.view.layer.borderColor = UIColor.darkGray.cgColor
        self.view.layer.masksToBounds = true
        
        let layout = RappleColorPickerFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 30, height: 30)
        
        let colRect = CGRect(x: 2, y: 30, width: view.frame.width, height: view.frame.height - 30)
        collectionView = UICollectionView(frame: colRect, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        collectionView.reloadData()
        
        titleLabel = UILabel(frame: CGRect(x: 2,y: 2,width: view.frame.width-4,height: 28))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = attributes[RappleCPAttributeKey.TintColor] as? UIColor
        titleLabel.text = attributes[RappleCPAttributeKey.Title] as? String
        self.view.addSubview(titleLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return colorDic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (colorDic[section]?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = getColor(indexPath.section, row: indexPath.row)
        if attributes[RappleCPAttributeKey.Style] as? String == RappleCPStyleCircle {
            cell.layer.cornerRadius = 15.0
        } else {
            cell.layer.cornerRadius = 1.0
        }
        cell.layer.borderColor = (attributes[RappleCPAttributeKey.TintColor] as? UIColor)?.cgColor
        cell.layer.borderWidth = 1.0
        return cell
    }
    
    func getColor(_ section:Int, row:Int) -> UIColor {
        return colorDic[section]![row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate?.responds(to: "colorSelected:") == true {
            delegate?.colorSelected?(getColor(indexPath.section, row: indexPath.row))
        }
        
        if delegate?.responds(to: "colorSelected:tag:") == true {
            delegate?.colorSelected?(getColor(indexPath.section, row: indexPath.row), tag: tag)
        }
    }
}

class RappleColorPickerFlowLayout : UICollectionViewFlowLayout {
    
    let cellSpacing:CGFloat = 1
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElements(in: rect) {
            for (index, attribute) in attributes.enumerated() {
                if index == 0 { continue }
                let prevLayoutAttributes = attributes[index - 1]
                let origin = prevLayoutAttributes.frame.maxX
                if(origin + cellSpacing + attribute.frame.size.width < self.collectionViewContentSize.width) {
                    attribute.frame.origin.x = origin + cellSpacing
                }
            }
            return attributes
        }
        return nil
    }
}


extension RappleColorPickerViewController {
    
    fileprivate func setAllColor(){
        colorDic[0] = [
            UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.886274509803922, green: 0.886274509803922, blue: 0.886274509803922, alpha: 1.0),
            UIColor(red: 0.666666666666667, green: 0.666666666666667, blue: 0.666666666666667, alpha: 1.0),
            UIColor(red: 0.43921568627451, green: 0.43921568627451, blue: 0.43921568627451, alpha: 1.0),
            UIColor(red: 0.219607843137255, green: 0.219607843137255, blue: 0.219607843137255, alpha: 1.0),
            UIColor(red: 0.109803921568627, green: 0.109803921568627, blue: 0.109803921568627, alpha: 1.0),
            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        ]
        
        
        
        colorDic[1] = [
            UIColor(red: 0.847058823529412, green: 1.0, blue: 0.972549019607843, alpha: 1.0),
            UIColor(red: 0.568627450980392, green: 1.0, blue: 0.925490196078431, alpha: 1.0),
            UIColor(red: 0.0, green: 1.0, blue: 0.831372549019608, alpha: 1.0),
            UIColor(red: 0.0, green: 0.717647058823529, blue: 0.6, alpha: 1.0),
            UIColor(red: 0.0, green: 0.458823529411765, blue: 0.380392156862745, alpha: 1.0),
            UIColor(red: 0.0, green: 0.329411764705882, blue: 0.274509803921569, alpha: 1.0),
            UIColor(red: 0.0, green: 0.2, blue: 0.164705882352941, alpha: 1.0)
        ]
        
        
        
        colorDic[2] = [
            UIColor(red: 0.847058823529412, green: 1.0, blue: 0.847058823529412, alpha: 1.0),
            UIColor(red: 0.63921568627451, green: 1.0, blue: 0.63921568627451, alpha: 1.0),
            UIColor(red: 0.219607843137255, green: 1.0, blue: 0.219607843137255, alpha: 1.0),
            UIColor(red: 0.0, green: 0.83921568627451, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.517647058823529, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.356862745098039, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.2, blue: 0.0, alpha: 1.0)
        ]
        
        
        
        colorDic[3] = [
            UIColor(red: 1.0, green: 1.0, blue: 0.847058823529412, alpha: 1.0),
            UIColor(red: 1.0, green: 1.0, blue: 0.568627450980392, alpha: 1.0),
            UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.717647058823529, green: 0.717647058823529, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.458823529411765, green: 0.458823529411765, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.329411764705882, green: 0.329411764705882, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.2, green: 0.2, blue: 0.0, alpha: 1.0)
        ]
        
        
        
        colorDic[4] = [
            UIColor(red: 1.0, green: 0.92156862745098, blue: 0.847058823529412, alpha: 1.0),
            UIColor(red: 1.0, green: 0.83921568627451, blue: 0.67843137254902, alpha: 1.0),
            UIColor(red: 1.0, green: 0.666666666666667, blue: 0.337254901960784, alpha: 1.0),
            UIColor(red: 1.0, green: 0.498039215686275, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.627450980392157, green: 0.313725490196078, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.43921568627451, green: 0.219607843137255, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.247058823529412, green: 0.12156862745098, blue: 0.0, alpha: 1.0)
        ]
        
        
        
        colorDic[5] = [
            UIColor(red: 1.0, green: 0.886274509803922, blue: 0.847058823529412, alpha: 1.0),
            UIColor(red: 1.0, green: 0.756862745098039, blue: 0.67843137254902, alpha: 1.0),
            UIColor(red: 1.0, green: 0.501960784313725, blue: 0.337254901960784, alpha: 1.0),
            UIColor(red: 1.0, green: 0.247058823529412, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.658823529411765, green: 0.164705882352941, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.47843137254902, green: 0.117647058823529, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.298039215686275, green: 0.0745098039215686, blue: 0.0, alpha: 1.0)
        ]
        
        
        
        colorDic[6] = [
            UIColor(red: 1.0, green: 0.847058823529412, blue: 0.847058823529412, alpha: 1.0),
            UIColor(red: 1.0, green: 0.67843137254902, blue: 0.67843137254902, alpha: 1.0),
            UIColor(red: 1.0, green: 0.337254901960784, blue: 0.337254901960784, alpha: 1.0),
            UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.627450980392157, green: 0.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.43921568627451, green: 0.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 0.247058823529412, green: 0.0, blue: 0.0, alpha: 1.0)
        ]
        
        
        
        colorDic[7] = [
            UIColor(red: 1.0, green: 0.847058823529412, blue: 1.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.63921568627451, blue: 1.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.219607843137255, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.83921568627451, green: 0.0, blue: 0.83921568627451, alpha: 1.0),
            UIColor(red: 0.517647058823529, green: 0.0, blue: 0.517647058823529, alpha: 1.0),
            UIColor(red: 0.356862745098039, green: 0.0, blue: 0.356862745098039, alpha: 1.0),
            UIColor(red: 0.2, green: 0.0, blue: 0.2, alpha: 1.0)
        ]
        
        
        
        colorDic[8] = [
            UIColor(red: 0.92156862745098, green: 0.847058823529412, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.83921568627451, green: 0.67843137254902, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.666666666666667, green: 0.337254901960784, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.498039215686275, green: 0.0, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.298039215686275, green: 0.0, blue: 0.6, alpha: 1.0),
            UIColor(red: 0.2, green: 0.0, blue: 0.4, alpha: 1.0),
            UIColor(red: 0.0980392156862745, green: 0.0, blue: 0.2, alpha: 1.0)
        ]
        
        
        
        colorDic[9] = [
            UIColor(red: 0.847058823529412, green: 0.847058823529412, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.67843137254902, green: 0.67843137254902, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.337254901960784, green: 0.337254901960784, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.0, blue: 0.627450980392157, alpha: 1.0),
            UIColor(red: 0.0, green: 0.0, blue: 0.43921568627451, alpha: 1.0),
            UIColor(red: 0.0, green: 0.0, blue: 0.247058823529412, alpha: 1.0)
        ]
        
        
        
        colorDic[10] = [
            UIColor(red: 0.847058823529412, green: 0.898039215686275, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.67843137254902, green: 0.784313725490196, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.337254901960784, green: 0.556862745098039, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.333333333333333, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.2, blue: 0.6, alpha: 1.0),
            UIColor(red: 0.0, green: 0.133333333333333, blue: 0.4, alpha: 1.0),
            UIColor(red: 0.0, green: 0.0666666666666667, blue: 0.2, alpha: 1.0)
        ]
    }
}
