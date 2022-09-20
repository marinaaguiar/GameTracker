
import Foundation

struct Game: Hashable {
    let id: String
    let name: String
    let price: String
    let yearPublished: Int
    let minPlayers: Int
    let maxPlayers: Int
    let playtime: String
    let minAge: Int
    let description: String
    let commentary: String
    let thumbUrl: String
    let imageUrl: String
    let officialUrl: String?
    let descriptionPreview: String
    let rulesUrl: String?
    let numUserRatings: Int
    let averageUserRating: Double
    let averageLearningComplexity: Int
    let rank: Int

    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: Game, rhs: Game) -> Bool {
      return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()

}
