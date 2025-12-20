//
//  ContactView.swift
//  HyperFocus
//
//  Created by 김영건 on 12/10/25.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>
    
    
    var body: some View {
        NavigationStack {
//            List {
//                ForEach(store.contacts) { contact in
//                    HStack {
//                        Text(contact.name)
//                        Spacer()
//                        Button("삭제") {
//                            store.send(.deleteButtonTapped(for: contact.id))
//                        }
//                    }
//                }
//            }
//            .navigationTitle(Text("Contacts"))
//            .toolbar {
//                ToolbarItem {
//                    Button {
//                        store.send(.addButtonTapped)
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
        }
        .sheet(item: $store.scope(state: \.addContact, action: \.addContact)) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    ContactsView(store: Store(initialState: ContactsFeature.State()) {
        ContactsFeature()
    })
}
