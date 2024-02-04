import Foundation

// MARK: - Weather
struct Weather: Codable {
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
    let temp, feelsLike: Int?
    let icon, condition: String?
    let windSpeed: Int?
    let windGust: Double?
    let windDir: String?
    let pressureMm, pressurePa, humidity: Int?
    let daytime: String?
    let polar: Bool?
    let season: String?
    let obsTime: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case icon, condition
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case pressurePa = "pressure_pa"
        case humidity, daytime, polar, season
        case obsTime = "obs_time"
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
    let tempMin, tempMax, tempAvg, feelsLike: Int?
    let icon, condition, daytime: String?
    let polar: Bool?
    let windSpeed: Double?
    let windGust: Int?
    let windDir: String?
    let pressureMm, pressurePa, humidity, precMm: Int?
    let precPeriod, precProb: Int?

    enum CodingKeys: String, CodingKey {
        case partName = "part_name"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case tempAvg = "temp_avg"
        case feelsLike = "feels_like"
        case icon, condition, daytime, polar
        case windSpeed = "wind_speed"
        case windGust = "wind_gust"
        case windDir = "wind_dir"
        case pressureMm = "pressure_mm"
        case pressurePa = "pressure_pa"
        case humidity
        case precMm = "prec_mm"
        case precPeriod = "prec_period"
        case precProb = "prec_prob"
    }
}

// MARK: - Info
struct Info: Codable {
    let lat, lon: Double?
    let url: String?
}
