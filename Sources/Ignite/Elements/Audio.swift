//
// Audio.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Plays Audio on your page.
public struct Audio: BlockHTML, InlineHTML, LazyLoadable {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The name of the audio to display. This should be specified relative
    /// to the root of your site, e.g. /audio/bark.mp3.
    var files: [String]?

    /// Creates an `Audio` instance from the name of a file contained
    /// in your site's assets. This should be specified relative to the root
    /// of your site, e.g. /audio/bark.mp3.
    /// - Parameters:
    ///   - name: The filename of your audio relative to the root of your site. e.g. /audio/bark.mp3
    ///   - fileType: The format of the audio file.
    public init(_ files: String...) {
        self.files = files
    }

    /// Renders a user audio into the current publishing context.
    /// - Parameters:
    ///   - files: The user audios to render.
    ///   - context: The active publishing context.
    /// - Returns: The HTML for this element.
    public func render(files: [String], into context: PublishingContext) -> String {
        var output = "<audio controls\(attributes.description())>"

        for filename in files {
            if let fileType = audioTypes(for: filename) {
                output += "<source src=\"\(filename)\" type=\"audio/\(fileType.rawValue)\">"
            }
        }

        output += "Your browser does not support the audio element."
        output += "</audio>"
        return output
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        guard let files = files else {
            context.addWarning("""
            Creating audio with no name should not be possible. \
            Please file a bug report on the Ignite project.
            """)
            return ""
        }

        return render(files: files, into: context)
    }

    // Dictionary mapping file extensions to AudioType
    let audioTypeMapping: [String: AudioType] = [
        ".aac": .aac,
        ".aifc": .aifc,
        ".aif": .aif,
        ".au": .au, ".snd": .au,
        ".flac": .flac,
        ".funk": .funk, ".my": .funk, ".pfunk": .funk,
        ".gsd": .gsd, ".gsm": .gsd,
        ".it": .it,
        ".jam": .jam,
        ".kar": .kar, ".mid": .kar,
        ".la": .la, ".lma": .la,
        ".lam": .lam,
        ".m3u": .m3u,
        ".mka": .mka,
        ".mod": .mod,
        ".mp2": .mp2, ".m2a": .mp2,
        ".mp3": .mp3,
        ".mp4": .m4a,
        ".midi": .midi,
        ".mjf": .mjf,
        ".midX": .midX,
        ".ogg": .ogg,
        ".opus": .opus,
        ".pfunkMyFunk": .pfunkMyFunk,
        ".qcp": .qcp,
        ".ra": .ra, ".ram": .ra, ".rm": .ra, ".rmm": .ra, ".rmp": .ra,
        ".raPlugin": .raPlugin, ".rmpPlugin": .raPlugin, ".rpm": .raPlugin,
        ".rmi": .rmi,
        ".s3m": .s3m,
        ".sid": .sid,
        ".sndX": .sndX,
        ".tsi": .tsi, ".tsp": .tsi,
        ".voc": .voc,
        ".vox": .vox,
        ".vqe": .vqe, ".vql": .vql,
        ".vqf": .vqf,
        ".wav": .wav, ".wavX": .wavX,
        "webm": .webm,
        ".xm": .xm
    ]
}

public extension Audio {
    /// `AudioType` is an enumeration that defines a list of audio file types.
    /// Each case in the enum represents a different audio format, and the
    /// raw value of each case is the MIME type associated with that format.
    enum AudioType: String {
        /// - aac: Advanced Audio Coding
        /// Known for its efficiency and quality, often used in Apple products.
        case aac = "audio/aac"

        /// - aif: Audio Interchange File Format
        /// Standard audio format used by Apple. It stores sound data
        /// for personal computers and other electronic audio devices.
        case aif = "audio/aiff"

        /// - aifc: Compressed Audio Interchange File
        /// Similar to AIFF but compressed using various codecs.
        case aifc = "audio/x-aiff"

        /// - au, snd: Basic Audio
        /// The standard audio format for Unix-based systems.
        case au, snd = "audio/basic" // swiftlint:disable:this identifier_name

        /// - flac: Free Lossless Audio Codec
        /// A lossless compression for audio files.
        case flac = "audio/flac"

        /// - funk, my, pfunk: Funk Sound
        /// A playful or proprietary audio format typically used for making
        /// fun or funky sounds.
        case funk, my, pfunk = "audio/make" // swiftlint:disable:this identifier_name

        /// - gsd, gsm: GSM Audio
        /// Audio format for Global System for Mobile Communications.
        case gsd, gsm = "audio/x-gsm"

        /// - it: Impulse Tracker Module
        /// Audio file format for Impulse Tracker, a sequencer music editor.
        case it = "audio/it" // swiftlint:disable:this identifier_name

        /// - jam: Jam Music File
        /// A file format typically associated with a music application called Jam.
        case jam = "audio/x-jam"

        /// - kar, mid: MIDI Sound
        /// Musical Instrument Digital Interface; a standard for digital music instruments.
        case kar, mid = "audio/midi"

        /// - la, lma: NSP Audio
        /// Audio format used by the Unix-based NeXTSTEP operating system.
        case la, lma = "audio/nspaudio" // swiftlint:disable:this identifier_name

