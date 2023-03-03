//
//  ContentView.swift
//  Verb0seBoot
//
//  Created by NotHans CYDIA on 3/1/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var taps = 0
    @State private var verbose: [String] = []
    @State private var iosVerbose: [String] = []
    @State private var ver2 = ["============ Verb0seBoot ============", "# Press E to execute verbose logs", "# Press C to clear verbose logs", "# Press O to customize verbose logs", "# Press Command+C to clear verbose text", "# Press Command+O to change into different modes", " ", "# NotHansCYDIa v1.0.0 Beta", "Made in SwiftUI", "====================================="]
    
    @State private var iosVer2 = ["============ Verb0seBoot ============", "# Double tap the screen to open menu", " ", "# NotHansCYDIa v1.0.0 Beta", "Made in SwiftUI", "====================================="]
    @State private var iosCustomBackgroundColor: Color = Color.black
    @State private var iosCustomTextColor: Color = Color.white
    
    @State private var open = false
    @State private var start = false
    @State private var appending = ""
    
    @State private var light = false
    @State private var iosVerboseMenu = false
    
    @State private var iosGestureTripleTapExecuteVerboseText = false
    @State private var iosTextDuration = "0.05"
    
    var body: some View {
        ZStack {
            
            #if os(macOS)
            iosCustomBackgroundColor
            
            
            GeometryReader { geometry in
                ScrollViewReader { scrollView in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            
                            ForEach(verbose.indices, id: \.self) { ver in
                                Text("\(verbose[ver])")
                                    .foregroundColor(iosCustomTextColor)
                                
                            }
                            
                            Rectangle()
                                .frame(width: 7, height: 12)
                                .foregroundColor(light == true ?  .black : .white)
                                .offset(y: verbose == [] ? 0 : -6)
                            
                            
                            
                            Button("Execute") {
                                DispatchQueue.global(qos: .background).async {
                                    for text in ver2 {
                                        DispatchQueue.main.async {
                                            verbose.append(text)
                                        }
                                        Thread.sleep(forTimeInterval: 0.01)
                                    }
                                }
                            }
                            .offset(y: 3330)
                            .keyboardShortcut("E", modifiers: [])
                            
                            Button("Execute") {
                                verbose = []
                            }
                            .offset(y: 3330)
                            .keyboardShortcut("C", modifiers: [])
                            
                            Button("Execute") {
                                open = true
                            }
                            .offset(y: geometry.size.height - 30)
                            .keyboardShortcut("O", modifiers: [])
                            
                            Button("Execute") {
                                light.toggle()
                            }
                            .offset(y: geometry.size.height - 30)
                            .keyboardShortcut("O", modifiers: [.command])
                            
                            Button("Open TextField") {
                                ver2 = []
                            }
                            .offset(y: geometry.size.height - 30)
                            .keyboardShortcut("C", modifiers: [.command])
                            
                        }
                        .font(.custom("OSXDarwin", size: 12))
                        .onAppear {
                            // NSCursor.hide()
                        }
                        .onChange(of: verbose) { _ in
                            scrollView.scrollTo(verbose.count - 1, anchor: .bottom)
                        }
                    }
                }
                
               
            } .onAppear {
                DispatchQueue.global(qos: .background).async {
                    for text in ver2 {
                        DispatchQueue.main.async {
                            verbose.append(text)
                        }
                        Thread.sleep(forTimeInterval: 0.01)
                    }
                }
            }
            
        #elseif os(iOS)
            
            iosCustomBackgroundColor
                .ignoresSafeArea()
            
            GeometryReader { _ in
                ScrollViewReader { scrollView in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            ForEach(iosVerbose.indices, id: \.self) { ver in
                                Text("\(iosVerbose[ver])")
                                    .foregroundColor(iosCustomTextColor)
                                
                            } 
                            
                            Rectangle()
                                .frame(width: 7, height: 12)
                                .foregroundColor(iosCustomTextColor)
                                .offset(y: iosVerbose == [] ? 0 : -6)
                        } .ignoresSafeArea() .statusBarHidden(true)
                    } .onChange(of: iosVerbose) { _ in
                        scrollView.scrollTo(iosVerbose.count - 1, anchor: .bottom)
                    }
                }
            } .onAppear {
                DispatchQueue.global(qos: .background).async {
                    for text in iosVer2 {
                        DispatchQueue.main.async {
                            iosVerbose.append(text)
                        }
                        Thread.sleep(forTimeInterval: 0.01)
                    }
                }
            } .font(.custom("OSXDarwin", size: 12)) .sheet(isPresented: $iosVerboseMenu) {
                NavigationStack {
                    List {
                        
                        Section(header: Text("Verbose Text").foregroundColor(.gray), footer: Text("e.g. \n\"lol 123\ntesting\", you can use multiline to add more text")
                            .foregroundColor(.gray)) {
                            
                            TextEditor(text: $appending)
                                .foregroundColor(.primary)
                            
                            Button("Save Text") {
                                let lines = appending.components(separatedBy: "\n")
                                var cleanedElements: [String] = []

                                for i in 0..<lines.count {
                                    let line = lines[i]
                                    if i < lines.count - 1 && line.last == "\\" {
                                        let nextLine = lines[i+1]
                                        let mergedLine = String(line.dropLast()) + nextLine
                                        let elements = mergedLine.components(separatedBy: ",")
                                        let cleanedLineElements = elements.map { element in
                                            element.trimmingCharacters(in: .whitespacesAndNewlines)
                                                .replacingOccurrences(of: "\"", with: "")
                                        }
                                        cleanedElements += cleanedLineElements
                                    } else {
                                        let elements = line.components(separatedBy: ",")
                                        let cleanedLineElements = elements.map { element in
                                            element.trimmingCharacters(in: .whitespacesAndNewlines)
                                                .replacingOccurrences(of: "\"", with: "")
                                        }
                                        cleanedElements += cleanedLineElements
                                    }
                                }

                                iosVer2 = cleanedElements
                                appending = ""
                                open = false
                            } .foregroundColor(.blue)
                            
                            Button("Save Text & Execute Verbose") {
                                let lines = appending.components(separatedBy: "\n")
                                var cleanedElements: [String] = []

                                for i in 0..<lines.count {
                                    let line = lines[i]
                                    if i < lines.count - 1 && line.last == "\\" {
                                        let nextLine = lines[i+1]
                                        let mergedLine = String(line.dropLast()) + nextLine
                                        let elements = mergedLine.components(separatedBy: ",")
                                        let cleanedLineElements = elements.map { element in
                                            element.trimmingCharacters(in: .whitespacesAndNewlines)
                                                .replacingOccurrences(of: "\"", with: "")
                                        }
                                        cleanedElements += cleanedLineElements
                                    } else {
                                        let elements = line.components(separatedBy: ",")
                                        let cleanedLineElements = elements.map { element in
                                            element.trimmingCharacters(in: .whitespacesAndNewlines)
                                                .replacingOccurrences(of: "\"", with: "")
                                        }
                                        cleanedElements += cleanedLineElements
                                    }
                                }

                                iosVer2 = cleanedElements
                                appending = ""
                                open = false

                                DispatchQueue.global(qos: .background).async {
                                    for text in iosVer2 {
                                        DispatchQueue.main.async {
                                            iosVerbose.append(text)
                                        }
                                        if let duration = Float(iosTextDuration) {
                                            Thread.sleep(forTimeInterval: TimeInterval(duration))
                                        }
                                    }
                                }

                                iosVerboseMenu = false

                            } .foregroundColor(.blue)
                            
                            Button("Execute Verbose") {
                                DispatchQueue.global(qos: .background).async {
                                    for text in iosVer2 {
                                        DispatchQueue.main.async {
                                            iosVerbose.append(text)
                                        }
                                        if let duration = Float(iosTextDuration) {
                                            Thread.sleep(forTimeInterval: TimeInterval(duration))
                                        }
                                    }
                                }
                                iosVerboseMenu = false
                            } .foregroundColor(.blue)
                                
                                
                                TextField("Text Duration e.g. 0.1", text: $iosTextDuration)
                                    .foregroundColor(.primary)
                            
                        }
                        
                        Section(header: Text("Verbose").foregroundColor(.gray)) {
                            
                            NavigationLink("Theme") {
                                List {
                                    
                                    Section(footer: ZStack {
                                        
                                        iosCustomBackgroundColor
                                            .frame(height: 120)
                                        
                                        GeometryReader { _ in
                                            VStack(alignment: .leading) {
                                                Text("Hello World!\nThis is my Text\n1234567890\nABCDEFGHIJKLMNOPQRSTUVWXYZ")
                                                    .font(.custom("OSXDarwin", size: 12))
                                                    .foregroundColor(iosCustomTextColor)
                                                Rectangle()
                                                    .frame(width: 5, height: 10)
                                                    .offset(y: -6)
                                                    .foregroundColor(iosCustomTextColor)
                                            }
                                        }
                                    }) {
                                        ColorPicker("Background Color", selection: $iosCustomBackgroundColor)
                                        
                                        ColorPicker("Text Color", selection: $iosCustomTextColor)
                                    }

                                } .navigationTitle("Theme")
                            } .foregroundColor(.primary)
                            
                            /*
                            NavigationLink("Gestures") {
                                List {
                                    Toggle(isOn: $iosGestureTripleTapExecuteVerboseText) {
                                        Text("Triple Tap To Execute Verbose")
                                            .foregroundColor(.primary)
                                    }
                                } .navigationTitle("Gestures")
                            } .foregroundColor(.primary)
                             */
                            
                            Button("Clear Verbose Logs", role: .destructive) {
                                iosVerbose = []
                                iosVerboseMenu = false
                            } .foregroundColor(.red)
                            
                            Button("Clear Verbose Text", role: .destructive) {
                                iosVer2 = []
                                iosVerboseMenu = false
                            } .foregroundColor(.red)

                            
                        } .foregroundColor(.primary)
                        
                        
                    } .navigationTitle("Verbose Menu") .toolbar {
                        
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                
                            } label: {
                                VStack(alignment: .leading) {
                                    Text("Documentation")
                                        .font(.title.bold())
                                    Text("Verb0seBoot")
                                } .padding()
                            }
                        }
                        
                        ToolbarItem(placement: .bottomBar) {
                            Spacer()
                        }
                        
                    }
                }
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        #endif
        } .onTapGesture(count: 2) {
            #if os(iOS)
            taps += 1
            iosVerboseMenu = true
            #endif
        } .simultaneousGesture(
            TapGesture(count: 1)
                .onEnded { _ in
                    #if os(iOS)
                    taps += 1
                    #endif
                }
        ) .foregroundColor(light == true ? .black : .white)
            .sheet(isPresented: $open) {
                NavigationStack {
                    List {
                        
                        
                        TextField("\"Test\", \"123\" or Test, 123", text: $appending)
                            .onSubmit {
                                let elements = appending.split(separator: ", ")
                                let cleanedElements = elements.map { element in
                                    element.trimmingCharacters(in: .whitespacesAndNewlines)
                                        .replacingOccurrences(of: "\"", with: "")
                                }
                                ver2 = cleanedElements
                                appending = ""
                                open = false
                                print(ver2)
                            }
                        
                        NavigationLink("Theme") {
                            List {
                                
                                Section(footer: ZStack {
                                    
                                    iosCustomBackgroundColor
                                        .frame(height: 120)
                                    
                                    GeometryReader { _ in
                                        VStack(alignment: .leading) {
                                            Text("Hello World!\nThis is my Text\n1234567890\nABCDEFGHIJKLMNOPQRSTUVWXYZ")
                                                .font(.custom("OSXDarwin", size: 12))
                                                .foregroundColor(iosCustomTextColor)
                                            Rectangle()
                                                .frame(width: 5, height: 10)
                                                .offset(y: -6)
                                                .foregroundColor(iosCustomTextColor)
                                        }
                                    }
                                }) {
                                    ColorPicker("Background Color", selection: $iosCustomBackgroundColor)
                                    
                                    ColorPicker("Text Color", selection: $iosCustomTextColor)
                                }
                                
                            } .navigationTitle("Theme") 
                        }
                    }
                }
            }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
