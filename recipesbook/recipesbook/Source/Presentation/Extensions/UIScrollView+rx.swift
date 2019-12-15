//
//  UICollectionView+rx.swift
//  recipesbook
//
//  Created by Pere Almendro on 12/12/2019.
//  Copyright © 2019 Pere Almendro. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIScrollView {
    public var scrollViewDidScroll: ControlEvent<UIScrollView> {
        let observable = Observable<UIScrollView>.create({ [base] observer in
            base.rx.didScroll
                .subscribe(onNext: { _ in
                    observer.onNext(base)
                })
        })
        return ControlEvent(events: observable)
    }
}
