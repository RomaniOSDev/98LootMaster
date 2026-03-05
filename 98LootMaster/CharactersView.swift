import SwiftUI

struct CharactersView: View {
    @ObservedObject var viewModel: LootMasterViewModel
    
    @State private var isShowingAddCharacter = false
    @State private var selectedCharacter: Character?
    
    var body: some View {
        ZStack {
            Color.lootBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                header
                charactersList
            }
        }
        .sheet(isPresented: $isShowingAddCharacter) {
            AddCharacterView(viewModel: viewModel)
        }
        .sheet(item: $selectedCharacter) { character in
            CharacterDetailView(viewModel: viewModel, character: character)
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Characters")
                    .foregroundColor(.lootRare)
                    .font(.largeTitle)
                    .bold()
                
                Text("Track who received each drop.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button {
                isShowingAddCharacter = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.lootRare)
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    private var charactersList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.characters) { character in
                    CharacterCard(
                        character: character,
                        dropCount: viewModel.dropsForCharacter(character.id).count
                    )
                    .onTapGesture {
                        selectedCharacter = character
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.characters.removeAll { $0.id == character.id }
                            viewModel.saveToUserDefaults()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            viewModel.toggleMainCharacter(character)
                        } label: {
                            Label("Main", systemImage: "crown")
                        }
                        .tint(.lootRare)
                    }
                }
            }
            .padding()
        }
    }
}

struct CharacterCard: View {
    let character: Character
    let dropCount: Int
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(character.isMain ? Color.lootRare : Color.lootCommon.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Text(String(character.name.prefix(1)).uppercased())
                    .foregroundColor(character.isMain ? .lootBackground : .white)
                    .font(.title2)
                    .bold()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(character.name)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    if character.isMain {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.lootRare)
                            .font(.caption)
                    }
                }
                
                Text(character.gameName)
                    .foregroundColor(.gray)
                    .font(.caption)
                
                if let className = character.className {
                    Text(className)
                        .foregroundColor(.lootCommon)
                        .font(.caption2)
                }
            }
            
            Spacer()
            
            if dropCount > 0 {
                VStack {
                    Text("\(dropCount)")
                        .foregroundColor(.lootRare)
                        .font(.title3)
                        .bold()
                    Text("drops")
                        .foregroundColor(.gray)
                        .font(.caption2)
                }
            }
        }
        .padding()
        .lootCard(borderColor: character.isMain ? .lootRare : .lootCommon)
    }
}

