//
//  MatchDetailsModel.swift
//  Shaadi.com

//{
//    cell = "(62) 1271-8494";
//    dob =     {
//        age = 41;
//        date = "1983-06-15T21:10:27.039Z";
//    };
//    email = "geruza.souza@example.com";
//    gender = female;
//    id =     {
//        name = CPF;
//        value = "805.036.839-65";
//    };
//    location =     {
//        city = Serra;
//        coordinates =         {
//            latitude = "-20.9269";
//            longitude = "21.1686";
//        };
//        country = Brazil;
//        postcode = 95202;
//        state = "Cear\U00e1";
//        street =         {
//            name = "Rua Das Flores ";
//            number = 1394;
//        };
//        timezone =         {
//            description = "Western Europe Time, London, Lisbon, Casablanca";
//            offset = "0:00";
//        };
//    };
//    login =     {
//        md5 = dde501eaef94766f13bf1655b4bea0a1;
//        password = 1028;
//        salt = w7BKUBkx;
//        sha1 = 48dc71340fdae66e6708a758235c37e5dd47237a;
//        sha256 = 5aa8b64d8e3aba720fa09ee72b2362be523105f143bfa8e05996f181f28e8e8f;
//        username = whitefish369;
//        uuid = "82c94c29-90de-47f1-be50-35bd188b529e";
//    };
//    name =     {
//        first = Geruza;
//        last = Souza;
//        title = Miss;
//    };
//    nat = BR;
//    phone = "(33) 2765-5913";
//    picture =     {
//        large = "https://randomuser.me/api/portraits/women/14.jpg";
//        medium = "https://randomuser.me/api/portraits/med/women/14.jpg";
//        thumbnail = "https://randomuser.me/api/portraits/thumb/women/14.jpg";
//    };
//    registered =     {
//        age = 20;
//        date = "2005-02-09T14:57:54.286Z";
//    };
//}

import Foundation

struct MatchDetailsModel: Codable {
    var name: Name
    var picture: Picture
    var location: Location
    var login: Login
}

struct Name: Codable {
    var first: String
    var last: String
    var title: String
}

struct Picture: Codable {
    var large: String
}

struct Location: Codable {
    var state: String
    var street: Street
}

struct Street: Codable {
    var name: String
    var number: Int
}

struct Login: Codable {
    var uuid: String
}

