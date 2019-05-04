#!/bin/bash

while true; do 
  curl -k ${REST_CXFRS_URL}/rest/customerservice/enrich -X POST  -d '{"company":{"name":"Rotobots","geo":"NA","active":true},"contact":{"firstName":"Bill","lastName":"Smith","streetAddr":"100 N Park Ave.","city":"Phoenix","state":"AZ","zip":"85017","phone":"602-555-1100"}}' -H 'content-type: application/json'  	
done