
struct GameSettings {
    
    private let roundTime: Int
    private let topic: String
    private let code: Int
    private var maxNumOfRounds: Int
    
    init(roundTime: Int = 0, topic: String = "", code: Int = 0, maxNumOfRounds: Int = 0) {
        self.roundTime = roundTime
        self.topic = topic
        self.code = code
        self.maxNumOfRounds = maxNumOfRounds
    }
    
    func getRoundTime() -> Int { roundTime }
    func getTopic() -> String { topic }
    func getCode() -> Int { code }
    func getMaxNumOfRounds() -> Int { maxNumOfRounds }
}
