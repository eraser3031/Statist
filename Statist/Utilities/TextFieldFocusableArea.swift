import SwiftUI
import Introspect

extension View {
    public func textFieldFocusableArea() -> some View {
        TextFieldButton { self.contentShape(Rectangle()) }
    }
}

fileprivate struct TextFieldButton<Label: View>: View {
    init(label: @escaping () -> Label) {
        self.label = label
    }
    
    var label: () -> Label
    
    private var textField = Weak<UITextField>(nil)
    
    var body: some View {
        Button(action: {
            self.textField.value?.becomeFirstResponder()
        }, label: {
            label().introspectTextField {
                self.textField.value = $0
            }
        }).buttonStyle(PlainButtonStyle())
    }
}

/// Holds a weak reference to a value
public class Weak<T: AnyObject> {
    public weak var value: T?
    public init(_ value: T?) {
        self.value = value
    }
}
