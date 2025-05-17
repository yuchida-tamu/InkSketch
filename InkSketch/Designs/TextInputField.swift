//
//  TextInputField.swift
//  InkSketch
//
//  Created by Yuta Uchida on 2025/05/18.
//

import SwiftUI

struct TextInputField: View {
    @State private var input = ""
    var placeholder = ""
    var submit: (String) -> Void

    var disabled: Bool {
        return input.isEmpty
    }

    var body: some View {
        HStack {
            TextField(placeholder, text: $input)
                .onSubmit(handleSubmit)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            Button(
                action: handleSubmit,
                label: {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            )
            .disabled(disabled)
        }
        .textFieldStyle(.roundedBorder)
    }

    init(submit: @escaping (String) -> Void) {
        self.submit = submit
    }

    init(placeholder: String, submit: @escaping (String) -> Void) {
        self.placeholder = placeholder
        self.submit = submit
    }

    private func handleSubmit() {
        guard input != "" else { return }
        submit(input)
        input = ""
    }
}

#Preview {
    TextInputField { value in
        print(value)
    }
}
