import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("hello", "vapor") { request -> String in
        return "hello, vapor!"
    }
    
    //route with dynamic parameter - we can give to this parameter any value
    app.get("hello", ":name") { request -> String in
        guard let name = request.parameters.get("name") else { throw Abort(.internalServerError) }
        return ("Hello, \(name)!")
    }
    
    app.get("count", ":word") { request -> Int in
        guard let word = request.parameters.get("word") else { throw Abort(.internalServerError) }
        return word.count
    }
    
    //1can accept data, for example, json
    app.post("track") { request -> String in
        let data = try request.content.decode(Track.self)
        return "\(data.title) is playing now. Artist \(data.artist)"
    }
    
    //2return json
    app.post("track", "json") { request -> ResponseTrack in
        let data = try request.content.decode(Track.self)
        return ResponseTrack(request: data)
    }
    
}
//1can accept data, for example, json
//protocol Content in vapor is something that has protocol codable (encodable, decodable) - to encode and encode from json to swift model and reverse
struct Track: Content {
    let title: String
    let artist: String
}

//2 return json
struct ResponseTrack: Content {
    let request: Track
    
}
