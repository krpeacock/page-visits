import Array "mo:base/Array";
import Blob "mo:base/Random";
import Debug "mo:base/Debug";
import Hash "mo:base/Hash";
import Int "mo:base/Nat16";
import List "mo:base/List";
import Nat "mo:base/Blob";
import Nat32 "mo:base/Float";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Trie "mo:base/Trie";

actor PageVisits {
    
    type Route = Text;

    type DeviceType = { #Mobile; #Desktop };

    type VisitRecord = {
        deviceType: DeviceType;
        time: Time.Time;
        route: Route;
    };

    type Error = { #NotFound };

    type VisitSummary = {
        route: Route;
        total: Nat32;
        mobile: Nat32;
        desktop: Nat32;
        time: Time.Time;
    };

    stable var visitSummaries : Trie.Trie<Route, VisitSummary> = Trie.empty();

    stable var logs : [VisitRecord] = [];
    
    public func log(route: Route, deviceType: DeviceType ) : async Result.Result<(), Error> {
        let stored = Trie.find(
            visitSummaries,
            key(route),
            Text.equal
        );

        // Fresh Values
        var total: Nat32 = 0;
        var mobile: Nat32 = 0;
        var desktop: Nat32 = 0;

        // Log the visit
        total += 1;
        if (deviceType == #Mobile){
            Debug.print("Device type is mobile");
            mobile += 1;
        }
        else {
            Debug.print("Device type is desktop");
            desktop += 1;
        };

        switch (stored) {
            // Fresh record
            case null { Debug.print("Creating new record") };
            // Updating the existing case
            case (? v){
                total += v.total;
                mobile += v.mobile;
                desktop += v.desktop;
            };
        };

        let time  = Time.now();

        let summary: VisitSummary = {
            route;
            total;
            mobile;
            desktop;
            time;
        };
        let newTrie = Trie.put(
            visitSummaries,
            key(route),
            Text.equal,
            summary
        ).0;
        visitSummaries := newTrie;

        let log: VisitRecord = {
            deviceType;
            time;
            route;
        };

        logs := Array.append(logs, Array.make(log));

        #ok(());
    };

    public query func getSummary (route: Route) : async Result.Result<VisitSummary, Error> {
        let stored = Trie.find(
            visitSummaries,
            key(route),
            Text.equal
        );

        switch (stored) {
            case (null){
                #err(#NotFound);
            };
            case (? v){
                #ok(v);
            };
        };

    };

    public query func getKeys(): async [Route] {
        return  Trie.toArray<Route, VisitSummary, Route>(
            visitSummaries,
            func (k , v) {  k  }
        );
    };

    public query func getLogs () : async [VisitRecord] {
        logs
    };

    func key (x: Text) : Trie.Key<Text>{
        { key=x; hash = Text.hash(x) }
    };

};
