xquery version "1.0";

import module namespace http = "http://expath.org/ns/http-client" at "/http-client/http-client.xq";

declare namespace sparql = "http://www.w3.org/2005/sparql-results#";

declare option exist:serialize "method=html5 media-type=text/html";

declare function local:getQueryPrefixes() as xs:string {
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

declare function local:getSparqlQuery($drink as xs:string, $type as xs:string) as xs:string {
let $query := xs:string('
    SELECT ?label
    WHERE
    {
        ?machine soton:vendingMachineModel ?drink ;
        soton:vendingMachineType ?type ;
        spacerel:within ?building .
        ?building rdfs:label ?label .
    } ORDER BY ASC(?label)
    ') return replace(
        replace($query, '\?drink', concat('"',$drink,'"')),
            '\?type', concat('"',$type, '"'))
};

declare function local:getHtml($sparql-result as node()) {
    <html>
        <head>
            <title>SPARQLing XQuery</title>
        </head>
        <body>
            <ul>
            {
                for $result in $sparql-result//sparql:result return
                    <li>{$result/sparql:binding/sparql:literal/text()}</li>
            }
            </ul>
        </body>
    </html>
};

(: main query :)
let $url := "http://sparql.data.southampton.ac.uk/?query=",
$drink := request:get-parameter("drink", "Bottle"),
$type := request:get-parameter("type", "Can"),
$sparql := concat(local:getQueryPrefixes(), local:getSparqlQuery($drink, $type)),
$encoded-sparql := encode-for-uri($sparql),
$sparql-result := http:send-request(
   <http:request href="{concat($url, $encoded-sparql)}" method="get" >
      <http:header name="accept" value="application/xml"/>
   </http:request>
)
return local:getHtml($sparql-result[2]) 
    