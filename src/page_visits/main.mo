import Trie "mo:base/Trie";
import List "mo:base/List";
import Text "mo:base/Text";
import Result "mo:base/Result";

actor PageVisits {
    
    type Route = Text;

    type VisitRecord = {
        deviceType: { #Mobile; #Desktop };
        time: Int;
    };

    type Error = { #NotFound };

    type VisitSummary = {
        route: Route;
        total: Nat32;
        mobile: Nat32;
        desktop: Nat32;
        time: Int;
    };

    stable var visitSummaries : Trie.Trie<Route, VisitSummary> = Trie.empty();
    stable var logs : List.List<VisitRecord> = List.nil<VisitRecord>();

    
    public func log(route: Route, visitRecord: VisitRecord) : async Result.Result<(), Error> {
        let stored = Trie.find(
            visitSummaries,
            key(route),
            Text.equal
        );
        var total: Nat32 = 0;
        var mobile: Nat32 = 0;
        var desktop: Nat32 = 0;

        switch (stored) {
            case null {
                total += 1;
                switch (visitRecord.deviceType){
                    case (#Mobile) {
                        mobile += 1;
                    };
                    case (#Desktop){
                        desktop += 1;
                    };
                };
                let freshSummary: VisitSummary = {
                    route;
                    total;
                    mobile;
                    desktop;
                    time = visitRecord.time;
                };
                let newTrie = Trie.put<Route, VisitSummary>(
                    visitSummaries,
                    key(route),
                    Text.equal,
                    freshSummary
                ).0;
                

            };
            case (? v){
                total := v.total + 1;
                switch (visitRecord.deviceType){
                    case (#Mobile) {
                        mobile += 1;
                    };
                    case (#Desktop){
                        desktop += 1;
                    };
                };
                let freshSummary: VisitSummary = {
                    route = route;
                    total;
                    mobile;
                    desktop;
                    time = visitRecord.time;
                };
                let newTrie = Trie.put(
                    visitSummaries,
                    key(route),
                    Text.equal,
                    freshSummary
                );
            };
        };

        logs := List.push<VisitRecord>(visitRecord, logs);

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

    func key (x: Text) : Trie.Key<Text>{
        { key=x; hash = Text.hash(x) }
    };

};
