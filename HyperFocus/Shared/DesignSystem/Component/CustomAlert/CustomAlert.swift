//
//  CustomAlert.swift
//  HyperFocus
//
//  Created by 김영건 on 12/29/25.
//

import SwiftUI

struct CustomAlert: View {
    var params: CustomAlertParams
    
    init(params: CustomAlertParams) {
        self.params = params
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 10) {
                Text(params.title)
                    .multilineTextAlignment(.leading)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let description = self.params.description {
                    Text(description)
                        .multilineTextAlignment(.leading)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
            .padding(
                .init(top: 8, leading: 8, bottom: 24, trailing: 8)
            )
            
            ForEach(self.params.btns, id: \.id) { btnParams in
                CustomAlertBtn(params: btnParams)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .glassEffect(.clear, in: .rect(cornerRadius: 20))
        .padding(50)
    }
}

#Preview {
    ZStack {
        Image(AssetSystem.icPlay.rawValue)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scaledToFit()
        CustomAlert(
            params: CustomAlertParams(
                title: "안녕하세요",
                description: "fefefefe",
                btns: [
                    CustomAlertBtnModel(title: "확인",style: .blue, action: { }),
                    CustomAlertBtnModel(title: "확인",style: .gray, action: { }),
                    CustomAlertBtnModel(title: "확인",style: .grayRed, action: { })
                ]
            )
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.blue)
}
