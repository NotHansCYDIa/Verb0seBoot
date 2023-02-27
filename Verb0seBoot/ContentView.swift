//
//  ContentView.swift
//  Verb0seBoot
//
//  Created by NotHans CYDIA on 2/27/23.
//

import SwiftUI
import AppKit

struct ContentView: View {
    
    @State private var verbose: [String] = []
    @State private var ver2 = ["============ Verb0seBoot ============", "# Press E to execute verbose logs", "# Press C to clear verbose logs", "# Press O to customize verbose logs", "# Press Command+C to clear verbose text", "# Press Command+O to change into different modes", " ", "# NotHansCYDIa v1.0.0 Beta", "Made in SwiftUI", "====================================="]
    
    @State private var open = false
    @State private var start = false
    @State private var appending = ""
    
    @State private var light = false
    
    var body: some View {
        ZStack {
            
            if light == false {
                Color.black
                    .ignoresSafeArea()
            } else {
                Color.white
                    .ignoresSafeArea()
            }
            
            
            GeometryReader { geometry in
                ScrollViewReader { scrollView in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            
                            ForEach(verbose.indices, id: \.self) { ver in
                                Text("\(verbose[ver])")
                                
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
                            NSCursor.hide()
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
        } .foregroundColor(light == true ? .black : .white)
        .sheet(isPresented: $open) {
            VStack {
                TextField("\"test\", \"123\" or test, 123", text: $appending)
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
                    .frame(width: 320)
                
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
