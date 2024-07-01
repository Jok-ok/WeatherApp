import Foundation

// MARK: - WeatherResponse
struct YandexAPIWeatherResponse: Codable {
    let now: Int?
    let nowDt: String?
    let info: Info?
    let fact: Fact?
    let forecast: Forecast?

    enum CodingKeys: String, CodingKey {
        case now
        case nowDt = "now_dt"
        case info, fact, forecast
    }
}

// MARK: - Fact
struct Fact: Codable {
    let obsTime, temp, feelsLike: Int?
    let icon: String?
    let condition: Condition?
    let windSpeed: Double?
    let windDir: String?
    let pressureMm, pressurePa, humidity: Int?
    let daytime: String?
    let polar: Bool?
    let season: String?
    let windGust: Double?

    enum CodingKeys: String, CodingKey {
        case obsTime = "obs_time"
        case temp
        case feelsLike = "feels_like"
        case icon, condition
        case windSpeed = "wind_speed"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case pressurePa = "pressure_pa"
        case humidity, daytime, polar, season
        case windGust = "wind_gust"
    }
}

enum Condition: String, Codable {
    case clear = "clear"
    case partlyCloudy = "partly-cloudy"
    case cloudy = "cloudy"
    case overcast = "overcast"
    case lightRain = "light-rain"
    case rain = "rain"
    case heavyRain = "heavy-rain"
    case showers = "showers"
    case wetSnow = "wet-snow"
    case lightSnow = "light-snow"
    case snow = "snow"
    case snowShowers = "snow-showers"
    case hail = "hail"
    case thunderstorm = "thunderstorm"
    case thunderstormWithRain = "thunderstorm-with-rain"
    case thunderstormWithHail = "thunderstorm-with-hail"

    var description: String {
        switch self {
        case .clear:
            "Ясно"
        case .partlyCloudy:
            "Малооблачно"
        case .cloudy:
            "Облачно с прояснениями"
        case .overcast:
            "Пасмурно"
        case .lightRain:
            "Небольшой дождь"
        case .rain:
            "Дождь"
        case .heavyRain:
            "Сильный дождь"
        case .showers:
            "Ливень"
        case .wetSnow:
            "Дождь со снегом"
        case .lightSnow:
            "Небольшой снег"
        case .snow:
            "Снег"
        case .snowShowers:
            "Снегопад"
        case .hail:
            "Град"
        case .thunderstorm:
            "Дождь с грозой"
        case .thunderstormWithRain:
            "Гроза с градом"
        case .thunderstormWithHail:
            "Ясно"
        }
    }
}

// MARK: - Forecast
struct Forecast: Codable {
    let date: String?
    let dateTs, week: Int?
    let sunrise, sunset: String?
    let moonCode: Int?
    let moonText: String?
    let parts: [Part]?

    enum CodingKeys: String, CodingKey {
        case date
        case dateTs = "date_ts"
        case week, sunrise, sunset
        case moonCode = "moon_code"
        case moonText = "moon_text"
        case parts
    }
}

// MARK: - Part
struct Part: Codable {
    let partName: String?
    let tempMin, tempAvg, tempMax: Int?
    let windSpeed, windGust: Double?
    let windDir: String?
    let pressureMm, pressurePa, humidity: Int?
    let precMm: Double?
    let precProb, precPeriod: Int?
    let icon, condition: String?
    let feelsLike: Int?
    let daytime: String?
    let polar: Bool?

    enum CodingKeys: String, CodingKey {
        case partName = "part_name"
        case tempMin = "temp_min"
        case tempAvg = "temp_avg"
        case tempMax = "temp_max"
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case pressurePa = "pressure_pa"
        case humidity
        case precMm = "prec_mm"
        case precProb = "prec_prob"
        case precPeriod = "prec_period"
        case icon, condition
        case feelsLike = "feels_like"
        case daytime, polar
    }
}

// MARK: - Info
struct Info: Codable {
    let url: String?
    let lat, lon: Double?
}
