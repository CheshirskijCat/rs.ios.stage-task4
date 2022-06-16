import Foundation

final class CallStation {
    
    var activeUsers = Set<User>()
    
    var activeCalls = [Call]()
    
}

extension CallStation: Station {

    
    func users() -> [User] {
        Array(activeUsers)
    }
    
    func add(user: User) {
        activeUsers.insert(user)
    }
    
    func remove(user: User) {
        activeUsers.remove(user)

        for (index,item) in activeCalls.enumerated() {
            if (item.outgoingUser.id == user.id || item.incomingUser.id == user.id){
                activeCalls[index].status = .ended(reason: .error)
            }
        }
    }
    
    func execute(action: CallAction) -> CallID? {
        switch (action){
        case let .start(from, to):
            return callStartAction(from: from, to: to)
        case let .answer(from):
            return callAnswerAction(from: from)
        case let .end(from):
            return callEndAction(from: from)
        }
    }
    
    func callStartAction(from: User, to: User) -> UUID? {
        if (!activeUsers.contains(from)){ return nil }
        let error = !activeUsers.contains(to)
        let busy = activeCalls.first {
            ($0.incomingUser.id == to.id || $0.outgoingUser.id == to.id) &&
            ($0.status == .calling || $0.status == .talk )} != nil
        let status: CallStatus = error ? .ended(reason: .error) : busy ? .ended(reason: .userBusy) : .calling
        let newCall = Call(id: UUID(), incomingUser: to, outgoingUser: from, status: status)
        activeCalls.append(newCall)
        return newCall.id
    }
    
    func callAnswerAction(from: User) -> UUID? {
        var id:UUID? = nil
        if let index = activeCalls.firstIndex(where: { $0.incomingUser.id == from.id && $0.status == .calling} ){
            activeCalls[index].status = .talk
            id = activeCalls[index].id
        }
        return id
    }
    
    func callEndAction(from: User) -> UUID? {
        var id:UUID? = nil
        if let index = activeCalls.firstIndex(where: {
            ($0.incomingUser.id == from.id || $0.outgoingUser.id == from.id) && ($0.status == .calling || $0.status == .talk)
        } ){
            if (activeCalls[index].status == .talk){
                activeCalls[index].status = .ended(reason: .end)
            } else {
                activeCalls[index].status = .ended(reason: .cancel)
            }
            id = activeCalls[index].id
        }
        return id
    }
    
    func calls() -> [Call] { activeCalls }
    
    func calls(user: User) -> [Call] {
        activeCalls.filter({ $0.outgoingUser.id == user.id || $0.incomingUser.id == user.id })
    }
    
    func call(id: CallID) -> Call? {
        activeCalls.first(where: { $0.id == id})
    }
    
    func currentCall(user: User) -> Call? {
        return activeCalls.first(where: {
            ( $0.incomingUser.id == user.id || $0.outgoingUser.id == user.id ) && ($0.status == .calling || $0.status == .talk ) } )
    }
}
