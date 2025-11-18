
import SwiftUI
import Combine

struct StoriesFullScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var stories: [Story]
    
    @State var currentIndex: Int
    @State private var progress: CGFloat = 0
    @State private var timer: AnyCancellable?
    
    private let secondsPerStory: TimeInterval = 10
    private let tick: TimeInterval = 0.05
    private var progressPerTick: CGFloat {
        guard stories.count > 0 else { return 0 }
        return CGFloat(1.0) / CGFloat(stories.count) / CGFloat(secondsPerStory) * CGFloat(tick)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer().frame(height: 7)
                
                ZStack(alignment: .topTrailing) {
                    TabView(selection: $currentIndex) {
                        ForEach(Array(stories.enumerated()), id: \.offset) { index, story in
                            StoryPage(story: story)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    ProgressBar(numberOfSections: stories.count, progress: progress)
                        .padding(.top, 28)
                        .padding(.horizontal, 12)
                    
                    Button(action: { dismiss() }) {
                        Image("CloseButton")
                            .renderingMode(.original)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                            .padding(3)
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 12)
                }
                .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                .contentShape(Rectangle())
                .onTapGesture { goNext() }
                
                Spacer().frame(height: 17)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.cancel()
        }
       
        .onChange(of: currentIndex) { oldIndex, _ in
            if stories.indices.contains(oldIndex) {
                stories[oldIndex].isViewed = true
            }
            withAnimation { progress = sectionStart() }
        }
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer?.cancel()
        
        progress = sectionStart()
        timer = Timer.publish(every: tick, on: .main, in: .common)
            .autoconnect()
            .sink { _ in timerTick() }
    }
    
    private func timerTick() {
        
        let end = sectionEnd()
        let next = progress + progressPerTick
        if next >= end {
            goNext()
            return
        }
        withAnimation(.linear(duration: tick)) {
            progress = next
        }
    }
    
    private func sectionStart() -> CGFloat {
        guard stories.count > 0 else { return 0 }
        return CGFloat(currentIndex) / CGFloat(stories.count)
    }
    
    private func sectionEnd() -> CGFloat {
        guard stories.count > 0 else { return 1 }
        return CGFloat(min(currentIndex + 1, stories.count)) / CGFloat(stories.count)
    }
    
    // MARK: - Navigation
    
    private func goNext() {
        if stories.indices.contains(currentIndex) {
            stories[currentIndex].isViewed = true
        }
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            withAnimation { progress = sectionStart() }
        } else {
            dismiss()
        }
    }
    
    private func goPrev() {
        if currentIndex > 0 {
            currentIndex -= 1
            withAnimation { progress = sectionStart() }
        } else {
            dismiss()
        }
    }
}

private struct StoryPage: View {
    let story: Story
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Image(story.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(story.title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                    .lineLimit(2)
                    
                    Text(story.description)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white)
                    .tracking(0.4)
                        .lineLimit(3)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

// MARK: - ProgressBar with mask

private struct ProgressBar: View {
    let numberOfSections: Int
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let safeCount = max(numberOfSections, 1)
            let clamped = max(0, min(progress, 1))
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: geometry.size.width, height: 6)
                    .foregroundColor(.white)
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(
                        width: min(clamped * geometry.size.width, geometry.size.width),
                        height: 6
                    )
                    .foregroundColor(Color(.appBlue))
            }
            .mask {
                MaskView(numberOfSections: safeCount)
            }
        }
        .frame(height: 46)
    }
}

private struct MaskView: View {
    let numberOfSections: Int
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<numberOfSections, id: \.self) { _ in
                MaskFragmentView()
            }
        }
    }
}

private struct MaskFragmentView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .frame(height: 6)
    }
}

#Preview {
    StoriesFullScreenView(stories: .constant(Story.previewStories), currentIndex: 0)
}
