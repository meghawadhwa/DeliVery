import Foundation
import CoreData

class DeliveryListViewModel: DeliveryListViewModelBehavior {
    let cache: CacheBehavior
    let networkAdaptor: APIBehavior
    let reachable: ReachableBehavior
    var currentPage = 0
    var isCallInProgress = false
    typealias CacheCompletion = (Result<[DeliveryModel], CacheError>) -> Void
    typealias APICompletion = (Result<[DeliveryModel], APIServiceError>) -> Void
    var successCompletionHandler: CompletionClosure?
    var errorCompletionHandler: ErrorClosure?
    var deliveries = [DeliveryModel]()

    init(cache: CacheBehavior, networkAdaptor: APIBehavior, reachable: ReachableBehavior) {
        self.cache = cache
        self.networkAdaptor = networkAdaptor
        self.reachable = reachable
    }

    func refreshDeliveries() {
        guard isCallInProgress == false else {
            return
        }
        isCallInProgress = true
        let offset = 0
        let limit = Constants.deliveryFetchLimit
       fetchFromAPI(refresh:true, offset: offset, limit: limit)
    }

    func getDeliveries() {
        getDeliveries(page: currentPage)
    }

    func shouldFetchNextData(index: Int) -> Bool {
        var shouldFetchNextData = false
        if index == countOfDeliveries() - 1  && !isCallInProgress {
            shouldFetchNextData = true
        }
        return shouldFetchNextData
    }

    func getNextPageData() {
        getDeliveries(page: currentPage)
    }

    // MARK: Internal Methods
    private func getDeliveries(page: Int) {
        guard isCallInProgress == false else {
            return
        }
        isCallInProgress = true
        let limit = Constants.deliveryFetchLimit
        let offset = deliveries.count
        fetchFromCache(offset: offset, limit: limit) { [weak self] result in
            switch result {
            case .success(let deliveries):
                self?.deliveries.append(contentsOf: deliveries)
                self?.incrementPage()
                 self?.successCompletionHandler?()
                self?.isCallInProgress = false
            case .failure(let error):
                    CrashlyticsUtils.log(message: error.localizedDescription)
                    self?.fetchFromAPI(refresh:false, offset: offset, limit: limit)
                }
        }
    }

    private func fetchFromAPI(refresh:Bool, offset: Int, limit: Int) {
        if reachable.isInternetAvailable() {
            networkAdaptor.getDeliveries(offset: offset, limit: limit) { [weak self] result in
                switch result {
                case .success(let deliveries):
                    if refresh {
                        self?.cache.deleteCachedDeliveries()
                        self?.resetPageOnRefresh()
                        self?.deliveries = deliveries
                    } else {
                        self?.incrementPage()
                        self?.deliveries.append(contentsOf: deliveries)
                    }
                    self?.insertIntoCache(deliveries: deliveries)
                    self?.successCompletionHandler?()
                    self?.isCallInProgress = false
                case .failure(let error):
                    self?.errorCompletionHandler?(ErrorModel(error: error))
                    self?.isCallInProgress = false
                }
            }
        } else {
            self.errorCompletionHandler?(ErrorModel(error: .noNetwork))
            self.isCallInProgress = false
        }
    }

    private func fetchFromCache(offset: Int, limit: Int, completion: @escaping(CacheCompletion)) {
        cache.fetchDeliveries(offset: offset, limit: limit, completion: completion)
    }

    private func resetPageOnRefresh() {
        currentPage = 0
    }

    private func incrementPage() {
        currentPage += 1
    }

    private func insertIntoCache(deliveries: [DeliveryModel]) {
        cache.insertDeliveries(deliveries: deliveries)
    }
}
