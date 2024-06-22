import Foundation

struct WeatherWithForecastAfterDTO {
    let temperature: Double
    let weatherCondition: String
    let dailyForecast: DailyForecast
    let hourlyForecast: HourlyForecast
    
    struct DailyForecast {
        let maxTemperatures: [Double]
        let minTemperatures: [Double]
        let weatherConditions: [String]
        let sunrinse: [Date]
        let sunset: [Date]
        let times: [Date]
    }
    
    struct HourlyForecast {
        let temperature: [Double]
        let precipitationProbability: [Int]
        let weatherConditions: [String]
        let times: [Date]
    }
}
