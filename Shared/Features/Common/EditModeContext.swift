//
//  EditModeContext.swift
//  iOS
//
//  Created by Tinashe Mzondiwa on 2023-04-22.
//
//  A wrapper for properly restoring ``EditMode``
//

import SwiftUI

struct EditModeContext<Content: View> : View {
    
    @State var editMode: EditMode = .inactive
    
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content.environment(\.editMode, $editMode)
    }
}
