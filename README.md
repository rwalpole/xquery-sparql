xquery-sparql
=============

This demo combines XQuery and SPARQL and makes use of the EXPath HTTP Client module in order to send the SPARQL query over HTTP using the SPARQL 1.1 Protocol. It has been successfully tested on the latest trunk version of eXist-db checked out from https://github.com/eXist-db/exist

The demo is configured to access the Southampton University SPARQL endpoint at http://sparql.data.southampton.ac.uk/ and query open vending machine data to return the building names where selected food or drink items are stocked. Items can be specified throught the 'drink' and 'type' query parameters, for example:

http://{hostname}/{path-to-query}/demo.xq?drink=Coke&type=Can

Direct querying of the SPARQL endpoint will reveal more options that could be added.
