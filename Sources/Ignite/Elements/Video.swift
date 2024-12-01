//
// Video.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Shows a Video player on your page.
public struct Video: BlockHTML, InlineHTML, LazyLoadable {
    /// The content and behavior of this HTML.
    public var body: some HTML { self }

    /// The unique identifier of this HTML.
    public var id = UUID().uuidString.truncatedHash

    /// Whether this HTML belongs to the framework.
    public var isPrimitive: Bool { true }

    /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic

    /// The files of the video to display. This should be specified relative to the
    /// root of your site, e.g. /video/outforwalk.mp4.
    var files: [String]?

    /// Creates one or multiple `Video` instance from the names of
    /// files contained in your site's assets. This should be specified
    /// relative to the root of your site, e.g. /video/outforwalk.mp4.
    /// - Parameters:
    ///   - names: The filenames of your video relative to the root of
    ///   your site. e.g. /video/outforwalk.mp4.
    ///   - fileTypes: The format of the video files.
    public init(_ files: String...) {
        self.files = files
    }

    /// Renders user video into the current publishing context.
    /// - Parameters:
    ///   - files: The user videos to render.
    ///   - context: The active publishing context.
    /// - Returns: The HTML for this element.
    public func render(files: [String], into context: PublishingContext) -> String {
        var attributes = attributes
        attributes.tag = "video controls"
        attributes.closingTag = "video"

        let sources = files.compactMap { filename in
            guard let fileType = videoType(for: filename) else { return nil }
            var sourceAttributes = CoreAttributes()
            sourceAttributes.selfClosingTag = "source"
            sourceAttributes.append(customAttributes:
                .init(name: "src", value: filename),
                .init(name: "type", value: fileType.rawValue)
            )
            return sourceAttributes.description()
        }.joined()

        return attributes.description(wrapping: sources + "Your browser does not support the video tag.")
    }

    /// Renders this element using publishing context passed in.
    /// - Parameter context: The current publishing context.
    /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        guard let files = self.files else {
            context.addWarning("""
            Creating video with no name should not be possible. \
            Please file a bug report on the Ignite project.
            """)
            return ""
        }
        return render(files: files, into: context)
    }

    // Dictionary mapping file extensions to VideoType
    let videoTypeDictionary: [String: VideoType] = [
        ".animaflex": .animaflex,
        ".asfplugin": .asfPlugin,
        ".asf": .asf,
        ".atomic3dfeature": .atomic3dFeature,
        ".avi": .avi,
        ".avs": .avsVideo,
        ".av1": .av1,
        ".dv": .dv,
        ".fli": .fli,
        ".flv": .flv,
        ".gl": .gl,
        ".h264": .h264,
        ".mp4": .h264,
        ".h265": .h265,
        ".hevc": .h265,
        ".isvideo": .isvideo,
        ".matroska": .matroska,
        ".mkv": .matroska,
        ".motionjpeg": .motionJpeg,
        ".mpeg": .mpeg,
        ".mp2t": .mp2t,
        ".ogg": .ogg,
        ".quicktime": .quicktime,
        ".mov": .quicktime,
        ".rnrealvideo": .rnRealvideo,
        ".sgimovie": .sgiMovie,
        ".scm": .scm,
        ".vdo": .vdo,
        ".vivo": .vivo,
        ".vp9": .vp9,
        ".vosaic": .vosaic,
        ".webm": .webm
    ]

}

extension Video {
    /// `VideoType` is an enumeration that defines a list of video
    /// file types. Each case in the enum represents a different video
    /// format, and the raw value of each case is the MIME type associated
    /// with that format.
    public enum VideoType: String {
        /// - animaflex: Animaflex Format
        /// A video format with the MIME type 'video/animaflex'.
        case animaflex = "video/animaflex"

        /// - asf: Advanced Systems Format
        /// A Microsoft streaming format supported by Windows Media Player.
        case asf = "video/x-ms-asf"

        /// - asfPlugin: ASF Plugin Format
        /// A variant of the ASF format used with browser plugins.
        case asfPlugin = "video/x-ms-asf-plugin"

