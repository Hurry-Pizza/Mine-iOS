//
//  RankViewModel.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation
import Combine

final class RankViewModel: ObservableObject {
    @Published var rankList: [Rank] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    func getRanks() {
        RankManager.shared.getRanks()
            .sink(receiveValue: { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(let rankResponse):
                    if let ranks = rankResponse.data?.ranks {
                        self.rankList = ranks
                    }
                case .failure(let error):
                    print(error)
                }
            }).store(in: &subscriptions)
    }
}
