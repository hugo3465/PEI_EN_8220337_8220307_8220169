module namespace page = 'http://basex.org/examples/web-page';
declare namespace salesModule = 'http://example.com/sales-module';

(: Globas variables:)
(:
declare variable $url := "https://eu-west-2.aws.data.mongodb-api.com/app/data-krpco/endpoint/data/v1/action/findOne";
declare variable $findSuffix := "/action/findOne";
declare variable $apiKey := "suGjpm3S5Uue7H3sCuTLlKKxPBsWmXI8gf9x7Qx0yXegqquTrnNvuXo21SrXthBb";
declare variable $contentType := "application/json";
:)

(: Obter relatório de vendas de um mês :)
declare
 %rest:path("/sales")
 %rest:query-param("ano", "{$ano}")
 %rest:query-param("mes", "{$mes}")
 %rest:GET
function page:getSale($ano as xs:integer, $mes as xs:integer) {
  let $xsd := "./xsd/saleRules.xsd"
  (: validate:xsd($sale, $xsd) :)
  let $xml := page:getSalesRawData($ano, $mes)
  let $parsedXml := page:transformSalesXML($xml)
  
  return $parsedXml
};

declare function page:getSalesRawData($ano as xs:integer, $mes as xs:integer) {
  let $rightMes := fn:format-number($mes, "00") (: com isto não vai ignorar o 0 caso o mes seja 03 :)
  let $rightProximoMes := fn:format-number($mes + 1, "00")

  let $url := "https://eu-west-2.aws.data.mongodb-api.com/app/data-krpco/endpoint/data/v1"
  let $findSuffix := "/action/find"
  let $apiKey := "suGjpm3S5Uue7H3sCuTLlKKxPBsWmXI8gf9x7Qx0yXegqquTrnNvuXo21SrXthBb"
  let $contentType := "application/json"
  let $body := concat('{
      "collection":"sales",
      "database":"BdPeiTP",
      "dataSource":"Cluster0",

        "filter": {
            "date": {
                "$gte": {"$date": "', $ano, '-', $rightMes, '-01T00:00:00Z"},
                "$lt": {"$date": "', $ano, '-', $rightProximoMes, '-01T00:00:00Z"}
            }
        },
        "projection": {
            "_id": 0,
            "invoice_id": 1,
            "date": 1,
            "customer_id": 1,
            "totalVendas": 1,
            "receitaTotal": 1,
            "sales_lines.id": 1,
            "sales_lines.product_id": 1,
            "sales_lines.quantity": 1,
            "sales_lines.total_with_vat": 1
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

declare function page:transformSalesXML($xml) {
  (: aparentemente não é preciso return com funções assim:)
    <sales>
    {
      for $sale in $xml/json/documents/*
      return (
        <sale>
          {$sale/invoice__id},
          {$sale/date}
          <sales_lines>
          {
            for $saleLine in $sale/sales__lines/*
            return (
              <sale_line>
                {$saleLine/id}
                {$saleLine/total__with__vat},
                {$saleLine/quantity},
                {$saleLine/product__id}
              </sale_line>
            )
          }
          </sales_lines>
        </sale>
      )
      
    }
   </sales>
};