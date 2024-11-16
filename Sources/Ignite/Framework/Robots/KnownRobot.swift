//
// KnownRobot.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// A collection of known robots.
public enum KnownRobot: String {
    /// Apple's robot.
    case apple = "Applebot"

    /// Baidu's robot.
    case baidu = "baiduspider"

    /// Bing's robot.
    case bing = "bingbot"

    /// ChatGPT's robot.
    case chatGPT = "GPTBot"

    /// The Common Crawl robot, which is used to make websites available
    /// to researchers. Sadly also used by OpenAI to train ChatGPT.
    case commonCrawl = "CCBot"

    /// Google's robot.
    case google = "Googlebot"

    /// Yahoo's robot.
    case yahoo = "slurp"

    /// Yandex's robot.
    case yandex = "yandex"
}
