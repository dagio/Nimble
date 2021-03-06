import Foundation

/// A Nimble matcher that succeeds when a value is "empty". For collections, this
/// means the are no items in that collection. For strings, it is an empty string.
public func beEmpty<S: Sequence>() -> Predicate<S> {
    return Predicate.simple("be empty") { actualExpression in
        let actualSeq = try actualExpression.evaluate()
        if actualSeq == nil {
            return .fail
        }
        var generator = actualSeq!.makeIterator()
        return Satisfiability(bool: generator.next() == nil)
    }
}

/// A Nimble matcher that succeeds when a value is "empty". For collections, this
/// means the are no items in that collection. For strings, it is an empty string.
public func beEmpty() -> Predicate<String> {
    return Predicate.simple("be empty") { actualExpression in
        let actualString = try actualExpression.evaluate()
        return Satisfiability(bool: actualString == nil || NSString(string: actualString!).length  == 0)
    }
}

/// A Nimble matcher that succeeds when a value is "empty". For collections, this
/// means the are no items in that collection. For NSString instances, it is an empty string.
public func beEmpty() -> Predicate<NSString> {
    return Predicate.simple("be empty") { actualExpression in
        let actualString = try actualExpression.evaluate()
        return Satisfiability(bool: actualString == nil || actualString!.length == 0)
    }
}

// Without specific overrides, beEmpty() is ambiguous for NSDictionary, NSArray,
// etc, since they conform to Sequence as well as NMBCollection.

/// A Nimble matcher that succeeds when a value is "empty". For collections, this
/// means the are no items in that collection. For strings, it is an empty string.
public func beEmpty() -> Predicate<NSDictionary> {
	return Predicate.simple("be empty") { actualExpression in
		let actualDictionary = try actualExpression.evaluate()
        return Satisfiability(bool: actualDictionary == nil || actualDictionary!.count == 0)
	}
}

/// A Nimble matcher that succeeds when a value is "empty". For collections, this
/// means the are no items in that collection. For strings, it is an empty string.
public func beEmpty() -> Predicate<NSArray> {
	return Predicate.simple("be empty") { actualExpression in
		let actualArray = try actualExpression.evaluate()
        return Satisfiability(bool: actualArray == nil || actualArray!.count == 0)
	}
}

/// A Nimble matcher that succeeds when a value is "empty". For collections, this
/// means the are no items in that collection. For strings, it is an empty string.
public func beEmpty() -> Predicate<NMBCollection> {
    return Predicate.simple("be empty") { actualExpression in
        let actual = try actualExpression.evaluate()
        return Satisfiability(bool: actual == nil || actual!.count == 0)
    }
}

#if _runtime(_ObjC)
extension NMBObjCMatcher {
    public class func beEmptyMatcher() -> NMBObjCMatcher {
        return NMBObjCMatcher(canMatchNil: false) { actualExpression, failureMessage in
            let location = actualExpression.location
            let actualValue = try! actualExpression.evaluate()
            failureMessage.postfixMessage = "be empty"
            if let value = actualValue as? NMBCollection {
                let expr = Expression(expression: ({ value as NMBCollection }), location: location)
                return try! beEmpty().matches(expr, failureMessage: failureMessage)
            } else if let value = actualValue as? NSString {
                let expr = Expression(expression: ({ value as String }), location: location)
                return try! beEmpty().matches(expr, failureMessage: failureMessage)
            } else if let actualValue = actualValue {
                failureMessage.postfixMessage = "be empty (only works for NSArrays, NSSets, NSIndexSets, NSDictionaries, NSHashTables, and NSStrings)"
                failureMessage.actualValue = "\(String(describing: type(of: actualValue))) type"
            }
            return false
        }
    }
}
#endif
