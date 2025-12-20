//
//  AddContractFeature.swift
//  HyperFocus
//
//  Created by 김영건 on 12/10/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AddContactFeature {
    @ObservableState
    struct State: Equatable{
        var contact: Contact
    }
    
    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setName(String)
        case delegate(Delegate)
        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                  await send(.delegate(.saveContact(contact)))
                  await self.dismiss()
                }

            case .setName(let name):
                state.contact.name = name
                return .none
            case .delegate(_):
                return .none
            }
            
        }
    }
}
