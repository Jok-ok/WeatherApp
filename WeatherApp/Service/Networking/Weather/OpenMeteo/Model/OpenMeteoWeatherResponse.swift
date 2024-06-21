import Foundation

// MARK: - OpenMeteoWeatherResponse
struct OpenMeteoWeatherResponse: Codable {
    let latitude, longitude, generationtimems: Double?
    let utcOffsetSeconds: Int?
    let timezone, timezoneAbbreviation: String?
    let elevation: Int?
    let currentUnits: CurrentUnits?
    let current: Current?
    let hourlyUnits: HourlyUnits?
    let hourly: Hourly?
    let dailyUnits: DailyUnits?
    let daily: Daily?

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimems = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentUnits = "current_units"
        case current
        case hourlyUnits = "hourly_units"
        case hourly
        case dailyUnits = "daily_units"
        case daily
    }
}

// MARK: - Current
struct Current: Codable {
    let time: String?
    let interval: Int?
    let temperature2M: Double?
    let weatherCode: WeatherCodes?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case weatherCode = "weather_code"
    }
}

enum WeatherCodes: Int, Codable {
    case clearSky = 0
    case mainlyClear = 1
    case partlyCloudy = 2
    case overcast = 3
    case fog = 45
    case depositingRimeFog = 48
    case drizzleLight = 51
    case drizzleModerate = 53
    case drizzleDense = 55
    case freezingDrizzleLight = 56
    case freezingDrizzleDense = 57
    case rainSlight = 61
    case rainModerate = 63
    case rainHeavy = 65
    case freezingRainLight = 66
    case freezingRainHeavy = 67
    case snowFallSlight = 71
    case snowFallModerate = 73
    case snowFallHeavy = 75
    case snowGrains = 77
    case rainShowersSlight = 80
    case rainShowersModerate = 81
    case rainShowersViolent = 82
    case snowShowersSlight = 85
    case snowShowersHeavy = 86
    case thunderstormSlight = 95
    case thunderstormWithHail = 96

    var description: String {
        switch self {
        case .clearSky:
            return "Ясное небо"
        case .mainlyClear:
            return "В основном ясно"
        case .partlyCloudy:
            return "Переменная облачность"
        case .overcast:
            return "Пасмурно"
        case .fog:
            return "Туман"
        case .depositingRimeFog:
            return "Инеистый туман"
        case .drizzleLight:
            return "Легкая морось"
        case .drizzleModerate:
            return "Умеренная морось"
        case .drizzleDense:
            return "Сильная морось"
        case .freezingDrizzleLight:
            return "Легкая морось с замерзанием"
        case .freezingDrizzleDense:
            return "Сильная морось с замерзанием"
        case .rainSlight:
            return "Легкий дождь"
        case .rainModerate:
            return "Умеренный дождь"
        case .rainHeavy:
            return "Сильный дождь"
        case .freezingRainLight:
            return "Легкий ледяной дождь"
        case .freezingRainHeavy:
            return "Сильный ледяной дождь"
        case .snowFallSlight:
            return "Легкий снегопад"
        case .snowFallModerate:
            return "Умеренный снегопад"
        case .snowFallHeavy:
            return "Сильный снегопад"
        case .snowGrains:
            return "Снежные зерна"
        case .rainShowersSlight:
            return "Легкие ливни"
        case .rainShowersModerate:
            return "Умеренные ливни"
        case .rainShowersViolent:
            return "Сильные ливни"
        case .snowShowersSlight:
            return "Легкие снегопады"
        case .snowShowersHeavy:
            return "Сильные снегопады"
        case .thunderstormSlight:
            return "Легкая гроза"
        case .thunderstormWithHail:
            return "Гроза с градом"
        }
    }
}

// MARK: - CurrentUnits
struct CurrentUnits: Codable {
    let time, interval, temperature2M, weatherCode: String?

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case weatherCode = "weather_code"
    }
}

// MARK: - Daily
struct Daily: Codable {
    let time: [String]?
    let weatherCode: [Int]?

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
    }
}

// MARK: - DailyUnits
struct DailyUnits: Codable {
    let time, weatherCode: String?

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let time: [String]?
    let temperature2M: [Double]?

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
    }
}

// MARK: - HourlyUnits
struct HourlyUnits: Codable {
    let time, temperature2M: String?

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
    }
}
