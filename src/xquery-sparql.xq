xquery version "1.0";

import module namespace http = "http://expath.org/ns/http-client" at "/http-client/http-client.xq";

declare namespace sparql = "http://www.w3.org/2005/sparql-results#";

declare function local:getPrefixes() as xs:string {
    let $prefixes := concat(
        "PREFIX soton: <http://id.southampton.ac.uk/ns/>",
        "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
        "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>",
        "PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>",
        "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
        "PREFIX org: <http://www.w3.org/ns/org#>",
        "PREFIX spacerel: <http://data.ordnancesurvey.co.uk/ontology/spatialrelations/>",
        "PREFIX ep: <http://eprints.org/ontology/>",
        "PREFIX dct: <http://purl.org/dc/terms/>",
        "PREFIX bibo: <http://purl.org/ontology/bibo/>",
        "PREFIX owl: <http://www.w3.org/2002/07/owl#>",
        "PREFIX oo: <http://purl.org/openorg/>")
    return $prefixes
};

declare function local:getQuery() as xs:string {
let $query := "
    SELECT * WHERE {
        ?s ?p ?o .
    } LIMIT 10
" return $query
};

let $url := "http://sparql.data.southampton.ac.uk/?query=",
$sparql := concat(local:getPrefixes(), local:getQuery()),
$encoded-sparql := encode-for-uri($sparql) return
http:send-request(
   <http:request href="{concat($url, $encoded-sparql)}" method="get" >
      <http:header name="accept" value="application/xml"/>
   </http:request>
)