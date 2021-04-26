
let databaseURL = "https://scatch-1ba65-default-rtdb.europe-west1.firebasedatabase.app/"
let storageURL = "gs://scatch-1ba65.appspot.com/"
let imageMaxSize = Int64(1 * 1024 * 1024/2) // 1KB = 1024 bytes

enum PlayerKeys: String {
    case id = "id"
    case nickname = "nickname"
    case joinDate = "joinDate"
    case number = "number"
}

enum SheetKeys: String {
    case content = "content"
    case authorNum = "authorNum"
}

enum GameKeys: String {
    case topic = "topic"
    case maxNumOfRounds = "maxNumOfRounds"
    case roundTime = "roundTime"
    case code = "code"
    case roundNum = "roundNum"
    case players = "players"
    case rounds = "rounds"
    case round = "round_"
}
