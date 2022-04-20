//
//  ScrollableStackView.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 4/4/22.
//

import UIKit

class ScrollableStackView: UIScrollView {

    

    let stackView = UIStackView()

    

    override init(frame: CGRect = .zero) {

        super.init(frame: frame)

        

        alwaysBounceVertical = false

                

        stackView.axis = .vertical

        stackView.spacing = 0

        

        addAutoLayoutSubview(stackView)

        

        NSLayoutConstraint.activate([

            stackView.leftAnchor.constraint(equalTo: leftAnchor),

            stackView.rightAnchor.constraint(equalTo: rightAnchor),

            stackView.widthAnchor.constraint(equalTo: widthAnchor),

            stackView.topAnchor.constraint(equalTo: topAnchor),

            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)

            ])

    }

    

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }

}



class HorizontalScrollableStackView: UIScrollView {

    

    let stackView = UIStackView()

    

    override init(frame: CGRect = .zero) {

        super.init(frame: frame)

        

        alwaysBounceHorizontal = true

                

        stackView.axis = .horizontal

        stackView.spacing = 0

        

        addAutoLayoutSubview(stackView)

        

        NSLayoutConstraint.activate([

            stackView.leftAnchor.constraint(equalTo: leftAnchor),

            stackView.rightAnchor.constraint(equalTo: rightAnchor),

            stackView.heightAnchor.constraint(equalTo: heightAnchor),

            stackView.topAnchor.constraint(equalTo: topAnchor),

            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)

            ])

    }

    

    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }

}
