//
//  TextWithAttributedString.swift
//  VideoPlayerSwiftUI
//
//  Created by Anthony Odu on 14/01/2024.
//

import Foundation
import SwiftUI

struct TextWithAttributedString: View {

   var attributedText: NSAttributedString
   @State private var height: CGFloat = .zero

   var body: some View {
       InternalTextView(attributedText: attributedText,
                        dynamicHeight: $height)
       .frame(minHeight: height)
   }

   struct InternalTextView: UIViewRepresentable {

       var attributedText: NSAttributedString
       @Binding var dynamicHeight: CGFloat

       func makeUIView(context: Context) -> UITextView {
           let textView = UITextView()
           textView.textAlignment = .justified
           textView.isScrollEnabled = false
           textView.isUserInteractionEnabled = false
           textView.showsVerticalScrollIndicator = false
           textView.showsHorizontalScrollIndicator = false
           textView.allowsEditingTextAttributes = false
           textView.backgroundColor = .clear
           textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
           textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
           return textView
       }

       func updateUIView(_ uiView: UITextView, context: Context) {
           uiView.attributedText = attributedText
           DispatchQueue.main.async {
               dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
           }
       }
   }
}

