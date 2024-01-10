module namespace page = 'http://basex.org/examples/web-page';

(:declare default element namespace 'http://www.trabalhoPEI.pt/returnRules';:) (: Para o xsd:)

(: Obter relatório de devoluçções de um mês :)
declare
 %rest:path("/returns")
 %rest:query-param("ano", "{$ano}")
 %rest:query-param("mes", "{$mes}")
 %rest:GET
function page:getReturn($ano as xs:int, $mes as xs:int) {
  let $xsd := "./xsd/saleRules.xsd"
  
  let $xml := page:getReturnsRawData($ano, $mes)
  let $parsedXml := page:transformReturnsXML($xml)
  
  return $parsedXml
};


declare function page:getReturnsRawData($ano as xs:integer, $mes as xs:integer) {
  let $rightMes := fn:format-number($mes, "00") (: com isto não vai ignorar o 0 caso o mes seja 03 :)
  let $rightProximoMes := fn:format-number($mes + 1, "00")
  
  let $url := "https://eu-west-2.aws.data.mongodb-api.com/app/data-krpco/endpoint/data/v1"
  let $findSuffix := "/action/find"
  let $apiKey := "suGjpm3S5Uue7H3sCuTLlKKxPBsWmXI8gf9x7Qx0yXegqquTrnNvuXo21SrXthBb"
  let $contentType := "application/json"
  let $body := concat('{
    "collection":"returns",
    "database":"BdPeiTP",
    "dataSource":"Cluster0",

    "filter": {
        "date": {
            "$gte": {"$date": "', $ano, '-', $rightMes, '-01T00:00:00Z"},
            "$lt": {"$date": "', $ano, '-', $rightProximoMes, '-01T00:00:00Z"}
        }
    }
}')

  let $httpResponse := http:send-request(
    <http:request method='post'>
      {<http:header name="Access-Control-Request-Headers" value="*"/>},
      {<http:header name="api-key" value='{$apiKey}'/>}
      
      {<http:body media-type='{$contentType}'>{$body}</http:body>}
    </http:request>,
    concat($url, $findSuffix)
  )
  
  return $httpResponse
};

declare function page:transformReturnsXML($xml) {
  <returns>
  {
    for $return in $xml/json/documents/*
    return (
      <return>
        {$return/invoice__id},
        {$return/product__id},
        {$return/daysUntilReturn},
        {$return/earlyReturn},
        {$return/date},
        {$return/sale},
        <customer>
          {$return/customer/customer__id},
          {$return/customer/first__name},
          {$return/customer/last__name},
          <address__info>
            {$return/customer/address__info/country},
            {$return/customer/address__info/city},
            {$return/customer/address__info/postal__code}
          </address__info>
        </customer>,
        <product>
          {$return/product/brand},
          {$return/product/model},
          {
            for $category in $return/product/categories/*
            return
              <category>
                {$category/name}
                {
                  for $subCategory in $category/sub__categories/*
                  return
                    <sub__category>{$subCategory/text()}</sub__category>
                }
              </category>
          }
        </product>
        
    	</return>
    )
    
  }
 </returns>
};