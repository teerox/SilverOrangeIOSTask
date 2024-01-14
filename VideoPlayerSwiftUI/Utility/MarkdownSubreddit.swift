//
//  MarkdownSubreddit.swift
//  VideoPlayerSwiftUI
//
//  Created by Anthony Odu on 14/01/2024.
//

import Foundation
import MarkdownKit

/*
This class extends the functionality of MarkdownLink
specifically for subreddit links. When parsing a Markdown text,
instances of MarkdownSubreddit will be used to handle and format subreddit links according to the specified logic.
This allows customization and additional processing for subreddit links within a Markdown document.
This class was created reading the documentation from the Markdownkit Library
 link: https://github.com/bmoliveira/MarkdownKit/blob/master/Examples/iOS/MarkdownSubreddit.swift
 */


/// Custom Markdown link for handling subreddit links.
class MarkdownSubreddit: MarkdownLink {
  
    /// Regular expression pattern to match subreddit links in Markdown text.
    fileprivate static let regex = "(^|\\s|\\W)(/?r/(\\w+)/?)"
  
    /// Overrides the regex property to provide the subreddit-specific regular expression.
    override var regex: String {
        return MarkdownSubreddit.regex
    }
  
    /// Overrides the match method to customize the handling of subreddit links.
    override func match(_ match: NSTextCheckingResult,
                        attributedString: NSMutableAttributedString) {
        // Extracts the subreddit name from the matched result.
        let subredditName = attributedString.attributedSubstring(from: match.range(at: 3)).string
        
        // Generates a link URL for the subreddit.
        let linkURLString = "http://reddit.com/r/\(subredditName)"
        
        // Calls methods to format and add attributes to the Markdown text related to the subreddit link.
        formatText(attributedString, range: match.range, link: linkURLString)
        addAttributes(attributedString, range: match.range, link: linkURLString)
    }
}