        /// - laX, lmaX: Extended NSP Audio
        /// Extended version of the NSP audio format.
        case laX, lmaX = "audio/x-nspaudio"

        /// - lam: Live Audio Media
        /// An audio streaming format.
        case lam = "audio/x-liveaudio"

        /// - m3u: MP3 Playlist File
        /// File format used for multimedia playlists.
        case m3u = "audio/x-mpequrl"

        /// - m4a: MPEG-4 Audio
        /// Commonly used for audio books and podcasts.
        case m4a = "audio/mp4"

        /// - midX: Extended MIDI File
        /// An extended version of the standard MIDI audio format.
        case midX = "audio/x-mid"

        /// - midi: MIDI File
        /// Standard MIDI (Musical Instrument Digital Interface) file format.
        case midi = "audio/x-midi"

        /// - mjf: MJuice Media File
        /// Proprietary audio format used by MJuice media player.
        case mjf = "audio/x-vnd.audioexplosion.mjuicemediafile"

        /// - mka: Matroska Audio File
        /// An audio container format that can hold various audio codecs.
        case mka = "audio/x-matroska"

        /// - mod: MOD Audio
        /// Audio file format used with Amiga and PC trackers.
        case mod = "audio/mod"

        /// - modX: Extended MOD Audio
        /// An extended version of the MOD audio format.
        case modX = "audio/x-mod"

        /// - mp2, m2a, mp2X: Extended MPEG Audio
        /// An extended version of the MPEG audio format.
        case mp2, m2a, mp2X = "audio/x-mpeg"

        /// - mp3, mpa, mpg, mpga, mp3Mpeg3, mp3X: MPEG-3 Audio
        /// Audio layer 3 of the MPEG standard.
        case mp3, mpa, mpg, mpga, mp3Mpeg3, mp3X = "audio/mpeg"

        /// - ogg: Ogg Vorbis
        /// Often used for streaming audio.
        case ogg = "audio/ogg"

        /// - opus: Opus Audio Codec
        /// Known for its low latency and versatility in various applications.
        case opus = "audio/opus"

        /// - pfunkMyFunk: Make My Funk Audio
        /// A proprietary or playful audio format for funky sounds.
        case pfunkMyFunk = "audio/make.my.funk"

        /// - qcp: Qualcomm PureVoice Audio
        /// Audio format used for recording human speech.
        case qcp = "audio/vnd.qcelp"

        /// - ra, ram, rm, rmm, rmp, raReal: RealAudio
        /// Audio format developed by RealNetworks for streaming audio over the internet.
        case ra, ram, rm, rmm, rmp, raReal = "audio/x-pn-realaudio" // swiftlint:disable:this identifier_name

        /// - raPlugin, rmpPlugin, rpm: RealAudio Plugin
        /// Extension for RealAudio to be used with browser plugins.
        case raPlugin, rmpPlugin, rpm = "audio/x-pn-realaudio-plugin"

        /// - rmi: MIDI File for Windows
        /// A MIDI file format used by Windows operating systems.
        case rmi = "audio/mid"

        /// - s3m: ScreamTracker 3 Module
        /// Audio file format used by ScreamTracker.
        case s3m = "audio/s3m"

        /// - sid: Commodore 64 SID Music
        /// Audio file format used to store music created for the Commodore 64 SID chip.
        case sid = "audio/x-psid"

        /// - sndX: Extended ADPCM Audio
        /// An extended version of the Adaptive Differential Pulse-Code Modulation audio format.
        case sndX = "audio/x-adpcm"

        /// - tsp, tsi: TSP Audio
        /// Audio format for the TrueSpeech Player.
        case tsp, tsi = "audio/tsplayer"

        /// - voc, vocX: Creative Labs Audio File
        /// Audio file format used by Creative Labs hardware.
        case voc, vocX = "audio/x-voc"

        /// - vox: Voxware Audio File
        /// Audio format used by Voxware applications.
        case vox = "audio/voxware"

        /// - vqe, vql: TwinVQ Plugin Audio
        /// Audio format used by TwinVQ for browser plugins.
        case vqe, vql = "audio/x-twinvq-plugin"

        /// - vqf: TwinVQ Audio File
        /// Audio file format developed by NTT for compressed audio.
        case vqf = "audio/x-twinvq"

        /// - wav, wavX: Extended WAV Audio
        /// An extended version of the WAV audio format.
        case wav, wavX = "audio/wav"

        /// - webm: WebM Audio
        /// Designed for use in HTML5 web browsers.
        case webm = "audio/webm"

        /// - xm: Extended Module
        /// Audio file format used by various tracker software.
        case xm = "audio/xm" // swiftlint:disable:this identifier_name
    }

    /// Determines the audio file type based on the file extension present in the filename.
    /// - Parameter filename: The name of the file, including its extension.
    /// - Returns: An optional `AudioType` corresponding to the file extension.
    ///            Returns `nil` if the extension does not match any known audio types.

    func audioTypes(for filename: String) -> AudioType? {
        for (fileExtension, type) in audioTypeMapping where filename.contains(fileExtension) {
            return type
        }
        return nil
    }
}
