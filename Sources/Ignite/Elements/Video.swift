//
// Video.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation

/// Shows a Video player on your page.
public struct Video: BlockElement, InlineElement, LazyLoadable {
    /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()

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
            var output = "<video controls\(attributes.description)>"

            for filename in files {
                if let fileType = videoType(for: filename) {
                    output += "<source src=\"\(filename)\" type=\"\(fileType.rawValue)\">"
                }
            }

            output += "Your browser does not support the video tag."
            output += "</video>"
            return output
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

    // swiftlint:disable function_body_length
    /// Determines the video file type based on the file extension present in the filename.
    /// - Parameter filename: The name of the file, including its extension.
    /// - Returns: An optional `VideoType` corresponding to the file extension.
    ///            Returns `nil` if the extension does not match any known video types.
    public func videoType(for filename: String) -> VideoType? {
        switch filename {
        case let name where name.contains(".animaflex"):
            .animaflex
        case let name where name.contains(".asfplugin"):
            .asfPlugin
        case let name where name.contains(".asf"):
            .asf
        case let name where name.contains(".atomic3dfeature"):
            .atomic3dFeature
        case let name where name.contains(".avi"):
            .avi
        case let name where name.contains(".avs"):
            .avsVideo
        case let name where name.contains(".av1"):
            .av1
        case let name where name.contains(".dv"):
            .dv
        case let name where name.contains(".fli"):
            .fli
        case let name where name.contains(".flv"):
            .flv
        case let name where name.contains(".gl"):
            .gl
        case let name where name.contains(".h264"),
             let name where name.contains(".mp4"):
            .h264
        case let name where name.contains(".h265"),
             let name where name.contains(".hevc"):
            .h265
        case let name where name.contains(".isvideo"):
            .isvideo
        case let name where name.contains(".matroska"),
             let name where name.contains(".mkv"):
            .matroska
        case let name where name.contains(".motionjpeg"):
            .motionJpeg
        case let name where name.contains(".mpeg"):
            .mpeg
        case let name where name.contains(".mp2t"):
            .mp2t
        case let name where name.contains(".ogg"):
            .ogg
        case let name where name.contains(".quicktime"),
             let name where name.contains(".mov"):
            .quicktime
        case let name where name.contains(".rnrealvideo"):
            .rnRealvideo
        case let name where name.contains(".sgimovie"):
            .sgiMovie
        case let name where name.contains(".scm"):
            .scm
        case let name where name.contains(".vdo"):
            .vdo
        case let name where name.contains(".vivo"):
            .vivo
        case let name where name.contains(".vp9"):
            .vp9
        case let name where name.contains(".vosaic"):
            .vosaic
        case let name where name.contains(".webm"):
            .webm
        default:
            nil
        }
    }
    // swiftlint:enable function_body_length
}
