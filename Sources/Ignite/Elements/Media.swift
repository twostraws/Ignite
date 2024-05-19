//
// Media.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Foundation
    /// Displays Media on your page.
public struct Media: BlockElement, InlineElement, LazyLoadable {
    
        /// The standard set of control attributes for HTML elements.
    public var attributes = CoreAttributes()
    
        /// How many columns this should occupy when placed in a section.
    public var columnWidth = ColumnWidth.automatic
    
        /// The name of the media to display. This should be specified relative to the
        /// root of your site, e.g. /audio/bark.mp3.
    var name: String?
    
        /// The names of the media to display. This should be specified relative to the
        /// root of your site, e.g. /audio/bark.mp3.
    var names: [String]?
    
        /// The media format.
    var fileType: String?
    
        /// Multiple media formats.
    var fileTypes: [String]?
    
        /// Creates an `Media` instance from the name of a file contained in your site's assets. This should be specified relative to the root of your site, e.g. /audio/sound.mp3.
        /// - Parameters:
        ///   - name: The filename of your media relative to the root of your site. e.g. /audio/sound.mp3
        ///   - fileType: The format of the media file.
    public init(_ name: String,_ fileType: String) {
        self.name = name
        self.fileType = fileType
    }
    
        /// Creates multiple `Media` instance from the name of a files contained in your site's assets. This should be specified relative to the root of your site, e.g. /audio/sound.mp3.
        /// - Parameters:
        ///   - names: The filenames of your media relative to the root of your site. e.g. /audio/sound.mp3
        ///   - fileTypes: The format of the media files.
    public init(_ names: [String],_ fileTypes: [String]) {
        self.names = names
        self.fileTypes = fileTypes
    }
    
        /// Renders a user media into the current publishing context.
        /// - Parameters:
        ///   - media: The user media to render.
        ///   - fileType: The format of the media file.
        ///   - context: The active publishing context.
        /// - Returns: The HTML for this element.
    public func render(name: String, fileType: String, into context: PublishingContext) -> String {
        if fileType.contains("video") == true {
      """
     <video controls\(attributes.description)>
     <source src=\"\(name)\" type="\(fileType)">
     Your browser does not support the video tag.
     </video>
     """
        } else {
     """
     <audio controls\(attributes.description)>
     <source src=\"\(name)\" type="\(fileType)">
     Your browser does not support the audio element.
     </audio>
     """
        }
    }
    
        /// Renders a user audio into the current publishing context.
        /// - Parameters:
        ///   - medias: The user medias to render.
        ///   - fileTypes: The format of the media files.
        ///   - context: The active publishing context.
        /// - Returns: The HTML for this element.
    public func render(names: [String], fileTypes: [String], into context: PublishingContext) -> String {
        if fileTypes.first!.contains("video") == true {
            var output = "<video controls\(attributes.description)>"
            
            for (index, name) in names.enumerated() {
                let fileType = fileTypes[index]
                output += "<source src=\"\(name)\" type=\"\(fileType)\">"
            }
            
            output += "Your browser does not support the video tag."
            output += "</video>"
            return output
        } else {
            var output = "<audio controls\(attributes.description)>"
            
            for (index, name) in names.enumerated() {
                let fileType = fileTypes[index]
                output += "<source src=\"\(name)\" type=\"\(fileType)\">"
            }
            
            output += "Your browser does not support the audio element."
            output += "</audio>"
            return output
        }
    }
    
        /// Renders this element using publishing context passed in.
        /// - Parameter context: The current publishing context.
        /// - Returns: The HTML for this element.
    public func render(context: PublishingContext) -> String {
        
        if fileType == nil {
            context.addWarning("""
          \(name ?? "Media"): specify the file type
          """)
        }
        
        if let name {
            return render(name: name, fileType: fileType!, into: context)
        } else if let names {
            return render(names: names, fileTypes: fileTypes!, into: context)
        } else {
            context.addWarning("""
            Creating media with no name should not be possible. \
            Please file a bug report on the Ignite project.
            """)
            return ""
        }
    }
}
