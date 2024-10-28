//
//  weatherWidgetExtension.swift
//  weatherWidgetExtension
//
//  Created by Alex Lopez on 4/7/23.
//

import Combine
import CoreLocation
import Intents
import SwiftUI
import WidgetKit

class Provider: IntentTimelineProvider {
    var widgetLocationManager = WidgetLocationManager()

    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), configuration: ConfigurationIntent(), weatherData: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        createTimelineEntry(date: Date(), configuration: configuration, completion: completion)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        createTimeline(date: Date(), configuration: configuration, completion: completion)
    }

    var cancellable: Set<AnyCancellable> = []

    func createTimelineEntry(date: Date, configuration: ConfigurationIntent, completion: @escaping (WeatherEntry) -> ()) {
        widgetLocationManager.fetchLocation(handler: { location in
            getWeatherDataByCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, language: "", completion: { weatherData, _ in

                let entry = WeatherEntry(date: date, configuration: configuration, weatherData: weatherData)
                completion(entry)
            })
        })
    }

    func createTimeline(date: Date, configuration: ConfigurationIntent, completion: @escaping (Timeline<WeatherEntry>) -> ()) {
        widgetLocationManager.fetchLocation(handler: { location in
            getWeatherDataByCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, language: "", completion: { weatherData, _ in

                
                let entry = WeatherEntry(date: date, configuration: configuration, weatherData: weatherData)
                
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 30, to: date)!
                
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
                
                completion(timeline)
            })
        })
    }
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let weatherData: WeatherData?
}

struct weatherWidgetExtensionEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(LinearGradient(gradient:  getGradientBackground(code: entry.weatherData?.current?.weather?.first?.icon ?? "02d"), startPoint: .top, endPoint: .bottom)
                )
            VStack {
                Image(getFormattedFromImagename(imageName: entry.weatherData?.current?.weather?.first?.icon ?? "02d") ?? "02d")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text(" \(Int(round(entry.weatherData?.current?.temp ?? 0)))°")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
            }
        }
        .widgetBackground(backgroundView: self)
    }
}

struct weatherWidgetExtension: Widget {
    let kind: String = "weatherWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            weatherWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("WeatherLite")
        .description("Shows the current weather")
    }
}

struct weatherWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        weatherWidgetExtensionEntryView(entry: WeatherEntry(date: Date(), configuration: ConfigurationIntent(), weatherData: WeatherData()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension View {
    func widgetBackground(backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