        /// - atomic3dFeature: Atomic3D Feature Format
        /// A video format used for 3D feature films.
        case atomic3dFeature = "video/x-atomic3d-feature"

        /// - avi: Audio Video Interleave
        /// A popular video format supported by many players and platforms.
        case avi = "video/avi"

        /// - avsVideo: AVS Video Format
        /// A format used for AVS video files.
        case avsVideo = "video/avs-video"

        /// - av1: AOMedia Video 1
        /// A cutting-edge codec known for its efficiency and open-source status.
        case av1 = "video/av1"

        /// - dv: Digital Video Format
        /// A digital video format used in digital camcorders.
        case dv = "video/x-dv" // swiftlint:disable:this identifier_name

        /// - fli: FLI Animation Format
        /// An animation format capable of storing short animations.
        case fli = "video/fli"

        /// - flv: Flash Video Format
        /// Used by Adobe Flash Player and other applications for streaming video over the internet.
        case flv = "video/x-flv"

        /// - gl: GL Animation Format
        /// A video format used for GL animations.
        case gl = "video/gl" // swiftlint:disable:this identifier_name

        /// - h264: H.264 Video Format
        /// Commonly used for high-definition video in MP4 containers.
        case h264 = "video/mp4"

        /// - h265: High Efficiency Video Coding (HEVC)
        /// Known for its improved compression over H.264.
        case h265 = "video/hevc"

        /// - isvideo: ISVIDEO Format
        /// A format used for IS video files.
        case isvideo = "video/x-isvideo"

        /// - matroska: Matroska Format
        /// A modern container format capable of holding an unlimited
        /// number of video, audio, picture, or subtitle tracks in one file.
        case matroska = "video/x-matroska"

        /// - motionJpeg: Motion JPEG Format
        /// A video format where each video frame is separately
        /// compressed as a JPEG image.
        case motionJpeg = "video/x-motion-jpeg"

        /// - mpeg: MPEG Video Format
        /// A standard for lossy compression of video and audio.
        case mpeg = "video/mpeg"

        /// - mp2t: MP2T Streaming Format
        /// A video streaming format used for broadcasting over the internet.
        case mp2t = "video/mp2t"

        /// - ogg: Ogg Video Format
        /// Often used for embedding video on web pages with HTML5.
        case ogg = "video/ogg"

        /// - quicktime: QuickTime Format
        /// Used primarily for Apple's QuickTime Player.
        case quicktime = "video/quicktime"

        /// - rnRealvideo: RN Realvideo Format
        /// A proprietary video format developed by RealNetworks.
        case rnRealvideo = "video/vnd.rn-realvideo"

        /// - sgiMovie: SGI Movie Format
        /// A video format developed by Silicon Graphics.
        case sgiMovie = "video/x-sgi-movie"

        /// - scm: SCM Video Format
        /// A video format used for SCM video files.
        case scm = "video/x-scm"

        /// - vdo: VDO Video Format
        /// A video format used for VDO files.
        case vdo = "video/vdo"

        /// - vivo: Vivo Video Format
        /// A video format developed by Vivo Software.
        case vivo = "video/vnd.vivo"

        /// - vp9: VP9 Video Format
        /// An open-source codec developed by Google.
        case vp9 = "video/vp9"

        /// - vosaic: Vosaic Video Format
        /// A video format used for Vosaic files.
        case vosaic = "video/vosaic"

        /// - webm: WebM Video Format
        /// Designed for use in HTML5 web browsers.
        case webm = "video/webm"
    }

    /// Determines the video file type based on the file extension present in the filename.
    /// - Parameter filename: The name of the file, including its extension.
    /// - Returns: An optional `VideoType` corresponding to the file extension.
    ///            Returns `nil` if the extension does not match any known video types.
    public func videoType(for filename: String) -> VideoType? {
        for (fileExtension, type) in videoTypeDictionary where filename.contains(fileExtension) {
            return type
        }
        return nil
    }
}
